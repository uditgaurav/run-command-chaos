package lib

import (
	clients "github.com/litmuschaos/litmus-go/pkg/clients"
	"github.com/litmuschaos/litmus-go/pkg/events"
	experimentTypes "github.com/litmuschaos/litmus-go/pkg/generic/run-command-chaos/types"
	"github.com/litmuschaos/litmus-go/pkg/log"
	"github.com/litmuschaos/litmus-go/pkg/probe"
	"github.com/litmuschaos/litmus-go/pkg/status"
	"github.com/litmuschaos/litmus-go/pkg/types"
	"github.com/litmuschaos/litmus-go/pkg/utils/common"
	"github.com/pkg/errors"
	"github.com/sirupsen/logrus"
	apiv1 "k8s.io/api/core/v1"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"strconv"
)

// PrepareRunCommandChaos contains prepration steps before chaos injection
func PrepareRunCommandChaos(experimentsDetails *experimentTypes.ExperimentDetails, clients clients.ClientSets, resultDetails *types.ResultDetails, eventsDetails *types.EventDetails, chaosDetails *types.ChaosDetails) error {

	var err error

	log.InfoWithValues("[Info]: Details of run chaos experiment tunables", logrus.Fields{
		"CPU CORES": experimentsDetails.Cpu,
	})

	experimentsDetails.RunID = common.GetRunID()

	//Waiting for the ramp time before chaos injection
	if experimentsDetails.RampTime != 0 {
		log.Infof("[Ramp]: Waiting for the %vs ramp time before injecting chaos", experimentsDetails.RampTime)
		common.WaitForDuration(experimentsDetails.RampTime)
	}

	if experimentsDetails.EngineName != "" {
		msg := "Injecting " + experimentsDetails.ExperimentName + " chaos on " + experimentsDetails.Ip + " vm"
		types.SetEngineEventAttributes(eventsDetails, types.ChaosInject, msg, "Normal", chaosDetails)
		events.GenerateEvents(eventsDetails, clients, chaosDetails, "ChaosEngine")
	}

	if experimentsDetails.EngineName != "" {
		if err := common.SetHelperData(chaosDetails, clients); err != nil {
			return err
		}
	}

	// Creating the helper pod to perform node memory hog
	if err = createHelperPod(experimentsDetails, clients, chaosDetails); err != nil {
		return errors.Errorf("unable to create the helper pod, err: %v", err)
	}

	appLabel := "name=" + experimentsDetails.ExperimentName + "-helper-" + experimentsDetails.RunID

	//Checking the status of helper pod
	log.Info("[Status]: Checking the status of the helper pod")
	if err = status.CheckHelperStatus(experimentsDetails.ChaosNamespace, appLabel, experimentsDetails.Timeout, experimentsDetails.Delay, clients); err != nil {
		common.DeleteHelperPodBasedOnJobCleanupPolicy(experimentsDetails.ExperimentName+"-helper-"+experimentsDetails.RunID, appLabel, chaosDetails, clients)
		return errors.Errorf("helper pod is not in running state, err: %v", err)
	}

	common.SetTargets(experimentsDetails.Ip, "targeted", "vm", chaosDetails)

	// run the probes during chaos
	if len(resultDetails.ProbeDetails) != 0 {
		if err = probe.RunProbes(chaosDetails, clients, resultDetails, "DuringChaos", eventsDetails); err != nil {
			common.DeleteAllHelperPodBasedOnJobCleanupPolicy(appLabel, chaosDetails, clients)
			return err
		}
	}

	// Wait till the completion of helper pod
	log.Info("[Wait]: Waiting till the completion of the helper pod")

	podStatus, err := status.WaitForCompletion(experimentsDetails.ChaosNamespace, appLabel, clients, experimentsDetails.ChaosDuration+experimentsDetails.Timeout, experimentsDetails.ExperimentName)
	if err != nil || podStatus == "Failed" {
		common.DeleteHelperPodBasedOnJobCleanupPolicy(experimentsDetails.ExperimentName+"-helper-"+experimentsDetails.RunID, appLabel, chaosDetails, clients)
		return common.HelperFailedError(err)
	}

	//Deleting the helper pod
	log.Info("[Cleanup]: Deleting the helper pod")
	if err = common.DeletePod(experimentsDetails.ExperimentName+"-helper-"+experimentsDetails.RunID, appLabel, experimentsDetails.ChaosNamespace, chaosDetails.Timeout, chaosDetails.Delay, clients); err != nil {
		return errors.Errorf("unable to delete the helper pod, err: %v", err)
	}

	//Waiting for the ramp time after chaos injection
	if experimentsDetails.RampTime != 0 {
		log.Infof("[Ramp]: Waiting for the %vs ramp time after injecting chaos", experimentsDetails.RampTime)
		common.WaitForDuration(experimentsDetails.RampTime)
	}
	return nil
}

// createHelperPod derive the attributes for helper pod and create the helper pod
func createHelperPod(experimentsDetails *experimentTypes.ExperimentDetails, clients clients.ClientSets, chaosDetails *types.ChaosDetails) error {

	privileged := true
	terminationGracePeriodSeconds := int64(experimentsDetails.TerminationGracePeriodSeconds)

	helperPod := &apiv1.Pod{
		ObjectMeta: v1.ObjectMeta{
			Name:        experimentsDetails.ExperimentName + "-helper-" + experimentsDetails.RunID,
			Namespace:   experimentsDetails.ChaosNamespace,
			Labels:      common.GetHelperLabels(chaosDetails.Labels, experimentsDetails.RunID, "", experimentsDetails.ExperimentName),
			Annotations: chaosDetails.Annotations,
		},
		Spec: apiv1.PodSpec{
			RestartPolicy:                 apiv1.RestartPolicyNever,
			ImagePullSecrets:              chaosDetails.ImagePullSecrets,
			TerminationGracePeriodSeconds: &terminationGracePeriodSeconds,
			Volumes: []apiv1.Volume{
				{
					Name: "bus",
					VolumeSource: apiv1.VolumeSource{
						HostPath: &apiv1.HostPathVolumeSource{
							Path: "/var/run",
						},
					},
				},
				{
					Name: "root",
					VolumeSource: apiv1.VolumeSource{
						HostPath: &apiv1.HostPathVolumeSource{
							Path: "/",
						},
					},
				},
			},
			Containers: []apiv1.Container{
				{
					Name:            experimentsDetails.ExperimentName,
					Image:           experimentsDetails.LIBImage,
					ImagePullPolicy: apiv1.PullPolicy(experimentsDetails.LIBImagePullPolicy),
					Command: []string{
						"/bin/bash",
					},
					Args: []string{
						"-c",
						"sudo chmod 777 ./litmus/cpu-chaos.sh && ./litmus/cpu-chaos.sh",
					},
					Resources: chaosDetails.Resources,
					Env:       getPodEnv(experimentsDetails),
					VolumeMounts: []apiv1.VolumeMount{
						{
							Name:      "bus",
							MountPath: "/var/run",
						},
						{
							Name:      "root",
							MountPath: "/node",
						},
					},
					SecurityContext: &apiv1.SecurityContext{
						Privileged: &privileged,
					},
					TTY: true,
				},
			},
			Tolerations: []apiv1.Toleration{
				{
					Key:               "node.kubernetes.io/not-ready",
					Operator:          apiv1.TolerationOperator("Exists"),
					Effect:            apiv1.TaintEffect("NoExecute"),
					TolerationSeconds: ptrint64(int64(experimentsDetails.ChaosDuration) + 60),
				},
				{
					Key:               "node.kubernetes.io/unreachable",
					Operator:          apiv1.TolerationOperator("Exists"),
					Effect:            apiv1.TaintEffect("NoExecute"),
					TolerationSeconds: ptrint64(int64(experimentsDetails.ChaosDuration) + 60),
				},
			},
		},
	}

	_, err := clients.KubeClient.CoreV1().Pods(experimentsDetails.ChaosNamespace).Create(helperPod)
	return err
}

// getPodEnv derive all the env required for the helper pod
func getPodEnv(experimentsDetails *experimentTypes.ExperimentDetails) []apiv1.EnvVar {

	var envDetails common.ENVDetails
	envDetails.SetEnv("APP_NAMESPACE", experimentsDetails.AppNS).
		SetEnv("PORT", strconv.Itoa(experimentsDetails.Port)).
		SetEnv("CPU_CORES", strconv.Itoa(experimentsDetails.Cpu)).
		SetEnv("PRIVATE_SSH_FILE_PATH", experimentsDetails.PrivateSshFilePath).
		SetEnv("PASSWORD", experimentsDetails.Password).
		SetEnv("IP", experimentsDetails.Ip).
		SetEnv("USER", experimentsDetails.Username).
		SetEnv("TOTAL_CHAOS_DURATION", strconv.Itoa(experimentsDetails.ChaosDuration)).
		SetEnvFromDownwardAPI("v1", "metadata.name")

	return envDetails.ENV
}

func ptrint64(p int64) *int64 {
	return &p
}

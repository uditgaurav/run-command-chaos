package environment

import (
	"strconv"

	clientTypes "k8s.io/apimachinery/pkg/types"

	experimentTypes "github.com/litmuschaos/litmus-go/pkg/generic/run-command-chaos/types"
	"github.com/litmuschaos/litmus-go/pkg/types"
)

//GetENV fetches all the env variables from the runner pod
func GetENV(experimentDetails *experimentTypes.ExperimentDetails) {
	experimentDetails.ExperimentName = types.Getenv("EXPERIMENT_NAME", "run-command-chaos")
	experimentDetails.ChaosNamespace = types.Getenv("CHAOS_NAMESPACE", "litmus")
	experimentDetails.EngineName = types.Getenv("CHAOSENGINE", "")
	experimentDetails.ChaosDuration, _ = strconv.Atoi(types.Getenv("TOTAL_CHAOS_DURATION", "90"))
	experimentDetails.RampTime, _ = strconv.Atoi(types.Getenv("RAMP_TIME", "0"))
	experimentDetails.ChaosLib = types.Getenv("LIB", "litmus")
	experimentDetails.AppNS = types.Getenv("APP_NAMESPACE", "")
	experimentDetails.AppLabel = types.Getenv("APP_LABEL", "")
	experimentDetails.AppKind = types.Getenv("APP_KIND", "")
	experimentDetails.ChaosUID = clientTypes.UID(types.Getenv("CHAOS_UID", ""))
	experimentDetails.InstanceID = types.Getenv("INSTANCE_ID", "")
	experimentDetails.ChaosPodName = types.Getenv("POD_NAME", "")
	experimentDetails.AuxiliaryAppInfo = types.Getenv("AUXILIARY_APPINFO", "")
	experimentDetails.Delay, _ = strconv.Atoi(types.Getenv("STATUS_CHECK_DELAY", "2"))
	experimentDetails.Timeout, _ = strconv.Atoi(types.Getenv("STATUS_CHECK_TIMEOUT", "180"))
	experimentDetails.LIBImage = types.Getenv("LIB_IMAGE", "uditgaurav/go-runner:run")
	experimentDetails.LIBImagePullPolicy = types.Getenv("LIB_IMAGE_PULL_POLICY", "Always")
	experimentDetails.TargetContainer = types.Getenv("TARGET_CONTAINER", "")
	experimentDetails.TerminationGracePeriodSeconds, _ = strconv.Atoi(types.Getenv("TERMINATION_GRACE_PERIOD_SECONDS", ""))
	experimentDetails.Cpu, _ = strconv.Atoi(types.Getenv("CPU_CORES", "2"))
	experimentDetails.Username = types.Getenv("USERNAME", "")
	experimentDetails.Password = types.Getenv("PASSWORD", "")
	experimentDetails.Ip = types.Getenv("IP", "")
	experimentDetails.PrivateSshFilePath = types.Getenv("PRIVATE_SSH_FILE_PATH", "")
	experimentDetails.Port, _ = strconv.Atoi(types.Getenv("PORT", "22"))
	experimentDetails.ChaosType = types.Getenv("CHAOS_TYPE", "cpu")

	experimentDetails.MemoryConsumption, _ = strconv.Atoi(types.Getenv("MEMORY_CONSUMPTION", "500"))
	experimentDetails.NumberOfWorkers, _ = strconv.Atoi(types.Getenv("NUMBER_OF_WORKERS", "4"))

	experimentDetails.NetworkLatency, _ = strconv.Atoi(types.Getenv("NETWORK_LATENCY", "2000"))
	experimentDetails.NetworkPacketLossPercentage, _ = strconv.Atoi(types.Getenv("NETWORK_PACKET_LOSS_PERCENTAGE", "30"))
	experimentDetails.NetworkInterface = types.Getenv("NETWORK_INTERFACE", "eth0")

	experimentDetails.FillPercentage, _ = strconv.Atoi(types.Getenv("FILL_PERCENTAGE", ""))
	experimentDetails.VolumeMountPath = types.Getenv("VOLUME_MOUNT_PATH", "/")
	experimentDetails.DiskConsumption, _ = strconv.Atoi(types.Getenv("DISK_CONSUMPTION", "2"))
	experimentDetails.RebootCommand = types.Getenv("REBOOT_COMMAND", "")
}

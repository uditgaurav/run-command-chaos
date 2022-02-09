package types

import (
	clientTypes "k8s.io/apimachinery/pkg/types"
)

// ExperimentDetails is for collecting all the experiment-related details
type ExperimentDetails struct {
	ExperimentName                string
	EngineName                    string
	ChaosDuration                 int
	RampTime                      int
	ChaosLib                      string
	AppNS                         string
	AppLabel                      string
	AppKind                       string
	ChaosUID                      clientTypes.UID
	TerminationGracePeriodSeconds int
	InstanceID                    string
	ChaosNamespace                string
	ChaosPodName                  string
	AuxiliaryAppInfo              string
	RunID                         string
	Timeout                       int
	Delay                         int
	LIBImage                      string
	LIBImagePullPolicy            string
	TargetContainer               string
	Username                      string
	Password                      string
	Ip                            string
	Cpu                           int
	PrivateSshFilePath            string
	Port                          int
	ChaosType                     string
	NumberOfWorkers               int
	MemoryConsumption             int
	NetworkLatency                int
	NetworkInterface              string
	NetworkPacketLossPercentage   int
	FillPercentage                int
	DiskConsumption               int
	VolumeMountPath               string
	RebootCommand                 string
	ListenUrl					  string
	StreamUrl                     string
	StreamType                    string
}

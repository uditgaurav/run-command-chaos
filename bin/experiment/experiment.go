package main

import (
	"flag"
	// Uncomment to load all auth plugins
	// _ "k8s.io/client-go/plugin/pkg/client/auth"

	// Or uncomment to load specific auth plugins
	// _ "k8s.io/client-go/plugin/pkg/client/auth/azure"
	// _ "k8s.io/client-go/plugin/pkg/client/auth/gcp"
	// _ "k8s.io/client-go/plugin/pkg/client/auth/oidc"
	// _ "k8s.io/client-go/plugin/pkg/client/auth/openstack"

	runCommandChaos "github.com/litmuschaos/litmus-go/experiments/generic/run-command-chaos/experiment"

	"github.com/litmuschaos/litmus-go/pkg/clients"
	"github.com/litmuschaos/litmus-go/pkg/log"
	"github.com/sirupsen/logrus"
)

func init() {
	// Log as JSON instead of the default ASCII formatter.
	logrus.SetFormatter(&logrus.TextFormatter{
		FullTimestamp:          true,
		DisableSorting:         true,
		DisableLevelTruncation: true,
	})
}

func main() {

	clients := clients.ClientSets{}

	// parse the experiment name
	experimentName := flag.String("name", "run-command-chaos", "name of the chaos experiment")

	//Getting kubeConfig and Generate ClientSets
	if err := clients.GenerateClientSetFromKubeConfig(); err != nil {
		log.Errorf("Unable to Get the kubeconfig, err: %v", err)
		return
	}

	log.Infof("Experiment Name: %v", *experimentName)

	// invoke the corresponding experiment based on the the (-name) flag
	switch *experimentName {

	case "run-command-chaos":
		runCommandChaos.RunCommandChaos(clients)

	default:
		log.Errorf("Unsupported -name %v, please provide the correct value of -name args", *experimentName)
		return
	}
}

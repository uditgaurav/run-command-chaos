# Run Command Chaos

Following are the details of run command chaos:

## Experiments

<table>
  <tr>
    <th>Experiment</th>
    <th>Pre-requisite</th>
    <th>Script</th>
    <th>Workflow</th>
    <th>Logs&Result</th>
  </tr>
  <tr>
    <td>cpu-chaos</td>
    <td>stress-ng on the target VM</td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/pkg/utils/scripts/cpu-chaos.sh">Click Here</a></td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/artefact/workflows/cpu-chaos-wf.yaml">workflow.yaml</a></td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/artefact/logs/cpu-chaos-logs-and-result.txt">Logs.txt</a></td>
  </tr>
  
  <tr>
    <td>memory-chaos</td>
    <td>stress-ng on the target VM</td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/pkg/utils/scripts/memory-chaos.sh">Click Here</a></td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/artefact/workflows/memory-chaos-wf.yaml">workflow.yaml</a></td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/artefact/logs/memory-chaos-logs-and-result.txt">Logs.txt</a></td>
  </tr>
  
  <tr>
    <td>network-latency</td>
    <td>sch_netem kernel module instllated <br> tc commands</td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/pkg/utils/scripts/network-latency-chaos.sh">Click Here</a></td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/artefact/workflows/network-latency-wf.yaml">workflow.yaml</a></td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/artefact/logs/network-latency-logs-and-result.txt">Logs.txt</a></td>
  </tr>
  
   <tr>
    <td>network-loss</td>
    <td>sch_netem kernel module instllated <br> tc commands</td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/pkg/utils/scripts/network-loss-chaos.sh">Click Here</a></td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/artefact/workflows/network-loss-wf.yaml">workflow.yaml</a></td>
    <td><a href="https://github.com/uditgaurav/run-command-chaos/blob/master/artefact/logs/network-loss-logs-and-result.txt">workflow.yaml</a></td>
  </tr>
</table>

## Limitations

Proper Cleanup: We need to have a cleanup strategy if the chaos terminates in-between or if the chaos process remain in the system even after the chaos completion.

**NOTE:** The experiments are tested on Azure VMs

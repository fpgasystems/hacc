<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/infrastructure-validation/README.md#infrastructure-validation">Back to infrastructure validation</a>
</p>

# Networking validation with EasyNet
In this experiment, we are using CLI’s [sgutil validate mpi](../../CLI/docs/sgutil-validate-mpi.md#sgutil-validate-mpi) command to verify MPI message-passing standard on the ETHZ-HACC network.

### Prerrequisites
* You must have a valid authentication key pairs for SSH in your **~/.ssh** directory, and
* Your public key must be added to the authorized keys. 

```
$ ssh-keygen
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

If the public key **~/.ssh/id_rsa.pub** is not present, *sgutil validate iperf* will run the commands above for you automatically.

## Experiment

## Results
For this experiment
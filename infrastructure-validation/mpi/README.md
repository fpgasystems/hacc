<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/infrastructure-validation/README.md#infrastructure-validation">Back to infrastructure validation</a>
</p>

# Message passing interface validation with mpich
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
1. Use the [booking system](https://alveo-booking.ethz.ch/login.php) to reserve the servers you wish to validate,
2. Login to the server you want to set as the iperf server—all others will be the clients for the experiment,
3. Run ```sgutil validate mpi``` and wait for the results.

![Message passing interface validation with mpich.](./infrastructure-validation-mpi.png "Message passing interface validation with mpich.")
*Message passing interface validation with mpich.*

## Results
For this experiment we have reserved five servers (alveo-u55c-01 to alveo-u55c-05) where alveo-u55c-01 is the local instance connecting to the remotes. **Please, remember that** ```sgutil validate iperf``` **sets -n (the number of processes to use) to two.**
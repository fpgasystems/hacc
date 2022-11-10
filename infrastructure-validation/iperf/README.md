<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/infrastructure-validation/README.md#infrastructure-validation">Back to infrastructure validation</a>
</p>

# Networking validation with iperf
In this experiment, we are using CLI’s [sgutil validate iperf](../../CLI/docs/sgutil-validate.md#sgutil-validate-iperf) command to actively measure the maximum achievable bandwidth on the ETHZ-HACC network.

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
3. Run ```sgutil validate iperf``` and wait for the results.

## Results
To provide a baseline, we repeated the same experiment for the different clusters (e.g., when we reserved all six machines for cluster U250) and also to verify the inter-cluster network (when we booked one server from each cluster). Please, remember that ```sgutil validate iperf``` sets the number of parallel client threads to run (-P or --parellel) to four.

### U250
The following table has been derived after booking the **six** U250 servers that are available in the HACC:

![sgutil validate iperf for U250 cluster.](./U250.png "sgutil validate iperf for U250 cluster.")
*sgutil validate iperf for U250 cluster.*

### U280
The following table has been derived after booking the **four** U280 servers that are available in the HACC:

![sgutil validate iperf for U280 cluster.](./U280.png "sgutil validate iperf for U280 cluster.")
*sgutil validate iperf for U280 cluster.*

### U50D
The following table has been derived after booking the **four** U50D servers that are available in the HACC:

![sgutil validate iperf for U50D cluster.](./U50D.png "sgutil validate iperf for U50D cluster.")
*sgutil validate iperf for U50D cluster.*

### U55C
The following table has been derived after booking the **ten** U55C servers that are available in the HACC:

![sgutil validate iperf for U55C cluster.](./U55C.png "sgutil validate iperf for U250 cluster.")
*sgutil validate iperf for U55C cluster.*

### Inter-cluster measurements

![sgutil validate iperf between clusters.](./inter-cluster.png "sgutil validate iperf between clusters.")
*sgutil validate iperf between clusters.*
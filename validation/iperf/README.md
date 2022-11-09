<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/validation/README.md">Back</a>
</p>

# Networking validation with iperf
With ```sgutil validate iperf```, we are using our HACC CLI to measure the maximum achievable bandwidth on the HACC network actively. Such a command establishes a TCP connection between the server (the host from where you run the validation test) and all other machines you have previously booked on the booking system. For tuning other parameters relating to timing, buffers, and protocols, please visit [sgutil validate iperf](../../CLI/docs/sgutil-validate.md#sgutil-validate-iperf).

The following sections show measurements for the different clusters (U250, U280, U50D, U55C) and between them—assuming the first node of each group as representative. Before starting, please have a look at the [Prerequisites](#prerrequisites).

## U250
The following table has been derived after booking the **six** U250 servers that are available in the HACC:

![sgutil validate iperf for U250 cluster.](./U250.png "sgutil validate iperf for U250 cluster.")
*sgutil validate iperf for U250 cluster.*

## U280
The following table has been derived after booking the **four** U280 servers that are available in the HACC:

![sgutil validate iperf for U280 cluster.](./U280.png "sgutil validate iperf for U280 cluster.")
*sgutil validate iperf for U280 cluster.*

## U50D
The following table has been derived after booking the **four** U50D servers that are available in the HACC:

![sgutil validate iperf for U50D cluster.](./U50D.png "sgutil validate iperf for U50D cluster.")
*sgutil validate iperf for U50D cluster.*

## U55C
The following table has been derived after booking the **ten** U55C servers that are available in the HACC:

![sgutil validate iperf for U55C cluster.](./U55C.png "sgutil validate iperf for U250 cluster.")
*sgutil validate iperf for U55C cluster.*

## Inter-cluster measurements

![sgutil validate iperf between clusters.](./inter-cluster.png "sgutil validate iperf between clusters.")
*sgutil validate iperf between clusters.*

## Prerrequisites
Each user must have valid authentication key pairs for SSH. Such key pairs are used for automating logins, single sign-on, and for authenticating hosts—and are required for using CLI’s iperf validation scripts. If you have a valid key pair already generated in ```~/.ssh```, please be sure your public pair is added to authorized keys: ```cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys```

If you don’t have such keys ready, the ```sgutil validate iperf``` command will do that for you automatically.
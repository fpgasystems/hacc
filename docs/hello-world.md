<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/README.md#sections">Back</a>
</p>

# Hello, world!
This guideline will guide you through deploying, building, and running a [Hello, world!](../docs/vocabulary.md#hello-world) example running on SG HACC Alveo cards. In this case, the *Hello, world!* program reduces to a simple vector addition describing how to use HLS kernels in Vitis Environment [[1]](#references).

We will cover the following sections:
* [Accessing the cluster](#accessing-the-cluster)
* [Booking a server](#booking-a-server)
* [Validating Xilinx accelerator cards](#validating-xilinx-accelerator-cards) 
* [HLS vector addition](#hls-vector-addition)

Before continuing, please make sure you have been already accepted on ETH Zürich HACC program and you have a valid user account. In any other case, please visit [Get started](https://www.amd-haccs.io/get-started.html).

## Accessing the cluster
You must be connected to the ETH Zürich network to access the cluster. If this is not the case, you will need to use a [jump host](#jump-host) or set up a [VPN](#vpn) connection.

## Jump host
To make use of ETH’s jumphost [2](#references) please follow these steps:

1. Edit your ```~/.ssh/config``` file by adding the following lines:

```
# Remote Access by Secure Shell (SSH) - ETHZ

ServerAliveInterval 300
ServerAliveCountMax 12

Host jumphost.inf.ethz.ch
    User ETHUSER

Host *.ethz.ch !jumphost.inf.ethz.ch
    User ETHUSER
    ProxyJump jumphost.inf.ethz.ch
```

2. Access a server on SG HACC, i.e.: ```ssh ETHUSER@alveo-build-01.ethz.ch```

Please note that for this to work, you have to type the domain name ```.ethz.ch```. 

## VPN

https://scicomp.ethz.ch/wiki/Accessing_the_cluster
https://scicomp.ethz.ch/wiki/Accessing_the_clusters#VPN

## Booking a server

## Validating Xilinx accelerator cards

## HLS vector addition

## References
* [1] [Hello World (HLS C/C++ Kernel)](https://github.com/Xilinx/Vitis_Accel_Examples/tree/master/hello_world)
* [2] [Remote Access by Secure Shell (SSH) using a jump host](https://www.isg.inf.ethz.ch/Main/HelpRemoteAccessSSH)
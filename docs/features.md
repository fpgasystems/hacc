<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc#sections">Back</a>
</p>

# Features

## CLI
With SG [CLI](../CLI/README.md#cli), you can easily:

* Make use of *out-of-the-box* [Examples](./examples.md#examples) and user functions that help you to build your accelerated applications,
* Deploy, build and design using any of our shipped [Applications](./applications.md#applications),
* *Et cetera.*

## Vitis and Vivado workflows
Thanks to our [hot-plug boot](./vocabulary.md#hot-plug-boot) process, we are able to transition between the [Vivado and Vitis workflows](./vocabulary.md#vivado-and-vitis-workflows) without the need of rebooting the system.

## Managed
We use [Infrastructure as Code (IaC)](./vocabulary.md#infrastructure-as-code-iac) and [Ansible Automation Platform (AAP)](./vocabulary.md#ansible-automation-platform-aap) to [operate the cluster](../docs/operating-the-cluster.md#operating-the-cluster) efficiently. Under the scope of a [DevOps](./vocabulary.md#devops) methodology, we achieve the following: <!-- https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code -->

* Continuos delivery,
* Avoid manual configuration to enforce consistency,
* Use declarative definition files helping to document the cluster,
* Easily follow Xilinx’s tools versioning release schedule, and
* Deliver stable tests environments rapidly at scale.

## You are welcome
We are glad and welcome you every time you login to one of our servers. Behind the scenes, our *welcome_msg* script performs the following functions:

* Runs a sanity check to verify the correct functioning of the operating system, as well as hardware and software related to Xilinx accelerators,
* Helps you to choose your environement regarding [Vivado and Vitis workflows](./vocabulary.md#vivado-and-vitis-workflows),
* It gives you derived information regarding the active *Xilinx release branch, tools, and flashable partitions running on FPGA,* as well as the network information that might be relevant for your accelerated applications,
* *Et cetera.*
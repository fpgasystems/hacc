<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc#--heterogenous-accelerated-compute-cluster">Back to top</a>
</p>

# Infrastructure
ETHZ-HACC comprises high-end servers, GPUs, reconfigurable accelerator cards, and high-speed networking. Each accelerator card has all of its Ethernet interfaces connected to a 100 GbE leaf switch to allow exploration of arbitrary network topologies for distributed computing. Additionally, we are offering a build server with development and bitstream compilation purposes.

![ETHZ-HACC is comprised of high-​end servers, reconfigurable accelerator cards, and high-​speed networking.](../imgs/infrastructure.png "ETHZ-HACC is comprised of high-​end servers, reconfigurable accelerator cards, and high-​speed networking.")
*ETHZ-HACC is comprised of high-​end servers, reconfigurable accelerator cards, and high-​speed networking.*

There are **two types of deployment servers.** The first type of servers are equipped with only one accelerator card; the second are servers equipped with an heterogeneous variety of accelerators including GPUs, FPGAs, and ACAPs (please, see the section [HACC boxes architecture](#hacc-boxes-architecture)). In total, ETHZ-HACC counts twelve GPUs, thirty-one Alveo data center accelerator cards, and seven Versal cards. The following tables give an overview of the **server names** and their **resources:**

![ETHZ-HACC server names.](../imgs/server-names.png "ETHZ-HACC server names.")
*ETHZ-HACC server names.*

![ETHZ-HACC resources.](../imgs/resources.png "ETHZ-HACC resources.")
*ETHZ-HACC resources. On the Type - Model column, VU stands for [Virtex Ultrascale+](#virtex-ultrascale).*

## *Build cluster*
We are offering a *build cluster* for development and bitstream compilation purposes. Multiple users can access this machine simultaneously **without booking it first.** Please only use the HACC build servers if you do not have access to similar resources at your research institution: too many users running large jobs on this machine will likely cause builds to run slowly—or sometimes to fail. Also, avoid using the build servers for debugging or simulating your hardware.

## High-end servers and reconfigurable accelerator cards
### AMD EPYC
EPYC is the world’s highest-performing x86 server processor with faster performance for cloud, enterprise, and HPC workloads. To learn more about it, please refer to the [AMD EPYC processors website](https://www.amd.com/en/processors/epyc-server-cpu-family) and its [data sheet.](https://www.amd.com/system/files/documents/amd-epyc-7003-series-datasheet.pdf)

### Virtex Ultrascale+
Virtex UltraScale+ devices provide the highest performance and integration capabilities in a 14nm/16nm FinFET node. It also provides registered inter-die routing lines enabling >600 MHz operation, with abundant and flexible clocking to deliver a virtual monolithic design experience. As the industry’s most capable FPGA family, the devices are ideal for compute-intensive applications ranging from 1+Tb/s networking and machine learning to radar/early-warning systems.

* [Alveo U250](https://www.xilinx.com/products/boards-and-kits/alveo/u250.html)
* [Alveo U280](https://www.xilinx.com/products/boards-and-kits/alveo/u280.html)
* [Alveo U50D](https://www.xilinx.com/products/boards-and-kits/alveo/u50.html)
* [Alveo U55C](https://www.xilinx.com/applications/data-center/high-performance-computing/u55c.html)

### Versal ACAP
Versal ACAPs deliver unparalleled application- and system-level value for cloud, network, and edge applications​. The disruptive 7nm architecture combines heterogeneous compute engines with a breadth of hardened memory and interfacing technologies for superior performance/watt over competing 10nm FPGAs.

* [Versal VCK5000](https://www.xilinx.com/products/boards-and-kits/vck5000.html)

### Storage
Each HACC users can store data on the following directories:

* ```/home/USERNAME```: directory on an NFS drive accessible by USERNAME from any the HACC servers.
* ```/mnt/scratch```: directory on an NFS drive accessible by all users from any of the HACC servers.
* ```/local/home/USERNAME/```: directory on the local server drive accessible by USERNAME on the HACC server.
* ```/tmp```: directory on the local server drive accessible by all users on the HACC server. Its content is removed every time the server is restarted.   

### USB - JTAG connectivity
The USB - JTAG connection allows granted users to interact directly with the FPGA by downloading bitstreams or updating memory content. The correct setup and access of a USB - JTAG connection is essential developers using working with [Vivado workflow](./vocabulary.md#vivado-workflow).

## HACC boxes architecture
The following picture details the architecture of the three heterogeneous servers equipped with 2x EPYC Milan CPUs, 4x [Instinct MI200 GPUs,](https://www.amd.com/system/files/documents/amd-instinct-mi210-brochure.pdf) 2x [Alveo U55C FPGAs,](https://www.xilinx.com/applications/data-center/high-performance-computing/u55c.html) and 2x [Versal VCK5000 ACAPs](https://www.xilinx.com/products/boards-and-kits/vck5000.html) each.

![HACC boxes architecture.](../imgs/hacc-boxes.png "HACC boxes architecture.")
*HACC boxes architecture.*

## Networking

![Management, access and data networks.](../imgs/networking.png "Management, access and data networks.")
*Management, access and data networks.*

### Management network
We refer to the management network as the infrastructure allowing our IT administrators to manage, deploy, update and monitor our cluster **remotely.**

### Access network
The access network is the infrastructure that allows secure remote access to our **users** through SSH.

### Data network
For our **high-speed networking** data network, we are using a [spine-leaf architecture](../docs/vocabulary.md#spine-leaf-architecture) where the L2 leaf layer is built with 100 GbE [Cisco Nexus 9336c FX2](https://www.cisco.com/c/en/us/products/switches/nexus-9336c-fx2-switch/index.html) switches and active optic cables (AOCs):

![Spine-leaf data network architecture.](../imgs/spine-leaf.png "Spine-leaf data network architecture.")
*Spine-leaf data network architecture.*

On the server side, the CPU NICs are [ConnectX-5](https://www.nvidia.com/en-us/networking/ethernet/connectx-5/) adaptors. For the servers **with only one accelerator card, only one 100 GbE port is connected to the respective leaf switch.** On the other hand, **the HACC boxes have two 100 GbE ports connected to the respective leaf switch,** offering a total of 200 GbE effective bandwidth.
<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc#--heterogenous-accelerated-compute-cluster">Back to top</a>
</p>

# Infrastructure
The ETHZ-HACC comprises build and deployment servers. **Build servers are dedicated to development and bitstream compilation,** providing a robust environment for software and hardware design. **Deployment servers,** on the other hand, host one or more acceleration devices, enabling **high-performance execution of workloads.** This separation ensures an efficient workflow, allowing developers to compile and test their applications on build servers before deploying them to accelerator-equipped machines for execution.

![ETHZ-HACC infrastructure. This diagram is for illustrative purposes and may be subject to change. Please refer to the table below for the specific server configuration.](../imgs/infrastructure.png "ETHZ-HACC infrastructure. This diagram is for illustrative purposes and may be subject to change. Please refer to the table below for the specific server configuration.")
*ETHZ-HACC infrastructure. This diagram is for illustrative purposes and may be subject to change. Please refer to the table below for the specific server configuration.*

## Build servers
Build servers are dedicated for development and bitstream compilation purposes. Multiple users can access this machine simultaneously **without booking it first.** Please only use the HACC build servers if you do not have access to similar resources at your research institution: too many users running large jobs on this machine will likely cause builds to run slowly—or sometimes to fail. Also, avoid using the build servers for debugging or simulating your hardware.

<!-- ETHZ-HACC comprises high-end servers, GPUs, reconfigurable accelerator cards, and high-speed networking. Each accelerator card has all of its Ethernet interfaces connected to a 100 (or 200) GbE leaf switch to allow exploration of arbitrary network topologies for distributed computing. Additionally, we are offering a build server with development and bitstream compilation purposes. -->

## Deployment servers
<!-- Deployment servers are composed of high-end multi-core processors, one or more acceleration cards (like GPUs or reconfigurable accelerator cards), and high-speed networking. Reconfigurable accelerator cards have all of its Ethernet interfaces connected to a 100 (or 200) GbE leaf switch to allow exploration of arbitrary network topologies for distributed computing.  -->
Deployment servers feature high-end multi-core processors, one or more accelerator cards—such as GPUs or reconfigurable accelerator cards—and high-speed networking. The following table gives an overview of the devices installed on each of them: 

<table class="tg">
<thead>
  <tr style="text-align:center">
    <th class="tg-0pky" rowspan="2"><div align="center">Cluster</div></th>
    <th class="tg-0pky" colspan="2"><div align="center">ASoCs</div></th>
    <th class="tg-0pky" colspan="4" style="text-align:center"><div align="center">FPGAs</div></th>
    <th class="tg-0pky" colspan="2" style="text-align:center"><div align="center">GPUs</div></th>
    <th class="tg-0pky" rowspan="2"><div align="center">Servers</div></th>
    <!-- <th class="tg-c3ow" rowspan="2">Accelerators</th> -->
  </tr>
  <tr>
    <th class="tg-0pky" style="text-align:center">VCK5000</th>
    <th class="tg-0pky" style="text-align:center">V80</th>
    <th class="tg-0pky" style="text-align:center">U250</th>
    <th class="tg-0pky" style="text-align:center">U280</th>
    <th class="tg-0pky" style="text-align:center">U50D</th>
    <th class="tg-0pky" style="text-align:center">U55C</th>
    <th class="tg-0pky" style="text-align:center">MI100</th>
    <th class="tg-0pky" style="text-align:center">MI210</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky"><div align="center">U50D</div></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">alveo-u50d-[01:02]</td>
    <!--<td class="tg-0pky" style="text-align:center">Alveo U50D</td>  xilinx_u50_gen3x16_xdma_base_5 -->
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">U55C</div></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">alveo-u55c-[01:10]</td>
    <!-- <td class="tg-0pky">Alveo U55C</td> xilinx_u55c_gen3x16_xdma_base_3 -->
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">V80</div></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"> </td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">alveo-v80-01</td>
    <!-- <td class="tg-0pky" >Alveo V80</td> -->
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">ALVEO BOXES</div></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">alveo-box-[01:02]</td>
    <!-- <td class="tg-0pky">Alveo U250<br> Alveo U280</td> xilinx_vck5000_gen4x8_qdma_base_2 -->
  </tr>
  <tr>
    <td class="tg-0pky" ><div align="center">HACC BOXES</div></td>
    <td class="tg-0pky" align="center">&#9679; &#9679;                </br>&#9679;                        </br>&nbsp;                         </br>&nbsp;         </td>
    <td class="tg-0pky" align="center">&nbsp;                         </br>&nbsp;                         </br>&#9679; &#9679;                </br>&#9679; &#9679;</td>
    <td class="tg-0pky" align="center">&nbsp;                         </br>&nbsp;                         </br>&nbsp;                         </br>&nbsp;         </td>
    <td class="tg-0pky" align="center">&nbsp;                         </br>&nbsp;                         </br>&nbsp;                         </br>&nbsp;         </td>
    <td class="tg-0pky" align="center">&nbsp;                         </br>&nbsp;                         </br>&nbsp;                         </br>&nbsp;         </td>
    <td class="tg-0pky" align="center">&#9679; &#9679;                </br>&#9679; &#9679;                </br>&nbsp;                         </br>&nbsp;         </td>
    <td class="tg-0pky" align="center">&nbsp;                         </br>&#9679;                        </br>&nbsp;                         </br>&nbsp;         </td>
    <td class="tg-0pky" align="center">&#9679; &#9679; &#9679; &#9679;</br>&#9679; &#9679; &#9679; &#9679;</br>&#9679; &#9679; &#9679; &#9679;</br>&#9679; &#9679;</td>
    <td class="tg-0pky" align="center">hacc-box-[01:02]               </br>                    hacc-box-03</br>                    hacc-box-04</br>    hacc-box-05</td>
    <!-- <td class="tg-0pky">Alveo U55C (2)<br>Versal VCK500 (2)<br>Instinct MI210 (4)</td>  xilinx_u55c_gen3x16_xdma_base_3 <br> xilinx_vck5000_gen4x8_qdma_base_2 -->
  </tr>
</tbody>
<tfoot><tr><td colspan="10">&#9679; Number of devices.</td></tr></tfoot>
</table>

As shown in the table above, some servers are equipped with a single accelerator card, while others feature a heterogeneous mix of accelerators, including Adaptive SoCs, FPGAs, and GPUs. The section [HACC boxes architecture](#hacc-boxes-architecture) provides details on a representative heterogeneous configuration.

### AMD EPYC
EPYC is the world’s highest-performing x86 server processor with faster performance for cloud, enterprise, and HPC workloads. To learn more about it, please refer to the [AMD EPYC processors website](https://www.amd.com/en/processors/epyc-server-cpu-family) and its [data sheet.](https://www.amd.com/system/files/documents/amd-epyc-7003-series-datasheet.pdf)

### Virtex Ultrascale+
Virtex UltraScale+ devices provide the highest performance and integration capabilities in a 14nm/16nm FinFET node. It also provides registered inter-die routing lines enabling >600 MHz operation, with abundant and flexible clocking to deliver a virtual monolithic design experience. As the industry’s most capable FPGA family, the devices are ideal for compute-intensive applications ranging from 1+Tb/s networking and machine learning to radar/early-warning systems.

* [Alveo U250](https://www.xilinx.com/products/boards-and-kits/alveo/u250.html)
* [Alveo U280](https://www.xilinx.com/products/boards-and-kits/alveo/u280.html)
* [Alveo U50D](https://www.xilinx.com/products/boards-and-kits/alveo/u50.html)
* [Alveo U55C](https://www.xilinx.com/applications/data-center/high-performance-computing/u55c.html)

### Versal Adaptive SoCs
Versal Adaptive SoCs deliver unparalleled application- and system-level value for cloud, network, and edge applications​. The disruptive 7nm architecture combines heterogeneous compute engines with a breadth of hardened memory and interfacing technologies for superior performance/watt over competing 10nm FPGAs.

* [Versal VCK5000](https://www.xilinx.com/products/boards-and-kits/vck5000.html)

### Alveo V80 Compute Accelerator Cards
Alveo V80 compute accelerator cards provide exceptional performance for data center, AI, and high-performance computing workloads. Built on advanced 7nm technology, they integrate high-bandwidth memory, optimized compute engines, and low-latency interconnects to deliver superior throughput and efficiency compared to previous-generation accelerators.

* [Alveo V80](https://www.amd.com/en/products/accelerators/alveo/v80.html)

### Storage
Each HACC users can store data on the following directories:

* ```/home/USERNAME```: directory on an NFS drive accessible by USERNAME from any the HACC servers.
* ```/mnt/scratch```: directory on an NFS drive accessible by all users from any of the HACC servers.
* ```/local/home/USERNAME/```: directory on the local server drive accessible by USERNAME on the HACC server.
* ```/tmp```: directory on the local server drive accessible by all users on the HACC server. Its content is removed every time the server is restarted.   

### USB - JTAG connectivity
The USB - JTAG connection allows granted users to interact directly with the FPGA by downloading bitstreams or updating memory content. The correct setup and access of a USB - JTAG connection is essential developers using working with [Vivado workflow.](./vocabulary.md#vivado-workflow)

### HACC boxes architecture
The following picture details the architecture of the one of our heterogeneous servers (specifically, hacc-box-01), which is equipped with 2x EPYC Milan CPUs, 4x [Instinct MI210 GPUs,](https://www.amd.com/system/files/documents/amd-instinct-mi210-brochure.pdf) 1x 100 GbE NIC, 2x [Alveo U55C FPGAs,](https://www.xilinx.com/applications/data-center/high-performance-computing/u55c.html) and 2x [Versal VCK5000 Adaptive SoCs](https://www.xilinx.com/products/boards-and-kits/vck5000.html).

![Server architecture of hacc-box-01. This diagram can also serve as a reference for the architecture of other HACC boxes.](../imgs/hacc-boxes.png "Server architecture of hacc-box-01. This diagram can also serve as a reference for the architecture of other HACC boxes.")
*Server architecture of hacc-box-01. This diagram can also serve as a reference for the architecture of other HACC boxes.*

## Networking

Each server has at least three connections: one to the **management network,** one to the **access network,** and one to the high-speed **data network.** Additionally, all Ethernet interfaces of reconfigurable accelerator cards are connected to a 100 GbE leaf switch (or 200 GbE for Alveo V80 compute accelerator cards), enabling the exploration of arbitrary network topologies for distributed computing.

![Management, access and data networks. This diagram is for illustrative purposes and may be subject to change.](../imgs/networking.png "Management, access and data networks. This diagram is for illustrative purposes and may be subject to change.")
*Management, access and data networks. This diagram is for illustrative purposes and may be subject to change.*

### Management network
We refer to the management network as the infrastructure allowing our IT administrators to manage, deploy, update and monitor our cluster **remotely.**

### Access network
The access network is the infrastructure that allows secure remote access to our **users** through SSH.

### Data network
For our **high-speed networking** data network, we are using a [spine-leaf architecture](../docs/vocabulary.md#spine-leaf-architecture) where the L2 leaf layer is built with 100 and 200 GbE [Cisco Nexus 9000 Series](https://www.cisco.com/c/en/us/support/switches/nexus-9000-series-switches/series.html) switches, and active optic cables (AOCs):

![Spine-leaf data network architecture.](../imgs/spine-leaf.png "Spine-leaf data network architecture.")
*Spine-leaf data network architecture.*

<!-- On the server side, the CPU NICs are [ConnectX-5](https://www.nvidia.com/en-us/networking/ethernet/connectx-5/) adaptors. For the servers **with only one accelerator card, only one 100 GbE port is connected to the respective leaf switch.** On the other hand, **the HACC boxes have two 100 GbE ports connected to the respective leaf switch,** offering a total of 200 GbE effective bandwidth. -->
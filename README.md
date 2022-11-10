<!-- <div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text"> -->
<p align="right">
<a href="https://ethz.ch/en.html">ETH Zürich</a>
</p>

<p align="center">
<img src="https://systems.ethz.ch/_jcr_content/orgbox/image.imageformat.logo.1091186870.svg" align="center" width="350">
</p>

<h1 align="center">
  Heterogenous Accelerated Compute Cluster
</h1>

<!-- <table align="center"> 
<tr align="center">
<td align="center" width="9999">
<img src="https://systems.ethz.ch/_jcr_content/orgbox/image.imageformat.logo.1091186870.svg" align="center" width="350">


<h1>
  Heterogenous Accelerated Compute Cluster
</h1>
<a href="https://systems.ethz.ch">Institute for Computing Platforms - Systems Group</a>
</td>
</tr>
</table> -->

<!-- Under the scope of the [AMD Xilinx University Program](https://www.xilinx.com/support/university/XUP-HACC.html), the Heterogeneous Accelerated Compute Clusters (HACCs) is a unique initiative to support novel research in adaptive compute acceleration for high-performance computing (HPC). The scope of the program is broad and encompasses systems, architecture, tools, and applications. HACCs are equipped with the latest Xilinx technology for adaptive compute acceleration. -->

Under the scope of the <a href="https://www.xilinx.com/support/university/XUP-HACC.html">AMD Xilinx University Program</a>, the <a href="https://www.amd-haccs.io">Heterogeneous Accelerated Compute Clusters (HACCs)</a> is a special initiative to support novel research in adaptive compute acceleration for high-performance computing (HPC). The scope of the program is broad and encompasses systems, architecture, tools, and applications. 

HACCs are equipped with the latest Xilinx hardware and software technologies for adaptive compute acceleration research. Each cluster is specially configured to enable some of the world’s foremost academic teams to conduct state-of-the-art HPC research. 

Five HACCs have been established at some of world’s most prestigious universities. The first of them was assigned to [Prof. Dr. Gustavo Alonso](https://people.inf.ethz.ch/alonso/) of the [Institute for Platform Computing - Systems Group (SG)](https://systems.ethz.ch) at the [Swiss Federal Institute of Technology Zurich (ETH Zürich)](https://ethz.ch/en.html) in 2020.

## Sections
* [Booking system](/docs/booking-system.md#booking-system)
* [CLI](./CLI/README.md#cli) - *Coming soon!*
* [Examples](/examples/README.md#examples) - *Coming soon!*
* [Features](docs/features.md#features)
* [First steps](docs/first-steps.md#first-steps)
* [Get started](https://www.amd-haccs.io/get-started.html)
* [Hardware acceleration platform](docs/hardware-acceleration-platform.md#hardware-acceleration-platform)
* [Infrastructure](docs/infrastructure.md#infrastructure)
* [Infrastructure validation](./validation/README.md)
* [Known limitations](docs/known-limitations.md#known-limitations)
* [Operating the cluster](docs/operating-the-cluster.md#operating-the-cluster)
* [Vocabulary](docs/vocabulary.md#vocabulary)
* [Who does what](docs/who-does-what.md#who-does-what)

# Releases
We use [Ansible Automation Platform (AAP)](docs/vocabulary.md#ansible-automation-platform-aap) for managing Xilinx’s tools versioning according to [XRT’s release schedule](https://github.com/Xilinx/XRT/releases). All servers equipped with an FPGA are associated with a unique software version, including XRT’s Xilinx Board Utility (xbutil), Xilinx tools (Vivado, Vitis_HLS, Vitis), and the flashable partitions (or base shell) running on the FPGA.

<table class="tg">
<thead>
  <tr style="text-align:center">
    <th class="tg-0pky" rowspan="2"><div align="center">Cluster</div></th>
    <th class="tg-0pky" colspan="3" style="text-align:center"><div align="center">Release</div></th>
    <th class="tg-c3ow" rowspan="2">Base shell</th>
  </tr>
  <tr>
    <th class="tg-0pky" style="text-align:center">2021.1</th>
    <th class="tg-0pky" style="text-align:center">2021.2</th>
    <th class="tg-0pky" style="text-align:center">2022.1</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky"><div align="center">U50D</div></td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky" align="center"> </td> 
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" style="text-align:center">xilinx_u50_gen3x16_xdma_base_5</td>
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">U55C</div></td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky" align="center">&#9675;</td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky">xilinx_u55c_gen3x16_xdma_base_3</td>
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">U250</div></td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky" align="center"> </td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky">xilinx_u250_gen3x16_base_4<br>xilinx_u250_gen3x16_xdma_shell_4_1<br></td>
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">U280</div></td>
    <td class="tg-0pky" align="center">&#9675;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky">xilinx_u280_gen3x16_xdma_base_1</td>
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">Versal</div></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky">xilinx_vck5000_gen4x8_xdma_base_2</td>
  </tr>
</tbody>
<tfoot><tr><td colspan="5">&#9675; Existing release.</td></tr></tfoot>
<tfoot><tr><td colspan="5">&#9679; Existing release installed on the cluster.</td></tr></tfoot>
</table>

# License
For open source projects, say how it is licensed.
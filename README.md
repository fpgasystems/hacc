<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://systems.ethz.ch/research/data-processing-on-modern-hardware.html">Visit our website</a>
</p>

<table align="center"><tr><td align="center" width="9999">
<a href="https://systems.ethz.ch/research/data-processing-on-modern-hardware/alveo-fpga-cluster.html">
<img src="https://systems.ethz.ch/_jcr_content/orgbox/image.imageformat.logo.1091186870.svg" align="center" width="350">
</a>
<h1>
  HACC
</h1>
<a href="https://www.xilinx.com/support/university/XUP-HACC.html">Heterogenous Accelerated Compute Clusters (HACC) Program</a>
</td></tr></table>

The Heterogeneous Accelerated Compute Clusters (HACC) program is a special initiative to support novel research in adaptive compute acceleration for high performance computing (HPC). The scope of the program is broad and encompasses systems, architecture, tools and applications. Five HACCs have been established at some of world’s most prestigious universities. HACCs will be equipped with the latest Xilinx technology for adaptive compute acceleration. Each cluster is specially configured to enable some of the world’s foremost academic teams to conduct state-of-the-art HPC research. 

The first of the HACCs was assigned to [Prof. Dr. Gustavo Alonso’s](https://people.inf.ethz.ch/alonso/) *FPGA* Systems Group (FSG) at ETH Zürich (ETHZ) in Switzerland in 2020.

## Sections
* [Accessing the cluster](docs/accessing-the-cluster.md#accessing-the-cluster)
* [CLI](docs/CLI.md#cli)
* [Features](docs/features.md#features)
* [Infrastructure](docs/infrastructure.md#infrastructure)
* [Projects](docs/projects.md#projects)
* [Vocabulary](docs/vocabulary.md#vocabulary)

# Releases
We use [Ansible](docs/vocabulary.md#ansible) for managing Xilinx’s tools versioning according to [XRT’s release schedule](https://github.com/Xilinx/XRT/releases). All servers equipped with an FPGA are associated with a unique software version, including XRT’s Xilinx Board Utility (xbutil), Xilinx tools (Vivado, Vitis, Vitis_HLS), and the flashable partitions (or base shell) running on the FPGA.

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
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky">xilinx_u280_xdma_201920_3</td>
  </tr>
</tbody>
<tfoot><tr><td colspan="5">&#9675; Existing release.</td></tr></tfoot>
<tfoot><tr><td colspan="5">&#9679; Existing release installed on the cluster.</td></tr></tfoot>
</table>

# License
For open source projects, say how it is licensed.
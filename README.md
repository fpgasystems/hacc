<!-- <div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text"> -->
<p align="right">
<a href="https://github.com/fpgasystems">fpgasystems</a> <a href="https://github.com/fpgasystems/hdev">hdev</a>
</p>

<p align="center">
<img src="https://github.com/fpgasystems/hacc/blob/main/hacc-removebg.png" align="center" width="350">
</p>

<h1 align="center">
  Heterogenous Accelerated Compute Cluster
</h1>

Under the scope of the <a href="https://www.xilinx.com/support/university/XUP-HACC.html">AMD University Program,</a> the <a href="https://www.amd-haccs.io">Heterogeneous Accelerated Compute Clusters (HACCs)</a> is a special initiative to support novel research in adaptive compute acceleration for high-performance computing (HPC). The scope of the program is broad and encompasses systems, architecture, tools, and applications. 

HACCs are equipped with the latest AMD hardware and software technologies for adaptive compute acceleration research. Each cluster is specially configured to enable some of the world’s foremost academic teams to conduct state-of-the-art HPC research. 

Five HACCs have been established at some of world’s most prestigious universities. The first of them was assigned to [Prof. Dr. Gustavo Alonso](https://people.inf.ethz.ch/alonso/) of the [Institute for Platform Computing - Systems Group (SG)](https://systems.ethz.ch) at the [Swiss Federal Institute of Technology Zurich (ETH Zurich, ETHZ)](https://ethz.ch/en.html) in 2020.

## Sections
* [Account renewal](/docs/account-renewal.md#account-renewal)
* [Acknowledgment and citation](#acknowledgment-and-citation)
* [Booking system](/docs/booking-system.md#booking-system)
* [Features](docs/features.md#features)
* [First steps](docs/first-steps.md#first-steps)
* [Get started](https://www.amd-haccs.io/get-started.html)
* [HACC Development (hdev)](https://github.com/fpgasystems/hdev)
* [Infrastructure](docs/infrastructure.md#infrastructure)
* [License](#license)
* [Operating the cluster](docs/operating-the-cluster.md#operating-the-cluster)
* [Playbooks 🔒](https://3.basecamp.com/5241674/buckets/25107010/documents/6507506374)
* [Releases](#releases)
* [Technical support](docs/technical-support.md)
* [Usage guidance](#usage-guidance)
* [Vocabulary](docs/vocabulary.md#vocabulary)
* [Who does what](docs/who-does-what.md#who-does-what)

# Releases

The table below provides an overview of the current ETHZ-HACC setup across different releases:

<table class="tg">
<thead>
  <tr style="text-align:center">
    <th class="tg-0pky" rowspan="2"><div align="center">Cluster</div></th>
    <th class="tg-0pky" colspan="2"><div align="center">Ubuntu</div></th>
    <th class="tg-0pky" colspan="2" style="text-align:center"><div align="center">Vivado</div></th>
    <th class="tg-0pky" colspan="2" style="text-align:center"><div align="center">HIP/ROCm</div></th>
    <!-- <th class="tg-c3ow" rowspan="2">Accelerators</th> -->
  </tr>
  <tr>
    <th class="tg-0pky" style="text-align:center">20.04</th>
    <th class="tg-0pky" style="text-align:center">22.04</th>
    <th class="tg-0pky" style="text-align:center">2023.2</th>
    <th class="tg-0pky" style="text-align:center">2024.1</th>
    <th class="tg-0pky" style="text-align:center">6.1.2</th>
    <th class="tg-0pky" style="text-align:center">6.2.2</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky"><div align="center">BUILD</div></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">U50D</div></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <!--<td class="tg-0pky" style="text-align:center">Alveo U50D</td>  xilinx_u50_gen3x16_xdma_base_5 -->
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">U55C</div></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <!-- <td class="tg-0pky">Alveo U55C</td> xilinx_u55c_gen3x16_xdma_base_3 -->
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">V80</div></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"> </td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <!-- <td class="tg-0pky" >Alveo V80</td> -->
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">ALVEO BOXES</div></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"> </td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center"></td>
    <!-- <td class="tg-0pky">Alveo U250<br> Alveo U280</td> xilinx_vck5000_gen4x8_qdma_base_2 -->
  </tr>
  <tr>
    <td class="tg-0pky"><div align="center">HACC BOXES</div></td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <td class="tg-0pky" align="center"></td>
    <td class="tg-0pky" align="center">&#9679;</td>
    <!-- <td class="tg-0pky">Alveo U55C (2)<br>Versal VCK500 (2)<br>Instinct MI210 (4)</td>  xilinx_u55c_gen3x16_xdma_base_3 <br> xilinx_vck5000_gen4x8_qdma_base_2 -->
  </tr>
</tbody>
<!-- <tfoot><tr><td colspan="8">&#9675; Existing release.</td></tr></tfoot>
<tfoot><tr><td colspan="8">&#9679; Existing release installed on the cluster.</td></tr></tfoot> -->
</table>

## Ubuntu
Ubuntu releases are according to [IT Service Group of the Department of Computer Science](https://www.isg.inf.ethz.ch/Main/ServicesDesktopsAndLaptopsLinux) release schedule.

## AMD Tools
### Reconfigurable devices
AMD's tool versioning for ASoCs and FPGAs follows [XRT’s release schedule.](https://github.com/Xilinx/XRT/releases) All servers equipped with Alveo or Versal boards (referred to as deployment servers) are associated with a unique AMD software version. This includes XRT's Xilinx Board Utility (xbutil), Vivado, Vitis_HLS, and the flashable partitions (or base shell) running on the reconfigurable devices. Some deployment servers also feature Vitis installed. Pay attention to the **welcome message,** as it will indicate the installed tools and their locations.

![Installed AMD Tools.](./imgs/installed-xilinx-tools.png "Installed AMD Tools.")
*Installed AMD Tools.*

<!-- ### Alveo U250 and U280 End-of-Life (EOL) -->

AMD has officially announced the end-of-life (EOL) for its Alveo U250 and U280 data center accelerator cards. As a consequence, **we will no longer update tools or provide support for these devices.** The current tools will be **frozen at version 2023.2 (running on Ubuntu 22.04),** and no further updates will be released for these platforms. Users of the U250 and U280 are encouraged to plan for migration to alternative solutions within AMD's portfolio or other supported products. Please refer to the official AMD documentation and support channels for more details.

### Graphic Processing Units (GPUs)
For GPU accelerators, HIP and ROCm tools versioning is according to [HIP release schedule](https://github.com/ROCm-Developer-Tools/HIP/releases).

# Usage guidance
When utilizing the HACC, please adhere to the following guidelines:

* **Deployment servers:** Utilize deployment servers exclusively for testing and verification purposes. Refrain from utilizing them for any software builds. Restrict your usage on these machines to Vitis and HIP runtime.

* **Software builds:** For software building tasks, utilize the HACC BUILD cluster instead. This machine allows multiple users simultaneous access without requiring booking. Only resort to this node if you lack local access to suitable servers for running builds in your institute.

* **Tool installations:** Users are only permitted to use preinstalled tools on the system. Avoid installing external tools without prior approval from the HACC manager. If utilizing PYNQ, you may install packages using pip3, ensuring the package is system-wide installed beforehand. For any special requirements, contact [research_clusters@amd.com,](mailto:research_clusters@amd.com) and we will endeavor to accommodate your needs.

* Lastly, ensure compliance with the [Booking rules.](./docs/booking-system.md#booking-rules)

# Acknowledgment and citation

We encourage ETHZ-HACC users to acknowledge the support provided by AMD and ETH Zürich for their research in presentations, papers, posters, and press releases. Please use the following acknowledgment statement and citation.

## Acknowledgment

This work was supported in part by AMD under the Heterogeneous Accelerated Compute Clusters (HACC) program (formerly known as the XACC program - Xilinx Adaptive Compute Cluster program)

## Citation

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8340448.svg)](https://doi.org/10.5281/zenodo.8340448)

```
@misc{moya2023hacc,
  author       = {Javier Moya, Matthias Gabathuler, Mario Ruiz, Gustavo Alonso},
  title        = {fpgasystems/hacc: ETHZ-HACC},
  howpublished = {Zenodo},
  year         = {2023},
  month        = sep,
  note         = {\url{https://doi.org/10.5281/zenodo.8340448}},
  doi          = {10.5281/zenodo.8340448}
}
```

### Download

To get a printed copy of the cited resource, please follow [this link.](https://public.3.basecamp.com/p/oQPqiHQ8yHNatsMT7zMxteZ5) 

# License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Copyright (c) 2022 FPGA @ Systems Group, ETH Zurich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/README.md">Back</a>
</p>

# Infrastructure
FSG HACC is comprised of high-​end servers, Xilinx accelerator cards, and high-​speed networking. Each accelerator card has all of its QSFP28 interfaces connected to a 100 GbE TOR switch to allow exploration of arbitrary network topologies for distributed computing.

![FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking..](../imgs/infrastructure.png "FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking..")
*FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking.*

Additionally, we are offering a build server with development and bitstream compilation purposes. The following table gives an overview of FSG’s HACC resources: 

<table>
<thead>
  <tr>
    <th rowspan="2">Cluster</th>
    <th colspan="4">High-end servers</th>
    <th colspan="3">Xilinx accelerator card</th>
    <th colspan="5">FPGA/ACAP</th>
  </tr>
  <tr>
    <th>Family</th>
    <th>Memory</th>
    <th>CPU</th>
    <th>SSD</th>
    <th>Family</th>
    <th>DDR</th>
    <th>FPGA/ACAP</th>
    <th>LUTs</th>
    <th>Registers</th>
    <th>DSPs</th>
    <th>RAM</th>
    <th>HBM2</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Build</td>
    <td>PowerEdge R740</td>
    <td>394 GB</td>
    <td>80</td>
    <td>3 TB</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>U250</td>
    <td>PowerEdge R740</td>
    <td>128 GB</td>
    <td>16</td>
    <td>200/300 GB</td>
    <td>Alveo U250</td>
    <td>64 GB</td>
    <td>Virtex Ultrascale+</td>
    <td>1’728 K</td>
    <td>3’456 K</td>
    <td>12’288</td>
    <td>UltraRAM: 368.0 Mb</td>
    <td>-</td>
  </tr>
  <tr>
    <td>U280</td>
    <td>PowerEdge R740</td>
    <td>128 GB</td>
    <td>16</td>
    <td>200/300 GB</td>
    <td>Alveo U280</td>
    <td>32 GB</td>
    <td>Virtex Ultrascale+ HBM</td>
    <td>1’304 K</td>
    <td>2’607 K</td>
    <td>9’024</td>
    <td>-BRAM: 70.9 Mb<br>-UltraRAM: 270.0 Mb</td>
    <td>8 GB</td>
  </tr>
  <tr>
    <td>U50D</td>
    <td>AMD EPYC 7302</td>
    <td>64 GB</td>
    <td>32</td>
    <td>480 GB</td>
    <td>Alveo U50D</td>
    <td>-</td>
    <td>?</td>
    <td>872 K</td>
    <td>1’743 K</td>
    <td>5’952</td>
    <td>-Distributed RAM: 24.6 Mb<br>-BRAM: 47.3 Mb<br>-UltraRAM: 180.0 Mb</td>
    <td>8 GB</td>
  </tr>
  <tr>
    <td>U55C</td>
    <td>AMD EPYC 7302</td>
    <td>64 GB</td>
    <td>32</td>
    <td>1.2 TB</td>
    <td>Alveo U55C</td>
    <td>-</td>
    <td>Virtex Ultrascale+ HBM</td>
    <td>1’304 K</td>
    <td>2’607 K</td>
    <td>9’024</td>
    <td>-Distributed RAM: 36.7 Mb<br>-BRAM: 70.9 Mb<br>-UltraRAM: 270.0 Mb</td>
    <td>16 GB</td>
  </tr>
  <tr>
    <td>Versal</td>
    <td>PowerEdge R740</td>
    <td>128 GB</td>
    <td>16</td>
    <td>200 GB</td>
    <td>Versal VCK5000</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</tbody>
</table>

Remember that each high-end server exposes **only one Xilinx accelerator card to the user.**

## High-end servers

### AMD EPYC

## Xilinx accelerator cards

### U50D 

### U55C 

### U250

### U280

## Networking

## Limitations

* Els servidors son virtualitzats
* Els servidors comparteixen XXX
* Els servidors XXXX no tenen JTAG

<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/README.md">Back</a>
</p>

# Infrastructure
FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking. Each accelerator card has all of its QSFP28 interfaces connected to a 100 GbE TOR switch to allow exploration of arbitrary network topologies for distributed computing.

![FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking..](../imgs/infrastructure.png "FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking..")
*FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking.*

Additionally, we are offering a build server with development and bitstream compilation purposes.

## Inventory
The following table gives an overview of FSG’s HACC resources: 

<table class="tg">
<thead>
  <tr>
    <th class="tg-0pky" rowspan="2">Cluster</th>
    <th class="tg-0pky" colspan="3">Releases</th>
    <th class="tg-c3ow" rowspan="2">Base and/or shell</th>
  </tr>
  <tr>
    <th class="tg-0pky">2021.1</th>
    <th class="tg-0pky">2021.2</th>
    <th class="tg-0pky">2022.1</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky">U50D</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">xx</td>
    <td class="tg-0pky">x</td>
    <td class="tg-0pky">xilinx_u50_gen3x16_xdma_201920_3</td>
  </tr>
  <tr>
    <td class="tg-0pky">U55C</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">xx</td>
    <td class="tg-0pky">x</td>
    <td class="tg-0pky">xilinx_u55c_gen3x16_xdma_base_2</td>
  </tr>
  <tr>
    <td class="tg-0pky">U250</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">xx</td>
    <td class="tg-0pky">x</td>
    <td class="tg-0pky">xilinx_u250_gen3x16_base_3<br>xilinx_u250_gen3x16_xdma_shell_3_1<br></td>
  </tr>
  <tr>
    <td class="tg-0pky">U280</td>
    <td class="tg-0pky">xx</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">xilinx_u280_xdma_201920_3</td>
  </tr>
</tbody>
</table>

Remember that each high-end server exposes **only one Xilinx accelerator card to the user.**

## AMD high-end servers

### El model

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

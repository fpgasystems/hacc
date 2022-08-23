<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/README.md">Back</a>
</p>

# Infrastructure
FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking. Each accelerator card has all of its QSFP28 interfaces connected to a 100 GbE TOR switch to allow exploration of arbitrary network topologies for distributed computing.

![FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking..](../imgs/infrastructure.png "FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking..")
*FSG HACC is comprised of AMD high-​end servers, Xilinx accelerator cards, and high-​speed networking.*

Additionally, we are offering a build server with development and bitstream compilation purposes. The following table gives an overview of FSG’s HACC resources: 

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-baqh{text-align:center;vertical-align:top}
.tg .tg-c3ow{border-color:inherit;text-align:center;vertical-align:top}
.tg .tg-0lax{text-align:left;vertical-align:top}
.tg .tg-0pky{border-color:inherit;text-align:left;vertical-align:top}
.tg .tg-5qt9{font-size:small;text-align:left;vertical-align:top}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-c3ow" rowspan="2">Cluster</th>
    <th class="tg-c3ow" colspan="4">High-end servers</th>
    <th class="tg-c3ow" colspan="3">Xilinx accelerator card</th>
    <th class="tg-baqh" colspan="6">FPGA</th>
  </tr>
  <tr>
    <th class="tg-c3ow">Family</th>
    <th class="tg-c3ow">Memory</th>
    <th class="tg-c3ow">CPU</th>
    <th class="tg-c3ow">SSD</th>
    <th class="tg-c3ow">Family</th>
    <th class="tg-c3ow">DDR</th>
    <th class="tg-c3ow">FPGA</th>
    <th class="tg-baqh">LUTs</th>
    <th class="tg-baqh">Registers</th>
    <th class="tg-baqh">DSPs</th>
    <th class="tg-baqh">DRAM</th>
    <th class="tg-baqh">BRAM</th>
    <th class="tg-baqh">HBM</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0lax">Build</td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
  </tr>
  <tr>
    <td class="tg-0pky">U250</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">xx</td>
    <td class="tg-0pky">x</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">Alveo U250</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
  </tr>
  <tr>
    <td class="tg-0pky">U280</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">xx</td>
    <td class="tg-0pky">x</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">Alveo U280</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0lax"></td>
    <td class="tg-5qt9"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
  </tr>
  <tr>
    <td class="tg-0pky">U50D</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">xx</td>
    <td class="tg-0pky">x</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">Alveo U50D</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
  </tr>
  <tr>
    <td class="tg-0pky">U55C</td>
    <td class="tg-0pky">xx</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">Alveo U55C</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
  </tr>
  <tr>
    <td class="tg-0pky">Versal</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky">Versal VCK5000</td>
    <td class="tg-0pky"></td>
    <td class="tg-0pky"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
    <td class="tg-0lax"></td>
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

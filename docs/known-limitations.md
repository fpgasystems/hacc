<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc#--heterogenous-accelerated-compute-cluster">Back to top</a>
</p>

# Known limitations

* The U250 and U280 servers—as well as the Versal server—are virtualized. 
* Not all servers in the U250 cluster support the Vivado workflow (as they do not have a USB - JTAG connection). The same is true for the Versal server.
* None of the QSFP28 FPGA interfaces are directly connected to other FPGAs—in a point-to-point topology—but to the corresponding leaf switch.
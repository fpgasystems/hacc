<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/docs/examples.md#examples">Back to Examples</a>
</p>

# Hello, Coyote!
Similarly to Vitis [Hello, world!](),  we are solving a simple two-vector addition using Coyote [[1]](#references). For didactic purposes, the load/compute/store coding style is applied to different combinations of host code and kernel’s description languages like HLS C/C++ , OpenCL [[3]](#references), or RTL [[4]](#references).

## Creating a Coyote project

sgutil new coyote

sgutil build coyote -p hello_coyote

Select:

Coyote (shell) parameters:

Global parameters:
N_REGIONS 3
EN_PR 0
N_CONFIG 1
EN_HLS 0

Memory parameters:
EN_DDR 0
N_DDR_CHAN 0
EN_STRM 1
EN_HBM 0

Networking parameters:
EN_TCP_0 0
EN_TCP_1 0
EN_RDMA_0 0
EN_RDMA_1 0
EN_RPC 0

Clocking parameters:
EN_ACLK 0
EN_NCLK 0
EN_UCLK 0

Application (hardware) parameters:

Choose at your convenience...
        

## References
* [[1] Coyote](https://github.com/fpgasystems/Coyote)

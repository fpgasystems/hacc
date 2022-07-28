<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc">Back</a> | Next
</p>

# Projects
System’s Group scientific staff uses the ETHZ’s HACC to develop, test, and ship their applications.

## ACCL: Accelerated Collective Communication Library
ACCL is designed to enable compute kernels resident in FPGA fabric to communicate directly under host supervision but without requiring data movement between the FPGA and host. Instead, ACCL uses Vitis-compatible TCP and UDP stacks to connect FPGAs directly over Ethernet at up to 100 Gbps on Alveo cards.

[See ACCL on GitHub.](https://github.com/Xilinx/ACCL)

## Coyote
Coyote is an open source, portable, configurable *shell* for FPGAs which provides a full suite of OS abstractions, working with the host OS. Coyote supports secure spatial and temporal multiplexing of the FPGA between tenants, virtual memory, communication, and memory management inside a uniform execution environment. The overhead of Coyote is small, and the performance benefit is significant, but more importantly, it allows us to reflect on whether importing OS abstractions wholesale to FPGAs is the best way forward.

[See Coyote on GitHub.](https://github.com/fpgasystems/Coyote)

### Hardware Transaction Processing for multi-channel memory node
Transactional memory attempts to simplify concurrent programming by allowing a group of load and store instructions to execute in an atomic way. It is a concurrency control mechanism analogous to database transactions controlling access to shared memory in concurrent computing. Transactional memory systems provide high-level abstraction as an alternative to low-level thread synchronization. Building a hardware transaction processing layer for the multi-channel memory node is valuable.

[See on GitHub.](https://github.com/rbshi/dlm)

## EasyNet

[See EasyNet on GitHub.](https://github.com/fpgasystems/Vitis_with_100Gbps_TCP-IP)

We are working to make all the deployments described here available through our CLI.
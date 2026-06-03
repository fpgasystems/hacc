# Terminology

## Ansible
[Ansible](https://www.ansible.com) is an open-source tool developed by RedHat for server configuration management, and application-deployment automation. Ansible allows us to declare the state of our servers in a semi-declarative way, enabling us to quickly configure new servers and document the state of them at the same time.

## Pipeline
This refers to CI/CD pipelines as found in tools like GitHub and GitLab. In our case, we store our Ansible code in a locally hosted GitLab repo and use a GitLab pipeline to apply the Ansible configuration to our servers.

## DCIM
Data Center Infrastructure Management (DCIM) is a term used for keeping track of the physical items (the inventory) in a Data Center. This also includes how the physical items are interconnected and relate to each other. We created an inventory model of our physical infrastructure and use this to build tools on top of the data. This bridges the gap between users and the physical infrastructure.

## PCI hot-plug
We refer to the PCIe hot-plug as the process that allows us to transition Xilinx accelerator cards from the Vitis to Vivado workflows or vice-versa. The critical aspect of the process is to use Linux capabilities to re-enumerate PCI devices on the fly without the need for cold or warm rebooting of the system. Many thanks to Alex Forencich for his blog post: [https://alexforencich.com/wiki/en/pcie/hot-reset-linux](https://alexforencich.com/wiki/en/pcie/hot-reset-linux)

## Cold boot
The process of rebooting a server, where between shutdown and power on, the server is completely detached from power. This is also referred to as a `Power cycle`. In the context of AMD Alveo Cards, a cold boot causes the programmable fabric to be reset. The device will have to load the flashable partitions (or base shell) from the card’s Flash memory and program the programmable logic with it. This operation thus resets the programmable logic to its default fabric. Users are able to do this on the ETHZ-HACC, using `sudo hdev reboot -c`.

## Warm boot
A warm boot is the same as a regular reboot (`sudo reboot now` in Linux). Between shutdown and power on, power is not interrupted. This is also referred to as a `Graceful reboot`. In the context of Xilinx Alveo Cards, after a warm boot the programmable fabric is not reset and still contains the same bitstream as before the reboot. A warm reboot sometimes is needed, when hot-plugging is not sufficient.

## Vivado and Vitis workflows
AMD offers a hardware-centric approach to designing hardware for FPGAs using Vivado and also a more software-centric approach to developing *both* hardware and software using Vitis. The Vitis approach requires the XRT shell to be present on the FPGA, whereas the Vivado approach allows one to fully control the entire programmable fabric, therefore we refer to these approaches as the Vitis workflow and Vivado Workflow respectively.

### Vivado workflow
Vivado is for creating hardware designs that run in an FPGA. These either consist of a set of hardware description language (HDL, typically Verilog or VHDL) files, or of a block design, which can include a variety of pre-built IP blocks (which at their core abstract away pre-written HDL). If a design includes a processor, Vitis will also be required to write the program to run on the processor, as Vivado only handles the programmable logic.

### Vitis workflow
Vitis is for writing software to run in an FPGA, and is the combination of a couple of different Xilinx tools, including what was Xilinx SDK, Vivado High-Level Synthesis (HLS), and SDSoC. The functionality of each of these is now merged together under Vitis. This workflow primarily targets the XRT shell as a foundation.

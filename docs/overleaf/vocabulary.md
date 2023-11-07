# Vocabulary

## Agile 
Agile is an iterative project management and software development approach that helps teams deliver value to their customers faster and with fewer headaches. Instead of betting everything on a long-term launch, an agile team provides work in small but consumable increments. Requirements, plans, and results are evaluated continuously, so teams have a natural mechanism for responding to change quickly. Frameworks such as Shape up or DevOps are considered part of Agile methodologies.

## Ansible Automation Platform (AAP)
The Red Hat **Ansible Automation Platform (AAP)** is an orchestrated and open-source tool for software provisioning, configuration management, and application-deployment automation. Ansible uses its own YAML-based declarative language enabling Infrastructure as Code (IaC).

## DCIM
Data center infrastructure management (DCIM) is the integration of information technology (IT) and facility management disciplines to centralize monitoring, management and intelligent capacity planning of a data center's critical systems.

## Deployment types
### Infrastructure as a service (IaaS)
Introduced in 2012 by Oracle, infrastructure as a service (IaaS) is a cloud computing service model through which computing resources are hosted in a public, private, or hybrid cloud and provided on-demand to the final users.

### Platform as a service (PaaS)
Platform as a service (PaaS) is a category of cloud computing services that allows customers to provision, instantiate, run, and manage a modular bundle comprising a computing platform and one or more applications, without the complexity of building and maintaining the infrastructure typically associated with developing and launching the application(s); and to allow developers to create, develop, and package such software bundles.

## DevOps 
DevOps is a set of practices that combines software development (Dev) and IT operations (Ops). It aims to shorten the systems development life cycle and provide continuous delivery with high software quality. Several DevOps aspects came from the Agile methodology.

## PCI hot-plug 
We refer to the PCIe hot-plug as the process that allows us to transition Xilinx accelerator cards from the Vitis to Vivado workflows or vice-versa. The critical aspect of the process is to use Linux capabilities to re-enumerate PCI devices on the fly without the need for cold or warm rebooting of the system.

### Cold boot
The process of powering off and on the machine to completely reload the operating system and reset all the hardware peripherals (including all PCI devices). In the context of Xilinx Alveo Cards, a cold boot causes to pull the flashable partitions (or base shell) from the card’s PROM into the programmable logic. This operation is required to revert a server to the Vitis workflow.

### Warm boot
A warm boot restarts the system without the need to interrupt the power. In the context of Xilinx Alveo Cards, a warm boot would be required to re-enumarate the number of PCI functions without restoring the base shell. This operation is required to bring a server to the Vivado workflow.

## Infrastructure as Code (IaC)
Infrastructure as Code (IaC) is the process of provisioning and managing computer data centers through machine- and human-readable YAML definition files—rather than physical hardware configuration or interactive configuration tools. The IT infrastructure managed by this process comprises physical equipment, such as bare-metal servers, virtual machines, and associated configuration resources. The definitions may be in a version control system.

### Tools
There are many tools that fulfill infrastructure automation capabilities and use IaC. Broadly speaking, any framework or tool that performs changes or configures infrastructure declaratively or imperatively based on a programmatic approach can be considered IaC. ETHZ-HACC uses Ansible for defining the cluster infrastructure.

### Relation to DevOps
IaC can be a key attribute of enabling best practices in DevOps–developers become more involved in defining configuration and Ops teams get involved earlier in the development process. Tools that utilize IaC bring visibility to the state and configuration of servers and ultimately provide the visibility to users within the enterprise, aiming to bring teams together to maximize their efforts.

## Shape up
Instead of *Scrum,* we use **Shape up** to shape and build our accelerated applications. To execute the techniques of the method we use **Basecamp**—a project management tool that puts all our project communication, task management, and documentation in one place (where designers and programmers work seamlessly together). To see how we make that happen, please visit **How to implement Shape up in Basecamp**.

## Spine-leaf architecture 
A spine-leaf architecture is data center network topology that consists of two switching layers—a spine and leaf. The leaf layer consists of access switches that aggregate traffic from servers and connect directly into the spine or network core. Spine switches interconnect all leaf switches in a full-mesh topology.

## Vivado and Vitis workflows
Vivado offers a hardware-centric approach to designing hardware, while Vitis offers a software-centric approach to developing *both* hardware and software. These perspectives are best represented by the languages used to make things with the two tools.

### Vivado workflow
Vivado is for creating hardware designs that run in an FPGA. These either consist of a set of hardware description language (HDL, typically Verilog or VHDL) files, or of a block design, which can include a variety of pre-built IP blocks (which at their core abstract away pre-written HDL). If a design includes a processor, Vitis will also be required to write the program to run on the processor, as Vivado only handles the programmable logic.

### Vitis workflow
Vitis is for writing software to run in an FPGA, and is the combination of a couple of different Xilinx tools, including what was Xilinx SDK, Vivado High-Level Synthesis (HLS), and SDSoC. The functionality of each of these is now merged together under Vitis. 

## YAML
YAML is a human-readable data-serialization language commonly used for configuration files and in applications where data is being stored or transmitted. 

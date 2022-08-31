<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/README.md">Back</a>
</p>

# Vocabulary

## Agile 
Agile is an iterative project management and software development approach that helps teams deliver value to their customers faster and with fewer headaches. Instead of betting everything on a long-term launch, an agile team provides work in small but consumable increments. Requirements, plans, and results are evaluated continuously, so teams have a natural mechanism for responding to change quickly. Frameworks such as [Shape up](https://basecamp.com/shapeup) or [DevOps](#devops) are considered part of Agile methodologies. <!-- https://www.atlassian.com/agile -->

## Ansible
The [Red Hat Ansible Automation Platform (AAP)](https://www.ansible.com) is an orchestrated and open-source tool for software provisioning, configuration management, and application-deployment automation. Ansible uses its own YAML-based declarative language enabling [infrastructure as code](#infrastructure-as-code-iac).

## Deployment types
### Infrastructure as a service (IaaS)
Introduced in 2012 by Oracle, infrastructure as a service (IaaS) is a cloud computing service model through which computing resources are hosted in a public, private, or hybrid cloud and provided on-demand to the final users.

### Platform as a service (PaaS)
Platform as a service (PaaS) is a category of cloud computing services that allows customers to provision, instantiate, run, and manage a modular bundle comprising a computing platform and one or more applications, without the complexity of building and maintaining the infrastructure typically associated with developing and launching the application(s); and to allow developers to create, develop, and package such software bundles.

## DevOps 
DevOps is a set of practices that combines software development (Dev) and IT operations (Ops). It aims to shorten the systems development life cycle and provide continuous delivery with high software quality. Several DevOps aspects came from the [Agile](#agile) methodology. <!-- https://en.wikipedia.org/wiki/DevOps -->

## Hot-plug boot
We refer to the hot-plug boot as the process that allows us to transition Xilinx Alveo Cards from the Vitis to Vivado workflows or vice-versa. The critical aspect of the process is to use Linux capabilities to re-enumerate PCI devices on the fly without the need for cold or warm rebooting of the system.

### Cold boot
The process of powering off and on the machine to completely reload the operating system and reset all the hardware peripherals (including all PCI devices). In the context of Xilinx Alveo Cards, a cold boot causes to pull the flashable partitions (or base shell) from the card’s PROM into the programmable logic. This would be an opration required to revert a server to the Vitis workflow.

### Warm boot
A warm boot restarts the system without the need to interrupt the power. In the context of Xilinx Alveo Cards, a warm boot would be required to re-enumarate the number of PCI functions without restoring the base shell. A warm boot would be required to bring a server to the Vivado workflow.

## Infrastructure as Code (IaC)
Infrastructure as Code (IaC) is the process of provisioning and managing computer data centers through machine- and human-readable [YAML](#yaml) definition files—rather than physical hardware configuration or interactive configuration tools. The IT infrastructure managed by this process comprises physical equipment, such as bare-metal servers, virtual machines, and associated configuration resources. The definitions may be in a version control system.

<!-- Infrastructure as code (IaC) uses [DevOps](#devops) methodology and versioning with a descriptive model to define and deploy infrastructure, such as networks, virtual machines, load balancers, and connection topologies. Just as the same source code always generates the same binary, an IaC model generates the same environment every time it deploys—specially when the source code is in a version control system. IaC is a key DevOps practice and a component of continuous delivery. With IaC, DevOps teams can work together with a unified set of practices and tools to deliver applications and their supporting infrastructure rapidly and reliably at scale. https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code -->

### Tools
There are many tools that fulfill infrastructure automation capabilities and use IaC. Broadly speaking, any framework or tool that performs changes or configures infrastructure declaratively or imperatively based on a programmatic approach can be considered IaC. FSG HACC uses [Ansible](#ansible) for defining the cluster infrastructure.

### Relation to DevOps
IaC can be a key attribute of enabling best practices in [DevOps](#devops)–developers become more involved in defining configuration and Ops teams get involved earlier in the development process. Tools that utilize IaC bring visibility to the state and configuration of servers and ultimately provide the visibility to users within the enterprise, aiming to bring teams together to maximize their efforts.

## Spine-leaf architecture 
A spine-leaf architecture is data center network topology that consists of two switching layers—a spine and leaf. The leaf layer consists of access switches that aggregate traffic from servers and connect directly into the spine or network core. Spine switches interconnect all leaf switches in a full-mesh topology. <!-- https://www.arubanetworks.com/faq/what-is-spine-leaf-architecture/ -->

## YAML
YAML is a human-readable data-serialization language commonly used for configuration files and in applications where data is being stored or transmitted. 
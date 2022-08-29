<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/README.md">Back</a>
</p>

# Vocabulary

## Agile 
Agile is an iterative project management and software development approach that helps teams deliver value to their customers faster and with fewer headaches. Instead of betting everything on a long-term launch, an agile team provides work in small but consumable increments. Requirements, plans, and results are evaluated continuously, so teams have a natural mechanism for responding to change quickly. Frameworks such as [Shape up](https://basecamp.com/shapeup) or [DevOps](#devops) are considered part of Agile methodologies. <!-- https://www.atlassian.com/agile -->

## Ansible
The [Red Hat Ansible Automation Platform (AAP)](https://www.ansible.com) is an orchestrated and open-source tool for software provisioning, configuration management, and application-deployment automation. Ansible uses its own YAML-based declarative language enabling [infrastructure as code](#infrastructure-as-code). 

### AAP
The *Ansible Automation Platform* (AAP) is a product that includes enterprise level features and integrates many tools of the Ansible ecosystem like the ansible-core, awx, galaxyNG, and so on.

## DevOps 
DevOps is a set of practices that combines software development (Dev) and IT operations (Ops). It aims to shorten the systems development life cycle and provide continuous delivery with high software quality. Several DevOps aspects came from the [Agile](#agile) methodology. <!-- https://en.wikipedia.org/wiki/DevOps -->

## Infrastructure as Code
Infrastructure as Code (IaC) is the process of provisioning and managing computer data centers through machine-readable definition files rather than physical hardware configuration or interactive configuration tools. The IT infrastructure managed by this process comprises physical equipment, such as bare-metal servers, virtual machines, and associated configuration resources. The definitions may be in a version control system.

### Tools
There are many tools that fulfill infrastructure automation capabilities and use IaC. Broadly speaking, any framework or tool that performs changes or configures infrastructure declaratively or imperatively based on a programmatic approach can be considered IaC. FSG HACC uses [Ansible](#ansible) for defining the cluster infrastructure.

### Relation to DevOps
IaC can be a key attribute of enabling best practices in [DevOps](#devops)–developers become more involved in defining configuration and Ops teams get involved earlier in the development process. Tools that utilize IaC bring visibility to the state and configuration of servers and ultimately provide the visibility to users within the enterprise, aiming to bring teams together to maximize their efforts.

## Shape up

## Spine-leaf architecture 
A spine-leaf architecture is data center network topology that consists of two switching layers—a spine and leaf. The leaf layer consists of access switches that aggregate traffic from servers and connect directly into the spine or network core. Spine switches interconnect all leaf switches in a full-mesh topology. <!-- https://www.arubanetworks.com/faq/what-is-spine-leaf-architecture/ -->

## YAML
YAML is a human-readable data-serialization language commonly used for configuration files and in applications where data is being stored or transmitted. 
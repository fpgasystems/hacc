<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/README.md">Back</a>
</p>

# Operating the cluster

<!-- We manage our HACC fully automatic: there is no room for manual administration. By using [Ansible](docs/vocabulary.md#ansible),  -->

Our HACC is provisioned and managed based on [Infrastructure as Code](../docs/vocabulary.md#infrastructure-as-code) and [Ansible](../docs/vocabulary.md#ansible). With such an approach we can be sure that the cluster configuration is homogeneous and reproducible—so we can reset the whole infrastructure to a defined state at any time. In fact, we can re-install and set up from scratch—without other interaction—all of the servers in our cluster in about an hour. 

The following figure shows a simplified model of HACC’s Ansible automation platform:

![Ansible Automation Platform (AAP).](../imgs/ansible.png "Ansible Automation Platform (AAP).")
*Ansible Automation Platform (AAP).*

The playbooks and task definning our cluster are grouped into two diferenciated parts. The first one is for definning the infrastructure itself and relates to the OS installation (including the definitions of partition sizes and similar lower-level attributes), Debian packages installation, and network setup. The second part of the IaC files relate to the PaaS side of the service as we take care of the installation of all the software required for our users would need to develop their heterogeneous accelerated applications, including: XRT’s Xilinx Board Utility (xbutil), Xilinx tools (Vivado, Vitis_HLS, Vitis), and the flashable partitions (or base shell) running on the FPGA. Thanks to Ansible we are able to easily follow Xilinx’s tools versioning release schedule as mentioned in [Releases](../README.md/#releases).

<!-- Such a process includes installing not only the operating system and Debian packages but also all Xilinx tools, the deployment and development platforms, the base shells’ programming (with a handled servers’ cold boot), and networking configuration. In addition, the YAML-based playbooks and tasks allow us to inherently document servers and cluster setup.



------------

Operations (we actually are managing the cluster with DevOps ==> an agile approach to handle the cluster)
Managed cluster which is publicly available.

THis is not a service... We provide access to a cluster in a more low-level... Service is much more abstracted... here we are still accessing the whole server and we can operate with more freedom. 

It could be PaaS but S (Service) would be too ambitious... PaaS won’t be wrong

IaaS would be correct. Ansible is a platform supporting IaaS. Ansible helps us or support our IaaS. With ansible we install XRT that brings us to PaaS ===> so IaaS would be the installation and setup of the network, OS, etc. and then we go one step forward with XRT/PaaS. 

Ansible ===> Infrastructure as a code. We define everything in a code in a repository => this was the main design decision... 
Infrastructure as code was the primary design choice we made. Infrastructure as Code is a paradigm. Which allows us that allows us to test hardware designs between Xilinx realeses for better availability and mainteinability (much better with Ansible as we know that all the systems are in the same state!).

ANSIBLE makes the operation of the cluster easier ==> is the tool we choose because our support department had the know-how. 


-Public cloud? Private cloud? Managed cloud?
-Networking architecture? What happens when we do SSH to the cluster but then the Mellanox and IPs are in another LAN?
-Ansible reference model? -->
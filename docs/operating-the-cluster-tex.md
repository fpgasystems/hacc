# Operating the cluster

Our HACC is provisioned and managed based on [Infrastructure as Code (IaC)](../docs/vocabulary.md#infrastructure-as-code-iac) and [Ansible Automation Platform (AAP)](../docs/vocabulary.md#ansible-automation-platform-aap). Just as the same source code always generates the same binary, an IaC model generates the same environment every time it deploys. This allows us to reset the whole infrastructure to a defined state at any time. In fact, we can re-install and set up from scratch—without other interaction—all of the servers in our cluster in about an hour.

The following figure shows a simplified model of HACC’s Ansible automation platform:

![Ansible Automation Platform (AAP).](../imgs/ansible.png "Ansible Automation Platform (AAP).")

The playbooks defining our cluster are grouped into two categories: [IaaS](../docs/vocabulary.md#infrastructure-as-a-service-iaas) and [PaaS](../docs/vocabulary.md#platform-as-a-service-paas) playbooks. We refer the IaaS playbooks to the [YAML](../docs/vocabulary.md#yaml) files describing the infrastructure itself. This relates to the OS installation (including the definitions of partition sizes and similar lower-level attributes), virtual machines, networking setup, load balancers, connection topologies, and Debian package installation. With the PaaS playbooks, we take care of installing the software allowing users to develop their heterogeneous accelerated applications. 

**Thanks to IaC and AAP, we can easily follow Xilinx’s tools versioning release schedule as mentioned in [Releases.](../README.md#releases)**

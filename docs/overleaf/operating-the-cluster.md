# Operating the cluster

Our HACC is provisioned and managed based on **Infrastructure as Code (IaC)**. Just as the same source code always generates the same binary, an IaC model generates the same environment every time it deploys. This allows us to reset the whole infrastructure to a defined state at any time. In fact, we can re-install and set up from scratch—without other interaction—all of the servers in our cluster in about an hour.

The following figure shows a simplified model of HACC’s Ansible automation platform:

![Ansible Automation Platform (AAP).](./ansible.png "Ansible Automation Platform (AAP).")

The playbooks defining our cluster are grouped into two categories: **IaaS**, virtual machines, networking setup, load balancers, connection topologies, and Debian package installation. With the PaaS playbooks, we take care of installing the software allowing users to develop their heterogeneous accelerated applications. 

**Thanks to IaC and AAP, we can easily follow Xilinx’s tools versioning release schedule as mentioned in **Releases.****

## Pipelines

In order to maintain the health and performance of our cluster, two different pipelines are executed to ensure servers sanity and optimal functionality: 

* Weekly pipeline on build servers: Deals with memory leak mitigation, resource cleanup, consistent performance, and improved reliability.
* Daily pipeline on deployment servers: In addition, ensures that all servers are reverted to the **Vitis Workflow** *at the beginning of the day.*

The exact pipeline execution times are reflected on the **booking system** itself. 

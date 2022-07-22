<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://gitlab.inf.ethz.ch/OU-SYSTEMS/alveo-cluster/-/tree/main">Back</a> | Next
</p>


# Ansible Managed HACC
ETH’s Systems Group HACC is comprised of high-​end servers, Xilinx Alveo accelerator cards and high-​speed networking. This turns into a complex infrastructure that requires to be managed with an orchestrated configuration tool like [Red Hat Ansible Automation Platform](https://www.ansible.com). Ansible is an open-source software provisioning, configuration management, and application-deployment tool enabling infrastructure as code—including its own declarative language to describe system configuration [1]. 

## Base configuration and operating system
Both the base configuration and the operating system on the Alveo Cluster servers are managed by ISG through its own Ansible infrastructure. The configuration on each server is derived from the union of two different playbooks [A]. On the one hand, a group playbook defines the operating system installation, root users, hard disk partitions, network drives, and other management parameters common to all servers in the cluster. On the other hand, a host-specific playbook installs specific packages to each server [B].

Group and host playbooks are merged and deployed every hour by ISG on their automated Ansible machinery.

### Group playbook
A copy of the *_80_group_alveo_cluster.yml* [C] group playbook can be found [here](./_80_group_alveo_cluster.yml) (please pay attention to the comments giving a detailed description of the hard disk partions and network drives). 

### Host playbooks
Copies of the different yaml files for server representatives [D] can be found here:
* [alveo-hypervisor-01.ethz.ch.yml](./alveo-hypervisor-01.ethz.ch.yml)
* [alveo-u50d-01.inf.ethz.ch.yml](./alveo-u50d-01.inf.ethz.ch.yml)
* [alveo-u55c-01.inf.ethz.ch.yml](./alveo-u55c-01.inf.ethz.ch.yml) [E]
* [alveo-u250-01.ethz.ch.yml](./alveo-u250-01.ethz.ch.yml)
* alveo-u280-01.ethz.ch.yml
* versal-vck5000-01.ethz.yml

We can refer to groups of servers by means of the [hosts](../playbooks/hosts) file. With *hosts*, we can refer to the U250 cluster in our playbooks as *alveo-u250*—which identifies all the servers mounting an Alveo U250 Accelerator card (i.e., alveo-u250-[01:02].ethz.ch on the *hosts* file). 

## Xilinx tools and Alveo Cards Management
With ISG support, we have developed our own Ansible infrastructure to handle everything related to Xilinx tools and Alveo Accelerator Cards management. Ansible’s Alveo cards management is performed by means of cluster-specific playbooks (see [Alveo Card playbook](#alveo-card-playbooks) and [tasks](#tasks) [F]).

### Alveo Card playbooks
We define an specific playbook for each of the clusters defined in the *hosts* file, i.e.: [alveo-u250-install.yml](../playbooks/2021.2/alveo-u250-install.yml) or [alveo-u55c.yml](../playbooks/2021.2/alveo-u55c-install.yml). As we can see, each of these playbooks are a simply collection of variables (see [vars.yml](../playbooks/2021.2/vars.yml)) and tasks. 

### Tasks
Tasks are generic and cause a different effect on each cluster based on the varibales defined on the playbook. Most of the tasks could be considered duplicates amongst the releases. For example:

* [booking_system_add.yml](../playbooks/2021.2/tasks/booking_system_add.yml): makes the server available on the Alveo Booking System. Both the cluster and the servar names have to be introduced on the Alveo Booking System beforehand (see [Adding clusters and servers to the booking-system](https://public.3.basecamp.com/p/h4uuWmJpaGbnofcQ8fLG1MHD)).
* [dell_idrac_cold_boot.yml](../playbooks/2021.2/tasks/dell_idrac_cold_boot.yml): restarts the system by interrupting the power of the server using the integrated Dell Remote Access Controller (iDRAC). The intention of the task is to cut off power from PCIe devices so the Alveo cards effectively load XRT’s base shell after [xbmgmt_program_base_shell.yml](../playbooks/2021.2/tasks/xbmgmt_program_base_shell.yml).
* [install-vitis-core-dev-kit.yml](../playbooks/2021.2/tasks/install-vitis-core-dev-kit.yml): installs Vitis Core Development Kit on XXXX.
* [install-vitis-lab.yml](../playbooks/2021.2/tasks/install-vitis-lab.yml): installs Vitis_Lab on XXXX.
* [jtag_enable.yml](../playbooks/2021.2/tasks/jtag_enable.yml): installs the cable drivers and grants the required permissions to allow the Vivado developers group members to flash a shell on Alveo cards with secured JTAG connections.
* [vivado_developers_groupadd.yml](../playbooks/2021.2/tasks/vivado_developers_groupadd.yml): creates the *vivado_developers* group and adds the *vivado_users* defined in [vars.yml](../playbooks/2021.2/vars.yml) to it. The Vivado developers group members are able to run privileged (sudo) commands to flash custom shells (as Coyote) on the Alveo card.
* [xilinx-install-dependencies.yml](../playbooks/2021.2/tasks/xilinx-install-dependencies.yml)
* [xilinx-install-deployment.yml](../playbooks/2021.2/tasks/xilinx-install-deployment.yml): installs the deployment target platform on the `/opt/xilinx/firmware` folder.
* [xilinx-install-dev.yml](../playbooks/2021.2/tasks/xilinx-install-dev.yml): installs the development target platform on the `/opt/xilinx/platform` folder.
* [xilinx-install-xrt.yml](../playbooks/2021.2/tasks/xilinx-install-xrt.yml): installs Xilinx RunTime (XRT) on the server for the release version.

are identical for realeses 2021.2 and 2022.1. However, there are other tasks that are release-specific as: 

* [xbmgmt_program_base.yml](../playbooks/2021.2/tasks/xbmgmt_program_base.yml)
* [xbmgmt_program_shell.yml](../playbooks/2021.2/tasks/xbmgmt_program_shell.yml)

for release 2021.2—which are equivalent to these 2022.1’s release tasks:

* [xbmgmt_program_base_shell.yml](../playbooks/2022.1/tasks/xbmgmt_program_base_shell.yml): updates the persistent platform images (i.e., SHELL) on the device.
* [xbmgmt_program_base_partition.yml](../playbooks/2022.1/tasks/xbmgmt_program_base_partition.yml)
* [xbmgmt_program_base_sc.yml](../playbooks/2022.1/tasks/xbmgmt_program_base_sc.yml): updates the Satellite controller on the device. This operation can be only performed after performing a cold boot (i.e., by running [dell_idrac_cold_boot.yml](../playbooks/2022.1/tasks/dell_idrac_cold_boot.yml)) [G].

## Other playbooks
The following are general non-release-specific playbooks (see in `/playbooks/cluster_admin`):
* [sudo_temp_groupadd.yml](../playbooks/cluster_admin/sudo_temp_groupadd.yml): creates the *sudo_temp* group and adds the *sudo_temp_users* defined as *vars* on the playbook itself. The sudo temp group members receive sudo permissions on the server.
* [sudo_temp_groupdel.yml](../playbooks/cluster_admin/sudo_temp_groupdel.yml): deletes the *sudo_temp* group on the server.

### Templates
We have defined some Ansible templates that can be handful for defining more complex playbooks or tasks. You will find them under the [templates](../playbooks/cluster_admin/templates/) folder.

## Inslalling Ansible
To install Ansible for use at the command line, simply install the Ansible package on one machine:
~~~
apt-get update
apt-get install ansible
~~~

The following Ansible extensions are also required to run the Alveo Cluster playbooks:
~~~
ansible-galaxy collection install community.general
ansible-galaxy collection install dellemc.openmanage
ansible-galaxy collection install dellemc.os10
ansible-galaxy collection install community.libvirt
ansible-galaxy collection install ansible.posix
~~~

### Using ansible-vault
The ansible vault file can be used to store secret/confidential inforamtion (i.e. passwords, keys...) in file which can be commited into the git repository. The file is encrypted will be treated as a binary file by git.

To interact with the ansible vault file
~~~
# edit secrets inside the vault
# will re-encrypt the vault upon writing and closing the file
ansible-vault edit defaults/secrets.yml

# view the contents of the vault file
ansible-vault view defaults/secrets.yml
~~~

## Running Ansible playbooks
To run any of the playbooks defined in [Alveo Card playbooks](#alveo-card-playbooks) or [Other playbooks](#other-playbooks), proceed as follows:
1. Install Ansible on your local machine (see [Installing Ansible](#inslalling-ansible)).
2. Checkout the alveo-cluster repository:
~~~
$ git clone https://gitlab.inf.ethz.ch/OU-SYSTEMS/alveo-cluster.git
~~~
3. *Change directory* to `alveo-cluster/playbooks` and execute a playbook with `./run.sh release/playbook_name`, i.e.:
~~~
$ ./run.sh 2022.1/alveo-u250-install.yml
~~~

Only the root users defined in [*_80_group_alveo_cluster.yml*](docs/_80_group_alveo_cluster.yml) are able to make use of the *run.sh* script and playbooks. 

## Installing a server from scratch
After a PXE installation, release and platform specific alveo installation playbooks should be run. For example, if we would like to install Release 2022.1 on the U55C cluster, we should run `2022.1/alveo-u55c-install.yml`.

## Jumping through releases
When we want to make an update (or downgrade) to a different Xilinx tools release, we must do the following:
1. Run the *uninstall* platform-playbook for the current release. 
2. Run the install platform playbook for the new relese.

Let’s assume we want to upgrade the U55C cluster from 2021.2 to 2022.1. These commands (when we are at the `alveo-cluster/playbooks`) would do the transition:
~~~
$ ./run 2021.2/alveo-u55c-uninstall.yml
~~~
~~~
$ ./run 2022.1/alveo-u55c-install.yml
~~~

## References
* [1] "Ansible," Wikipedia, Wikimedia Foundation, 06.10.2021, [https://en.wikipedia.org/wiki/Ansible_(software)](https://en.wikipedia.org/wiki/Ansible_(software))

## Notes
* [A] An Ansible playbook is an organized unit of scripts that defines work for a server configuration managed by the automation tool Ansible. Ansible is a configuration management tool that automates the configuration of multiple servers by the use of Ansible playbooks.
* [B] Each server in the cluster has its own *host_vars* yaml file on a mandatory basis. As an example, the server alveo-u250-01 has its alveo-u250-01.ethz.ch.yml, alveo-u250-02 has its alveo-u250-02.ethz.ch.yml. It is a common practice that each server of a family (for instance, the U250) has as its yaml file a symbolic link to the very first server of its own, i.e.: alveo-u250-02.ethz.ch.yml has link to alveo-u250-01.ethz.ch.yml.
* [C] The *_80_group_alveo_cluster.yml* playbook is located under OU_ISG/pull/all/inventory/group_vars/ and is only accessible by ISG.
* [D] The *host_var* playbooks are located under OU_ISG/pull/all/inventory/host_vars and are only accessible by ISG.
* [E] The *alveo-u55c* *host_var* playbooks include a special *booting kernel option* that enables IOMMU to pass-through mode to allow XDMA operations between an AMD processor (which are used on this cluster) and the Alveo Card.
* [F] A task is the smallest unit of action you can automate using an Ansible playbook. Playbooks typically contain a series of tasks that serve a goal, such as to set up a web server, or to deploy an application to remote environments. Ansible executes tasks in the same order they are defined inside a playbook.
* [G] Warning: damage could occur to the device.
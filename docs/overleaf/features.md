# Features

## Systems Group RunTime
By using **Systems Group RunTime**, you can easily:

* Validate the fundamental infrastructure functionality of ETHZ-HACC, ensuring its reliability and performance.
* Expedite project creation through intuitive multiple-choice dialogs and templates, streamlining the development of your accelerated applications.
* Seamlessly integrate with **GitHub CLI** for efficient version control and collaboration.
* Effectively manage ACAPs, FPGAs, multi-core CPUs, and GPUs, all through a unified device index.
* Transition between [Vivado and Vitis workflows](./vocabulary.md#vivado-and-vitis-workflows) effortlessly, eliminating the need for system reboots and enhancing your development agility.
* Design, build, and deploy modern FPGA-accelerated applications with ease, leveraging your own or third-party integrations, for instance, ACCL, Coyote, or EasyNet (please refer to our **Infrastructure for heterogeneous architectures and hardware acceleration**).
* Explore model-based design principles with readily available *out-of-the-box* examples.
* Simplify the creation of HIP/ROCm GPU applications using the *sgutil new-build-run hip* commands.



## Managed platform
We use [Infrastructure as Code (IaC)](./vocabulary.md#infrastructure-as-code-iac) and [Ansible Automation Platform (AAP)](./vocabulary.md#ansible-automation-platform-aap) to [operate the cluster](../docs/operating-the-cluster.md#operating-the-cluster) efficiently. Under the scope of a [DevOps](./vocabulary.md#devops) methodology, we achieve the following: 

* Continuos delivery,
* Avoid manual configuration to enforce consistency,
* Use declarative definition files helping to document the cluster,
* Easily follow Xilinx’s tools versioning release schedule, and
* Deliver stable tests environments rapidly at scale.

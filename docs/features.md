<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/README.md#sections">Back</a>
</p>

# Features

## CLI

## Hot-plug boot

## Ansible managed
We manage our HACC fully automatic: there is no room for manual administration. By using [Ansible](docs/vocabulary.md#ansible), we can be sure that the cluster configuration is homogeneous and reproducible. We can re-install and set up from scratch—without other interaction—all of the servers in our cluster in about an hour. Such a process includes installing not only the operating system and Debian packages but also all Xilinx tools, the deployment and development platforms, the base shells’ programming (with a handled servers’ cold boot), and networking configuration. In addition, the YAML-based playbooks and tasks allow us to inherently document servers and cluster setup.

Thanks to Ansible we are able to easily follow Xilinx’s tools versioning release schedule as mentioned in [Releases](../README.md/#releases).

## You are welcome

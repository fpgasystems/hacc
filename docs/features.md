<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/README.md#sections">Back</a>
</p>

# Features

## CLI

## Hot-plug boot

## Managed
We manage our HACC fully automatic: there is no room for manual administration. By using Ansible, we can be sure that the cluster configuration is homogeneous and reproducible. We can re-install and set up from scratch—without other interaction—each of the servers in our cluster in about an hour. Such a process includes installing all Xilinx tools, the deployment and development platforms, the base shells' programming, and the servers' cold boot. In addition, the YAML-based playbooks and tasks allow us to inherently document servers and cluster setup.

This allows us to easily follow Xilinx’s tools versioning release schedule as mentioned in [Releases](../README.md/#releases).

## You are welcome

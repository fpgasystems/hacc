<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc#--heterogenous-accelerated-compute-cluster">Back to top</a>
</p>

# CLI
ETHZ-HACC CLI brings Systems Group’s designs to your terminal and allows you to use [Vivado and Vitis workflows](../docs/vocabulary.md#vivado-and-vitis-workflows) seamlessly.

## sgutil
<code>sgutil [commands] [arguments [flags]] [--help] [--version]</code>

### Commands

* [build](./docs/sgutil-build.md#sgutil-build)
* [examine](./docs/sgutil-examine.md#sgutil-examine)
* [get](./docs/sgutil-get.md#sgutil-get)
* [new](./docs/sgutil-new.md#sgutil-new)
* [program](./docs/sgutil-program.md#sgutil-program)
* [run](./docs/sgutil-run.md#sgutil-run)
* [set](./docs/sgutil-set.md#sgutil-set)
* [validate](./docs/sgutil-validate.md#sgutil-validate)

<!-- ### Options -->
<code>-h, --help</code>
<p>
&nbsp; &nbsp; Help to use this application.
</p>

<code>-v, --version</code>
<p>
  &nbsp; &nbsp; Reports CLI version.
</p>

### Examples
```
$ sgutil -h
$ sgutil --version
$ sgutil validate
```
<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/README.md#cli">Back to CLI</a>
</p>

## sgutil build

<code>
  sgutil build [arguments [flags]] [--help]
</code>
<p>
  &nbsp; &nbsp; Creates binaries, bitstreams, and drivers for your FPGA designs.
</p>

### Arguments

* [coyote](./sgutil-build-coyote.md#sgutil-build-coyote)
* [vitis](./sgutil-build-vitis.md#sgutil-build-vitis)
* vivado

<code>
  -h, --help
</code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil build vivado -h
$ sgutil build vitis -h
```
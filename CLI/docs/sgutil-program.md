<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/README.md#cli">Back to CLI</a>
</p>

## sgutil program

<code>
  sgutil program [arguments [flags]] [--help]
</code>
<p>
  &nbsp; &nbsp; Downloads the accelerated program or driver to a given device.
</p>

### Arguments

* [rescan](./sgutil-program-rescan.md)
* [revert](./sgutil-program-revert.md)
* [vivado](./sgutil-program-vivado.md)
* [vitis](./sgutil-program-vitis.md)

<code>
  -h, --help
</code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil program vivado -h
$ sgutil program vitis -h
```
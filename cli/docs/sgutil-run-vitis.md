<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-run.md#sgutil-run">Back to sgutil run</a>
</p>

## sgutil run vitis

<code>
  sgutil run vitis [flags] [--help]
</code>
<p>
  &nbsp; &nbsp; Runs a Vitis FPGA-binary on a given device.
</p>

### Flags
<code>
  -p, --project
</code>
<p>
  &nbsp; &nbsp; Specifies your Vitis project name.
</p>
<code>
  -s, --serial
</code>
<p>
  &nbsp; &nbsp; FPGA's serial number. See sgutil get serial.
</p>

<code>
  -h, --help
</code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil run vitis -p hello_world
```
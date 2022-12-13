<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-program.md#sgutil-program">Back to sgutil program</a>
</p>

## sgutil program revert

<code>
  sgutil program revert [flags] [--help]
</code>
<p>
  &nbsp; &nbsp; Returns the specified device to the Vitis workflow.
</p>

### Flags
<code>
  -n, --name <string>
</code>
<p>
  &nbsp; &nbsp; FPGA's device name. See <a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get-device.md">sgutil get device</a>.
</p>

<code>
  -s, --serial <string>
</code>
<p>
  &nbsp; &nbsp; FPGA's serial number. See <a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get-serial.md">sgutil get serial</a>.
</p>

<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to revert a device.
</p>

### Examples
```
$ sgutil program revert -h
$ sgutil program revert
```
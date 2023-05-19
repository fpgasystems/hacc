<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-program.md#sgutil-program">Back to sgutil program</a>
</p>

## sgutil program vitis

<code>sgutil program vitis [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Programs a Vitis FPGA-binary to a given device.
</p>

### Flags
<!-- <code>
  -b, --binary <string>
</code>
<p>
  &nbsp; &nbsp; Programs an .xclbin binary to the specified device.
</p>

<code>
  -n, --name <string>
</code>
<p>
  &nbsp; &nbsp; FPGA's device name. See <a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get-device.md">sgutil get device</a>.
</p> -->

<code>-d, --device <string></code>
<p>
  &nbsp; &nbsp; FPGA Device Index (see sgutil examine).
</p>

<code>-p, --project <string></code>
<p>
  &nbsp; &nbsp; Specifies your Vitis project name.
</p>

<!-- <code>
  -u, --user <string>
</code>
<p>
  &nbsp; &nbsp; The name (and path) of the xclbin to be loaded.
</p> -->

<code>-h, --help <string></code>
<p>
  &nbsp; &nbsp; Help to program a binary.
</p>

### Examples
```
$ sgutil program vitis
```
<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-build.md#sgutil-build">Back to sgutil build</a>
</p>

## sgutil build vitis

<code>sgutil build vitis [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Generates .xo kernels and .xclbin binaries for Vitis workflow.
</p>

### Flags
<code>-p, --project <string></code>
<p>
  &nbsp; &nbsp; Specifies your Vitis project name.
</p>
<code>-s, --serial <string></code>
<p>
  &nbsp; &nbsp; FPGA's serial number. See <a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get-serial.md">sgutil get serial</a>.
</p>

<code>-h, --help <string></code>
<p>
  &nbsp; &nbsp; Help to build a binary.
</p>

### Examples
```
$ sgutil build vitis -p hello_world
```
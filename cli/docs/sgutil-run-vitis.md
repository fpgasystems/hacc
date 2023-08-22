<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-run.md#sgutil-run">Back to sgutil run</a>
</p>

## sgutil run vitis

<code>sgutil run vitis [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Runs a Vitis FPGA-binary on a given FPGA/ACAP.
</p>

### Flags
<code>-d, --device <string></code>
<p>
  &nbsp; &nbsp; FPGA Device Index (see sgutil examine).
</p>

<code>    --platform</code>
<p>
  &nbsp; &nbsp; Xilinx platform (according to sgutil get platform).
</p>

<code>    --project</code>
<p>
  &nbsp; &nbsp; Specifies your Vitis project name.
</p>

<code>-t, --target</code>
<p>
  &nbsp; &nbsp; Binary compilation target (sw_emu, hw_emu, hw).
</p>

<code>-h, --help</code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil run vitis -p hello_world -d 1 -t sw_emu
```
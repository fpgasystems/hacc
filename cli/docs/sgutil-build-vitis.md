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
<code>    --platform <string></code>
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

<code>-h, --help <string></code>
<p>
  &nbsp; &nbsp; Help to build a binary.
</p>

### Examples
```
$ sgutil build vitis
$ sgutil build vitis --platform xilinx_u55c_gen3x16_xdma_3_202210_1 -p hello_world -t sw_emu
```
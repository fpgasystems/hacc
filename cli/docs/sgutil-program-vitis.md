<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-program.md#sgutil-program">Back to sgutil program</a>
</p>

## sgutil program vitis

<code>
  sgutil program vitis [flags] [--help]
</code>
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
  &nbsp; &nbsp; FPGA's device name. See <a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-get-device.md">sgutil get device</a>.
</p> -->

<code>
  -p, --project <string>
</code>
<p>
  &nbsp; &nbsp; Specifies your Vitis project name.
</p>

<code>
  -s, --serial <string>
</code>
<p>
  &nbsp; &nbsp; FPGA's serial number. See <a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-get-serial.md">sgutil get serial</a>.
</p>

<!-- <code>
  -u, --user <string>
</code>
<p>
  &nbsp; &nbsp; The name (and path) of the xclbin to be loaded.
</p> -->

<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to program a binary.
</p>

### Examples
```
$ sgutil program vitis -u ~/my_projects/vitis/hello_world/build_dir.hw.xilinx_u55c_gen3x16_xdma_3_202210_1/vadd.xclbin
```
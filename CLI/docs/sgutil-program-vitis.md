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
<code>
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
</p>

<code>
  -s, --serial <string>
</code>
<p>
  &nbsp; &nbsp; FPGA's serial number. See <a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-get-serial.md">sgutil get serial</a>.
</p>

<code>
  -t, --target <string>
</code>
<p>
  &nbsp; &nbsp; Binary compilation target (sw_emu, hw_emu, hw).
</p>

<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to program a binary.
</p>

### Examples
```
$ sgutil program vitis -b ~/my_projects/hello_world/hello_world.xclbin
$ sgutil program vitis -d xcu50_u55n_0 -s 500202A20DQAA -b ~/my_projects/hello_world/hello_world.xclbin
```
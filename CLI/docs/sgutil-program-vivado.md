<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-program.md#sgutil-program">Back to sgutil program</a>
</p>

## sgutil program vivado

<code>
  sgutil program vivado [flags] [--help]
</code>
<p>
  &nbsp; &nbsp; Programs a Vivado FPGA-bitstream to a given device.
</p>

### Flags
<code>
  -b, --bitstream <string>
</code>
<p>
  &nbsp; &nbsp; Programs a .bit bitstream to the specified device.
</p>

<code>
  -d, --driver <string>
</code>
<p>
  &nbsp; &nbsp; Installs an FPGA driver on the server.
</p>

<code>
  -n, --name <string>
</code>
<p>
  &nbsp; &nbsp; FPGA's device name. See <a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-get-device.md">sgutil get device</a>.
</p>

<code>
  -r, --revert <string>
</code>
<p>
  &nbsp; &nbsp; Return the specified device to the Vitis workflow.
</p>

<code>
  -s, --serial <string>
</code>
<p>
  &nbsp; &nbsp; FPGA's serial number. See <a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-get-serial.md">sgutil get serial</a>.
</p>

<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to program a bitstream.
</p>

### Examples
```
$ sgutil program vivado -b ~/my_projects/hello_world/hello_world.bit -d ~/my_projects/hello_world/hello_world_drv.ko
$ sgutil program vivado -d xcu50_u55n_0 -s 500202A20DQAA -b ~/my_projects/hello_world/hello_world.bit -d ~/my_projects/hello_world/hello_world_drv.ko
```
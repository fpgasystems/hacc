<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-program.md#sgutil-program">Back to sgutil program</a>
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
  -l, --ltx <string>
</code>
<p>
  &nbsp; &nbsp; Specifies a .ltx debug probes file.
</p>

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
  &nbsp; &nbsp; Help to program a bitstream.
</p>

### Examples
```
$ sgutil program vivado -b my_bitstream.bit -d my_driver.ko
$ sgutil program vivado -d xcu50_u55n_0 -s 500202A20DQAA -b my_bitstream.bit -d my_driver.ko
```
<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-program.md#sgutil-program">Back to sgutil program</a>
</p>

## sgutil program vivado

<code>sgutil program vivado [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Programs a Vivado bitstream to a given FPGA.
</p>

### Flags
<code>-b, --bitstream <string></code>
<p>
  &nbsp; &nbsp; Bitstream (.bit) file path.
</p>

<code>    --device <string></code>
<p>
  &nbsp; &nbsp; FPGA Device Index (see sgutil examine).
</p>

<code>    --driver <string></code>
<p>
  &nbsp; &nbsp; Driver (.ko) file path.
</p>

<!-- <code>-l, --ltx <string></code>
<p>
  &nbsp; &nbsp; Specifies a .ltx debug probes file.
</p>

<code>-n, --name <string></code>
<p>
  &nbsp; &nbsp; FPGA's device name. See <a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get-device.md">sgutil get device</a>.
</p>

<code>-s, --serial <string></code>
<p>
  &nbsp; &nbsp; FPGA's serial number. See <a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get-serial.md">sgutil get serial</a>.
</p> -->

<code>-h, --help <string></code>
<p>
  &nbsp; &nbsp; Help to program a bitstream.
</p>

### Examples
```
$ sgutil program vivado --bitstream my_bitstream.bit --driver my_driver.ko --device 1
$ sgutil program vivado --bitstream my_bitstream.bit --device 1
$ sgutil program vivado --driver my_driver.ko
```
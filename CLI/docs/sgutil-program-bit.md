<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-program.md#sgutil-program">Back to sgutil program</a>
</p>

## sgutil program bit

<code>
  sgutil program bit [flags] [--help]
</code>
<p>
  &nbsp; &nbsp; Programs an FPGA bitstream (.bit) to a given device.
</p>

### Flags
<code>
  -d, --device <string>
</code>
<p>
  &nbsp; &nbsp; FPGA device name (see sgutil get device).
</p>

<code>
  -s, --serial <string>
</code>
<p>
  &nbsp; &nbsp; FPGA serial number (see sgutil get serial).
</p>

<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to program a bitstream.
</p>

### Examples
```
$ sgutil program bit ~/my_projects/hello_world/hello_world.bit
$ sgutil program bit -d xcu50_u55n_0 -s 500202A20DQAA ~/my_projects/hello_world/hello_world.bit
```
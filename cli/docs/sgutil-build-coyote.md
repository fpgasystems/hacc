<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-build.md#sgutil-build">Back to sgutil build</a>
</p>

## sgutil build coyote

<code>
  sgutil build coyote [flags] [--help]
</code>
<p>
  &nbsp; &nbsp; Generates Coyote's bitstreams and drivers.
</p>

### Flags
<!-- <code>
  -b, --binary <string>
</code>
<p>
  &nbsp; &nbsp; Programs an .xclbin binary to the specified device.
</p> -->

<code>
  -n, --name <string>
</code>
<p>
  &nbsp; &nbsp; FPGA's device name. See <a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get-device.md">sgutil get device</a>.
</p>

<code>
  -p, --project <string>
</code>
<p>
  &nbsp; &nbsp; Specifies your Coyote project name.
</p>

<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to program a binary.
</p>

### Examples
```
$ sgutil build coyote -p hello_world
```
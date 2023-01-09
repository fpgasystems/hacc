<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get.md#sgutil-get">Back to sgutil get</a>
</p>

## sgutil get device

<code>sgutil get device [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Retreives FPGA device name from the server/s.
</p>
<!-- The number of parallel client threads to run is four by default. -->

### Flags
<code>-w, --word <string></code>
<p>
  &nbsp; &nbsp; Filters FPGA device name according to regexp expression.
</p>

<code>-h, --help <string></code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil get device
$ sgutil get device -w u250
```
<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get.md#sgutil-get">Back to sgutil get</a>
</p>

## sgutil get network

<code>sgutil get network [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Retreives networking information from the server/s.
</p>
<!-- The number of parallel client threads to run is four by default. -->

### Flags
<code>-d, --device <string></code>
<p>
  &nbsp; &nbsp; FPGA Device Index (see sgutil examine).
</p>

<code>-h, --help <string></code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil get network
$ sgutil get network -d 0
```
<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-set.md#sgutil-set">Back to sgutil set</a>
</p>

## sgutil set write

<code>sgutil set write [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Assigns writing permissions to a given device.
</p>
<!-- The number of parallel client threads to run is four by default. -->

### Flags
<code>-i, --index <string></code>
<p>
  &nbsp; &nbsp; PCI device index. See sgutil get devices.
</p>

<code>-h, --help <string></code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil set write -i 0
```
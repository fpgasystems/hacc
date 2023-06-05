<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get.md#sgutil-get">Back to sgutil get</a>
</p>

## sgutil get bus

<code>sgutil get bus [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Retreives GPU PCI Bus ID.
</p>

### Flags
<code>-d, --device <string></code>
<p>
  &nbsp; &nbsp; GPU Device Index (according to sgutil examine).
</p>

<code>-h, --help <string></code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil get bus -d 1
```
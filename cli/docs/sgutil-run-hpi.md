<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-run.md#sgutil-run">Back to sgutil run</a>
</p>

## sgutil run hip

<code>sgutil run hip [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Runs your HIP application on a given GPU.
</p>

### Flags
<code>-d, --device <string></code>
<p>
  &nbsp; &nbsp; GPU Device Index (see sgutil examine).
</p>

<code>-p, --project</code>
<p>
  &nbsp; &nbsp; Specifies your HIP project name.
</p>

<code>-h, --help</code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil run hip -p hello_world
```
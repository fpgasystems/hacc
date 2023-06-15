<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-validate.md#sg-validate">Back to sgutil validate</a>
</p>

## sgutil validate coyote

<code>sgutil validate coyote [flags] [--help]</code>
<p>
  &nbsp; &nbsp; Validates Coyote on the selected FPGA.
</p>

### Flags
<code>-d, --device <string></code>
<p>
  &nbsp; &nbsp; FPGA Device Index (see sgutil examine).
</p>

<code>-h, --help <string></code>
<p>
  &nbsp; &nbsp; Help to use Coyote validation.
</p>

### Examples
```
$ sgutil validate coyote
$ sgutil validate coyote -d 1
```
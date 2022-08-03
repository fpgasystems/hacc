<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/docs/CLI.md#cli">Back</a> | Next
</p>

# sg flash_bitstream
Flash a bitstream using Vivado.

* [sg flash_bitstream xrt]()
* [sg flash_bitstream vivado](#sg-flashbitstream-vivado)
* [sg flash_bitstream coyote]()

## sg flash_bitstream vivado
```
sg flash_bitstream vivado [flags]
```
Flash a bitstream of your choice.

### Options
&nbsp; &nbsp; -b, --bit <string>...
&nbsp; &nbsp; &nbsp; &nbsp; Specifies the path for your .bit and .ltx files

### Examples
&nbsp; &nbsp; sg flash_bitstream vivado -b /mnt/scratch/hacc/bit/hello_world.bit
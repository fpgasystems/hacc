<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/docs/CLI.md#cli">Back</a> | Next
</p>

# sg flash_bitstream
Flash a bitstream using Vivado

* [sg flash_bitstream xrt]()
* [sg flash_bitstream vivado](#sg-flashbitstream-vivado)
* [sg flash_bitstream coyote]()

## sg flash_bitstream vivado
<code>
  &nbsp; sg flash_bitstream vivado [flags]
</code>
<p>
  &nbsp; &nbsp; &nbsp; &nbsp; Flash a bitstream of your choice
</p>

### Options
<code>
  &nbsp; -b, --bit <string>
</code>
<p>
  &nbsp; &nbsp; &nbsp; &nbsp; Specifies the path to your .bit and .ltx files
</p>




### Examples
```
$ sg flash_bitstream vivado -b /mnt/scratch/hacc/bit/hello_world.bit
```
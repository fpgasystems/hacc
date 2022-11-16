<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/README.md#cli">Back</a>
</p>

# sg program
Flash a bitstream using Vivado.

* [sg program xrt]()
* [sg program vivado](#sg-program-vivado)
* [sg program coyote]()

## sg program vivado
<code>
  sg program vivado [flags]
</code>
<p>
  &nbsp; &nbsp; Flash a bitstream of your choice.
</p>

### Options
<code>
  -b, --bit <string>
</code>
<p>
  &nbsp; &nbsp; Specifies the path to your .bit and .ltx files.
</p>

<p>
  &nbsp; &nbsp;
</p>
<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to use iperf validation (change).
</p>
<p>
  &nbsp; &nbsp;
</p>

### Examples
```
$ sg program vivado -b /mnt/scratch/hacc/bit/hello_world.bit
$ sg program vivado -b /mnt/scratch/hacc/bit/hello_world.bit
$ sg program vivado -b /mnt/scratch/hacc/bit/hello_world.bit
```
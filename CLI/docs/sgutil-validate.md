<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/README.md#cli">Back to CLI</a>
</p>

## sgutil validate

<code>
  sgutil validate [arguments [flags]] [--help]
</code>
<p>
  &nbsp; &nbsp; Validates the basic HACC infrastructure functionality.
</p>

### Arguments

* [iperf](./sgutil-validate-iperf.md)
* [mpi](./sgutil-validate-mpi.md)

<code>
  -h, --help
</code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

<!-- <code>
  iperf
</code>
<p>
  &nbsp; &nbsp; Measures HACC network performance.
</p>

<code>
  mpi
</code>
<p>
  &nbsp; &nbsp; Validates MPI.
</p> -->

### Examples
```
$ sgutil validate -h
$ sgutil validate iperf
$ sgutil validate mpi
```
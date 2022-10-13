<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/README.md#cli">Back</a>
</p>

# sgutil validate
Validates HACC infrastructure.

* [sgutil validate iperf](#sgutil-validate-iperf)
* [sgutil validate mpi](#sgutil-validate-mpi)

## sgutil validate iperf
<code>
  sgutil validate iperf [options]
</code>
<p>
  &nbsp; &nbsp; Validates iperf amongst the machines you have previosly booked.
</p>

### Options
&nbsp; &nbsp; This command has no options.
<!-- <code>
  -p, --process <string>
</code>
<p>
  &nbsp; &nbsp; Specifies the number of processes to be stablished between the local and remote nodes.
</p> -->

### Examples
```
$ sgutil validate iperf
```

## sgutil validate mpi
<code>
  sgutil validate mpi [options]
</code>
<p>
  &nbsp; &nbsp; Validates MPICH amongst the machines you have previosly booked.
</p>

### Options
&nbsp; &nbsp; This command has no options.
<!-- <code>
  -p, --process <string>
</code>
<p>
  &nbsp; &nbsp; Specifies the number of processes to be stablished between the local and remote nodes.
</p> -->

### Examples
```
$ sgutil validate mpi
```
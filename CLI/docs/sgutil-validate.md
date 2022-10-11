<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/README.md#cli">Back</a>
</p>

# sgutil validate
Validates HACC infrastructure.

* [sgutil validate openmpi](#sgutil-validate-openmpi)

## sgutil validate openmpi
<code>
  sgutil validate openmpi [flags]
</code>
<p>
  &nbsp; &nbsp; Validates OpenMPI amongst the machines you have previosly booked.
</p>

### Options
<code>
  -p, --process <string>
</code>
<p>
  &nbsp; &nbsp; Specifies the number of processes to be stablished between the local and remote nodes.
</p>

### Examples
```
$ sgutil validate openmpi -p 2
```
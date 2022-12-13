<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/cli/docs/sgutil-get.md#sgutil-get">Back to sgutil get</a>
</p>

## sgutil get mac

<code>
  sgutil get mac [flags] [--help]
</code>
<p>
  &nbsp; &nbsp; Retreives L2 information from the server/s.
</p>
<!-- The number of parallel client threads to run is four by default. -->

### Flags
<code>
  -w, --word <string>
</code>
<p>
  &nbsp; &nbsp; Filters L2 information according to regexp expression.
</p>

<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil get mac
$ sgutil get mac -w alveo-u50d-03
$ sgutil get mac -w mellanox
```
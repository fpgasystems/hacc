<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/docs/sgutil-validate.md#sg-validate">Back to sgutil validate</a>
</p>

## sgutil get ip

<code>
  sgutil get ip [flags] [--help]
</code>
<p>
  &nbsp; &nbsp; Retreives IP information from the server/s.
</p>
<!-- The number of parallel client threads to run is four by default. -->

### Flags
<code>
  -w, --word <string>
</code>
<p>
  &nbsp; &nbsp; Filters IP information according to regexp expression.
</p>

<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to use this command.
</p>

### Examples
```
$ sgutil get ip
$ sgutil get ip -w alveo-u50d-03
$ sgutil get ip -w mellanox
```
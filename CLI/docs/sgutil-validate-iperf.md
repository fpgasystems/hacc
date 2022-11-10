<div id="readme" class="Box-body readme blob js-code-block-container">
<article class="markdown-body entry-content p-3 p-md-6" itemprop="text">
<p align="right">
<a href="https://github.com/fpgasystems/hacc/blob/main/CLI/README.md#cli">Back</a>
</p>

## sgutil validate iperf
<code>
  sgutil validate iperf [flags]
</code>
<p>
  &nbsp; &nbsp; Measures HACC network performance. The number of parallel client threads to run is four by default.
</p>

### Flags
<code>
  -b, --bandwidth <string>
</code>
<p>
  &nbsp; &nbsp; Bandwidth to send at in bits/sec or packets per second.
</p>
<code>
  -h, --help <string>
</code>
<p>
  &nbsp; &nbsp; Help to use this application.
</p>
<code>
  -P, --parallel <string>
</code>
<p>
  &nbsp; &nbsp; Number of parallel client threads to run.
</p>
<code>
  -t, --time <string>
</code>
<p>
  &nbsp; &nbsp; Time in seconds to transmit for.
</p>
<code>
  -u, --udp <string>
</code>
<p>
  &nbsp; &nbsp; Use UDP rather than TCP.
</p>

### Examples
```
$ sgutil validate iperf
$ sgutil validate iperf -P 6
$ sgutil validate iperf -b 900M -u
```
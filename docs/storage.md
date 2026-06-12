
# Storage
Our HACC provides users with various storage methods. You are free to use this storage, but are required to keep the usage to as little as needed.

> [!WARNING]
> The safety of your data is not guaranteed and it can be deleted without notic. You are therefore ecouraged to always copy important data over to a safe place.

## Network drives
All HACC servers have two network drives, which can be used to share data between servers, like FPGA bitstreams. These are relatively slow (ca. 50MB/s), but offer accessibility from all our servers.

#### `/home/USERNAME`
Your home directory (the directory you land in, when you SSH into a machine) is an automatically mounted network drive. Only you have access to this directory. This directory is subject to disk quota's set by our IT team (max ca. 20GB).

#### `/pub/scratch`
This is our big scratch network drive, which is world-readable. The convention is to create a directory with your `USERNAME` and use that to offload larger data.

## Local drives
All HACC servers also provide fast (500+ MB/s) local storage for experiments. This data is only reachable from the server it's stored on. 

#### `/local/home/USERNAME`
This directory is automatically created for you on a SATA SSD (NVMe SSD on some servers). The data in this directory is readable by other users.

> [!TIP]
> This storage does not have a quota. However, the space you take up, you take away from all other users. Be mindfull and clean up after you are done!

#### `/tmp`
Temporary storage folder (default Linux concept) located on the OS drive, which depending on the server, might be stored on HDD, SATA SSD, or NVMe SSD. The data in this directory is deleted after each reboot (at least each morning (experiment servers) or each week (build servers)).

#### `tmpfs`
Very fast in memory temporary storage (10+ GB/s). This feature is still in the experimental phase and may become generally available in the near-future.

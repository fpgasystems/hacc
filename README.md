
<p align="center">
<img src="./imgs/hacc-removebg.png" align="center" width="350">
</p>

<h1 align="center">
  Heterogenous Accelerated Compute Cluster
</h1>


Under the scope of the [AMD University Program](https://www.xilinx.com/support/university/XUP-HACC.html), the [Heterogeneous Accelerated Compute Cluster (HACC)](https://www.amd-haccs.io) is a special initiative to support novel research in adaptive compute acceleration for high-performance computing (HPC). The scope of the program is broad and encompasses systems, architecture, tools, and applications.

Seven HACCs have been established at some of world’s most prestigious universities. The first of them was assigned to [Prof. Dr. Gustavo Alonso](https://people.inf.ethz.ch/alonso/) of the [Institute for Platform Computing - Systems Group (SG)](https://systems.ethz.ch) at the [Swiss Federal Institute of Technology Zurich (ETH Zurich, ETHZ)](https://ethz.ch/en.html) in 2020.

A HACC is equipped with the latest AMD hardware and software technologies for adaptive compute acceleration research. Each hosting institute specially configures their HACC to conduct their state-of-the-art HPC research.

## HACC at ETH Zürich
The HACC at ETH Zürich consists of Ultrascale+ and Versal based FPGAs, as well as Instinct GPUs, installed in 20+ servers. Each server is also equipped with a high-speed network interface card (NIC), which connect to our high-speed experiments network. All of our FPGAs also connect to this experiment network, allowing researchers to do extensive network research. For more info about our physical infrastructure, see the [Infrastructure](docs/infrastructure.md) setction.

## Getting started

#### 1. Request access to HACC

- Go to: [https://www.amd-haccs.io/get-started.html](https://www.amd-haccs.io/get-started.html) and register for the HACC program.
- Create an AMD account using your institutional email address.
- Provide a short description of the work you plan to do on HACC.

#### 2. Account approval and ETH guest account

After AMD approves your application, an ETH guest account will be created. You may be asked for additional details; the whole process usually takes up to two weeks. The account will be valid for one year, see [Account Renewal](#docs/account-renewal.md) documenation if you want to extend.

#### 3. Accessing HACC

Once your ETH account is active, you can access HACC. To reach the cluster, you must be connected to the ETH network, either:
- On-site at ETH, or
- Via the ETH VPN (see [Remote Access](docs/remote-access.md) documentation)

#### 4. Using build and experiment servers

When you are connected to the ETH network, you can:
- SSH directly to one of the build servers, or
- [Book a time slot](https://hacc-booking.inf.ethz.ch) on one of the experiment servers and then SSH into it during your reservation.

Be sure to review the [cluster rules](docs/cluster-guidelines.md) before starting.


## Documentation

### The Cluster
* [Cluster guidelines](docs/cluster-guidelines.md)
* [Booking system](docs/booking-system.md)
* **Infrastructure**
    * [Devices](docs/devices.md)
    * [Topology](docs/topology.md)
    * [Storage](docs/storage.md)
    * [Software](docs/software-tools.md)  (coming soon)
    * [Cluster Management](docs/cluster-management.md)  (coming soon)
### Access
* [Getting Access](#getting-started)
* [Account Renewal](docs/account-renewal.md)
* [Remote Access](docs/remote-access.md)
### Other
* [Contact](docs/contact.md)
* [Terminology](docs/terminology.md)

# Acknowledgment and citation

We encourage ETHZ-HACC users to acknowledge the support provided by AMD and ETH Zürich for their research in presentations, papers, posters, and press releases. Please use the following acknowledgment statement or similar.

```plain
This work was supported in part by AMD and ETH Zürich, who provided access to the Heterogeneous Accelerated Compute Cluster (HACC) at ETHZ.
```

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

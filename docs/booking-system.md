# Booking system
Before connecting to the experiment HACC servers, you must make a reservation through the [booking system](https://hacc-booking.ethz.ch/login.php). To use the booking system, please remember the following:

* You must be connected to the ETH network in order to access it, and
* Use your ETH shortname as username and your **main LDAP/Active directory password** to login.

**Note that build servers are open and don't require a booking to access.**

![Booking system.](../imgs/booking-system.png "Booking system.")
*Booking system.*


## Booking a server
Please, follow these steps to book a server:

1. Go to our booking system at [https://hacc-booking.ethz.ch](https://hacc-booking.ethz.ch)
2. Use your **ETH shortname and main LDAP/Active directory password** to log in
3. Once you are on the *Dashboard* page, click on *New booking* at the top
4. Select the *Time range,* the servers you wish to book, along with a mandatory *Comment* referring to your research activities
5. Press the *Book* button

![Booking a server.](../imgs/booking-a-server.png "Booking a server.")
*Booking a server.*

## Accessing a server
After booking a server (assuming you are connected to ETH network) you should be able to access it using ssh: `ssh <eth_shortname>@hacc-u55c-01`. Please remember that for accessing a server you should also use your **main LDAP/Active directory password**:

![Accessing a server.](../imgs/accessing-a-server.png "Accessing a server.")
*Accessing a server.*

You can also make use of **X11 forwarding** if you need to run graphical applications on the remote server (for instance, Vivado). For this, add the `-X -C` flags to the ssh command: `ssh -X -C <eth_shortname>@hacc-u55c-01`. The `-X` flag enables X11 forwarding for SSH and the `-C` flag compresses the ssh connection, which has positive effects on responsiveness in graphical applications.

## Revert server to Vitis workflow upon login
It is possible that when you log on to a server, you may find that the previous user has left the server in [Vivado workflow]("terminology.md#vivado-workflow"). In such a situation, a login script will ask you whether you want to revert to the default [Vitis Workflow]("terminology.md").

![Reverting to Vitis workflow.](../imgs/reverting-to-vitits-workflow.png "Reverting to Vitis workflow.")
*Reverting to Vitis workflow.*

## Validating a Xilinx accelerator card
Once you are logged into a server, you are be able to validate the state of the accelerator card with `xbutil validate --device` for XRT based FPGAs and `ami_tool overview` for AVED based FPGAs (for example the V80):

![Validating a Xilinx accelerator card.](../imgs/validating-a-xilinx-accelerator-card.png "Validating a Xilinx accelerator card.")
*Validating an XRT-based accelerator card.*


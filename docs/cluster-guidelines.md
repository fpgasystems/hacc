# Cluster guidelines
The HACC cluster is used by many users at the same time. Please be mindful of others. By following these guidelines and notes, every user will be able to do their work.

1. **Server Use**
    - Use the build servers only to run long-living build processes, like bitstream generation. Use the experiment servers only to run your experiments.
    - Build servers are open to all users without booking. Please spread your jobs across the three build servers.  Check usage using the `who` and `htop` commands, to see the number of logged-in users and current resource usage.
    - The experiment servers are rebooted every morning (06:45-07:30 CET/CEST). The build servers are rebooted every Monday morning. After reboot, our Ansible pipeline also runs. You won't be able to use the HACC during this process.
    - Our HACC provides [a basic set of programs](./software-tools.md) that are generally needed by most users. Specific libraries for experiments must be compiled from source, or installed in a Docker/Apptainer container.

2. **Booking System**
    - Only book the time you need. Keep your booking time to the shortest possible period and release the booking, when you finish early; other users may be waiting.
    - The maximum booking time is 5 hours. If your research requires longer bookings, email us with a short explanation of why you need more time and for how long.
    - Don’t assume there will be low demand at night: users in other time zones may also want to access the HACC.
    - Note that you can book resources 2 weeks in advance if you need the hardware at a particular time.

3. **Storage Use**
    - Clean up your storage when you no longer need the data. Storage capacity is limited, so any space you occupy is space other users cannot use.
    - We don't guarantee the persistence of the files stored on the HACC (both local disks and NFS). Always copy important data to your local machine or another reliable storage system.

We reserve the right to revoke access to the HACC, when these guidelines are repeatedly ignored.

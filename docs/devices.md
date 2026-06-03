# Devices

## CPU
### AMD EPYC
EPYC is the world’s highest-performing x86 server processor with faster performance for cloud, enterprise, and HPC workloads. To learn more about it, please refer to the [AMD EPYC processors website](https://www.amd.com/en/products/processors/server/epyc.html) and its [data sheet.](https://www.amd.com/content/dam/amd/en/documents/epyc-business-docs/datasheets/amd-epyc-7003-series-product-datasheet.pdf)

## FPGA
### Virtex Ultrascale+
Virtex UltraScale+ devices provide the highest performance and integration capabilities in a 14nm/16nm FinFET node. It also provides registered inter-die routing lines enabling >600 MHz operation, with abundant and flexible clocking to deliver a virtual monolithic design experience. As the industry’s most capable FPGA family, the devices are ideal for compute-intensive applications ranging from 1+Tb/s networking and machine learning to radar/early-warning systems.

<table>
  <thead>
    <tr>
      <th>Device</th>
      <th>Alveo U250</th>
      <th>Alveo U280</th>
      <th>Alveo U50D</th>
      <th>Alveo U55C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Chip</td>
      <td>Virtex UltraScale+ XCU250</td>
      <td>Virtex UltraScale+ XCU280</td>
      <td>Virtex UltraScale+ XCU50</td>
      <td>Virtex UltraScale+ XCU55</td>
    </tr>
    <tr>
      <td>SLRs</td>
      <td>4</td>
      <td>3</td>
      <td>2</td>
      <td>3</td>
    </tr>
    <tr>
      <td>LUTs</td>
      <td>1.7M</td>
      <td>1.3M</td>
      <td>872K</td>
      <td>1.3M</td>
    </tr>
    <tr>
      <td>DSPs</td>
      <td>12,288</td>
      <td>9,024</td>
      <td>5,952</td>
      <td>9,024</td>
    </tr>
    <tr>
      <td>BRAM</td>
      <td>70.3 Mbit</td>
      <td>70.9 Mbit</td>
      <td>47.3 Mbit</td>
      <td>70.9 Mbit</td>
    </tr>
    <tr>
      <td>URAM</td>
      <td>360 Mbit</td>
      <td>270 Mbit</td>
      <td>180 Mbit</td>
      <td>270 Mbit</td>
    </tr>
    <tr>
      <td>HBM</td>
      <td>-</td>
      <td>
        2 × 4 GB HBM2<br/>
        @ 460 GB/s
      </td>
      <td>
        2 × 4 GB HBM2<br/>
        @ 316 GB/s
      </td>
      <td>
        2 × 8 GB HBM2<br/>
        @ 460 GB/s
      </td>
    </tr>
    <tr>
      <td>DDR</td>
      <td>
        4 × 16 GB DDR4‑2400<br/>
        @ 19.2 GB/s per module
      </td>
      <td>
        2 × 16 GB DDR4‑2400<br/>
        @ 19.2 GB/s per module<br/>
      </td>
      <td>-</td>
      <td>-</td>
    </tr>
    <tr>
      <td>Networking</td>
      <td>2 × 100 Gbit QSFP28</td>
      <td>2 × 100 Gbit QSFP28</td>
      <td>2 × 25 Gbit SFP+</td>
      <td>2 × 100 Gbit QSFP28</td>
    </tr>
    <tr>
      <td>PCIe</td>
      <td>Gen3 ×16</td>
      <td>Gen3 ×16 or;<br/>
      dual Gen4 ×8 (CCIX)</td>
      <td>Gen3 ×16 or;<br/>
      dual Gen4 ×8 (CCIX)</td>
      <td>Gen3 ×16 or;<br/>
      dual Gen4 ×8 (CCIX)</td>
    </tr>
    <tr>
      <td>Reference</td>
      <td><a href="https://docs.amd.com/r/en-US/ds962-u200-u250/Summary">DS962</a> - Datasheet</td>
      <td><a href="https://docs.amd.com/r/en-US/ds963-u280/Summary">DS963</a> - Datasheet</td>
      <td><a href="https://docs.amd.com/r/en-US/ds965-u50/Summary">DS965</a> - Datasheet</td>
      <td><a href="https://docs.amd.com/r/en-US/ds978-u55c/Summary">DS978</a> - Datasheet</td>
    </tr>
  </tbody>
</table>

### Versal Adaptive SoCs
Versal Adaptive SoCs deliver unparalleled application- and system-level value for cloud, network, and edge applications​. The disruptive 7nm architecture combines heterogeneous compute engines with a breadth of hardened memory and interfacing technologies for superior performance/watt over competing 10nm FPGAs.
Alveo V80 compute accelerator cards provide exceptional performance for data center, AI, and high-performance computing workloads. Built on advanced 7nm technology, they integrate high-bandwidth memory, optimized compute engines, and low-latency interconnects to deliver superior throughput and efficiency compared to previous-generation accelerators.

<table>
  <thead>
    <tr>
      <th>Device</th>
      <th>Versal VCK5000</th>
      <th>Alveo V80</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Chip</td>
      <td>Versal XCVC1902</td>
      <td>Versal XCV80</td>
    </tr>
    <tr>
      <td>LUTs</td>
      <td>900K</td>
      <td>2.6M</td>
    </tr>
    <tr>
      <td>DSPs</td>
      <td>1,968</td>
      <td>10,848</td>
    </tr>
    <tr>
      <td>BRAM</td>
      <td>34 Mbit</td>
      <td>132 Mbit</td>
    </tr>
    <tr>
      <td>URAM</td>
      <td>130 Mbit</td>
      <td>541 Mbit</td>
    </tr>
    <tr>
      <td>AI Engines / Array</td>
      <td>400 AIEv1 (8 × 50 array) @ 1.25GHz</td>
      <td>–</td>
    </tr>
    <tr>
      <td>HBM</td>
      <td>-</td>
      <td>
        2 × 16 GB HBM2e<br/>
        @ 820 GB/s<br/>
      </td>
    </tr>
    <tr>
      <td>DDR</td>
      <td>
        4 × 4 GB DDR4‑3200<br/>
        @ 25.6 GB/s per module
      </td>
      <td>
        1 × 32 GB DDR4<br/>
        @ 25.6 GB/s
      </td>
    </tr>
    <tr>
      <td>Processing System</td>
      <td>
        Dual‑core ARM Cortex‑A72<br/>
        Dual‑core ARM Cortex‑R5F
      </td>
      <td>
        Dual‑core ARM Cortex‑A72<br/>
        Dual‑core ARM Cortex‑R5F
      </td>
    </tr>
    <tr>
      <td>Networking</td>
      <td>2 × 100 Gbit QSFP28</td>
      <td>4 × 200 Gbit QSFP56</td>
    </tr>
    <tr>
      <td>PCIe</td>
      <td>Gen3 ×16 or Gen4 ×8</td>
      <td>Gen4 ×16 or dual Gen5 ×8</td>
    </tr>
    <tr>
      <td>Expansion</td>
      <td>–</td>
      <td>MCIO (2× Gen5 ×4, 1× Gen5 ×8)</td>
    </tr>
    <tr>
      <td>References</td>
      <td><a href="https://docs.amd.com/r/en-US/ug1531-vck5000-install/Introduction">UG1531</a> - Datasheet</td>
      <td><a href="https://docs.amd.com/r/en-US/ds1013-v80/Summary">DS1013</a> - Datasheet</td>
    </tr>
  </tbody>
</table>

## GPU
### Instict Data Center GPU

<table>
  <thead>
    <tr>
      <th>Device</th>
      <th>MI210</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Architecture</td>
      <td>CDNA2</td>
    </tr>
    <tr>
      <td>Compute Units</td>
      <td>104</td>
    </tr>
    <tr>
      <td>Peak Compute (FP16)</td>
      <td>181 TFLOPs</td>
    </tr>
    <tr>
      <td>Memory</td>
      <td>64 GB HBM2e</td>
    </tr>
    <tr>
      <td>Memory Bandwidth</td>
      <td>1.6 TB/s</td>
    </tr>
    <tr>
      <td>PCIe</td>
      <td>Gen4 ×16</td>
    </tr>
    <tr>
      <td>GPU–GPU Interconnect</td>
      <td>Up to 3 Infinity Fabric Links @ up to 100 GB/s</td>
    </tr>
    <tr>
      <td>Reference</td>
      <td><a href="https://www.amd.com/en/products/accelerators/instinct/mi200/mi210.html">Product Page</a></td>
    </tr>
  </tbody>
</table>

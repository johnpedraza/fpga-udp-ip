# FPGA UDP/IP
_For a longer read, check out the [blog](https://johnpedraza.org/projects/fpga-udp-ip/)._

A UDP/IP network stack written in Hardcaml, targeting the Nexys A7 board with an 
Artix-7 FPGA (Xilinx 7 Series, XC7A100TCSG324-1).

## Ethernet MAC
At the bottom of the network stack, a PHY handles the physical layer. The
Nexys A7 board includes this hardware. From the [Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual):

> The Nexys A7 board includes an SMSC 10/100 Ethernet PHY (SMSC part number 
> LAN8720A) paired with an RJ-45 Ethernet jack with integrated magnetics. The 
> SMSC PHY uses the RMII interface and supports 10/100 Mb/s.

The layer directly above the PHY is the Media Access Controller (MAC). The
PHY on this particular board communicates with the MAC through the Reduced 
Media Independent Interface (RMII).

The `eth_mac` directory will contain the implementation of the MAC, which 
produces a byte stream from the RMII symbols, assembles and parses ethernet frames,
and outputs the ethernet payload upwards to the rest of the stack.

# Introduction

The primary purpose of this Lab experiment is to perform single-point positioning using satellite broadcast ephemeris data and receiver observations for a given epoch. The Least-Square Method has been used for estimating the receiver's coordinate and the receiver's clock offset.

The receiver's initial position is X0 = -2694685.473, Y0 = -4293642.366, Z0 = 3857878.924 (WGS 84 XYZ in meters), and the initial clock offset of the receiver is zero.

# Instruction

The usage of the source code:

1. Download the zip file and uncompressed.
2. Set the current folder of Matlab to spp folder.
3. Type ***main\*** in command line windows.

##### The Frame of Codes

1. **readrcv.m:** Read the rcvr.dat file and store the data in rcv struct.
2. **readeph.m:** Read the eph.dat file and store the data in Eph_broadcast struct.
3. **eph2satxyz.m:** Convert the orbit parameters to ECEF coordinate (The earth rotation has been considered, and the relativity effect also be considered).
4. **XYZ2BLH.m**
5. **XYZ2NEU.m**
6. **main.m:** Using the Least-Square method to calculate the receiver's coordinate and clock offset.

# Results

## The ECEF position and the clock offset of satellites.

| svid |     X (m)      |     Y (m)      |     Z (m)      | Clock offset (s) |
| :--: | :------------: | :------------: | :------------: | :--------------: |
|  5   | -8855545.4737  | -22060115.1685 | -11922133.1713 |    0.00018907    |
|  6   | -8087233.0607  | -16945956.5996 | 18816198.5368  |   -8.3932e-08    |
|  17  | -21277119.8022 | -7467119.5023  | 14287505.0468  |    -0.0002049    |
|  30  | -17713900.9391 | -19797464.3067 |   19213.2028   |   -1.0041e-05    |
|  10  |  9027646.532   | -12319233.163  | 21737387.4107  |    3.3248e-05    |
|  23  | -19452319.1118 | -16750376.9085 | -6918519.6344  |    1.036e-05     |
|  22  | -13649531.2661 |  8229504.3157  | 21122957.8349  |    0.00022268    |
|  26  |  6162910.1746  | -25286774.5207 | -3541191.2494  |    0.00028099    |

## The iteration of this LS problem.

| Iterations | Position X,Y,Z changed (m)                                   | Receiver clock changed (s) | Updated position ECEF (m)                                    |
| ---------- | ------------------------------------------------------------ | -------------------------- | ------------------------------------------------------------ |
| 1          | dx  = -5737.933 (m)<br />dy  =  1099.090 (m) <br/>dz  = -2610.774 (m) | dtr  = 0.001733 (s)        | X  = -2700423.406332   <br />Y  = -4292543.276071 <br />Z  =  3855268.150447 |
| 2          | dx  =  -0.130 (m)<br />dy  =  -0.100 (m)<br />dz  =   0.105 (m) | dtr  = -0.000000 (s)       | X  = -2700423.536456   <br />Y  = -4292543.375690   <br />Z  =   3855268.255359 |
| 3          | dx  =  -0.000 (m)  <br />dy  =   0.000  (m)  <br />dz  =   0.000 (m) | dtr  = 0.000000 (s)        | X  = -2700423.536456  <br />Y  = -4292543.375690  <br />Z  =  3855268.255359 |



# Reference

1. ARINC Research Corporation. (2000). GPS Interface Control Document ICD-GPS-200 (IRN-200C-004): Navstar GPS Space Segment and Aviation User Interfaces.


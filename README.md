# Failing-over Gateway HOWTO

EXPRESSCLUSTER is impossible to failover FIP across independent subnet. But it become possible by using OSPF.
This document describes how to setup OSPF with EXPRESSCLUSTER.

----

## Configuration overview

```

                             +--------------------------------+
    +------+    +------+     | vRouter#1                      |     +----+
----+ GW#1 +----+ SW#1 +-----+ 192.168.72.147    192.168.73.1 +-----+ VM |
    +------+    |      +--+  | Linux                          |     +----+
                +--+---+  |  | Quagga                         |
                   |      |  +--------------------------------+
                   |      |
                   |      |  +--------+
                   |      +--+ Node#1 |
                   |         |        |
                   |         | ECX    |
                   |         +--------+
                   |
                   |
                   |
                   |         +--------------------------------+
    +------+    +--+---+     | vRouter#2                      |
----+ GW#2 +----+ SW#2 +-----+ 192.168.72.148                 +
    +------+    |      +--+  | Linux                          |
                +------+  |  | Quagga                         |
                          |  +--------------------------------+
                          |
                          |  +--------+
                          +--+ Node#2 |
                             |        |
                             | ECX    |
                             +--------+
```
(*) 192.168.73.1 is just a sample.

The cluster is configured by Node#1 and #2 which ECX is installed.

  1. FOG (FailOver Group) is started on Node#1
  2. An Exec resource in the FOG (start.sh) remotely login to vRouter#1 and enable network I/F for VM by ifup command (Taht's the I/F which has 192.168.73.1 in the above diagram).
  3. vRouter#1 distributes the routing information for IP address of the VM to surrounding switches (SW#1, SW#2) by Quagga using OSPF protocol.
  4. VM become accessible to outer world and vice versa.

### Monitoring

1. Open Cluster WebUI and move to Config mode
2. Push [Adding monitor resource] in the right of [Monitors]
3. Select [IP monitor] as [Type] > Input [ipw-gataway] as [Name] > [Next]
4. Input [60] sec as [Interval] > Input [2] time as [Retry Count] > Input [60] sec as [Wait Time to Start Monitoring] > Select [Active] as [Monitor Timing] > Push [Browse] > Select [exec-gateway] > [OK] > [Next]
5. [Add] > Input IP address such as [192.168.73.1] of the vRouter I/F to be controlled > [OK] > [Next]
6. Select [Restart the recovery target] as [Recovery Action] > [Browse] > Select [exec-gateway] > [OK] > [Finish]
7. Push [Apply the Configuration File]
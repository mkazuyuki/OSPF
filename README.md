# OSPF HWOTO

EXPRESSCLUSTER is impossible to failover FIP across independent subnet. But it become possible by using OSPF.
This document describes how to setup OSPF with EXPRESSCLUSTER.

----

## Configuration overview

```

                             +-----------+
    +------+    +------+     | vRouter#1 |     +----+
----+ GW#1 +----+ SW#1 +-----+           *-----+ VM |
    +------+    |      +--+  | Linux     |     +----+
                +--+---+  |  | Quagga    |
                   |      |  +-----------+
                   |      |
                   |      |  +--------+
                   |      +--+ Node#1 |
                   |         |        |
                   |         | ECX    |
                   |         +--------+
                   |
                   |
                   |
                   |         +-----------+
    +------+    +--+---+     | vRouter#2 |
----+ GW#2 +----+ SW#2 +-----+           x
    +------+    |      +--+  | Linux     |
                +------+  |  | Quagga    |
                          |  +-----------+
                          |
                          |  +--------+
                          +--+ Node#2 |
                             |        |
                             | ECX    |
                             +--------+

```

- The cluster is configured by Node#1 and #2 which ECX is installed.

1. FOG (FailOver Group) start on Node#1
2. an Exec resource in the FOG (start.sh) remotely login to vRouter#1 and enable network I/F for VM by ifup command.
3. Quagga in vRouter#1 distributes the routing information for IP address of the VM to surrounding switches (SW#1, SW#2) nu OSPF protocol.
4. VM become accessible to outer world, vice versa.

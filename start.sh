#! /bin/sh
#***************************************
#*              start.sh               *
#***************************************

# Parameters
#-----------
# Name of the failovr group
FOG=failover-iscsi

# IP address of virtual routers
ROUTER1=192.168.72.147
ROUTER2=192.168.72.148

# Target NIC in the virtual routers to be controlled
NIC=ens224
#-----------

BUF=`clpstat --local`
PRI=`echo $BUF | sed -r 's/.*<server>[ *]{1,2}//'  | sed 's/ .*//'`
ACT=`echo $BUF | sed -r "s/.* $FOG ([^:]*:){2} //" | sed 's/ .*//'`

echo [D] primary : [$PRI]
echo [D] active  : [$ACT]

if [ $PRI = $ACT ]; then
        ROUTER_ACT=$ROUTER1
        ROUTER_STB=$ROUTER2
else
        ROUTER_ACT=$ROUTER2
        ROUTER_STB=$ROUTER1
fi

echo [D] active  : [$ROUTER_ACT]
echo [D] standby : [$ROUTER_STB]

ret=0
ssh $ROUTER_STB ifdown $NIC
if [ $? -ne 0 ];then
        echo [W] [$ROUTER_STB] [$NIC] DOWN failed
else
        echo [I] [$ROUTER_STB] [$NIC] DOWN
fi

ssh $ROUTER_ACT ifup   $NIC
if [ $? -ne 0 ];then
        ret=1
        echo [E] [$ROUTER_ACT] [$NIC] UP failed
else
        echo [I] [$ROUTER_ACT] [$NIC] UP
fi

exit $ret

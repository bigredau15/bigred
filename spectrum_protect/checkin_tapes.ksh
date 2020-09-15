#!/bin/ksh
#set -xv
###############################################
# Author: Michael (bigredau15)                #
# Title: Spectrum Protect Checkin Tape Script #
# Date: 2019-02-15 (YYYY-MM-DD)               #
# OS: AIX 7.x                                 #
# Requirements: ITDT, Spectrum Protect        #
###############################################

# Spectrum Protect Username and Password Credentials #
TSMID="admin"
TSMPA="password"

# Spectrum Protect Tape Library Definition Name #
TSMLIBRARYNAME="TS4300"

# Functions
dsmq()
{
dsmadmc -id=${TSMID} -pa=${TSMPA} -dataonly=yes "$*"
rv=$?
}

# Identify Tapes In the I/O Station on device /dev/smc0, and Perform a move drm on each tape #
for i in `itdt -f /dev/smc0 inventory |grep -p Import/Export |grep "Volume Tag" |awk '{print $4}' | grep TS`; do
    dsmq "move drm $i wherest=vaultretrieve tostate=onsiteretrieve wait=yes"
    dsmq "checkin libv $TSMLIBRARYNAME $i search=no status=scratch checkl=barcode waittime=0"
done

dsmq "move drm * wherest=courier tostate=vault"

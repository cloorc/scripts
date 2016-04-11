@echo off

set services="VMAuthdService" "VMnetDHCP" "VMware NAT Service" "VMUSBArbService" "VMwareHostd" "LanmanWorkstation"
for %%s in (%services%) do (
	net %1 %%s
)

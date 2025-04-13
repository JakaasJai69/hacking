ip a > /sdcard/network_info.txt
ip route >> /sdcard/network_info.txt
dumpsys wifi | grep -E "SSID|RSSI|Link speed|Supplicant state" >> /sdcard/network_info.txt
getprop | grep dns >> /sdcard/network_info.txt
ip neigh show >> /sdcard/network_info.txt
cat /proc/net/dev >> /sdcard/network_info.txt
dumpsys connectivity | grep -A 10 "ActiveDefaultNetwork" >> /sdcard/network_info.txt
dumpsys telephony.registry | grep -E "mServiceState|mDataConnectionState|mDataNetworkType" >> /sdcard/network_info.txt

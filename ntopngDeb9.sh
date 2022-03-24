# Install ntopng on Debian 9

# You can install Ntopng repository with the following command:
wget http://apt.ntop.org/stretch/all/apt-ntop.deb
dpkg -i apt-ntop.deb

# The DPKG install likely to throw dependency errors. This can be mitigated through;
apt install -f -y
apt-get update -y
apt-get install pfring-dkms nprobe ntopng n2disk cento -y

# Once the installation has been completed, start Ntopng service and enable it to start on system reboot with the #following command: 
systemctl enable ntopng
systemctl start ntopng

#  check the status of Ntopng with the following command:
echo "Checking on ntopng status"
systemctl status ntopng

# You should see the following output:
# ● ntopng.service - ntopng high-speed web-based traffic monitoring and analysis tool
#  Loaded: loaded (/etc/systemd/system/ntopng.service; enabled; vendor preset: enabled)
#   Active: active (running) since Thu 2022-03-24 16:00:04 EAT; 3min 46s ago
# Main PID: 21127 (5/flow_checks)
#   CGroup: /system.slice/ntopng.service
#           └─21127 /usr/bin/ntopng /run/ntopng.conf
#
# Mar 24 16:00:52 gw ntopng[21127]: 24/Mar/2022 16:00:52 [startup.lua:140] Initializing alerts...
# Mar 24 16:00:52 gw ntopng[21127]: 24/Mar/2022 16:00:52 [startup.lua:149] Initializing timeseries...
# Mar 24 16:00:52 gw ntopng[21127]: 24/Mar/2022 16:00:52 [startup.lua:212] Fetching latest ntop blog posts...
# Mar 24 16:00:52 gw ntopng[21127]: 24/Mar/2022 16:00:52 [startup.lua:216] Completed startup.lua
# Mar 24 16:00:52 gw ntopng[21127]: 24/Mar/2022 16:00:52 [PeriodicActivities.cpp:167] Found 10 activities


# You will need to edit it to make some changes in the ntopng config file found in /etc/ntopng/ntopng.conf:
echo "Changing to ntopng directory...."
cd /etc/ntopng/

# vim /etc/ntopng/ntopng.conf
# Change the following lines:

# Define the network interface for network monitoring.
# -i=enp0s3 
echo "-i=enp0s3" > ntopng.conf # Change to your server LAN Interface


##Define the HTTP port for web server.
# -w=3000
echo "-w=3000" >> ntopng.conf # 

# Specify the process ID location
# -G=/var/run/ntopng.pid
echo "-G=/var/run/ntopng.pid" >> ntopng.conf

# Save and close the file when finished. Next, create a new ntopng.start file to define your network. 
# vim /etc/ntopng/ntopng.start
echo "Creating ntopng start file...."
touch ntopng.start

# Add the following lines:
echo "Adding LAN and interface lines"

echo "--local-networks "192.168.0.0/24"  ## Edit to your preferred LAN subnets." > ntopng.start
echo "--interface 1" >> ntopng.start

# Save and close the file, then restart Ntopng to apply the configuration changes:
echo "Restarting ntopng service...."
systemctl restart ntopng

echo "Installation completed successfuly...."
echo "Navigate to your fav browser and punch in <Your server IP>:3000"

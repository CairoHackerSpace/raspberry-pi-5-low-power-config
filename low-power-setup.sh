#!/bin/bash
# Raspberry Pi 5 Low Power Setup Script
# Automates power-saving tweaks for Pi 5

set -e

# Disable WiFi and Bluetooth overlays in config.txt
grep -qxF 'dtoverlay=disable-wifi' /boot/config.txt || echo 'dtoverlay=disable-wifi' | sudo tee -a /boot/config.txt
grep -qxF 'dtoverlay=disable-bt' /boot/config.txt || echo 'dtoverlay=disable-bt' | sudo tee -a /boot/config.txt

grep -qxF 'dtparam=audio=off' /boot/config.txt || echo 'dtparam=audio=off' | sudo tee -a /boot/config.txt

grep -qxF 'dtparam=act_led_trigger=none' /boot/config.txt || echo 'dtparam=act_led_trigger=none' | sudo tee -a /boot/config.txt
grep -qxF 'dtparam=act_led_activelow=off' /boot/config.txt || echo 'dtparam=act_led_activelow=off' | sudo tee -a /boot/config.txt
grep -qxF 'dtparam=pwr_led_trigger=none' /boot/config.txt || echo 'dtparam=pwr_led_trigger=none' | sudo tee -a /boot/config.txt
grep -qxF 'dtparam=pwr_led_activelow=off' /boot/config.txt || echo 'dtparam=pwr_led_activelow=off' | sudo tee -a /boot/config.txt
grep -qxF 'dtparam=eth_led0=4' /boot/config.txt || echo 'dtparam=eth_led0=4' | sudo tee -a /boot/config.txt
grep -qxF 'dtparam=eth_led1=4' /boot/config.txt || echo 'dtparam=eth_led1=4' | sudo tee -a /boot/config.txt

grep -qxF 'gpu_mem=16' /boot/config.txt || echo 'gpu_mem=16' | sudo tee -a /boot/config.txt
grep -qxF 'gpu_freq=500' /boot/config.txt || echo 'gpu_freq=500' | sudo tee -a /boot/config.txt
grep -qxF 'gpu_freq_min=500' /boot/config.txt || echo 'gpu_freq_min=500' | sudo tee -a /boot/config.txt
grep -qxF 'arm_freq=1500' /boot/config.txt || echo 'arm_freq=1500' | sudo tee -a /boot/config.txt
grep -qxF 'arm_freq_min=1500' /boot/config.txt || echo 'arm_freq_min=1500' | sudo tee -a /boot/config.txt
grep -qxF 'core_freq_min=500' /boot/config.txt || echo 'core_freq_min=500' | sudo tee -a /boot/config.txt
grep -qxF 'over_voltage_delta=-10000' /boot/config.txt || echo 'over_voltage_delta=-10000' | sudo tee -a /boot/config.txt
grep -qxF 'disable_fw_kms_setup=1' /boot/config.txt || echo 'disable_fw_kms_setup=1' | sudo tee -a /boot/config.txt
grep -qxF 'arm_64bit=1' /boot/config.txt || echo 'arm_64bit=1' | sudo tee -a /boot/config.txt
grep -qxF 'total_mem=512' /boot/config.txt || echo 'total_mem=512' | sudo tee -a /boot/config.txt

# Disable unused services
sudo systemctl disable hciuart || true
sudo systemctl disable triggerhappy || true

# Install required tools
sudo apt-get update
sudo apt-get install -y libraspberrypi-bin ethtool

# Disable HDMI at runtime
sudo tvservice --off

# Limit Ethernet to 100Mbps
sudo ethtool -s eth0 speed 100 duplex full autoneg off

# Turn off Power LED
echo 0 | sudo tee /sys/class/leds/led1/brightness

# Turn off Ethernet (no network via cable)
sudo ifconfig eth0 down

echo "Low power setup applied. Please reboot for config.txt changes to take effect."

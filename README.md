# Raspberry Pi 5 Low Power Consumption Guide

This guide provides all the best practices, configuration tweaks, and scripts to minimize power usage on Raspberry Pi 5. It combines official documentation and community tips.

## 1. Hardware & Environment
- Use a high-efficiency power supply (official or >90% efficient)
- Passive cooling (heatsink) can help reduce power draw slightly
- Remove unused peripherals (USB, HDMI, Ethernet cables)

## 2. Essential `config.txt` Tweaks (Pi 5)
Edit `/boot/config.txt` and add or adjust the following:

```ini
# Disable WiFi and Bluetooth
# (saves power if not needed)
dtoverlay=disable-wifi
dtoverlay=disable-bt

# Disable onboard audio
dtparam=audio=off

# Turn off mainboard LEDs
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=off

# Turn off Ethernet port LEDs
dtparam=eth_led0=4
dtparam=eth_led1=4

# Reduce GPU memory allocation
gpu_mem=16


# Set GPU frequency (minimum supported for Pi 5 is 500MHz)
gpu_freq=500
gpu_freq_min=500



# Lower CPU frequency (minimum supported for Pi 5 is 1500MHz)
arm_freq=1500
arm_freq_min=1500

# Lower core frequency (minimum supported for Pi 5 is 500MHz)
core_freq_min=500


# Undervolting (recommended for Pi 5, minimum supported is -10000)
over_voltage_delta=-10000

# Disable HDMI (if not needed)
disable_fw_kms_setup=1

# Boot in 64-bit mode (default for Pi 5)
arm_64bit=1

# Optional: Limit RAM usage (for minimal setups)
total_mem=512

# Turn off Ethernet (if not needed)
# There is no official overlay, but you can disable the interface in the OS:
# Add to /etc/rc.local or use a script:
# ifconfig eth0 down
```

## 3. System Tweaks & Scripts

### Disable Unused Services
```sh
sudo systemctl disable hciuart  # Bluetooth UART
sudo systemctl disable triggerhappy  # Keyboard daemon (if headless)
```

### Disable HDMI at runtime
```sh
sudo apt-get install libraspberrypi-bin
sudo tvservice --off
```

### Limit Ethernet to 100Mbps
```sh
sudo apt-get install ethtool
sudo ethtool -s eth0 speed 100 duplex full autoneg off
```

### Turn off Power LED
```sh
echo 0 | sudo tee /sys/class/leds/led1/brightness

### Turn off Ethernet
# This disables the Ethernet interface (no network via cable):
sudo ifconfig eth0 down
# To re-enable:
sudo ifconfig eth0 up
```

## 4. Automation Script
See `low-power-setup.sh` for a script to automate these steps.

## 5. Template `config.txt`
See `config.txt.template` for a ready-to-use configuration file.

## 6. References

- [Official Raspberry Pi config.txt documentation](https://www.raspberrypi.com/documentation/computers/config_txt.html)
- [Raspberry Pi Forums: Pi 5 Power Consumption](https://forums.raspberrypi.com/viewtopic.php?t=357661)
- [Raspberry Pi Forums: Pi 5 Power Saving Tips](https://forums.raspberrypi.com/viewtopic.php?t=357661#p2143127)
- [Jeff Geerling: Raspberry Pi 5 Power Consumption](https://www.jeffgeerling.com/blog/2023/raspberry-pi-5-power-consumption)
- [Raspberry Pi Documentation: Overclocking and Overvolting](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#overclocking-and-overvolting)
- [Raspberry Pi Documentation: GPU Memory](https://www.raspberrypi.com/documentation/computers/config_txt.html#gpu_mem)
- [Raspberry Pi Documentation: HDMI Options](https://www.raspberrypi.com/documentation/computers/config_txt.html#hdmi-options)

**Note:** Always reboot after changing `config.txt`. Some settings may require firmware updates for full effect.

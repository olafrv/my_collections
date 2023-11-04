# Linux Shell Script to Restart a Movilmax Router When Internet is Down

[Movilmax](https://www.movilmax.com) was a WiMax provider available in Venezuela. 

![Movilmax Router](media/cpe_samsung_modem.jpg) 

**Model: SMT-S3500**
- Central Frequency: 2.5 MHz
- Bandwidth: 10 MHz
- Dimensions: 190 mm x 146 mm x 129 mm
- Weight: 0.85 kg
- Temperature Range: +5 ~ + 45° C
- Humidity Range: 5 ~ 95%
- Standard Speed: DL 1Mbps, UL 512kbps
- Speed Range: DL 4Mbps ~ UL 2Mbps
- Power Consumption: 15W

I've created a [Linux shell script](movilmax/) to automatically restart a 
Movilmax router (pictured above) when the Internet gateway is down. 
This script can be scheduled in your crontab.

I'm sharing this script here in case you're experiencing stability issues
with your WiMax signal and need a reliable solution to maintain your connection.

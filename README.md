<p align="center">
  <img src="https://github.com/CorvusCodex/DeauthAngel/blob/main/deauthangel.png?raw=true">
</p>

# DeauthAngel - Wireless Network Deauthenticator

This script is a powerful tool for network analysis and security. It scans for wireless networks in the vicinity and sends deauthentication packets to all devices on those networks, effectively disconnecting them.

## Features

- Scans for all wireless networks in range
- Sends deauthentication packets to all devices on each network
- Checks if the necessary tools are installed and installs them if necessary
- Checks if the script is being run as root

## Usage

```bash
./deauthenticator.sh <wireless_interface>
```
## Requirements
This script requires the following tools:

airmon-ng <br>
airodump-ng <br>
aireplay-ng <br>
If these tools are not installed, the script will prompt you to install them.  <br>
Linux OS <br>
A network adapter that supports monitor mode and packet injection

## Support

Support my work:

- BTC: bc1q7wth254atug2p4v9j3krk9kauc0ehys2u8tgg3
- ETH & BNB: 0x68B6D33Ad1A3e0aFaDA60d6ADf8594601BE492F0
- Buy me a coffee: https://www.buymeacoffee.com/CorvusCodex

### Support my work for month or year so i can continue to work on my projects:
https://www.buymeacoffee.com/corvuscodex/membership

### Buy me some equipment:
https://www.buymeacoffee.com/corvuscodex/wishlist


## Disclaimer
This script should only be used for legal purposes, such as penetration testing with proper authorization or for educational purposes. Misuse of this script can lead to legal consequences. Please use responsibly!

MIT License

Copyright (c) 2023 CorvusCodex

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

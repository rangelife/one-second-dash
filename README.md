# ROB:

## to install this whole thing:
do "Raspberry Pi Setup" below


## to add a new dash button:

plug in AD Yellow router
plug LAN from laptop into port 1-4
go into config (http://192.168.1.252, admin/usual)
change BOTH Wifi Names to Sweepy New Name, ensure channel 1, save, apply

unplug.

plug upstream port into main internet connected router
reconnect from laptop via wifi. make sure it can reach through to internet [NEEDED!]

press button til blue flashy light on dash button.
connect to Amazon ConfigureMe wifi.

then run ./setup-dashbutton.py 'Sweepy%20New%20Name' 'password matters'

(NOTE DOWN THE MAC ADDRESS of the dash button spat out here)

reconnect router wired to laptop , change BOTH Wifi Names back to Sweepy Nothing, save, apply. now unplug it


in this repo, add a line to dash_ssids for the new network name

and add a script based on one of the others

and add to the below table

and save and push to github, pull down to pi

re run the monitor script ./start.sh

check it's firing.

if it doesn't, maybe the button wasn't registered so the setup-dashbutton doesn't work.

so we'll need to use the MAC address and longpress, hopefully can be seen in some kind of scan..

    sudo iwlist wlan0 scanning essid 'Amazon ConfigureMe'

.. need to ensure "Last beacon" is <1sec

## existing dash buttons:
+------------------+-----------------------+---------------+--------------+
| SSID             | Logo                  | Function      | Requirements |
+------------------+-----------------------+---------------+--------------+
| Sweepy Gripey    | Gaviscon              | Playlist upstairs bedroom      | cmd: squeezeplay  |
| Sweepy Nom Nom   | Pedigree              | 10 min timer  | cmd: henremind, sayhard, sayg ; apt: python3-pip mplayer sox libsox-fmt-mp3 ; pip3: requests  |
| Sweepy Poo Poo   | Andrex                | Playlist downstairs far     | cmd: squeezeplay  |
| Sweepy Scrubadub | Ariel                 |               |              |
| Sweepy Ting      | Finish                |               |              |
| Sweepy Pores     | Neutrogena            |               |              |
+------------------+-----------------------+---------------+--------------+


+--------------+-----------------------+---------------+
| MAC          | Logo                  | Function      |
+--------------+-----------------------+---------------+
| AC63BE8FE729 | Ariel                 |               |
| 50F5DA7F0FDC | Finish                |               |
| 50F5DA81D305 | Neutrogena            |               |
+--------------+-----------------------+---------------+



=========


# One Second Dash

One Second Dash is a bit of code to react to Amazon Dash buttons, designed for the Raspberry Pi.

To use One Second Dash, you associate your Dash with a unique network SSID, for a network that does not exist. One Second Dash works by placing your WiFi interface in monitor mode and listening for probe requests for a special SSID (via tcpdump). This reacts much faster (&lt;1 second) than the technique of monitoring ARP requests, because the Dash does not need to join the network first.

One Second Dash also has the advantage that your Dash buttons do not join your network and need not be given its password.

One Second Dash is made available under the very permissive Zlib license. The chime sound file `doorbell.wav` is in the public domain, available [here](http://www.freesound.org/people/pac007/sounds/331569/).

## Usage

#### Dash button setup

1. Think of a unique WiFi SSID. If there's another network with the same SSID nearby, you'll get spurious presses, so don't do that.
2. Temporarily configure a router to create a network with that SSID. It can be a hidden network. If your home router has a guest network feature, that's ideal.
3. Check what channel it's on. We'll need that later!
4. Go through the Dash button setup with this network. Stop at the final step, before you choose what to buy.
5. Nix the network. It's no longer necessary!

#### Raspberry Pi Setup

This tutorial assumes you also want to have your RPi on your normal WiFi network. This requires two dongles, since monitor mode displaces managed mode. If you are happy using Ethernet, things are a little simpler.

1. Get a network dongle that supports monitor mode. Be careful with the chipset: RT5370 works, RTL8188CUS does not.
2. Install stuff

        sudo apt-get update
		sudo apt-get install iw tcpdump
		sudo apt-get install alsaplayer alsaplayer-text # if you want it to play a sound

3. If you are using two dongles, we need to be able to tell them apart. We do this by looking at the _capabilities_ according to `iw phy`. Run `iw phy` and look for a field like `Capabilities:`. Figure out which one corresponds to your monitor dongle and write that down, for example, `Capabilities: 0x1862`
    
    One way to figure this out is to run `iw phy` with only one dongle attached [RJLH: i.e.
    before you plug in the new dongle]. That tells you the capabilities for that dongle.
	
	If you are using Ethernet, you'll only get one Capabilities field.
    
    (Note: if you know of a better way to identify the chipset behind a phy interface, please open a PR!)

4. `wpa_supplicant` is your nemesis. We want to disable it. Edit `/etc/network/interfaces`. If you plan to use Ethernet, make the WiFi section look like so:

        allow-hotplug wlan0
    
	If you plan to use two WiFi dongles, make it look like so (here wlan0 is the managed mode interface, that will connect to the real network, and wlan1 will be the monitor).

        allow-hotplug wlan0
        auto wlan0
        iface wlan0 inet dhcp
                wpa-ssid "YourWiFiSSID"
                wpa-psk 29058c1c28d70e6f7180ca50300fbc9b451cc1d519c4b33df3c4d30ee95b7292
        
        allow-hotplug wlan1
	
    [RJLH: this is bunk. since we don't care about the system being a wifi client, just

        sudo apt-get remove wpasupplicant

    .. turn off, insert dongle, turn on

    ]

    `YourWiFiSSID` is replaced with your network's SSID (the real one that your RPi connects to, not the fake one for the Dash). The wpa-psk value can be obtained via `wpa_passphrase YourWiFiSSID` (`sudo apt-get install wpasupplicant` if necessary)
    
    (Note: here we're bravely hoping wlan0 corresponds to the correct adapter, since I don't know of a better way. If you would like to update this, maybe with persistent-net-rules instructions, please open a PR!)

5. Clone this repo on your RPi

6. Edit `start.sh`:
   * Set `SSID_NAME` to the SSID you chose during Dash setup [RJLH - delegated to the dash_ssids file]
   * Set `CHANNEL` to the channel you identified in step 2 under "Dash button setup".
   * Set `CAP_FIELD` to the capabilities field you identified in step 3
   
7. `sudo start.sh` and watch the output. Once you see the line starting with `listening on DoorbellMonitor`, press your Dash button. You should see a line printed! If you have a speaker attached, the RPi will play a doorbell tone too.

8. To make your Dash button do something else, modify the `do_ring()` function in `doorbell.py`.

##### Launch at boot

1. To make the doorbell script run at boot, you can edit `/etc/rc.local` file to invoke `start.sh` (before exit 0):

        sudo -u pi /home/pi/rattus/one-second-dash/start.sh > /var/log/doorbell.log &

[rjlh while you're there... comment this bit out...

    #Start Accesspoint on Boot if no network connection available
    #/var/www/max2play/application/plugins/accesspoint/scripts/start_accesspoint_onboot.sh

]

**Happy Dashing!**

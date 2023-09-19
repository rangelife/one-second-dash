# One Second Dash rangelife edit

SEE ALSO JOURNAL.txt (above above this in dropbox)


## RECIPE: maintenance scan

get work laptop and home laptop.

work through list below..

### existing dash button inventory

see https://docs.google.com/spreadsheets/d/1sSGNl8m2li6CBcXt8w1auR_0nDcJlp_58tEBuLWa7P8/edit#gid=0



## RECIPE: to install this whole thing:
do "Raspberry Pi Setup" below





## RECIPE: to add a new dash button (or fix after power loss and battery change):

N.B. if you're repairing a failing button, ssh into pi (with work laptop) and
sudo service one-second-dash stop
sudo pkill doorbell
sudo NO_LAUNCH=1 ./doorbell.py

... to stop launches from known name being reported by AD orange's wifi beacons when we change the name next.


edit this file on home laptop. and use for below.
set up by bottom of stairs or in living room nr router (need wired lan)

plug in AD Orange (Linksys E3000) router
plug AD Orange lan upstream into main internet connected router

connect laptop wifi to it (Sweepy Dashmaster)

go into config (http://192.168.1.251, admin/password)



for a new button, you need to pick a NEW NAME which is not just a superset of the old ones,
or the old actions will trigger!
i.e. DON'T just stick 2 on the end or it will match the old rule. Maybe put numbers in the middle

go to Wireless->Wireless Security, unmask password and remember its password
go to Wireless->Basic Settings, change 2.4G Wifi Name to Sweepy New Name (allocate from table below), ensure channel 1,
leave 5G as Sweepy Dashmaster, save, apply

reconnect from laptop to new SSID via wifi.

disconnect AD orange WAN.

--1--

press button til blue flashy light on dash button.
connect to Amazon ConfigureMe wifi
browse to http://192.168.0.1 and leave page there for now...

then run ./setup-dashbutton.py 'Sweepy New Name' 'Whatever The Password Was'

(back in browser, NOTE DOWN THE MAC ADDRESS , firmware, battery of the dash button spat out here at https://docs.google.com/spreadsheets/d/1sSGNl8m2li6CBcXt8w1auR_0nDcJlp_58tEBuLWa7P8/edit#gid=0)

if "Dash button configured!" .. and light goes out, see if it worked:
turn off AD orange... TURN OFF LAPTOP WIFI

press dash button

see work laptop logs for whether it sent probe request, if so we're good!

if that didn't work:
    --2--
    (if you already did this section, skip to 3)
    Put Dash Button in setup mode by holding down the button until the LED flashes blue.
    While in setup mode, play this .wav file [afplay write_customer_secret.s.wav] through some earbuds aimed at the Dash Button, or on laptop speakers but ensure balance set all one side (so it's not having to listen to signal from 2 speakers which will mess its reception up).
    If the LED turns green, the exploit worked!
        try from --1-- again
    If the LED turns off, you’re possibly on a firmware version that fixed the vulnerability. Unfortunately, you’re out of luck if this is the case. (unless someone finds another vulnerability)

then:
    --3--
    turn AD orange on again, reconnect WAN to AD orange, make sure (from laptop) it can reach through to internet [NEEDED!]

    press button til blue flashy light on dash button.
    connect to Amazon ConfigureMe wifi

    then run ./setup-dashbutton.py 'Sweepy New Name' 'Whatever The Password Was'

if "Dash button configured!" .. and light goes out, see if it worked:
turn off AD orange... TURN OFF LAPTOP WIFI

press dash button

see work laptop log for whether it sent probe request, if so we're good! if not, tough luck :-( take battery out and icebox the dash button in case anyone ever figures out how to revive them



from laptop reconnect to AD orange Sweepy Dashmaster, hit http://192.168.1.251 again.
change BOTH Wifi Names back to Sweepy Dashmaster, save, apply




on pi,
if it's a new button/SSID, in this repo, add a line to dash_ssids for the new SSID name
sudo service one-second-dash stop
sudo NO_LAUNCH=1 ./doorbell.py

press dash button. check it's firing. ctrl-c.

if it wasn't firing (and maybe emitted red light) try these older techniques....:


### aside: further work for noncompliant ones

If all this fails, we could use some buttons in "long press" mode only, scanning for the MAC address

    sudo iwlist wlan0 scanning essid 'Amazon ConfigureMe'

.. need to ensure "Last beacon" is <1sec

.. and would have to implement something that scans to look for those MACs (see MACs in below table)

(I actually fixed these ones with the buffer overrun hack wav)


## wiring new buttons up to scipts

....... once dash signals established:

push new dash_ssids to github

pull onto laptop

and add a script based on one of the others

and add details to the below table

and save and push to github, pull down to pi

run script manually, ./ring-* check it's working.


re run the service

sudo service one-second-dash start

press button, check it's firing with:

tail -f /var/log/one-second-dash*




vvv original docs:

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

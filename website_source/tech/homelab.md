I have been trying to make a home lab for the past two years and I have learned a lot from doing this.

The different parts of my lab are the following:
- My managed switch
- Openwrt based router and an extending AP
- My NAS
- My pc running Nixos
  - Immich server
  - Jellyfin
  - Actual-budget
  - Caddy server
  - tailscale network with a friend

I am going to try and break down each component to explain what it does and why I am running all of these in my home network.

NAS

  This is where I store all of my media for jellyfin and any extra files I want to have in a shared space. Its based on this [SBC](https://www.friendlyelec.com/index.php?route=product/product&product_id=294)
  and it currently has about 4 TB of storage on it. I am running a ZFS 1 pool of SSD's and it contributes to an NFS share that is setup.
  I am using friendlyelec's [openmediavault](https://www.openmediavault.org/) image for the os which is debian based.

Managed switch

  Right now the switch is just being used as a simple ethernet port extender off of my AP for my house, but it supports vlans and I have used it
  to test certain configurations for the switches I use at work and it is a nice place to expieriment with new ideas I have for layer 2/ Layer 3
  networking. (Data Link and Internet/transport Layers)

Router and AP

  I got these from the job that I work at. They are WIFI 7 devices that are openwrt based with some extra programs for configuration. I can't
  really say a lot about these device's since I do not want to leak anything about them.

Lastly, I have my Nixos PC

  First, I will talk about why I chose [Nixos](https://nixos.org/) instead of just any Linux distribution. This can honestly be a section itself, and when
  I make a new blog post about it, I will link it here. In short, I think Nixos is well suited for a homelab, becuase it allows for easy deployments,
  shared configurations between devices and if a computer ever goes down, easy redeployments of the same environment over and over again.


This next section is dedicated to the software that runs in my home lab.

[Jellyfin](https://jellyfin.org/)

  This is a media sever. It allows me to stream any media located on my NAS in a media folder to any device that can connect to said server. Jellyfin
  has been so nice with not having to use scp and other copy programs moving from one device to another. It also allows for a device to download
  any media in the server locally, so I can watch it offline. I've download some shows right before some of my flights and it has been super nice.

[Immich](https://immich.app/)

  This is a more recent addition, but I have wanted a convient way to store all of my photos I own in one place. Through using Immich I took all of
  the backups and duplicated photsos from my home pcs and now they just live in this app.

[Actual-budget](https://actualbudget.org/)

  I use this app for my budgeting. I use it in tandem with [simplefin bridge](https://beta-bridge.simplefin.org/) to get all of my credit card
  and bank staements and import them into one easy interface to use. Simplefin only costs around $15 yearly, so this is also very budget friendly
  as well ;)

[Caddy](https://caddyserver.com/)

  I run a local instance to easily setup https certifactions to all of my local webservices. Caddy makes HTTPS really easy.

[Tailscale](https://tailscale.com/)

  This is also a newer addition to my home lab. I used to just use a [wireguard vpn tunnel](https://www.wireguard.com/), but tailscale is way
  nicer. Tailscale is a management system built on top of wireguard that allows for devices to connect to a VPS instance and automatically
  share all of the wireguard private keys to every device that has previously connected to the VPS. I use this to connect to all of my devices
  outside of my home network and get access to my immich server or jellyfin without having to make firewall rules, since Tailscale automatically
  does udp hole punching to avoid making firewall rules.

  Another benefit is that becuase Tailscale is built on top of wiregaurd tunnels, the connections are lightweight and tailscale also has
  an ACL (Access Control List) system built right in to secure your network even further.

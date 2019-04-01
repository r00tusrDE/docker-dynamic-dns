Docker Dynamic DNS Client for wint.global
=====

Dynamic DNS services have been around since the early days of the internet. Generally speaking, internet service providers (ISP's) will reassign an IP address to a subscriber after some period of time or if the user reconnects his or her connection. Traditional DNS services, however, relied on IP addresses staying the same. DynDNS developed an HTTP-based protocol for updating DNS records on Dynamic DNS services that has been copied for a number of platforms.  One of the real advantages of Dynamic DNS nowadays is that HTTPS can now be bound to a domain name instead of an IP. Likewise, a domain name (ie. subdomain.example.com) can be bound to a dynamic DNS name in a DNS record via a CNAME. So even if one is using a Dynamic DNS, traffic can still be secured using HTTPS.


To build the Docker image, simply run Docker build

```
docker build --no-cache --tag wint-global-ddns .
```

Before you run the container create ```hostsList.txt``` and ```ddns.log``` files in your config path.
```
touch /path/to/config/hostsList.txt /path/to/log/ddns.log
```

And add your hostnames. One per line!
You can add/delete/edit hostnames everytime. They are being loaded every INTERVAL (see below for more info).

To use the image, use Docker run.

```
docker run -it --rm --name wint-global-ddns -e USER=yourusername -e PASSWORD=yourpassword -e DETECTIP=1 -e INTERVAL=1 -e TZ=Europe/Berlin -v /path/to/config/hostsList.txt:/config/hostsList.txt:ro -v /path/to/log/ddns.log:/log/ddns.log wint-global-ddns
```

Or use docker-compose.

```
version: "2"
services:
  wint-global-ddns:
    image: wint-global-ddns
    container_name: dyndns
    environment:
      - TZ=Europe/Berlin
      - USER=yourusername
      - PASSWORD=yourpassword
      - DETECTIP=1
      - INTERVAL=1
    volumes:
      - /path/to/config/hostsList.txt:/config/hostsList.txt:ro
      - /path/to/log/ddns.log:/log/ddns.log
    restart: unless-stopped
```

The envitonmental variables are as follows:

* **USER**: the username for the service.

* **PASSWORD**: the password or token for the service.

* **DETECTIP**: If this is set to 1, then the script will detect the external IP of the service on which the container is running, such as the external IP of your DSL or cable modem.

* **IP**: if DETECTIP is not set, you can specify an IP address.

* **INTERVAL**: How often the script should call the update services in minutes.

* **TZ**: Your Timezone. Lookup your Timezone at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones . (not needed. You can add it if you want correct times in logs.)

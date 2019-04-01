Docker Dynamic DNS Client for wint.global
=====

Dynamic DNS services have been around since the early days of the internet. Generally speaking, internet service providers (ISP's) will reassign an IP address to a subscriber after some period of time or if the user reconnects his or her connection. Traditional DNS services, however, relied on IP addresses staying the same. DynDNS developed an HTTP-based protocol for updating DNS records on Dynamic DNS services that has been copied for a number of platforms.  One of the real advantages of Dynamic DNS nowadays is that HTTPS can now be bound to a domain name instead of an IP. Likewise, a domain name (ie. subdomain.example.com) can be bound to a dynamic DNS name in a DNS record via a CNAME. So even if one is using a Dynamic DNS, traffic can still be secured using HTTPS.


To build the Docker image, simply run Docker build

```
docker build --no-cache --tag wircon-ddns .
```

To use the image, use Docker run.

```
docker run -it --rm --name no-ip1 -e USER=username -e PASSWORD=yourpassword -e DETECTIP=1 -e INTERVAL=1 wint-global-ddns
```

The envitonmental variables are as follows:

* **USER**: the username for the service.

* **PASSWORD**: the password or token for the service.

* **DETECTIP**: If this is set to 1, then the script will detect the external IP of the service on which the container is running, such as the external IP of your DSL or cable modem.

* **IP**: if DETECTIP is not set, you can specify an IP address.

* **INTERVAL**: How often the script should call the update services in minutes.

FROM alpine
RUN apk update && apk add bash wget && apk add --no-cache tzdata
COPY no-ip.sh /no-ip.sh
CMD /bin/bash /no-ip.sh

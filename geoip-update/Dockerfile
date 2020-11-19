FROM alpine:latest

ENV GEOIP_EDITION=''
ENV GEOIP_LICENSE_KEY=''
ENV GEOIP_OUT_PATH=''

ADD update.sh update.sh
CMD [ "sh", "update.sh" ]

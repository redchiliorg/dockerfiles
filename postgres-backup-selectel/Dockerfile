FROM alpine:3.8
LABEL maintainer="redchiliorg"

ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ENV POSTGRES_DATABASE **None**
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD ''
ENV POSTGRES_EXTRA_OPTS ''
ENV SELECTEL_USER_ID **None**
ENV SELECTEL_PASSWORD **None**
ENV SELECTEL_CONTAINER_NAME **None**
ENV SELECTEL_DELETE_AFTER **None**
ENV SCHEDULE **None**

ADD run.sh run.sh
ADD backup.sh backup.sh

CMD ["sh", "run.sh"]


# Dockerfile
FROM openjdk:8u171-alpine

ENV ES_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.10.tar.gz"

# ENV ELASTIC_CONTAINER true
# ENV PATH /usr/share/elasticsearch/bin:$PATH
# ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk


# setup timezone
# RUN apk add --no-cache tzdata \
#  && cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
#  && echo "Europe/Moscow" > /etc/timezone


RUN apk update \
 && apk add --no-cache bash curl \
 && rm -rf /var/cache/apk/*

RUN addgroup -g 1000 elasticsearch \
 && adduser -u 1000 -G elasticsearch -D -h /usr/share/elasticsearch elasticsearch

WORKDIR /usr/share/elasticsearch

USER elasticsearch

# Download and extract defined ES version.
# RUN curl -fsSL {$ES_URL} | \
    # tar zx --strip-components=1
RUN wget -O - ${ES_URL} | tar -xz --strip-components=1

RUN set -ex && for esdirs in config data logs; do \
        mkdir -p "$esdirs"; \
    done



COPY elasticsearch.yml log4j2.properties config/
COPY bin/es-docker bin/es-docker

USER root
RUN chown elasticsearch:elasticsearch \
      config/elasticsearch.yml \
      config/log4j2.properties \
      bin/es-docker && \
    chmod 0750 bin/es-docker

USER elasticsearch
CMD ["/bin/bash", "bin/es-docker"]

EXPOSE 9200 9300




# RUN adduser -D -u 1000 -h /elasticsearch elasticsearch \
 # && chown -R elasticsearch:elasticsearch /elasticsearch

# RUN apk update \
 # && apk add --no-cache bash openrc procps curl \
 # && mkdir /run/openrc && touch /run/openrc/softlevel

# COPY init.d/elasticsearch /etc/init.d/elasticsearch
# RUN chmod 755 /etc/init.d/elasticsearch
 # && rc-status

# RUN rm -rf /var/cache/apk/*


# RUN rc-update add elasticsearch boot
# CMD rc-service elasticsearch start -v
# ENTRYPOINT rc-service elasticsearch start -v
 # && while true; do sleep 1000; done

# EXPOSE 9200

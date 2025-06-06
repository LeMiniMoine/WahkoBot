FROM python:3.11-slim-bookworm AS core-build

# Add PhasecoreX user-entrypoint script
ADD https://raw.githubusercontent.com/PhasecoreX/docker-user-image/master/user-entrypoint.sh /bin/user-entrypoint
RUN chmod +rx /bin/user-entrypoint && /bin/user-entrypoint --init
ENTRYPOINT ["/bin/user-entrypoint"]

RUN set -eux; \
# Install Red-DiscordBot dependencies
    apt-get update; \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        libsodium-dev \
        libffi-dev \
        jq \
        openssh-client \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /dummy; \
    mkdir -p /root/.config/Red-DiscordBot; \
    ln -s /data/config.json /root/.config/Red-DiscordBot/config.json; \
    mkdir -p /usr/local/share/Red-DiscordBot; \
    ln -s /data/config.json /usr/local/share/Red-DiscordBot/config.json; \
    mkdir -p /config/.config/Red-DiscordBot; \
    ln -s /data/config.json /config/.config/Red-DiscordBot/config.json;

VOLUME /data

ENV SODIUM_INSTALL=system



FROM core-build AS core
ARG PCX_DISCORDBOT_BUILD
ARG PCX_DISCORDBOT_COMMIT
ENV PCX_DISCORDBOT_BUILD=${PCX_DISCORDBOT_BUILD} PCX_DISCORDBOT_COMMIT=${PCX_DISCORDBOT_COMMIT} PCX_DISCORDBOT_TAG=core
COPY root/ /
EXPOSE 10000
CMD python3 -m http.server 10000 --directory /dummy & exec /app/start-redbot.sh



FROM core-build AS extra-build
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libmagickwand-dev \
        libaa1-dev \
        ffmpeg \
        imagemagick \
        $([ "$(uname --machine)" = "armv7l" ] && echo "gfortran libopenblas-dev liblapack-dev") \
        tesseract-ocr \
    ; \
    sed -i '/@\*/d' /etc/ImageMagick-6/policy.xml; \
    rm -rf /var/lib/apt/lists/*;



FROM extra-build AS extra
ARG PCX_DISCORDBOT_BUILD
ARG PCX_DISCORDBOT_COMMIT
ENV PCX_DISCORDBOT_BUILD=${PCX_DISCORDBOT_BUILD} PCX_DISCORDBOT_COMMIT=${PCX_DISCORDBOT_COMMIT} PCX_DISCORDBOT_TAG=extra
COPY root/ /
EXPOSE 10000
CMD python3 -m http.server 10000 --directory /dummy & exec /app/start-redbot.sh



FROM core-build AS core-audio-build
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
    ; \
    rm -rf /var/lib/apt/lists/*;



FROM core-audio-build AS core-audio
ARG PCX_DISCORDBOT_BUILD
ARG PCX_DISCORDBOT_COMMIT
ENV PCX_DISCORDBOT_BUILD=${PCX_DISCORDBOT_BUILD} PCX_DISCORDBOT_COMMIT=${PCX_DISCORDBOT_COMMIT} PCX_DISCORDBOT_TAG=core-audio
COPY root/ /
EXPOSE 10000
CMD python3 -m http.server 10000 --directory /dummy & exec /app/start-redbot.sh



FROM extra-build AS extra-audio-build
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
    ; \
    rm -rf /var/lib/apt/lists/*;



FROM extra-audio-build AS extra-audio
ARG PCX_DISCORDBOT_BUILD
ARG PCX_DISCORDBOT_COMMIT
ENV PCX_DISCORDBOT_BUILD=${PCX_DISCORDBOT_BUILD} PCX_DISCORDBOT_COMMIT=${PCX_DISCORDBOT_COMMIT} PCX_DISCORDBOT_TAG=extra-audio
COPY root/ /
EXPOSE 10000
CMD python3 -m http.server 10000 --directory /dummy & exec /app/start-redbot.sh



FROM core-build AS core-pylav-build
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libaio1  \
        libaio-dev \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /data/pylav;


FROM core-pylav-build AS core-pylav
ARG PCX_DISCORDBOT_BUILD
ARG PCX_DISCORDBOT_COMMIT
ENV PCX_DISCORDBOT_BUILD=${PCX_DISCORDBOT_BUILD} PCX_DISCORDBOT_COMMIT=${PCX_DISCORDBOT_COMMIT} PCX_DISCORDBOT_TAG=core-pylav
ENV PYLAV__DATA_FOLDER=/data/pylav PYLAV__YAML_CONFIG=/data/pylav/pylav.yaml PYLAV__IN_CONTAINER=1
COPY root/ /
EXPOSE 10000
CMD python3 -m http.server 10000 --directory /dummy & exec /app/start-redbot.sh



FROM extra-build AS extra-pylav-build
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libaio1  \
        libaio-dev \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /data/pylav;


FROM extra-pylav-build AS extra-pylav
ARG PCX_DISCORDBOT_BUILD
ARG PCX_DISCORDBOT_COMMIT
ENV PCX_DISCORDBOT_BUILD=${PCX_DISCORDBOT_BUILD} PCX_DISCORDBOT_COMMIT=${PCX_DISCORDBOT_COMMIT} PCX_DISCORDBOT_TAG=extra-pylav
ENV PYLAV__DATA_FOLDER=/data/pylav PYLAV__YAML_CONFIG=/data/pylav/pylav.yaml PYLAV__IN_CONTAINER=1
COPY root/ /
EXPOSE 10000
CMD python3 -m http.server 10000 --directory /dummy & exec /app/start-redbot.sh

FROM budtmo/docker-android:emulator_14.0

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends make \
    && rm -rf /var/lib/apt/lists/*

USER ${USERID}:${GROUPID}

COPY apk/haravan.haraworks /apk/haraworks
COPY Makefile /home/androidusr/Makefile

WORKDIR /home/androidusr

FROM budtmo/docker-android:emulator_11.0

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends make \
    && rm -rf /var/lib/apt/lists/*

COPY apk/haraworks_3_0_102 /apk/haraworks

RUN test -f /apk/haraworks/com.haravan.haraworks.apk \
    && test -f /apk/haraworks/config.arm64_v8a.apk

USER ${USERID}:${GROUPID}

COPY Makefile /home/androidusr/Makefile

WORKDIR /home/androidusr

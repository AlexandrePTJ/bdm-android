FROM alpine

ARG ANDROID_CLI_VERSION=6514223
ENV ANDROID_SDK_ROOT=/android
ENV JAVA_HOME=/usr/lib/java-1.8-openjdk

# BDM proxy
ENV http_proxy=http://proxy.home.lan:3128
ENV https_proxy=http://proxy.home.lan:3128

# Update and install packages
RUN apk update && \
	apk add openjdk8 py3-pip

#
# Android
#

RUN wget -P /tmp https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CLI_VERSION}_latest.zip
RUN mkdir -p $ANDROID_SDK_ROOT && \
	unzip /tmp/commandlinetools-linux-$ANDROID_CLI_VERSION_latest.zip -d $ANDROID_SDK_ROOT

RUN yes | $ANDROID_SDK_ROOT/tools/bin/sdkmanager --licenses --sdk_root=$ANDROID_SDK_ROOT

#
# Qt
#

#
# Conan
#

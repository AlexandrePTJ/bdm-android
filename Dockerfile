FROM debian:latest

# Versions
ENV ANDROID_CMDTOOLS_VERSION=6858069
ENV ANDROID_BUILDTOOLS_VERSION=30.0.3
ENV ANDROID_NDK_VERSION=21.3.6528147
ENV ANDROID_PLATFORM_VERSION=29
ENV QT_VERSION=5.15.2

# Paths
ENV ANDROID_SDK=/opt/android-sdk
ENV ANDROID_NDK=${ANDROID_SDK}/ndk/${ANDROID_NDK_VERSION}
ENV QT_ROOT=/opt/qt
ENV QT_ANDROID=${QT_ROOT}/${QT_VERSION}/android
ENV JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64

# Install base dependencies
RUN apt update && \
	apt install -y wget apt-transport-https gnupg build-essential python3-pip unzip git

# Install CMake
RUN python3 -m pip install --user cmake

# Install AdoptOpenJDK 8
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
	echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb buster main" | tee /etc/apt/sources.list.d/adoptopenjdk.list && \
	apt update && \
	apt install -y adoptopenjdk-8-hotspot

# Install Android SDK and NDK
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDTOOLS_VERSION}_latest.zip && \
	unzip commandlinetools-linux-${ANDROID_CMDTOOLS_VERSION}_latest.zip -d ${ANDROID_SDK}/ && \
	yes | ${ANDROID_SDK}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK} --licenses && \
	${ANDROID_SDK}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK} --install "cmdline-tools;latest" && \
	${ANDROID_SDK}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK} --install \
		"platform-tools" "platforms;android-${ANDROID_PLATFORM_VERSION}" \
		"build-tools;${ANDROID_BUILDTOOLS_VERSION}" "ndk;${ANDROID_NDK_VERSION}" && \
	rm commandlinetools-linux-${ANDROID_CMDTOOLS_VERSION}_latest.zip

# Install Qt android
RUN python3 -m pip install --user aqtinstall && \
	python3 -m aqt install --outputdir /opt/qt ${QT_VERSION} linux android

# Setup some aliases
RUN echo "alias cmake='/root/.local/bin/cmake'" >> /root/.bashrc
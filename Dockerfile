FROM ubuntu

ARG ANDROID_CLI_VERSION=6514223
ENV ANDROID_SDK_ROOT=/opt/android
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV QT_ROOT=/opt/qt
ENV TZ=Europe/Paris

# BDM proxy
ENV http_proxy=http://proxy.home.lan:3128
ENV https_proxy=http://proxy.home.lan:3128

# Update and install packages
RUN apt update && \
	apt install -y openjdk-8-jdk python3-pip cmake wget unzip

#
# Android
#

RUN wget -Y off -P /tmp https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CLI_VERSION}_latest.zip && \
	mkdir -p $ANDROID_SDK_ROOT && \
	unzip /tmp/commandlinetools-linux-${ANDROID_CLI_VERSION}_latest.zip -d $ANDROID_SDK_ROOT && \
	rm /tmp/commandlinetools-linux-${ANDROID_CLI_VERSION}_latest.zip

RUN yes | $ANDROID_SDK_ROOT/tools/bin/sdkmanager --licenses --sdk_root=$ANDROID_SDK_ROOT
RUN $ANDROID_SDK_ROOT/tools/bin/sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
		"ndk-bundle" \
		"build-tools;29.0.3" \
		"platform-tools" \
		"platforms;android-24" \
		"platforms;android-28"

#
# Qt
#
RUN pip install --user aqtinstall && \
	python3 -m aqt install -O ${QT_ROOT} 5.12.8 linux android android_armv7 && \
	python3 -m aqt install -O ${QT_ROOT} 5.12.8 linux android android_arm64_v8a

#
# Conan
#

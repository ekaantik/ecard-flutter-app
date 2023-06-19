FROM ubuntu:latest

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y && \
  apt-get upgrade -y

# Install basics
RUN apt-get install -y --no-install-recommends \
  git \
  wget \
  curl \
  zip \
  unzip \
  apt-transport-https \
  ca-certificates \
  gnupg \
  adb \
  nano


# Add repo for chrome stable
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | \
    tee /etc/apt/sources.list.d/google-chrome.list

# Add repo for gcloud sdk and install it
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

RUN apt-get update && apt-get install -y google-cloud-sdk && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true

# Add repo for OpenJDK from JFrog.io
RUN wget -q -O - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN echo 'deb [arch=amd64] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb bullseye main' | \
    tee /etc/apt/sources.list.d/adoptopenjdk.list

# Install the dependencies needed for the rest of the build.
RUN apt-get update && apt-get install -y --no-install-recommends \
  adoptopenjdk-11-hotspot \
  build-essential \
  default-jdk-headless \
  gcc \
  google-chrome-stable \
  lib32stdc++6 \
  libglu1-mesa \
  libstdc++6 \
  locales \
  nodejs \
  npm \
  ruby \
  ruby-dev && \
  apt-get clean

ENV JAVA_HOME="/usr/lib/jvm/adoptopenjdk-11-hotspot-amd64"

# Install the Android SDK Dependency.
# In the event of an update you can visit this page: https://developer.android.com/studio and scroll to the bottom to find
# the latest version to update. Be wary of any changes to the name of the package as you will need to adjust the paths below.
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
ENV ANDROID_TOOLS_ROOT="/opt/android_sdk"
RUN mkdir -p "${ANDROID_TOOLS_ROOT}"
RUN mkdir -p ~/.android

# Silence warning.
RUN touch ~/.android/repositories.cfg
ENV ANDROID_SDK_ARCHIVE="${ANDROID_TOOLS_ROOT}/archive"
RUN wget --progress=dot:giga "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}"
RUN unzip -q -d "${ANDROID_TOOLS_ROOT}" "${ANDROID_SDK_ARCHIVE}"

RUN mkdir "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest"

RUN mv "${ANDROID_TOOLS_ROOT}/cmdline-tools/NOTICE.txt" "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest"
RUN mv "${ANDROID_TOOLS_ROOT}/cmdline-tools/bin" "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest"
RUN mv "${ANDROID_TOOLS_ROOT}/cmdline-tools/lib" "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest"
RUN mv "${ANDROID_TOOLS_ROOT}/cmdline-tools/source.properties" "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest"

# Suppressing output of sdkmanager to keep log size down
# (it prints install progress WAY too often).

RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" "build-tools;30.0.3" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" "platforms;android-33" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" "platform-tools" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" "extras;android;m2repository" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" "extras;google;m2repository" > /dev/null
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" "patcher;v4" > /dev/null

RUN rm "${ANDROID_SDK_ARCHIVE}"

ENV ANDROID_SDK_ROOT=/opt/android_sdk/

ENV PATH="${ANDROID_TOOLS_ROOT}/cmdline-tools/latest:${PATH}"
ENV PATH="${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin:${PATH}"

ENV PATH="${ANDROID_TOOLS_ROOT}/tools:${PATH}"
ENV PATH="${ANDROID_TOOLS_ROOT}/tools/bin:${PATH}"

ENV PATH="${ANDROID_TOOLS_ROOT}/buid-tools:${PATH}"
ENV PATH="${ANDROID_TOOLS_ROOT}/platform-tools:${PATH}"
ENV PATH="${ANDROID_TOOLS_ROOT}/platforms:${PATH}"
ENV PATH="${ANDROID_TOOLS_ROOT}/patcher:${PATH}"
ENV PATH="${ANDROID_TOOLS_ROOT}/emulators/bin64:${PATH}"


# Silence warnings when accepting android licenses.
RUN mkdir -p ~/.android
RUN touch ~/.android/repositories.cfg

# Add npm to path.
ENV PATH="/usr/bin:${PATH}"

# Set locale to en_US
RUN locale-gen en_US "en_US.UTF-8" && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
ENV LANG en_US.UTF-8

# Install dependencies for desktop flutter run
RUN apt-get install -y --no-install-recommends \
  clang \
  cmake \
  libgtk-3-dev \
  ninja-build \
	pkg-config \
	x11-xserver-utils \
	xauth \
	xvfb && \
  apt-get upgrade -y --no-install-recommends && \
  apt-get clean

# Install flutter SDK
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.5-stable.tar.xz && \
  tar xf flutter_linux_3.10.5-stable.tar.xz && \
  rm flutter_linux_3.10.5-stable.tar.xz


# Setting ENV Path
ENV PATH="/flutter/bin:${PATH}"

RUN export ANDROID_SDK_ROOT

RUN  git config --global --add safe.directory '*'

# Updating Flutter and Validating
RUN flutter upgrade
RUN flutter doctor

# Accepting License
RUN yes "y" | "${ANDROID_TOOLS_ROOT}/cmdline-tools/latest/bin/sdkmanager" --licenses

# Copying Project 
COPY . /app

# Setting ENV variable for IP Address
ENV PHONE_IP_ADDRESS=<phone_ip_address>

# Shell Script for running App
RUN chmod +x /app/docker_main.sh
ENTRYPOINT ["/app/docker_main.sh"]
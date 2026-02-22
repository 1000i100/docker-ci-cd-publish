FROM debian:bookworm-slim

LABEL maintainer="[1000i100] Millicent Billette <git@1000i100.fr>"

# Flutter version (stable par défaut)
ARG FLUTTER_VERSION=stable

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# ============================================================
# System packages (one layer, sorted by purpose)
# ============================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Core tools
    bash curl wget git git-lfs openssh-client ca-certificates gnupg \
    rsync lftp tar zip unzip xz-utils jq \
    # Build essentials
    build-essential pkg-config \
    # Flutter Linux desktop deps
    clang cmake ninja-build lld \
    libgtk-3-dev libsecret-1-dev libjsoncpp-dev libcurl4-openssl-dev \
    # Java (Android SDK + Kotlin)
    openjdk-17-jdk-headless \
    # Python
    python3 python3-pip python3-venv pipx \
    # Browser testing
    chromium firefox-esr xvfb dbus \
    fontconfig libfreetype6 fonts-freefont-ttf \
    # Coverage
    lcov \
    && rm -rf /var/lib/apt/lists/*

# ============================================================
# Bun
# ============================================================
RUN curl -fsSL https://bun.sh/install | bash
ENV BUN_INSTALL="/root/.bun"
ENV PATH="$BUN_INSTALL/bin:$PATH"

# ============================================================
# Node.js (LTS)
# ============================================================
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# JS global tools
RUN bun install -g vitest jest @vitest/browser playwright nuekit
# ============================================================
# Flutter + Dart
# ============================================================
ENV FLUTTER_HOME=/opt/flutter
RUN git clone -b $FLUTTER_VERSION --depth 1 https://github.com/flutter/flutter.git $FLUTTER_HOME \
    && git config --global --add safe.directory $FLUTTER_HOME
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:/root/.pub-cache/bin:$PATH"
RUN flutter precache --android --web --linux \
    && flutter config --no-analytics \
    && dart --disable-analytics

# ============================================================
# Android SDK
# ============================================================
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && cd /tmp \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip -O cmdline-tools.zip \
    && unzip -q cmdline-tools.zip \
    && mv cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && rm cmdline-tools.zip
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
# Installer les dernières versions disponibles des outils Android
RUN yes | sdkmanager --licenses > /dev/null 2>&1 \
    && sdkmanager --list 2>/dev/null | head -80 \
    && LATEST_ANDROID_PLATFORM=$(sdkmanager --list 2>/dev/null | sed -n 's/^ *\(platforms;android-[^ ]*\).*/\1/p' | tail -1) \
    && LATEST_ANDROID_BUILD_TOOLS=$(sdkmanager --list 2>/dev/null | sed -n 's/^ *\(build-tools;[^ ]*\).*/\1/p' | tail -1) \
    && echo "Installation de la plateforme Android: ${LATEST_ANDROID_PLATFORM}" \
    && echo "Installation des build-tools Android: ${LATEST_ANDROID_BUILD_TOOLS}" \
    && sdkmanager \
    "platform-tools" \
    "${LATEST_ANDROID_PLATFORM}" \
    "${LATEST_ANDROID_BUILD_TOOLS}"

# ============================================================
# Rust
# ============================================================
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# ============================================================
# Kotlin (standalone compiler) - dernière version disponible
# ============================================================
ENV KOTLIN_HOME=/opt/kotlin
RUN cd /tmp \
    && KOTLIN_LATEST=$(curl -s https://api.github.com/repos/JetBrains/kotlin/releases/latest | jq -r .tag_name | sed 's/v//') \
    && echo "Installation de Kotlin version ${KOTLIN_LATEST}" \
    && wget -q https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_LATEST}/kotlin-compiler-${KOTLIN_LATEST}.zip -O kotlin.zip \
    && unzip -q kotlin.zip -d /opt \
    && mv /opt/kotlinc $KOTLIN_HOME \
    && rm kotlin.zip
ENV PATH="$KOTLIN_HOME/bin:$PATH"

# ============================================================
# Godot (headless, for CI export) - dernière version stable disponible
# ============================================================
RUN cd /tmp \
    && GODOT_LATEST=$(curl -s https://api.github.com/repos/godotengine/godot/releases/latest | jq -r .tag_name | sed 's/^v//' | sed 's/-stable$//') \
    && echo "Installation de Godot version ${GODOT_LATEST}" \
    && wget -q https://github.com/godotengine/godot/releases/download/${GODOT_LATEST}-stable/Godot_v${GODOT_LATEST}-stable_linux.x86_64.zip -O godot.zip \
    && unzip -q godot.zip \
    && mv Godot_v${GODOT_LATEST}-stable_linux.x86_64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm godot.zip

# ============================================================
# Python (pipx ready, no --break-system-packages needed)
# ============================================================
RUN pipx ensurepath

# ============================================================
# Browser / display config
# ============================================================
ENV PLAYWRIGHT_BROWSERS_PATH=/usr/bin
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV DISPLAY=:99

# ============================================================
# Warmup caches (Dart / Flutter)
# ============================================================
RUN yes | flutter doctor --android-licenses \
    && flutter doctor -v \
    && flutter create /tmp/dummy_project \
    && cd /tmp/dummy_project \
    && flutter pub get \
    && cd / \
    && rm -rf /tmp/dummy_project

# ============================================================
# Sanity check
# ============================================================
RUN echo "=== Versions ===" \
    && flutter --version \
    && dart --version \
    && java -version \
    && rustc --version \
    && kotlin -version \
    && python3 --version \
    && node --version \
    && bun --version \
    && godot --version --headless \
    && echo "=== OK ==="

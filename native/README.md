## OC JNLua Natives

## Building natives on your platform

    $ meson setup build -Dbuildtype=release -Db_lto=true
    $ cd build
    $ meson compile

## Reproducible release builds

The supported release path is the public `Build native libraries` GitHub
Actions workflow. It builds the native libraries on hosted Linux, Windows,
macOS, and FreeBSD environments, publishes the exact resulting JAR as a
workflow artifact, and writes a SHA-256 checksum alongside it.

The workflow does not consume the historical `jdk-jni-deps.tar.xz` bundle.
It uses the JDK installed on each build host for JNI headers. This preserves a
reviewable source-to-artifact chain and avoids treating a prebuilt JNI bundle
as a build input of unknown provenance.

### OC-Eris source provenance

The native sources are the pinned `PC-Logix/OC-Eris` submodules in this
repository: Lua 5.2 uses `master`, Lua 5.3 uses `master-lua5.3`, and Lua 5.4
uses `master-lua5.4`. Git records the exact commit for every native release;
the workflow compiles those commits and publishes a SHA-256 checksum beside
the JAR for consumers to verify before embedding it.

## Legacy all-target local build

The historical script below uses a preassembled JNI dependency archive and is
kept only for compatibility. Do not use it for a release intended to provide
auditable source-to-binary provenance; use the GitHub Actions workflow above.

1. Install mingw-w64 (for both i686 and x86_64), Meson, Zig.
2. Download and unpack [jdk-jni-deps.tar.xz](https://asie.pl/files/jdk-jni-deps.tar.xz). The archive contains about 100MB of JNI library dependencies, which are too big to store in a Git repository and don't exactly need versioning.
3. Run `./build-all.sh`.

## Troubleshooting

### linux-armhf fails to compile (library 'm' not found)

See [ziglang/#3287](https://github.com/ziglang/zig/issues/3287#issuecomment-1038914646) for workaround.

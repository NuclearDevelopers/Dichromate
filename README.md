# Archival Notice 

+ This verison of Dichromate was archived in 2023, and the project has been continued [here](https://github.com/Dichromate-Browser/Dichromate) 

# Dichromate

![Dichromate Logo](https://github.com/NuclearDevelopers/Dichromate/raw/main/Icons/product_logo_256.png)

Dichromate is a privacy and security hardened Chromium fork. It is based on the now discontinued [Hexavalent](https://github.com/Hexavalent-Browser/Hexavalent).

We follow the Chrome release schedule, and we try to release a newer build within 1-2 days of a stable release of Chrome.

Dichromate targets only Windows when developing patches and creating releases. It can be compiled for other platforms, but will not have all of the security features.

# Build from source

Click [here](https://github.com/NuclearDevelopers/Dichromate/blob/main/docs/Building.md) for build instructions.

# How is Dichromate different from Chromium?

Dichromate has a number of additional security and privacy features compared to Chromium.

This is a list of some of them: 

+ Windows Sandbox integration
+ The GPU and Renderer processes run in the Windows AppContainer
+ Browser dynamic code is disabled, and is enforced by ACG
+ Flag to disable V8's JIT compiler for Javascript
+ Flag to disable reading from the HTML5 canvas
+ HTTPS-only mode is the default
+ WebRTC hardening
+ Compiled with -fstack-protector-strong, -fwrapv, -ftrivial-auto-var-init=zero, and CFI
+ Disabled basic Google services such as Safe Browsing, browser sign in, and crash reporting
+ Partitioned Cookies enabled by default 

# Contributing

Anyone is welcome to contribute to Dichromate, just make sure that the branding patch is always the last one in the list. This makes it easier when porting patches to a newer release.

# Things to keep in mind

Although our releases are usually on time, Dichromate is a hobbyist project, and we cannot guarantee that releases are timely.

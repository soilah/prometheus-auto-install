# Prometheus Installation Script for Debian. Tested on Debian 12 (Bookworm)

**Important:** This is a fork of a project i found to be useful for auto installing and configuring prometheus suit programs. I want to expand it to have a nicer output, remove deprecated functions, add some important checks and add some more features... in time.

*Important:* These scripts need **root** privileges in order to run, because they involve user creation, changing permissions, manupulating systemd and others.

### To Do
- [x] Recreate full installation/unistall scripts (blackbox pending).
- [ ] Add functionality to allow arguments for scipts (such as custom port, config directories etc.)
- [ ] Recreate blackbox exporter scripts.
- [ ] Add optional installation for `mqtt2prometheus`, `json_exporter`.
- [ ] Add support for Raspberry pi (arm64)

# How to Use This?
Whether you are using this to install individual components or the full app, it is best to start scripts from the cloned repository. If you copy scripts anywhere else, the behaviour of the scripts is not guaranteed. **Note that these scripts will add Prometheus and other utilities to systemd as services, and enable the by default**.

## Full Installation
Full intallation is currently a work in progress. Until now all services except blackbox exporter has been included in the new, updated full installation script.

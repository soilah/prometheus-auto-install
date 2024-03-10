# Prometheus Installation Script for Debian. Tested on Debian 12 (Bookworm)

**Important:** This is a fork of a project i found to be useful for auto installing and configuring prometheus suit programs. I want to expand it to have a nicer output, remove deprecated functions, add some important checks and add some more features... in time.

*Important:* These scripts need **root** privileges in order to run, because they involve user creation, changing permissions, manupulating systemd and others.

### To Do
- [ ] Write uninstallation scripts (both full uninstall and uninstallation of individual components)
- [ ] Add optional installation for `mqtt2prometheus`, `json_exporter`

# How to Use This?
Whether you are using this to install individual components or the full app, it is best to start scripts from the cloned repository. If you copy scripts anywhere else, the behaviour of the scripts is not guaranteed. **Note that these scripts will add Prometheus and other utilities to systemd as services, and enable the by default**.

## Full Installation
Full intallation is currently a work in progress and has not been changed from the previous version. Currently all effort is focused in individual services.

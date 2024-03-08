# Prometheus Installation Script for Debian. Tested on Debian 12 (Bookworm)

**Important:** This is a fork of a project i found to be useful for auto installing and configuring prometheus suit programs. I want to expand it to have a nicer output, remove deprecated functions and add some more features... in time.

*Important:* These scripts need **root** privileges in order to run, because they involve user creation, changing permissions, manupulating systemd and others.

More about it here: [gist](https://gist.github.com/petarGitNik/18ae938aaef4c4ff58189df8a4fc7de9).

This script downloads the files in the current directory. You could change this.

### To Do
- [ ] Write uninstallation scripts (both full uninstall and uninstallation of individual components)
- [ ] Add optional installation for `mysqld_exporter` and `postgresql_exporter`

# How to Use This?
Whether you are using this to install individual components or the full app, it is best to start scripts from the cloned repository. If you copy scripts anywhere else, the behaviour of the scripts is not guaranteed. **Note that these scripts will add Prometheus and other utilities to systemd as services, and enable the by default**.

## Full Installation
Full installation will install the following:

* Prometheus
* Alertmanager
* Node Exporter
* Blackbox Exporter
* Grafana

To install individual components, use:
* Prometheus: `./prometheus.sh`
* Alertmanager: `./alertmanager.sh`
* Node Exporter: `./node.sh`
* Blackbox Exporter: `./blackbox.sh`
* Grafana: `./grafana.sh`

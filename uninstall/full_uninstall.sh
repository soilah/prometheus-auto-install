#!/bin/bash

source ./utils.sh

check_root

new "#######################"
new "UNINSTALLING PROMETHEUS"
new "#######################"
./uninstall/prometheus_uninstall.sh
new "##########################"
new "UNINSTALLING NODE EXPORTER"
new "##########################"
./uninstall/node_uninstall.sh
new "#########################"
new "UNINSTALLING ALERTMANAGER"
new "#########################"
./uninstall/alertmanager_uninstall.sh
new "####################"
new "UNINSTALLING GRAFANA"
new "####################"
./uninstall/grafana_uninstall.sh
ok "DONE UNINSTALLING PROMETHEUS SUITE."

#./blackbox_uninstall.sh


#!/bin/bash

source ./utils.sh


new "#####################"
new "INSTALLING PROMETHEUS"
new "#####################"
./prometheus.sh
new "########################"
new "INSTALLING NODE EXPORTER"
new "########################"
./node.sh
new "#######################"
new "INSTALLING ALERTMANAGER"
new "#######################"
./alertmanager.sh
new "##################"
new "INSTALLING GRAFANA"
new "##################"
./grafana.sh
#./blackbox.sh

ok "PROMETHEUS SUITE INSTALLED SUCESSFULLY."

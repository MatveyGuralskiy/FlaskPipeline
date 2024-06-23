#!/bin/bash
#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

#-------------Grafana----------------

# Get the IP address of the machine
PROMETHEUS_IP="PRIVATE_IP_PROMETHEUS"
PROMETHEUS_URL="http://${PROMETHEUS_IP}:9090"

apt-get install -y apt-transport-https software-properties-common wget
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install -y adduser libfontconfig1 musl

wget https://dl.grafana.com/oss/release/grafana_10.4.2_amd64.deb
dpkg -i grafana_10.4.2_amd64.deb

echo "export PATH=/usr/share/grafana/bin:$PATH" >> /etc/profile

cat <<EOF> /etc/grafana/provisioning/datasources/prometheus.yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    url: ${PROMETHEUS_URL}
EOF

# Restart Grafana
systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server

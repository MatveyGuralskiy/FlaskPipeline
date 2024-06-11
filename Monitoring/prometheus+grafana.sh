#!/bin/bash
#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------
#-------------Prometheus Installation----------------
PROMETHEUS_VERSION="2.51.1"
PROMETHEUS_FOLDER_CONFIG="/etc/prometheus"
PROMETHEUS_FOLDER_TSDATA="/etc/prometheus/data"

cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
tar xvfz prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
cd prometheus-$PROMETHEUS_VERSION.linux-amd64

mv prometheus /usr/bin/
rm -r NOTICE
rm -r LICENSE
rm -r promtool
rm -rf /tmp/prometheus*

mkdir -p $PROMETHEUS_FOLDER_CONFIG
mkdir -p $PROMETHEUS_FOLDER_TSDATA

cat <<EOF> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name      : "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
EOF

# Create Prometheus User
useradd -rs /bin/false prometheus

# Set Ownership to files
chown prometheus:prometheus /usr/bin/prometheus
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
chown prometheus:prometheus $PROMETHEUS_FOLDER_TSDATA

# Create Systemctl Service to Prometheus
cat <<EOF> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
ExecStart=/usr/bin/prometheus \
  --config.file       ${PROMETHEUS_FOLDER_CONFIG}/prometheus.yml \
  --storage.tsdb.path ${PROMETHEUS_FOLDER_TSDATA}

[Install]
WantedBy=multi-user.target
EOF

# Restart Prometheus service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus


#-------------Grafana----------------
GRAFANA_VERSION="10.4.2"

# Get the IP address of the machine
HOST_IP=$(hostname -I | awk '{print $1}')
PROMETHEUS_URL="http://${HOST_IP}:9090"

apt-get install -y apt-transport-https software-properties-common wget
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install -y adduser libfontconfig1 musl

wget https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_amd64.deb
dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb

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
#!/bin/bash
#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

#-----------------Prometheus--------------------
apt-get update
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.51.1/prometheus-2.51.1.linux-amd64.tar.gz
tar xvfz prometheus-2.51.1.linux-amd64.tar.gz
cd prometheus-2.51.1.linux-amd64

mv prometheus /usr/bin/
rm -r NOTICE
rm -r LICENSE
rm -r promtool
rm -rf /tmp/prometheus*

mkdir -p /etc/prometheus
mkdir -p /etc/prometheus/data

cat <<EOF> /etc/prometheus/prometheus.yml
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
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /etc/prometheus/prometheus.yml
chown prometheus:prometheus /etc/prometheus/data

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
  --config.file       /etc/prometheus/prometheus.yml \
  --storage.tsdb.path /etc/prometheus/data

[Install]
WantedBy=multi-user.target
EOF

# Restart Prometheus service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
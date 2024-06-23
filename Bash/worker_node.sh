MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
#---------------------------
#FlaskPipeline Project
#Created by Matvey Guralskiy
#---------------------------

cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.7.0.linux-amd64.tar.gz
cd node_exporter-1.7.0.linux-amd64

mv node_exporter /usr/bin/
rm -rf /tmp/node_exporter*

useradd -rs /bin/false node_exporter
chown node_exporter:node_exporter /usr/bin/node_exporter


cat <<EOF> /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
EOF

# SSH Public Key
mkdir -p /home/ec2-user/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3K5Cr...Q6ec+myemail@example.com" >> /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/authorized_keys

--==MYBOUNDARY==--
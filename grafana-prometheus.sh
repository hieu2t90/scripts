#!/bin/bash

# Cài đặt Grafana
wget https://dl.grafana.com/oss/release/grafana_8.2.2_amd64.deb
sudo dpkg -i grafana_8.2.2_amd64.deb
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Cài đặt Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.32.0/prometheus-2.32.0.linux-amd64.tar.gz
tar -xvf prometheus-2.32.0.linux-amd64.tar.gz
sudo mv prometheus-2.32.0.linux-amd64 /etc/prometheus
sudo cp /etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml.bak
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval:     15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
EOF

sudo systemctl start prometheus
sudo systemctl enable prometheus

# Tích hợp datasource Prometheus vào Grafana
sudo tee /etc/grafana/provisioning/datasources/prometheus.yml > /dev/null <<EOF
apiVersion: 1
datasources:
- name: Prometheus
  type: prometheus
  access: proxy
  url: http://localhost:9090
  isDefault: true
EOF

sudo systemctl restart grafana-server

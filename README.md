# liquidctl [Prometheus][2] exporter

Collects metrics from [liquidctl][1] supported devices and presents them for scraping

Example [Grafana][4] dashboard

![image info](./example.png)

## Usage

### Requirements:

- [liquidctl][1] is installed with support of JSON output (v1.6.x+)
- Golang if building on the same system

### Build and installation on Linux:

```shell
# Clone the repository
git clone https://github.com/paha/liquidctl-exporter
cd liquidctl-exporter
# Build
go build ./liquidctl-exporter.go
# Install
sudo cp ./liquidctl-exporter /usr/local/bin
# Setup systemd service
sudo cat << SERVICE > /etc/systemd/system/liquidctl-exporter.service
[Unit]
Description=Liquidctl prometheus exporter
[Service]
ExecStart=/usr/local/bin/liquidctl-exporter
[Install]
WantedBy=default.target
SERVICE
systemctl daemon-reload
systemctl enable liquidctl-exporter
systemctl start liquidctl-exporter
```

### Validation

```shell
# service status
systemctl status liquidctl-exporter
# service logs
journalctl -u liquidctl-exporter
# Preview exposed metrics
curl http://localhost:9530/metrics | grep liquidctl
```

### Configuration

Prometheus exporter _port_, update _interval_ and _path_ to `liquidctl` can be set via environment variables:

| Variable                      | Description                              |                    Default |
| :---------------------------- | :--------------------------------------- | -------------------------: |
| `LIQUIDCTL_EXPORTER_PORT`     | Exporter port. RE: [port allocations][3] |                       9530 |
| `LIQUIDCTL_EXPORTER_INTERVAL` | Update interval                          |                 10 seconds |
| `LIQUIDCTL_EXPORTER_PATH`     | Path to `liquidctl`                      | `/usr/local/bin/liquidctl` |

### Windows and MacOS support

Should work on Windows and MacOS as long as the proper path to the liquidctl executable is set. _Not tested on either Windows or Mac however._

### Docker container

The repository also contains a Dockerfile for building a container image. The image is not yet published to a registry but can be build locally using the following docker compose file:

```shell
version: "3.8"

services:
  liquidctl-exporter:
    build:
      context: ./exporters/liquidctl-exporter
    image: liquidctl-exporter
    container_name: liquidctl-exporter
    ports:
      - "9530:9530"
    privileged: true
    restart: unless-stopped
    network_mode: host
```

> [!NOTE]\
> The container needs to be run in privileged mode to access the USB devices.

## Examples

Metrics exposed with a single Corsair HX1200I device:

```shell
# HELP liquidctl_12v_output_current Corsair HX1200i +12V output current (A).
# TYPE liquidctl_12v_output_current gauge
liquidctl_12v_output_current{device="hidraw4"} 4
# HELP liquidctl_12v_output_power Corsair HX1200i +12V output power (W).
# TYPE liquidctl_12v_output_power gauge
liquidctl_12v_output_power{device="hidraw4"} 48
# HELP liquidctl_12v_output_voltage Corsair HX1200i +12V output voltage (V).
# TYPE liquidctl_12v_output_voltage gauge
liquidctl_12v_output_voltage{device="hidraw4"} 12.093
# HELP liquidctl_33v_output_current Corsair HX1200i +3.3V output current (A).
# TYPE liquidctl_33v_output_current gauge
liquidctl_33v_output_current{device="hidraw4"} 3.5620000000000003
# HELP liquidctl_33v_output_power Corsair HX1200i +3.3V output power (W).
# TYPE liquidctl_33v_output_power gauge
liquidctl_33v_output_power{device="hidraw4"} 11
# HELP liquidctl_33v_output_voltage Corsair HX1200i +3.3V output voltage (V).
# TYPE liquidctl_33v_output_voltage gauge
liquidctl_33v_output_voltage{device="hidraw4"} 3.265
# HELP liquidctl_5v_output_current Corsair HX1200i +5V output current (A).
# TYPE liquidctl_5v_output_current gauge
liquidctl_5v_output_current{device="hidraw4"} 2.125
# HELP liquidctl_5v_output_power Corsair HX1200i +5V output power (W).
# TYPE liquidctl_5v_output_power gauge
liquidctl_5v_output_power{device="hidraw4"} 10.5
# HELP liquidctl_5v_output_voltage Corsair HX1200i +5V output voltage (V).
# TYPE liquidctl_5v_output_voltage gauge
liquidctl_5v_output_voltage{device="hidraw4"} 4.953
# HELP liquidctl_case_temperature Corsair HX1200i Case temperature (°C).
# TYPE liquidctl_case_temperature gauge
liquidctl_case_temperature{device="hidraw4"} 39.75
# HELP liquidctl_estimated_efficiency Corsair HX1200i Estimated efficiency (%).
# TYPE liquidctl_estimated_efficiency gauge
liquidctl_estimated_efficiency{device="hidraw4"} 81
# HELP liquidctl_estimated_input_power Corsair HX1200i Estimated input power (W).
# TYPE liquidctl_estimated_input_power gauge
liquidctl_estimated_input_power{device="hidraw4"} 84
# HELP liquidctl_fan_speed Corsair HX1200i Fan speed (rpm).
# TYPE liquidctl_fan_speed gauge
liquidctl_fan_speed{device="hidraw4"} 0
# HELP liquidctl_input_voltage Corsair HX1200i Input voltage (V).
# TYPE liquidctl_input_voltage gauge
liquidctl_input_voltage{device="hidraw4"} 230
# HELP liquidctl_total_power_output Corsair HX1200i Total power output (W).
# TYPE liquidctl_total_power_output gauge
liquidctl_total_power_output{device="hidraw4"} 68
# HELP liquidctl_vrm_temperature Corsair HX1200i VRM temperature (°C).
# TYPE liquidctl_vrm_temperature gauge
liquidctl_vrm_temperature{device="hidraw4"} 52
```

---

### TODO

- Releases, CI, container images hosting
- test on Windows and MacOS

---

[1]: https://github.com/liquidctl/liquidctl
[2]: https://prometheus.io/
[3]: https://github.com/prometheus/prometheus/wiki/Default-port-allocations
[4]: https://grafana.com/

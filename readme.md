# Hetzner Storage Exporter

This is a simple prometheus exporter to provide storage space metrics of a Hetzner Storagebox.

# Example

The exporter will start a webserver on port 80 (no HTTPS/TLS) and provide its metrics under every URI. The exporter checks the storage box under a given `USERNAME`.
A SSH private key to login via SSH has to be provided and SSH has to be enabled in Hetzner Robot.

Here you can see an example output of the hetzner-storage-exporter:

```
# HELP hetzner_storage_available Available storage
# TYPE hetzner_storage_available gauge
# HELP hetzner_storage_used Used storage
# TYPE hetzner_storage_used gauge
# HELP hetzner_storage_total Total storage
# TYPE hetzner_storage_total gauge
hetzner_storage_available{host="u123456.your-storagebox.de"} 1062381134
hetzner_storage_used{host="u123456.your-storagebox.de"} 11360690
hetzner_storage_total{host="u123456.your-storagebox.de"} 1073741824
```

# Build

Build simply with docker:

```bash
docker build .
```

Build with Compose:

```bash
docker-compose build
```

**Note:** this will build an image called `registry.gmasil.de/docker/hetzner-storage-exporter`, this is my own docker registry.

# Usage

You can use the image I uploaded to my docker registry, if you want to use your own build just replace the image name accordingly.

The exporter will **listen** on **port 80** and exposes it by default.

You have to provide your username for your storage box via environment variable `USERNAME` and a SSH private key to login.
Additionally you need a `known_hosts` file to accept the SSH connection.

Usage with docker:

```bash
docker run -p 80:80 -e "USERNAME=u123456" -v "$(cd ~ && pwd)/.ssh:/root/.ssh" registry.gmasil.de/docker/hetzner-storage-exporter:1.0
```

Example docker-compose file:

```bash
version: '3'

services:
  hetzner-storage-exporter:
    image: registry.gmasil.de/docker/hetzner-storage-exporter:1.0
    environment:
      - "USERNAME=u123456"
    volumes:
      - "/home/peter/.ssh:/root/.ssh"
```

## Prometheus

In your `prometheus.yml` you can add the hetzner-storage-exporter like this:

```yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "hetznerstorage"
    static_configs:
      - targets:
          - hetzner-storage-exporter:80
```

**Note:** As the exporter will provide the metrics on all URIs, you can leave all defaults like scraping on the `/metrics` URI.

## License

[GNU GPL v3 License](LICENSE.md)

Hetzner Storage Exporter is free software: you can redistribute it and/or modify  
it under the terms of the GNU General Public License as published by  
the Free Software Foundation, either version 3 of the License, or  
(at your option) any later version.

Hetzner Storage Exporter is distributed in the hope that it will be useful,  
but WITHOUT ANY WARRANTY; without even the implied warranty of  
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the  
GNU General Public License for more details.

## About

Script for updating MaxMing GeoIP2 databases (free and paid)

### Usage

#### Shell

```shell
export GEOIP_EDITION=GeoLite-Country
export GEOIP_LICENSE_KEY=a1b2c3d4e5f6
export GEOIP_OUT_PATH=/geoip-data
sh update.sh
```

#### Docker

1. Copy `.env.example` to `.env` and edit it
2. Build

    ```shell
    docker build -t geoupdate .
    ```

3. Run

    ```shell
    docker run --rm --env-file .env -v geoip-data:/geoip-data geoupdate
    ```

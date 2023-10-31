####################
## Build the binary ##
####################
FROM golang:1.21.3-bullseye AS build

COPY . /node_exporter
WORKDIR /node_exporter

RUN go build ./liquidctl-exporter.go

######################
## Create final image ##
######################
FROM python:3.10-slim-bookworm AS final

RUN apt-get update && apt-get install -y  \
    build-essential \
    libusb-1.0-0-dev  \
    && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install --upgrade pip && pip install liquidctl

ENV LIQUIDCTL_EXPORTER_PATH=/opt/venv/bin/liquidctl

COPY --from=build /node_exporter/liquidctl-exporter /liquidctl-exporter

ENTRYPOINT [ "./liquidctl-exporter" ]

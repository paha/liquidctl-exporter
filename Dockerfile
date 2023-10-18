FROM golang:1.21.3-bullseye

RUN apt-get update && apt-get install -y  \
    build-essential \
    libusb-1.0-0-dev  \
    python3-venv  \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install liquidctl.
RUN pip install --upgrade pip && pip install liquidctl

# Set liquidctl path.
ENV LIQUIDCTL_EXPORTER_PATH=/opt/venv/bin/liquidctl

# Copy the exporter code to the container.
COPY . /node_exporter
WORKDIR /node_exporter

# Build the exporter.
RUN go build ./liquidctl-exporter.go

# Run the exporter.
ENTRYPOINT [ "./liquidctl-exporter" ]

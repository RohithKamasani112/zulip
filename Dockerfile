# Use an official Python base image
FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off

RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libpq-dev \
    libssl-dev \
    libjpeg-dev \
    zlib1g-dev \
    git \
    curl \
    locales \
    sudo \
    ca-certificates \
    nodejs \
    npm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up UTF-8 locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8

# Create zulip user and give passwordless sudo
RUN useradd -ms /bin/bash zulip && echo "zulip ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /zulip

COPY . /zulip

# Make zulip the owner of the directory
RUN chown -R zulip:zulip /zulip

# Upgrade pip and setuptools as root first
RUN pip install --upgrade pip setuptools

# Switch to zulip user for provisioning and running
USER zulip

# Provision Zulip (this script installs all dependencies)
RUN ./tools/provision

EXPOSE 8000

CMD ["tools/run-dev.py"]

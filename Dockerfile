# Use an official Python base image
FROM python:3.10-slim

# Set environment variables to prevent prompt during install
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off

# Install system dependencies required by Zulip
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up UTF-8 locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Set work directory
WORKDIR /zulip

# Copy Zulip code to container
COPY . /zulip

# Install Python dependencies using pyproject.toml/requirements
RUN pip install --upgrade pip
RUN pip install .

# Provision Zulip (installs JS, builds assets, etc.)
RUN ./tools/provision

# Expose default Zulip port
EXPOSE 8000

# Set Zulip's entrypoint (for dev, adjust for prod if needed)
CMD ["tools/run-dev.py"]

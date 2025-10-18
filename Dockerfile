FROM python:3.10-slim

WORKDIR /zulip

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libpq-dev \
    libssl-dev \
    libjpeg-dev \
    zlib1g-dev \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy code
COPY . /zulip

# Install Python requirements
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

EXPOSE 8000

# Start Zulip (this may need to be adjusted for your needs)
CMD ["tools/run-dev.py"]

# libpostal Docker Image

A minimal Docker image containing the [libpostal](https://github.com/openvenues/libpostal) library.

## Features

- Based on Alpine Linux for alpine-based workflows, 
  and Debian Bookworm slim for slim-based workflows
- Multi-stage build for optimized final image size
- Contains all necessary libpostal components:
  - Shared libraries (`libpostal.so*`)
  - Data files in `/usr/local/share/libpostal`
  - Header files in `/usr/local/include/libpostal`
  - Binary file: `/usr/local/bin/libpostal_data`

## Usage as Base Image for Python Applications

You can use this image as a base for your Python applications that require the [`postal`](https://github.com/openvenues/pypostal) package. Here's how to set it up:

```dockerfile
# Use an official Python runtime as a parent image
FROM python:3.9-alpine  # or python:3.9-slim

# Install system dependencies required to build the postal wheel
RUN apk add --no-cache \
    build-base

# Copy libpostal files from the libpostal:alpine image (or libpostal:slim for a slim-based Python images)
COPY --from=ghcr.io/clementmangin/libpostal:alpine /usr/local/lib/libpostal.so* /usr/local/lib/
COPY --from=ghcr.io/clementmangin/libpostal:alpine /usr/local/share/libpostal /usr/local/share/libpostal
COPY --from=ghcr.io/clementmangin/libpostal:alpine /usr/local/include/libpostal /usr/local/include/libpostal

# Install Python dependencies
RUN pip install postal

# Your application code here
COPY . /app
WORKDIR /app

# Run your application
CMD ["python", "your_script.py"]
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

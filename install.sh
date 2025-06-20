#!/bin/bash
echo "Building the full Windows Developer Docker image..."
docker build -t windows-devbox .
echo ""
echo "To run the container:"
echo "docker run -it --isolation=process windows-devbox"
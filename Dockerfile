# Build base image with: docker build -t hpnofp-base -f Dockerfile.base .
# Compile this image with: docker build -t hpnofp .
# Run this image with: docker run --rm --name hpnofp-run hpnofp
# Copy the output with: docker cp hpnofp-run:/opt/book/book1-target/book1.pdf .
#                       docker cp hpnofp-run:/opt/book/book1-target/book2.pdf .
#                       docker cp hpnofp-run:/opt/book/book1-target/book3.pdf .

FROM hpnofp-base:latest

WORKDIR "/opt/book"

# Copy source files
COPY . .

# Compile book
RUN chmod +x ./build_book.sh && \
    ./build_book.sh "book1" && \
    ./build_book.sh "book2" && \
    ./build_book.sh "book3"

ENTRYPOINT ["/bin/bash"]

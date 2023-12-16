#!/bin/bash
rm -f book1.pdf book2.pdf book3.pdf
docker build -t hpnofp .
docker run --name hpnofp-run hpnofp
docker cp hpnofp-run:/opt/book/book1-target/book1.pdf .
docker cp hpnofp-run:/opt/book/book2-target/book2.pdf .
docker cp hpnofp-run:/opt/book/book3-target/book3.pdf .
docker container rm hpnofp-run

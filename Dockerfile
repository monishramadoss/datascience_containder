FROM ubuntu:18.04
ENV SHELL="/bin/bash"
WORKDIR /root
RUN apt-get update && apt-get install upgrade

ARG PYTHON=python3
ARG USE_PYTHON_3_NOT_2
ARG _PY_SUFFIX=3

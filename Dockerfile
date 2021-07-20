FROM continuumio/miniconda3

RUN apt-get update && apt-get install -y \
    aufs-tools \
    automake \
    build-essential \
    curl \
    dpkg-sig \
    libcap-dev \
    libsqlite3-dev \
    mercurial \
    reprepro \
    gcc \    
 && rm -rf /var/lib/apt/lists/*




ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 driver>=450"

# Pytorch manylinux-cuda113:latest
# ADD file:4f10ffca52683e1e25601eb2043f67887e11ffd64df765b1fb44830ad931294b /

# tensorflow 2.1.0-gpu-py3
# ADD file:1010e051dde4a9b62532a80f4a9a619013eafc78491542d5ef5da796cc2697ae /

ENV TF_FORCE_GPU_ALLOW_GROWTH=true

CMD ["python3", "-V"]
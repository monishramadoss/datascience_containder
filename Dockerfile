FROM ubuntu:18.04
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update
RUN apt-get install -y wget curl && rm -rf /var/lib/apt/lists/*

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN apt-get update && apt-get install -y  \
    aufs-tools \
    automake \
    build-essential \
    dpkg-sig \
    libcap-dev \
    libsqlite3-dev \
    mercurial \
    reprepro \
    gcc \    
    dkms \    
    gnupg2 \
    ca-certificates\
 && rm -rf /var/lib/apt/lists/*

# Cuda 11.1.1
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*


# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-1=11.1.74-1 \
    cuda-compat-11-1 \
    && ln -s cuda-11.1 /usr/local/cuda-11-1 && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda-11-1/bin:${PATH}


RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn8=8.0.5.39-1+cuda11.1 \
    && apt-mark hold libcudnn8 && \
    rm -rf /var/lib/apt/lists/*


# CUDA 10.1.2
# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-10.1 \
    cuda-compat-10-1 \
    && ln -s cuda-10.1 /usr/local/cuda-10-1 && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/cuda-10-1/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# COPY NGC-DL-CONTAINER-LICENSE /

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=7.6.5.32-1+cuda10.1 \
    && apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 driver>=450"

# conda setup
ARG conda_env=jarvis
RUN echo "Running $(conda --version)" && \
    conda init bash && \
    . /root/.bashrc && \
    conda update -n base -c defaults conda && \
    conda create -n ${conda_env} python=3.7 pip && \
    conda install -n ${conda_env} pytorch torchvision torchaudio cudatoolkit=11.1 -c pytorch -c nvidia && \
    conda run --no-capture-output -n ${conda_env} pip install tensorflow==2.1.0 && \
    conda run --no-capture-output -n ${conda_env} pip install jarvis-md && \
    conda activate ${conda_env} 
# Pytorch manylinux-cuda113:latest
# ADD file:4f10ffca52683e1e25601eb2043f67887e11ffd64df765b1fb44830ad931294b /

# tensorflow 2.1.0-gpu-py3
# ADD file:1010e051dde4a9b62532a80f4a9a619013eafc78491542d5ef5da796cc2697ae /

ENV TF_FORCE_GPU_ALLOW_GROWTH=true

ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "jarvis", "pip", "show", "tensorflow" ]

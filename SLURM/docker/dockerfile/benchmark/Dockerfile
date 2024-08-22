# Follow instructions from https://www.mgaillard.fr/2022/08/27/benchmark-with-hpl.html

FROM debian-slurm:latest

RUN apt-get update && apt install build-essential hwloc libhwloc-dev libevent-dev gfortran

RUN git clone https://github.com/xianyi/OpenBLAS.git && \
    cd OpenBLAS && \
    git checkout v0.3.21 && \
    make && \
    make PREFIX=$HOME/opt/OpenBLAS install

ENV MPI_HOME=/usr
ENV PATH=$PATH:$MPI_HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPI_HOME/lib

RUN wget https://netlib.org/benchmark/hpl/hpl-2.3.tar.gz && \
    gunzip hpl-2.3.tar.gz && \
    tar xvf hpl-2.3.tar && \
    rm hpl-2.3.tar && \
    mv hpl-2.3 /root/hpl

RUN cd /root/hpl/setup && \
    sh make_generic && \
    cp Make.UNKNOWN ../Make.linux && \
    cd .. 

COPY Make.linux /root/hpl/Make.linux
RUN make -C /root/hpl arch=linux

ENTRYPOINT [ "bash" ]
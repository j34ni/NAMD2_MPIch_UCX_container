FROM quay.io/jeani/base_ubuntu_mpich_ucx

# Authors Jean Iaquinta
# Contact jeani@uio.no
# Version v1.1.0
#
# This is a definition file to build NAMD using a base container image with Ubuntu22.04 and MPIch4.2.1 (including support for UCX1.17.0)
# It is the responsibility of the user to accept the EULA and download locally the source and place it in the same folder as this file
#
# MPI version
#    ./config Linux-x86_64-g++ --charm-arch mpi-linux-x86_64
#
# If you use this container recipes and/or related material please kindly cite:
#
# Jean Iaquinta. (2024). j34ni/NAMD2_MPIch_UCX_container: Version 1.1.0 (v1.1.0). Zenodo.
# https://doi.org/10.5281/zenodo.14162224
#
# Copying from user local download of NAMD source (requires accepting EULA)
COPY ./NAMD*_Source.tar.gz /opt/uio/

# Copy source for NAMD 
RUN cd /usr/local && \
    mkdir -p NAMD_Source && \
    tar -xzf /opt/uio/NAMD*_Source.tar.gz -C NAMD_Source --strip-components=1 && \
    rm /opt/uio/NAMD*_Source.tar.gz

# Charm version 8.0.0
RUN cd /usr/local/NAMD_Source && \
    wget -q -nc --no-check-certificate https://github.com/charmplusplus/charm/archive/refs/tags/v8.0.0.tar.gz && \
    mkdir -p charm && tar -xzf v8.0.0.tar.gz -C charm --strip-components=1 && \
    cd charm && \
    ./build charm++ mpi-linux-x86_64 --with-production

# FFTW with -fPIC and single-precision support
RUN cd /usr/local/NAMD_Source && \
    wget -q -nc --no-check-certificate http://www.fftw.org/fftw-3.3.9.tar.gz && \
    tar -xzvf fftw-3.3.9.tar.gz && \
    cd fftw-3.3.9 && \
    ./configure --enable-float --enable-threads --prefix=/usr/local/NAMD_Source/fftw CFLAGS="-fPIC" && \
    make -j$(nproc) && make -j$(nproc) install && \
    rm -rf /usr/local/NAMD_Source/fftw-3.3.9 /usr/local/NAMD_Source/fftw-3.3.9.tar.gz

# Tcl version  8.5
RUN cd /usr/local/NAMD_Source && \
    wget -q -nc --no-check-certificate https://prdownloads.sourceforge.net/tcl/tcl8.5.19-src.tar.gz && \
    tar -xzf tcl8.5.19-src.tar.gz && \
    cd tcl8.5.19/unix && \
    ./configure --prefix=/usr/local/NAMD_Source/tcl && \
    make -j$(nproc) && make install && \
    cd /usr/local/NAMD_Source && \
    rm -rf tcl8.5.19 tcl8.5.19-src.tar.gz

# Tcl version 8.5.19 (threaded)
RUN cd /usr/local/NAMD_Source && \
    wget -q -nc --no-check-certificate https://prdownloads.sourceforge.net/tcl/tcl8.5.19-src.tar.gz && \
    tar -xzf tcl8.5.19-src.tar.gz && \
    cd tcl8.5.19/unix && \
    ./configure --enable-threads --prefix=/usr/local/NAMD_Source/tcl-threaded && \
    make -j$(nproc) && make install && \
    cd ../.. && \
    rm -rf tcl8.5.19 tcl8.5.19-src.tar.gz

ENV LDFLAGS="-L/usr/local/NAMD_Source/tcl/lib -L/usr/local/NAMD_Source/tcl-threaded/lib -L/usr/local/NAMD_Source/fftw/lib"
ENV CPPFLAGS="-I/usr/local/NAMD_Source/tcl/include -I/usr/local/NAMD_Source/tcl-threaded/include -I/usr/local/NAMD_Source/fftw/include"
ENV LD_LIBRARY_PATH="/usr/local/NAMD_Source/tcl/lib:/usr/local/NAMD_Source/tcl-threaded/lib:/usr/local/NAMD_Source/fftw/lib:$LD_LIBRARY_PATH"
ENV PATH="/usr/local/NAMD_Source/tcl/bin:/usr/local/NAMD_Source/tcl-threaded/bin:$PATH"

# Install NAMD
RUN cd /usr/local/NAMD_Source && \
    ./config Linux-x86_64-g++ --charm-base /usr/local/NAMD_Source/charm --charm-arch mpi-linux-x86_64 && \
    cd Linux-x86_64-g++ && \
    make -j$(nproc) 

ENV PATH=/usr/local/NAMD_Source/Linux-x86_64-g++:$PATH

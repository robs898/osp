FROM ubuntu:18.04

RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && \
    apt-get -y install software-properties-common autoconf automake build-essential libass-dev libtool pkg-config texinfo zlib1g-dev libva-dev cmake mercurial libdrm-dev libvorbis-dev libogg-dev git libx11-dev libperl-dev libpciaccess-dev libpciaccess0 xorg-dev intel-gpu-tools opencl-headers libwayland-dev xutils-dev ocl-icd-* && \
    add-apt-repository -y ppa:oibaf/graphics-drivers && \
    apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && \
    ln -s /usr/lib/x86_64-linux-gnu/libGLX_mesa.so.0 /usr/lib/x86_64-linux-gnu/libGLX_mesa.so && \
    mkdir -p ~/vaapi && \
    mkdir -p ~/ffmpeg_build && \
    mkdir -p ~/ffmpeg_sources && \
    mkdir -p ~/bin

RUN cd ~/vaapi && \
    git clone https://anongit.freedesktop.org/git/mesa/drm.git libdrm && \
    cd libdrm && \
    ./autogen.sh --prefix=/usr --enable-udev && \
    make -j$(nproc) VERBOSE=1 && \
    make -j$(nproc) install

RUN cd ~/vaapi && \
    git clone https://github.com/01org/libva && \
    cd libva && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j$(nproc) VERBOSE=1 && \
    make -j$(nproc) install

RUN mkdir -p ~/vaapi/workspace && \
    cd ~/vaapi/workspace && \
    git clone https://github.com/intel/gmmlib && \
    mkdir -p build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE= Release ../gmmlib && \
    make -j$(nproc) && \
    make -j$(nproc) install 

RUN cd ~/vaapi/workspace && \
    git clone https://github.com/intel/media-driver && \
    cd media-driver && \
    git submodule init && \
    git pull && \
    mkdir -p ~/vaapi/workspace/build_media && \
    cd ~/vaapi/workspace/build_media && \
    cmake ../media-driver \
    -DMEDIA_VERSION="2.0.0" \
    -DBS_DIR_GMMLIB=$PWD/../gmmlib/Source/GmmLib/ \
    -DBS_DIR_COMMON=$PWD/../gmmlib/Source/Common/ \
    -DBS_DIR_INC=$PWD/../gmmlib/Source/inc/ \
    -DBS_DIR_MEDIA=$PWD/../media-driver \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu \
    -DINSTALL_DRIVER_SYSCONF=OFF \
    -DLIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri && \
    make -j$(nproc) VERBOSE=1 && \
    make -j$(nproc) install VERBOSE=1

RUN usermod -a -G video root
RUN echo 'LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri' >> /etc/environments
RUN echo 'LIBVA_DRIVER_NAME=iHD' >> /etc/environments

RUN cd ~/vaapi && \
    git clone https://github.com/01org/cmrt && \
    cd cmrt && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j$(nproc) VERBOSE=1 && \
    make -j$(nproc) install

RUN cd ~/vaapi && \
    git clone https://github.com/01org/intel-hybrid-driver && \
    cd intel-hybrid-driver && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j$(nproc) VERBOSE=1 && \
    make -j$(nproc) install

RUN cd ~/vaapi && \
    git clone https://github.com/01org/intel-vaapi-driver && \
    cd intel-vaapi-driver && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu --enable-hybrid-codec && \
    make -j$(nproc) VERBOSE=1 && \
    make -j$(nproc) install

RUN cd ~/vaapi && \
    git clone https://github.com/intel/libva-utils && \
    cd libva-utils && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu && \
    make -j$(nproc) VERBOSE=1 && \
    make -j$(nproc) install

RUN add-apt-repository -y ppa:intel-opencl/intel-opencl
RUN apt-get update
RUN apt-get install intel-igc-* intel-opencl* intel-cloc intel-cmt-cat
RUN apt-get install ccache flex bison clang-4.0 cmake g++ git patch zlib1g-dev autoconf xutils-dev libtool pkg-config libpciaccess-dev libz-dev

RUN mkdir -p ~/intel-compute-runtime/workspace && \
    cd ~/intel-compute-runtime/workspace && \
    git clone -b release_40 https://github.com/llvm-mirror/clang clang_source && \
    git clone https://github.com/intel/opencl-clang common_clang && \
    git clone https://github.com/intel/llvm-patches llvm_patches && \
    git clone -b release_40 https://github.com/llvm-mirror/llvm llvm_source && \
    git clone -b release_70 https://github.com/llvm-mirror/llvm llvm7.0.0_source && \
    git clone https://github.com/intel/gmmlib gmmlib && \
    git clone https://github.com/intel/intel-graphics-compiler igc && \
    git clone https://github.com/KhronosGroup/OpenCL-Headers khronos && \
    git clone https://github.com/intel/compute-runtime neo && \
    ln -s khronos opencl_headers

RUN mkdir -p ~/intel-compute-runtime/workspace/build_igc

RUN cd ~/intel-compute-runtime/workspace/build_igc && \
    cmake -DIGC_OPTION__OUTPUT_DIR=../igc-install/Release ../igc/IGC && \
    make -j$(nproc) VERBOSE=1

RUN make -j$(nproc) package VERBOSE=1

RUN dpkg -i *.deb


ENTRYPOINT [ "ffmpeg" ]

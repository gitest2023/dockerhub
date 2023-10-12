FROM docker.io/library/amazonlinux:2023

ENV LEPTONICA_VERSION=1.75.1
ENV PYTHON_VERSION=3.8.10
ENV DLIB_VERSION=19.19

RUN yum -y update
RUN yum -y upgrade

RUN yum install -y which vim openssl openssl-devel libffi-devel sqlite-devel libglvnd-glx bzip2 bzip2-devel lzma xz xz-devel gtk3 gettext-devel && \
    yum install -y ImageMagick ImageMagick-devel && \
    yum install -y java-11-amazon-corretto

RUN yum install clang -y && \
    yum install libpng-devel libtiff-devel zlib-devel libwebp-devel libjpeg-turbo-devel wget tar gzip -y

# Install leptonica
RUN wget https://github.com/DanBloomberg/leptonica/releases/download/${LEPTONICA_VERSION}/leptonica-${LEPTONICA_VERSION}.tar.gz && \
    tar -zxvf leptonica-${LEPTONICA_VERSION}.tar.gz && \
    cd leptonica-${LEPTONICA_VERSION} && \
    ./configure && \
    make && \
    make install
RUN rm -rf /leptonica-${LEPTONICA_VERSION}

# Install tesseract
RUN cd ~ && \
    yum install git-core libtool pkgconfig -y && \
    git clone --depth 1  https://github.com/tesseract-ocr/tesseract.git tesseract-ocr && \
    cd tesseract-ocr && \
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install
RUN rm -rf /tesseract-ocr

# Install ImageMagick
RUN curl https://github.com/ImageMagick/ImageMagick/archive/7.1.1-20.tar.gz -L -o tmp-imagemagick.tar.gz && \
    tar xf tmp-imagemagick.tar.gz && \
    cd ImageMagick-7.1.1-20 && \
    # ./configure CPPFLAGS=-I/root/build/cache/include LDFLAGS="-L/root/build/cache/lib -lstdc++" --disable-dependency-tracking --disable-shared --enable-static --prefix=/usr/local --enable-delegate-build --disable-installed  --without-modules --disable-docs --without-magick-plus-plus --without-perl --without-x --disable-openmp && \
    ./configure  --prefix=/usr/local && \
    make clean && \
    make all && \
    make install
# RUN rm -rf tmp-imagemagick.tar.gz /ImageMagick-7.1.1-20

# Install zbar (qrcode scanner)
RUN git clone https://github.com/mchehab/zbar zbar && \
    cd zbar && \
    autoreconf -vfi && \
    ./configure && \
    make && \
    make install
# RUN rm -rf /zbar

# Install python
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make && \
    make install
RUN rm -rf /Python-${PYTHON_VERSION}

# https://kumarvinay.com/installing-dlib-library-in-ubuntu/
# RUN yum install build-essential cmake pkg-config libx11-dev libatlas-base-dev libgtk-3-dev libboost-python-dev -y
# RUN wget http://dlib.net/files/${DLIB_VERSION}.tar.bz2 && \
#     tar xvf dlib-${DLIB_VERSION}.tar.bz2 && \
#     cd dlib-${DLIB_VERSION}/ && \
#     mkdir build && \
#     cd build && \
#     cmake .. && \
#     cmake --build . --config Release && \
#     make install && \
#     ldconfig && \
#     cd .. && \
#     pkg-config --libs --cflags dlib-1
# RUN rm -rf /dlib-${DLIB_VERSION}

# Install Dlib
RUN pip3.8 install dlib

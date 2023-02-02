FROM registry.access.redhat.com/ubi8/python-39:latest

USER root

WORKDIR /deployment


COPY app.py /deployment
COPY requirements.txt /deployment
ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment

RUN chmod 777 /deployment/medium.pt
################################################

RUN yum install -y autoconf automake bzip2 bzip2-devel cmake freetype-devel gcc gcc-c++ git libtool make pkgconfig zlib-devel

RUN mkdir /tmp/ffmpeg_sources

# FFmpeg
RUN cd /tmp/ffmpeg_sources && \
    curl -O http://ffmpeg.org/releases/ffmpeg-4.1.1.tar.bz2 && \
    tar xjvf ffmpeg-4.1.1.tar.bz2 && \
    cd ffmpeg-4.1.1 && \
    PATH="$PATH:/tmp/bin" PKG_CONFIG_PATH="/tmp/ffmpeg_build/lib/pkgconfig" ./configure \
        --pkg-config-flags="--static" \
        --extra-cflags="-I/tmp/ffmpeg_build/include" \
        --extra-ldflags="-L/tmp/ffmpeg_build/lib -ldl" \
        --extra-libs=-lpthread \
        --enable-gpl \
        --enable-libfdk_aac \
        --enable-libfreetype \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libx265 \
        --enable-nonfree && \
    PATH="$PATH:/tmp/bin" make && \
    make install && \
    hash -r

#############################################
RUN pip3 install -r requirements.txt
#RUN pip3 install --no-cache-dir ffmpeg-python
RUN pip3 install "git+https://github.com/openai/whisper.git" 

EXPOSE 5000

USER 1001

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

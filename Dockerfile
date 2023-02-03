FROM registry.access.redhat.com/ubi8/python-39:latest

USER root

WORKDIR /deployment


COPY app.py /deployment
COPY requirements.txt /deployment
ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment

RUN chmod 777 /deployment/medium.pt

################################################
RUN dnf-config-manager --setopt=sslverify=false --save
RUN dnf update -y

RUN yum install dnf-plugins-core
RUN dnf -y install https://download.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf config-manager --set-enabled powertools
RUN dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
RUN dnf install -y https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
RUN dnf -y install ffmpeg
RUN dnf -y install ffmpeg-devel


#############################################
RUN pip3 install -r requirements.txt
#RUN pip3 install --no-cache-dir ffmpeg-python
RUN pip3 install "git+https://github.com/openai/whisper.git" 

EXPOSE 5000

USER 1001

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

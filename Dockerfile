FROM registry.access.redhat.com/ubi8/python-39:latest

USER root

WORKDIR /deployment


COPY app.py /deployment
COPY requirements.txt /deployment


################################################



#RUN echo "sslverify=false" >> /etc/yum.conf

RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN subscription-manager repos --enable rhel-7-server-optional-rpms
RUN subscription-manager repos --enable rhel-7-server-extras-rpms
RUN yum install epel-release.noarch
RUN yum install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
RUN yum install ffmpeg.x86_64



#############################################

ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment
RUN chmod 777 /deployment/medium.pt

RUN pip3 install -r requirements.txt

RUN pip3 install "git+https://github.com/openai/whisper.git"

EXPOSE 5000

USER 1001

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

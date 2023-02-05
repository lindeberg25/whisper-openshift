FROM registry.access.redhat.com/ubi8/python-39:latest

USER root

WORKDIR /deployment


COPY app.py /deployment
COPY requirements.txt /deployment


################################################


RUN echo "sslverify=false" >> /etc/yum.conf

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf -y upgrade

#RUN subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"
#RUN yum -y update

RUN yum -y --skip-broken install snapd

#RUN systemctl enable --now snapd.socket

RUN ln -s /var/lib/snapd/snap /snap

RUN yum -y install ffmpeg


#############################################

ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment
RUN chmod 777 /deployment/medium.pt

RUN pip3 install -r requirements.txt

RUN pip3 install "git+https://github.com/openai/whisper.git"

EXPOSE 5000

USER 1001

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

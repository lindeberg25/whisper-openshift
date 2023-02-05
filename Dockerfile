#FROM registry.access.redhat.com/ubi8/python-39:latest
FROM huggingface/transformers-pytorch-gpu

USER root

WORKDIR /deployment


COPY app.py /deployment
COPY requirements.txt /deployment


################################################

RUN yum update -y

RUN echo "sslverify=false" >> /etc/yum.conf

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
RUN dnf upgrade -y
RUN dnf install -y --enablerepo=codeready-builder-for-rhel-8-x86_64-rpms ffmpeg


ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment
RUN chmod 777 /deployment/medium.pt
#############################################
RUN pip3 install -r requirements.txt

RUN pip3 install "git+https://github.com/openai/whisper.git"

EXPOSE 5000

USER 1001

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

FROM huggingface/transformers-pytorch-gpu

USER root

EXPOSE 5000

WORKDIR /deployment


COPY app.py /deployment
COPY requirements.txt /deployment


#RUN apt-get -y install python3-tk
RUN  python3 -m pip install --upgrade pip 
   

ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment
RUN chmod 777 /deployment/medium.pt

RUN pip3 install -r requirements.txt

RUN pip3 install "git+https://github.com/openai/whisper.git"

USER 1001 

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

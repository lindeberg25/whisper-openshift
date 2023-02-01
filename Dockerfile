FROM registry.access.redhat.com/ubi8/python-39:latest

WORKDIR /deployment

COPY app.py /deployment
#COPY templates/* /deployment/templates/
COPY requirements.txt /deployment

RUN pip3 install -r requirements.txt
RUN pip3 install "git+https://github.com/openai/whisper.git" 

EXPOSE 5000

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

FROM python:3.8

RUN pip install paho-mqtt
ADD run.py /

ENTRYPOINT [ "python", "/run.py" ]

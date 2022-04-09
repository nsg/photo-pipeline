import random
import os
import json

from paho.mqtt import client as mqtt_client

topic = os.getenv("MQTT_TOPIC")

def connect_mqtt():
    broker = os.getenv("MQTT_SERVER")
    port = 1883
    client_id = f'python-mqtt-{random.randint(0, 1000)}'

    def on_connect(client, userdata, flags, rc):
        client.subscribe(f"{topic}/#")

    def on_message(client, userdata, msg):
        try:
            payload = json.loads(msg.payload.decode("utf-8"))
            if msg.topic == f"{topic}/pipe":
                payload['message']['data'] = len(payload['message']['data'])
                print(payload)
            elif msg.topic == f"{topic}/register":
                print(payload)
            else:
                print(msg.topic)
        except json.decoder.JSONDecodeError:
            print("Non-JSON message found")

    client = mqtt_client.Client(client_id)
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(broker, port)
    return client

def run():
    client = connect_mqtt()
    client.loop_forever()

if __name__ == '__main__':
    run()

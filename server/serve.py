from fastapi import FastAPI, WebSocket, Header, WebSocketDisconnect
from fastapi.responses import FileResponse
import classes as classes
from pymongo import MongoClient
import ssl
from bson.objectid import ObjectId
from typing import Optional
import uvicorn
import json
import base64
from collections import deque
import time
import librosa
import numpy as np
import os, asyncio
from websocket import create_connection
import websocket
import threading
from pydub import AudioSegment
global device_websockets, all_devices
device_websockets = {}
PASS = "admin"
client = MongoClient(f"",
                     ssl_cert_reqs=ssl.CERT_NONE)

db = client.main
groups = db["groups"]
devices = db["devices"]
all_devices = devices.find({})
app = FastAPI(title="Sound App",
              version="1.0")


def on_close(ws):
    # print('disconnected from server')
    print("Retry : %s" % time.ctime())
    time.sleep(2)
    connect_websocket(ws.url)  # retry per 10 seconds


def on_open(ws):
    print('connection established')


def connect_websocket(uri):
    ws = websocket.WebSocketApp(uri, on_open=on_open, on_close=on_close)
    wst = threading.Thread(target=ws.run_forever)
    wst.daemon = True
    wst.start()
    return ws


def keep_alive(socket):
    global device_websockets
    while True:
        ws = create_connection(f"ws://47.37.119.216:8080/ws/{device['_id']}", timeout=1000)
        device_websockets[str(device["_id"])] = {"websocket": ws}
        time.sleep(30)


for device in all_devices:
    print("OK")
    ws = create_connection(f"ws://47.37.119.216:8080/ws/{device['_id']}", timeout=1000)
    device_websockets[str(device["_id"])] = {"websocket": ws}
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_in_executor(None, keep_alive, ws)


@app.websocket("/ws/client")
async def websocket_client(websocket: WebSocket):
    global device_websockets
    await websocket.accept()
    session_info = {"device_id": "", "sounds": []}
    try:
        while True:
            data = await websocket.receive_text()
            data = data.split("||||")
            data[1] = json.loads(data[1])
            print(data[0])
            if data[0] == "SESSION_BEGIN":
                # retreive_websocket_connection to device
                session_info["device_id"] = data[1]["device_id"]

                device_websockets[session_info["device_id"]]["websocket"].send("INITIALIZE RECORDING SESSION")
                data = device_websockets[session_info["device_id"]]["websocket"].recv()
                print(data)
                await websocket.send_text('SESSION_BEGIN_STATUS||||{"status":"ready"}')

            if data[0] == "ONE_SECOND_RECORD_STATUS":
                # tell device to begin recording
                # return waveform
                await websocket.send_text('ONE_SECOND_RECORD_STATUS||||{"status":"started"}')
                device_websockets[session_info["device_id"]]["websocket"].send("BEGIN RECORDING")
                time.sleep(1.3)
                recording_data = device_websockets[session_info["device_id"]]["websocket"].recv().split("||||")
                with open(f"static/{recording_data[1]}.wav", "wb") as f:
                    f.write(device_websockets[session_info["device_id"]]["websocket"].recv())
                await websocket.send_text('ONE_SECOND_RECORD_STATUS||||{"status":"complete"}')
                wav_data, sr = librosa.load(f"static/{recording_data[1]}.wav", sr=None)
                wav_data = list((wav_data[::2205] - np.min(wav_data[::2205])) / np.ptp(wav_data[::2205]))
                print(wav_data)
                session_info["sounds"].append(recording_data[1])
                print(session_info["sounds"])
                await websocket.send_text(
                    f'ONE_SECOND_WAV||||{{"url":"http://47.37.119.216:8000/files/wav/{recording_data[1]}.wav", "waveform": {wav_data}}}')

            if data[0] == "ONE_SECOND_DELETE":
                session_info["sounds"].remove(data[1])
                os.remove(f"static/{data[1]}.wav")
                device_websockets[session_info["device_id"]]["websocket"].send(f"ONE SECOND DELETE||||{data[1]}")

            if data[0] == "SESSION_END":
                for wav_id in session_info["sounds"]:
                    try:
                        os.remove(f"static/{wav_id}.wav")
                    except FileNotFoundError:
                        pass
                name = data[1]["name"]
                category = data[1]["category"]
                sound_id = ObjectId()
                devices.update_one({"_id": ObjectId(session_info["device_id"])}, {"$push": {"available_sounds": {"_id":str(sound_id), "name": name, "category": category}}})
                device_websockets[session_info["device_id"]]["websocket"].send(
                    f"SAVE AND COMPLETE||||{sound_id}")
                # tell device to begin training on sounds and then start listening

            if data[0] == "SESSION_CANCEL":
                # tell device to delete list of sound ids, and begin listening
                for wav_id in session_info["sounds"]:
                    try:
                        os.remove(f"static/{wav_id}.wav")
                    except FileNotFoundError:
                        pass
                device_websockets[session_info["device_id"]]["websocket"].send(
                    f"SESSION CANCEL")

    except WebSocketDisconnect:
        print("Connection Ended!")


@app.post("/create/group")
def create_group():
    item = {"_id": ObjectId(), "devices": []}
    groups.insert_one(item)
    return {"_id": str(item["_id"])}


@app.post("/create/device")
def create_device(item: classes.device):
    device = vars(item)
    device["_id"] = ObjectId(item.device_id)
    device["sounds"] = []
    device["available_sounds"] = []
    # device added to database w/ attributes _id, group_id, name, location, purpose
    devices.insert_one(device)
    # device id added to relevant group database
    groups.update_one({"_id": ObjectId(item.group_id)}, {"$push": {"devices": str(device["_id"])}})
    return {"_id": str(device["_id"])}


@app.get("/activity")
def get_activity(group_id: str, device_id: str, category: Optional[str] = "nil"):
    sound_list = []
    device_ids = [device_id]
    if device_id == "nil":
        group = groups.find_one({"_id": ObjectId(group_id)})
        device_ids = group["devices"]

    for device_id in device_ids:
        device = devices.find_one({"_id": ObjectId(device_id)}, {'_id': 0})
        for sound in device["sounds"]:
            if sound["category"] == category or category == "nil":
                sound_list.append(sound)
    sound_list.reverse()
    return {"sound_list": sound_list}


@app.get("/group/devices")
def get_devices(group_id: str):
    group = groups.find_one({"_id": ObjectId(group_id)})
    device_ids = group["devices"]
    devices_list = []
    for device_id in device_ids:
        device = devices.find_one({"_id": ObjectId(device_id)})
        device.pop("sounds", None)
        device.pop("available_sounds")
        device["_id"] = str(device["_id"])
        devices_list.append(device)

    return {"devices_list": devices_list}


@app.get("/files/wav/{uid}/{path}.mp3")
def get_wav(uid: str, path: str):
    print(uid)
    print(path)
    AudioSegment.from_wav(f"static/{uid}/{path}.wav").export(f"static/{uid}/{path}.mp3", format="mp3")
    return FileResponse(f"static/{uid}/{path}.mp3")


@app.post("/report")
def report(item: classes.sound):
    global device_websockets
    print("Received Sound Detection Event...")
    device_websockets[item.device_id]["websocket"].send(f"SEND WAV||||{item.wav}")
    path = os.path.split(item.wav)[1]
    path = path.replace(" ", "")
    try:
        os.mkdir(f"static/{item.device_id}/")
    except:
        pass
    with open(f"static/{item.device_id}/{path}", "wb") as f:
        f.write(device_websockets[item.device_id]["websocket"].recv())
    item.wav = f"http://47.37.119.216:8000/files/wav/{item.device_id}/{path}"
    item.wav = item.wav.replace(".wav", ".mp3")
    print(item.wav)
    wav_data, sr = librosa.load(f"static/{item.device_id}/{path}", sr=None)

    item.waveform = list((wav_data[::2205] - np.min(wav_data[::2205])) / np.ptp(wav_data[::2205]))
    item.waveform = [float(level) for level in item.waveform]
    devices.update_one({"_id": ObjectId(item.device_id)}, {"$push": {"sounds": vars(item)}})
    return {"status": "ok"}


@app.post("/redo")
def redo():
    for device in all_devices:
        print("OK")
        ws = create_connection(f"ws://47.37.119.216:8080/ws/{device['_id']}")
        device_websockets[str(device["_id"])] = {"websocket": ws}
    return {"some": "thing"}


if __name__ == '__main__':
    uvicorn.run(app, host="0.0.0.0", port=8000)

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import time
import os, subprocess
from record import Recorder
from pathlib import Path
import shutil, asyncio

import uvicorn
from train import Trainer

with open("id/ID.txt", "r") as f:
    DEVICE_ID = f.readline()

app = FastAPI(name=DEVICE_ID, version="1.0")
global gsc
import requests, json


@app.websocket(f"/ws/{DEVICE_ID}")
async def always_on(websocket: WebSocket):
    try:
        global gsc
        await websocket.accept()
        while True:
            data = await websocket.receive_text()
            print(data)
            data = data.split("||||")
            if data[0] == "INITIALIZE RECORDING SESSION":
                gsc.kill_listener()
                Path("speech_commands_v0.02/tmp/").mkdir(parents=True, exist_ok=True)
                await websocket.send_text(f"INITIALIZATION COMPLETE")
                print("INITIALIZATION COMPLETE")

            if data[0] == "BEGIN RECORDING":
                print("RECEIVED RECORD REQUEST")
                t = time.time()
                recorder = Recorder()
                recorder.ready()
                filepath = recorder.record()
                await websocket.send_text(f"RECORDING COMPLETE||||{filepath}")
                await websocket.send_bytes(open(f"speech_commands_v0.02/tmp/{filepath}.wav", "rb").read())
                print("RECORD SENT")
                print(time.time() - t)

            if data[0] == "ONE SECOND DELETE":
                os.remove(f"speech_commands_v0.02/tmp/{data[1]}.wav")
                await websocket.send_text(f"DELETE COMPLETE")
                print("DELETE COMPLETE")

            if data[0] == "SAVE AND COMPLETE":
                os.mkdir(f"speech_commands_v0.02/{data[1]}/")
                os.mkdir(f"id/{data[1]}/")
                with open(f"id/{data[1]}/id.txt", "w+") as f:
                    f.write(data[1])
                paths = []
                src_path = 'speech_commands_v0.02/tmp/'
                trg_path = f'speech_commands_v0.02/{data[1]}/'
                for src_file in Path(src_path).glob('*.wav'):
                    shutil.copy(src_file, trg_path)
                for src_file in Path(trg_path).glob('*.wav'):
                    paths.append(str(src_file).replace("/", "."))

                shutil.rmtree(f"speech_commands_v0.02/tmp/", ignore_errors=True)

                # Send off to server for training (files/data[1]/*)
                trainer = Trainer(data[1])
                trainer.pre_process_data()
                trainer.train()
                gsc.launch_listener()
                await websocket.send_text(f"SESSION COMPLETE")

                print("SESSION COMPLETE")

            if data[0] == "SESSION CANCEL":
                os.rmdir(f"speech_commands_v0.02/tmp/")
                gsc.launch_listener()
                await websocket.send_text(f"SESSION CANCELED")
                print("SESSION CANCELED")

            if data[0] == "SEND WAV":
                await websocket.send_bytes(open(data[1], "rb").read())
    except WebSocketDisconnect:
        requests.post("http://47.37.119.216:8000/redo")


class GrandCentralStation:
    def __init__(self):
        with open("id/ID.txt", "r") as f:
            self.device_id = f.readline()
        self.launch_listener()

    def launch_listener(self):
        self.process = subprocess.Popen(
            f"python3 listen.py",
            shell=True, preexec_fn=os.setpgrp)
        print("Started Listener")

    def kill_listener(self):
        os.killpg(os.getpgid(self.process.pid), 9)
        print("Killed Listener")


gsc = GrandCentralStation()

if __name__ == '__main__':
    uvicorn.run(app, host="0.0.0.0", port=8080)

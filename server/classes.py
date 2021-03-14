from pydantic import BaseModel


class device(BaseModel):
    group_id: str
    name: str
    location: str
    purpose: str
    device_id: str


class sound(BaseModel):
    id: str
    name: str
    device_id: str
    device_name: str
    category: str
    waveform: list
    wav: str




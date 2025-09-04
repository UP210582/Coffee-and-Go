from fastapi import FastAPI, UploadFile, File
from typing import List

app = FastAPI()

@app.post("/upload")
async def upload(files: List[UploadFile] = File(...)):
    for file in files:
        contents = await file.read()
        print(f"Archivo recibido: {file.filename}, tamaño: {len(contents)} bytes")
    return {"message": f"{len(files)} archivo(s) recibidos exitosamente"}

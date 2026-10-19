# MinIO - week 7

Maarten ter Harmsel, 587328

MinIO object storage in Docker, op mijn eigen laptop.

## Starten

```powershell
.\start-minio-587328.ps1
```

- Console (webbrowser): http://localhost:9111, login `minio1234` / `minio1234`
- S3-API: http://localhost:9000
- De data staat in het Docker-volume `minio-587328-data`. Die blijft bestaan als de container stopt of weg is.

## Bucket en object met de mc-client

```powershell
docker exec minio-587328 mc alias set lokaal http://localhost:9000 minio1234 minio1234
docker exec minio-587328 mc mb lokaal/587328
docker cp hallo-587328.txt minio-587328:/tmp/
docker exec minio-587328 mc cp /tmp/hallo-587328.txt lokaal/587328/
docker exec minio-587328 mc ls --recursive lokaal/587328
```

## Stoppen

```powershell
docker stop minio-587328
```

Weer starten: `docker start minio-587328`.

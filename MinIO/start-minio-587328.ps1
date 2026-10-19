# Maarten ter Harmsel
# Studentnummer: 587328
# Week 7 - MinIO object storage in Docker, op mijn eigen laptop
# Gebaseerd op het commando van de slide (Opdracht deel 3 van 4), met image elestio/minio.
# Starten: .\start-minio-587328.ps1
# Console: http://localhost:9111  (gebruiker minio1234 / wachtwoord minio1234)
# API (S3): http://localhost:9000

docker volume create minio-587328-data

docker run -d `
  --name minio-587328 `
  --restart always `
  --volume minio-587328-data:/data `
  --publish 9000:9000 `
  --publish 9111:9001 `
  --publish 9090:9090 `
  -e "MINIO_ROOT_USER=minio1234" `
  -e "MINIO_ROOT_PASSWORD=minio1234" `
  elestio/minio `
  server /data `
  --console-address ":9001"

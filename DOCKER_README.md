# Excel MCP Server - Docker Kullanımı

Bu dokümantasyon Excel MCP Server'ını Docker container'ında çalıştırma talimatlarını içerir.

## Hızlı Başlangıç

### Docker Compose ile (Önerilen)

```bash
# Container'ı build et ve başlat
docker-compose up -d

# Logları kontrol et
docker-compose logs -f

# Container'ı durdur
docker-compose down
```

### Dockerfile ile

```bash
# Image'ı build et
docker build -t excel-mcp-server .

# Container'ı çalıştır
docker run -d \
  --name excel-mcp-server \
  -p 8000:8000 \
  -v $(pwd)/excel_files:/app/excel_files \
  excel-mcp-server
```

## Konfigürasyon

### Environment Variables

- `EXCEL_FILES_PATH`: Excel dosyalarının saklanacağı dizin (varsayılan: `/app/excel_files`)
- `FASTMCP_PORT`: Server'ın dinleyeceği port (varsayılan: `8000`)
- `FASTMCP_HOST`: Server'ın bind olacağı host (varsayılan: `0.0.0.0`)

### Volume Mapping

Excel dosyaları host sisteminde `./excel_files` dizininde saklanır ve container ile senkronize edilir.

## Client Bağlantısı

AI chatbot'un için MCP client konfigürasyonu:

```json
{
   "mcpServers": {
      "excel": {
         "url": "http://localhost:8000/mcp"
      }
   }
}
```

## Kullanım Komutları

### Container Yönetimi

```bash
# Container durumunu kontrol et
docker ps

# Logları görüntüle
docker logs excel-mcp-server

# Container'a bağlan
docker exec -it excel-mcp-server bash

# Container'ı yeniden başlat
docker restart excel-mcp-server
```

### Docker Compose Komutları

```bash
# Servisleri başlat
docker-compose up -d

# Logları görüntüle
docker-compose logs -f excel-mcp-server

# Servisleri durdur
docker-compose down

# Servisleri yeniden başlat
docker-compose restart
```

## Health Check

Container'da health check aktif ve 30 saniyede bir kontrol yapılıyor. Health check endpoint'i: `http://localhost:8000/health`

## Güvenlik

- Container sadece port 8000'i expose eder
- Excel dosyaları sadece belirlenen dizinde işlenir
- Container izole bir ortamda çalışır

## Troubleshooting

### Port Çakışması
Eğer port 8000 kullanımdaysa, `docker-compose.yml` dosyasında port mapping'i değiştirin:

```yaml
ports:
  - "8001:8000"  # Host port 8001, container port 8000
```

### Dosya İzinleri
Excel dosyaları için host dizininde yazma izni olduğundan emin olun:

```bash
chmod 755 excel_files/
```

### Log Kontrolü
Sorun yaşarsanız logları kontrol edin:

```bash
docker-compose logs -f excel-mcp-server
``` 
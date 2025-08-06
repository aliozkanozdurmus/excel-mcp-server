# Python 3.11 slim image kullan (daha küçük boyut)
FROM python:3.11-slim

# Sistem paketlerini güncelle ve gerekli paketleri kur
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Çalışma dizinini ayarla
WORKDIR /app

# uv package manager'ı kur
RUN pip install uv

# Excel dosyaları için dizin oluştur
RUN mkdir -p /app/excel_files

# Environment variables ayarla
ENV EXCEL_FILES_PATH=/app/excel_files
ENV FASTMCP_PORT=8000
ENV FASTMCP_HOST=0.0.0.0

# Excel MCP Server'ı kur
RUN uvx install excel-mcp-server

# Port'u expose et
EXPOSE 8000

# Health check ekle
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Server'ı başlat
CMD ["uvx", "excel-mcp-server", "streamable-http"] 
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

# Proje dosyalarını kopyala
COPY pyproject.toml uv.lock README.md ./
COPY src/ ./src/

# Excel dosyaları için dizin oluştur
RUN mkdir -p /app/excel_files

# Environment variables ayarla
ENV EXCEL_FILES_PATH=/app/excel_files
ENV FASTMCP_PORT=8000
ENV FASTMCP_HOST=0.0.0.0

# Dependencies'leri kur
RUN uv sync

# Port'u expose et
EXPOSE 8000

# Server'ı başlat
CMD ["uv", "run", "excel-mcp-server", "streamable-http"] 
FROM python:3.10-slim

# Sistem paketlerini kur
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# UV kur
RUN pip install uv

# Proje dosyalarını kopyala
COPY pyproject.toml uv.lock README.md ./
COPY src/ ./src/

# Dependencies yükle
RUN uv sync --no-dev

# Excel dosyaları için dizin oluştur
RUN mkdir -p /app/excel_files

# Port aç
EXPOSE 8017

# Environment variables
ENV FASTMCP_PORT=8017
ENV FASTMCP_HOST=0.0.0.0
ENV EXCEL_FILES_PATH=/app/excel_files
ENV BASE_URL=https://excelmcp.veniai.com.tr


# VSCode'da çalışan komutun aynısı
CMD ["uv", "run", "excel-mcp-server", "streamable-http"] 
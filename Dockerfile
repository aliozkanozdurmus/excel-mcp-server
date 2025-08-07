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

# R2 Storage Environment Variables (set these in Dokploy)
ENV R2_ENDPOINT=https://92e19074b3ec088a0e755e5174e8dd55.r2.cloudflarestorage.com
ENV R2_ACCESS_KEY=3505e08be24ef3793f265ad2440d3c54
ENV R2_SECRET_KEY=6889050c545bece2cf082a62b8836195dd21a6b4ea7ff9bc91040fb7f37f63c4
ENV R2_BUCKET=excelmcp
ENV R2_CUSTOM_DOMAIN=https://server.excelmcp.veniai.com.tr


# VSCode'da çalışan komutun aynısı
CMD ["uv", "run", "excel-mcp-server", "streamable-http"] 
FROM python:3.11-slim

# Install uv
RUN pip install uv

# Set working directory
WORKDIR /app

# Copy project files
COPY pyproject.toml uv.lock ./
COPY src/ ./src/
COPY README.md ./

# Install dependencies
RUN uv sync

# Expose port (FastMCP default port)
EXPOSE 8017

# Set environment variables
ENV EXCEL_FILES_PATH=/app/excel_files
ENV FASTMCP_PORT=8017

# Create excel files directory
RUN mkdir -p /app/excel_files

# Command to run the server
CMD ["uv", "run", "excel-mcp-server", "streamable-http"] 
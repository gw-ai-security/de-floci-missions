FROM python:3.12.11-slim-bookworm

RUN useradd --create-home --uid 10001 rag
WORKDIR /app
COPY server.py /app/server.py
RUN mkdir -p /app/data && chown -R rag:rag /app
USER rag
EXPOSE 8090
HEALTHCHECK --interval=10s --timeout=3s --retries=5 CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8090/health', timeout=2)" || exit 1
CMD ["python", "/app/server.py"]

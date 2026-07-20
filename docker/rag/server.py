"""Kleine deterministische RAG-Lern-API; lädt keine Modelle herunter."""
import hashlib
import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


def embedding(text: str, dimensions: int = 8) -> list[float]:
    digest = hashlib.sha256(text.encode("utf-8")).digest()
    return [round((digest[index] / 255.0) * 2 - 1, 6) for index in range(dimensions)]


class Handler(BaseHTTPRequestHandler):
    def send_json(self, status, payload):
        data = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path == "/health":
            self.send_json(200, {"status": "ok", "mode": "deterministic-mock"})
        else:
            self.send_json(404, {"error": "not found"})

    def do_POST(self):
        if self.path != "/embed":
            return self.send_json(404, {"error": "not found"})
        try:
            size = min(int(self.headers.get("Content-Length", "0")), 16_384)
            payload = json.loads(self.rfile.read(size) or b"{}")
            text = payload.get("text")
            if not isinstance(text, str) or not text.strip():
                return self.send_json(400, {"error": "text is required"})
            self.send_json(200, {"text": text, "embedding": embedding(text), "deterministic": True})
        except (ValueError, json.JSONDecodeError):
            self.send_json(400, {"error": "invalid json"})

    def log_message(self, fmt, *args):
        print("rag-api", fmt % args)


ThreadingHTTPServer(("0.0.0.0", 8090), Handler).serve_forever()

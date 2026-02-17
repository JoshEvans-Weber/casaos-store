#!/usr/bin/env python3
import http.server
import socketserver
import subprocess
import os
import sys
import webbrowser
import json
from pathlib import Path
from urllib.parse import urlparse, parse_qs
from api import handle_api_all, handle_api_single, handle_test
from threading import Thread
import logging

# Suppress verbose logging
logging.getLogger("http.server").setLevel(logging.WARNING)

PORT = 8000
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class PHPHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        """Suppress request logging"""
        pass
    
    def do_GET(self):
        # Parse the path and query string
        parsed_path = urlparse(self.path)
        file_path = parsed_path.path
        query_string = parsed_path.query
        
        if file_path == '/':
            file_path = '/index.html'
        
        full_path = os.path.join(DIRECTORY, file_path.lstrip('/'))
        
        # If it's a PHP file, handle with Python
        if full_path.endswith('.php'):
            try:
                response_data = None
                status_code = 200
                
                # Route to appropriate handler
                if full_path.endswith('api.php'):
                    action = parse_qs(query_string).get('action', [None])[0]
                    if action == 'all':
                        response_data = handle_api_all()
                    elif action == 'single':
                        url = parse_qs(query_string).get('url', [None])[0]
                        if url:
                            response_data = handle_api_single(url)
                        else:
                            status_code = 400
                            response_data = {"error": "Missing url parameter"}
                    else:
                        status_code = 400
                        response_data = {"error": "Missing action parameter"}
                        
                elif full_path.endswith('test.php'):
                    response_data = handle_test()
                else:
                    status_code = 404
                    response_data = {"error": "Unknown PHP file"}
                
                # Send response
                response_json = json.dumps(response_data).encode('utf-8')
                self.send_response(status_code)
                self.send_header('Content-type', 'application/json; charset=utf-8')
                self.send_header('Content-Length', str(len(response_json)))
                self.end_headers()
                self.wfile.write(response_json)
                    
            except Exception as e:
                self.send_error(500, str(e))
            return
        
        # Check if file exists
        if not os.path.exists(full_path):
            self.send_error(404)
            return
        
        # For other files, use default handler
        super().do_GET()

    def translate_path(self, path):
        # Remove query string
        path = path.split('?')[0]
        return super().translate_path(path)
    
    def log_message(self, format, *args):
        # Suppress noisy logging in Docker
        pass

if __name__ == '__main__':
    os.chdir(DIRECTORY)
    os.makedirs(os.path.join(DIRECTORY, 'cache'), exist_ok=True)
    
    # Use ThreadingTCPServer for concurrent request handling
    with socketserver.ThreadingTCPServer(("" , PORT), PHPHandler) as httpd:
        httpd.daemon_threads = True
        url = f"http://localhost:{PORT}"
        print(f"Server running at {url}")
        
        # Try to open browser (only on local machine)
        try:
            if os.getenv('DISPLAY') or sys.platform == 'win32':
                webbrowser.open(url)
        except:
            pass
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped")

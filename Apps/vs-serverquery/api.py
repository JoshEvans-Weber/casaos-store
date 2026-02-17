import json
import os
import hashlib
import time
import urllib.request
import urllib.error
from pathlib import Path

CACHE_DIR = os.path.join(os.path.dirname(__file__), "cache")
CACHE_TIME = 10  # seconds

def get_cache_filename(url):
    """Generate cache filename from URL hash"""
    return os.path.join(CACHE_DIR, f"server_{hashlib.md5(url.encode()).hexdigest()}.json")

def fetch_single(url):
    """Fetch from URL without caching"""
    try:
        # Validate URL format
        if not url.startswith(('http://', 'https://')):
            return {"url": url, "error": "Invalid URL"}
        
        # Fetch the URL
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=3) as response:
            data = response.read().decode('utf-8')
            http_code = response.status
        
        if http_code != 200:
            return {"url": url, "error": f"HTTP error: {http_code}"}
        
        # Parse JSON
        parsed_data = json.loads(data)
        return {"url": url, "data": {"success": True, "data": parsed_data}}
        
    except urllib.error.URLError as e:
        return {"url": url, "error": f"Connection error: {str(e)}"}
    except urllib.error.HTTPError as e:
        return {"url": url, "error": f"HTTP error: {e.code}"}
    except json.JSONDecodeError:
        return {"url": url, "error": "Invalid JSON"}
    except Exception as e:
        return {"url": url, "error": f"Error: {str(e)}"}

def fetch_single_cached(url):
    """Fetch from URL with caching"""
    filename = get_cache_filename(url)
    
    # Check if cache exists and is fresh
    if os.path.exists(filename):
        file_time = os.path.getmtime(filename)
        if (time.time() - file_time) < CACHE_TIME:
            try:
                with open(filename, 'r') as f:
                    cached = json.load(f)
                    if cached is not None:
                        return cached
            except:
                pass
    
    # Fetch fresh data
    data = fetch_single(url)
    
    # Save to cache
    try:
        os.makedirs(CACHE_DIR, exist_ok=True)
        with open(filename, 'w') as f:
            json.dump(data, f)
    except:
        pass
    
    return data

def handle_api_all():
    """Handle /api.php?action=all request"""
    os.makedirs(CACHE_DIR, exist_ok=True)
    
    servers_file = os.path.join(os.path.dirname(__file__), "servers.json")
    
    # Create default servers.json if it doesn't exist
    if not os.path.exists(servers_file):
        default_servers = [
            "http://vintagetest.minecraftharbor.net:8181/",
            "http://vintage.minecraftharbor.net:8182/"
        ]
        try:
            with open(servers_file, 'w') as f:
                json.dump(default_servers, f, indent=2)
        except:
            pass
    
    try:
        with open(servers_file, 'r') as f:
            servers = json.load(f)
    except:
        return []
    
    if not isinstance(servers, list):
        return []
    
    results = []
    for url in servers:
        results.append(fetch_single_cached(url))
    
    return results

def handle_api_single(url):
    """Handle /api.php?action=single&url=... request"""
    os.makedirs(CACHE_DIR, exist_ok=True)
    return fetch_single_cached(url)

def handle_test():
    """Handle /test.php request"""
    return {
        "python_version": __import__('sys').version,
        "platform": __import__('platform').system(),
        "cache_dir_exists": os.path.isdir(CACHE_DIR),
        "cache_dir_writable": os.access(CACHE_DIR if os.path.exists(CACHE_DIR) else os.path.dirname(__file__), os.W_OK),
        "servers_json_exists": os.path.isfile(os.path.join(os.path.dirname(__file__), "servers.json")),
        "servers_json_content": (lambda: json.load(open(os.path.join(os.path.dirname(__file__), "servers.json"))) if os.path.exists(os.path.join(os.path.dirname(__file__), "servers.json")) else None)()
    }

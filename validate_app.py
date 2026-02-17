import yaml
import json

try:
    with open('Apps/vs-serverquery/docker-compose.yml') as f:
        data = yaml.safe_load(f)
    print("✓ YAML is valid")
    print("✓ App name:", data.get('name'))
    print("✓ Services:", list(data.get('services', {}).keys()))
    print("✓ Has x-casaos:", 'x-casaos' in data)
    if 'x-casaos' in data:
        xc = data['x-casaos']
        print("  - Title keys:", list(xc.get('title', {}).keys()))
        print("  - Category:", xc.get('category'))
        print("  - Author:", xc.get('author'))
        print("  - Icon URL accessible:", bool(xc.get('icon')))
except Exception as e:
    print("✗ ERROR:", type(e).__name__, "-", e)
    import traceback
    traceback.print_exc()

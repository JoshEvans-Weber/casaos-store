import yaml

with open('Apps/doodleduet-app/docker-compose.yml', 'r') as f:
    compose = yaml.safe_load(f)

print('docker-compose.yml validation:')
print(f'  Version: {compose.get("version")}')
services = list(compose.get('services', {}).keys())
print(f'  Services: {services}')

if 'x-casaos' in compose:
    print('  x-casaos: FOUND')
    xc = compose['x-casaos']
    required = ['architectures', 'main', 'title', 'icon', 'category', 'version']
    for field in required:
        status = 'OK' if field in xc else 'MISSING'
        print(f'    - {field}: {status}')
else:
    print('  x-casaos: MISSING')
    
if 'doodleduet-app' in compose.get('services', {}):
    service = compose['services']['doodleduet-app']
    print('  doodleduet-app service:')
    print(f'    - image: {service.get("image", "MISSING")}')
    print(f'    - ports: {service.get("ports", "MISSING")}')
    env = 'OK' if service.get('environment') else 'MISSING'
    print(f'    - environment: {env}')

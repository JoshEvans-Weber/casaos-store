import json

with open('store.json', 'r') as f:
    store = json.load(f)

apps = store.get('apps', [])
print('Store.json validation:')
print(f'  Total apps: {len(apps)}')

doodleduet = next((a for a in apps if a['name'] == 'doodleduet-app'), None)

if doodleduet:
    print('  DoodleDuet found: YES')
    print(f'    - Name: {doodleduet.get("name")}')
    print(f'    - Title: {doodleduet.get("title")}')
    print(f'    - Icon: {doodleduet.get("icon", "MISSING")}')
    print(f'    - Category: {doodleduet.get("category", "MISSING")}')
    print(f'    - Image: {doodleduet.get("image", {})}')
    
    required = ['name', 'title', 'icon', 'tagline', 'category', 'version', 'updated', 'image']
    missing = [f for f in required if f not in doodleduet]
    if missing:
        print(f'    WARNING: Missing fields: {missing}')
    else:
        print('    OK: All required fields present')
else:
    print('  DoodleDuet found: NO')
    names = [a['name'] for a in apps]
    print(f'  Available apps: {names}')

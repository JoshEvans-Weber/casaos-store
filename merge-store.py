#!/usr/bin/env python3
import json

# Load both versions
with open('store.json', 'r') as f:
    local = json.load(f)

with open('store.json.remote.git', 'r') as f:
    remote = json.load(f)

# Merge apps, avoiding duplicates
local_apps = {app['name']: app for app in local.get('apps', [])}
remote_apps = {app['name']: app for app in remote.get('apps', [])}

# Combine: keep remote versions by default, but use local if it's newer
merged_apps = {}
merged_apps.update(remote_apps)  # Start with remote
merged_apps.update(local_apps)   # Overwrite with local (DoodleDuet should be here)

# Create merged store.json
merged_store = {
    "name": remote.get('name', local.get('name')),
    "category_list": remote.get('category_list', local.get('category_list')),
    "recommend": remote.get('recommend', local.get('recommend')),
    "apps": list(merged_apps.values())
}

# Sort apps by name for consistency
merged_store['apps'].sort(key=lambda x: x['name'])

# Write merged version
with open('store.json', 'w') as f:
    json.dump(merged_store, f, indent=2)

print(f"✓ Merged {len(remote_apps)} remote apps with {len(local_apps)} local apps")
print(f"✓ Total apps: {len(merged_apps)}")
print("\nMerged app list:")
for app in merged_store['apps']:
    print(f"  - {app['name']}")

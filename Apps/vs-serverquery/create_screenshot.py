from PIL import Image, ImageDraw

# Create screenshot (1280x720)
img = Image.new('RGB', (1280, 720), color='#f8f9fa')
draw = ImageDraw.Draw(img)

# Draw header bar
draw.rectangle([(0, 0), (1280, 80)], fill='#4F46E5')
draw.text((40, 20), "VS Server Query", fill='white')

# Draw mock interface elements
y = 120
draw.rectangle([(40, y), (1240, y+60)], outline='#ddd', width=2)
draw.text((60, y+15), "Server 1: vint.minecraftharbor.net (Online)", fill='#333')

y += 100
draw.rectangle([(40, y), (1240, y+60)], outline='#ddd', width=2)
draw.text((60, y+15), "Server 2: Query cache hits: 256 in last 10s", fill='#333')

y += 100
draw.rectangle([(40, y), (1240, y+60)], outline='#ddd', width=2)
draw.text((60, y+15), "Last updated: 2 seconds ago | Cache TTL: 10s", fill='#333')

img.save('screenshot-1.png')
print('Created screenshot-1.png')

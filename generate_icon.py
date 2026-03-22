#!/usr/bin/env python3
"""
Generate DoodleDuet app icon (512x512 PNG)
Simple art palette with brush strokes representing collaborative drawing
"""

from PIL import Image, ImageDraw
import os

def generate_icon(output_path="Apps/doodleduet-app/icon.png"):
    """Generate a 512x512 PNG icon for DoodleDuet"""
    
    # Create image with white background
    size = 512
    img = Image.new('RGBA', (size, size), color=(255, 255, 255, 0))
    draw = ImageDraw.Draw(img)
    
    # Colors for the palette
    bg_color = (240, 248, 255)  # Alice blue background
    palette_color = (210, 180, 140)  # Tan for palette
    paint_colors = [
        (255, 99, 71),    # Tomato red
        (50, 205, 50),    # Lime green
        (30, 144, 255),   # Dodger blue
        (255, 215, 0),    # Gold
        (218, 112, 214),  # Orchid purple
    ]
    brush_color = (139, 69, 19)  # Saddle brown for brush handles
    
    # Draw gradient-like background circle
    circle_radius = 240
    circle_pos = [(size//2 - circle_radius, size//2 - circle_radius),
                  (size//2 + circle_radius, size//2 + circle_radius)]
    draw.ellipse(circle_pos, fill=bg_color, outline=(100, 150, 200), width=3)
    
    # Draw artist palette (oval shape)
    palette_width = 280
    palette_height = 200
    palette_x = size//2 - palette_width//2
    palette_y = size//2 - palette_height//2 + 20
    
    draw.ellipse(
        [palette_x, palette_y, palette_x + palette_width, palette_y + palette_height],
        fill=palette_color,
        outline=(180, 150, 110),
        width=4
    )
    
    # Draw paint blobs on palette
    blob_positions = [
        (palette_x + 60, palette_y + 50),
        (palette_x + 150, palette_y + 40),
        (palette_x + 240, palette_y + 60),
        (palette_x + 80, palette_y + 130),
        (palette_x + 200, palette_y + 140),
    ]
    
    for i, (bx, by) in enumerate(blob_positions):
        blob_size = 28
        color = paint_colors[i % len(paint_colors)]
        draw.ellipse(
            [bx - blob_size//2, by - blob_size//2, 
             bx + blob_size//2, by + blob_size//2],
            fill=color,
            outline=(80, 80, 80),
            width=2
        )
    
    # Draw brush handles (two of them for collaboration theme)
    # Brush 1 (left)
    brush1_x = palette_x - 80
    brush1_y = palette_y + palette_height - 40
    # Handle
    draw.rectangle([brush1_x - 8, brush1_y - 80, brush1_x + 8, brush1_y + 20],
                   fill=brush_color, outline=(100, 50, 0), width=2)
    # Bristles
    draw.ellipse([brush1_x - 18, brush1_y + 15, brush1_x + 18, brush1_y + 35],
                 fill=(240, 240, 240), outline=(100, 100, 100), width=1)
    
    # Brush 2 (right)
    brush2_x = palette_x + palette_width + 80
    brush2_y = palette_y + palette_height - 40
    # Handle
    draw.rectangle([brush2_x - 8, brush2_y - 80, brush2_x + 8, brush2_y + 20],
                   fill=brush_color, outline=(100, 50, 0), width=2)
    # Bristles
    draw.ellipse([brush2_x - 18, brush2_y + 15, brush2_x + 18, brush2_y + 35],
                 fill=(240, 240, 240), outline=(100, 100, 100), width=1)
    
    # Draw some stroke marks (representing collaborative drawing)
    stroke_color = (100, 100, 100)
    strokes = [
        [(palette_x + 100, palette_y - 60), (palette_x + 140, palette_y - 40)],
        [(palette_x + 180, palette_y - 70), (palette_x + 220, palette_y - 30)],
        [(palette_x + palette_width - 40, palette_y - 80), (palette_x + palette_width - 20, palette_y - 40)],
    ]
    
    for stroke in strokes:
        draw.line(stroke, fill=stroke_color, width=4)
    
    # Add "DoodleDuet" text at bottom
    try:
        from PIL import ImageFont
        # Try to use a nice font, fallback to default if not available
        font_size = 48
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", font_size)
        except:
            try:
                font = ImageFont.truetype("C:\\Windows\\Fonts\\arial.ttf", font_size)
            except:
                font = ImageFont.load_default()
        
        text = "DoodleDuet"
        # Get text bounding box to center it
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_x = (size - text_width) // 2
        text_y = size - 100
        
        # Draw text with outline for visibility
        outline_width = 3
        for adj_x in range(-outline_width, outline_width + 1):
            for adj_y in range(-outline_width, outline_width + 1):
                if adj_x != 0 or adj_y != 0:
                    draw.text((text_x + adj_x, text_y + adj_y), text, 
                             font=font, fill=(200, 200, 200))
        
        draw.text((text_x, text_y), text, font=font, fill=(50, 50, 50))
    except Exception as e:
        print(f"Note: Could not draw text: {e}")
    
    # Ensure output directory exists
    os.makedirs(os.path.dirname(output_path) or ".", exist_ok=True)
    
    # Save the image
    img.save(output_path, "PNG")
    print(f"✓ Icon generated: {output_path}")
    print(f"  Size: {size}x{size} pixels")
    print(f"  Format: PNG with transparency support")

if __name__ == "__main__":
    generate_icon()
    print("\n✓ DoodleDuet icon created successfully!")

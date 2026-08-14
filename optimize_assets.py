from pathlib import Path
from PIL import Image

ROOT = Path(__file__).parent / "assets" / "images"
MAX_DIMENSIONS = {
    "environment": 1280,
    "monkey": 768,
    "obstacles": 768,
    "collectibles": 512,
    "ui": 512,
    "reference": 1024,
}

for image_path in ROOT.rglob("*.png"):
    if image_path.name.endswith("_original.png"):
        continue
    limit = MAX_DIMENSIONS.get(image_path.parent.name, 768)
    with Image.open(image_path) as image:
        image.load()
        longest = max(image.size)
        if longest > limit:
            scale = limit / longest
            target = (round(image.width * scale), round(image.height * scale))
            image = image.resize(target, Image.Resampling.LANCZOS)
        image.save(image_path, format="PNG", optimize=True, compress_level=9)
        print(f"optimized {image_path.relative_to(ROOT)} -> {image.size[0]}x{image.size[1]}")

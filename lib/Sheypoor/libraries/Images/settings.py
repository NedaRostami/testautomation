from typing import Dict
from datetime import datetime
import os


base_dir: str = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'Images')
listing_image_path: str = os.path.join(base_dir, 'listings')
today_listing_image_path = os.path.join(listing_image_path, datetime.now().strftime('%Y%m%d'))
static_image_path: str = os.path.join(base_dir, 'static')
category_map: Dict[str, str] = {
    '43626': 'cars',
    '43603': 'house',
    '43618': 'jobs',
    '43633': 'services',
    '43608': 'decorations',
    '43619': 'sports',
    '43596': 'electronics',
    '43631': 'businesses',
    '44096': 'mobile',
    '43612': 'personal',
}
IMAGE_EXTENSION = '.jpg'

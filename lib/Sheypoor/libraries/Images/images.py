import os
import shutil
from datetime import datetime, timedelta
from typing import List, Union, Dict, Any

from robot.api.deco import keyword

from exceptions import ImageError
from libraries.base import BaseSheypoorLibrary
from request import Session
from . import settings
from .models import ImageSet, Image


class Images(BaseSheypoorLibrary):

    platform_list: List[str] = ['web', 'mobile', 'android', 'ios', 'api', ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.__create_remote_image_directory()
        self.__remove_old_images()
        self.client = Session(exception=ImageError, retry_count=3, timeout=15)

    @keyword(name='Select Images')
    def select_images(self, category: str, count: Union[str, int] = 3, listing_id: str = None) -> ImageSet:
        count = int(count)
        if listing_id is None:
            return ImageSet.select_by_category(category).random_images(count)
        try:
            listing_images = ImageSet.select_by_listing_id(listing_id)
        except:
            return self.select_images(category, count)
        if len(listing_images) < count:
            return listing_images + ImageSet.select_by_category(category).random_images(count - len(listing_images))
        elif len(listing_images) > count:
            return ImageSet(image_list=listing_images[:count])
        return listing_images

    @keyword(name='Get Listing Images')
    def get_listing_images(self, listing_id: str) -> ImageSet:
        return ImageSet.select_by_listing_id(listing_id)

    @keyword(name='Upload Images Using API')
    def upload_images(self, image_list: Union[ImageSet, Image]) -> List[Dict[str, Any]]:
        upload_url = f'{self.env.url}/api/v{self.env.general_api_version}/listings/images'
        file_version: str = os.getenv('file_version')
        results = []
        if isinstance(image_list, ImageSet):
            for i in image_list:
                response = self.client.post(
                    url=upload_url,
                    files={'file': (i.name, i.content, 'image/jpeg')},
                    headers={'X-AGENT-TYPE': 'Android App', 'App-Version': file_version}
                )
                response.is_valid(raise_exception=True)
                results.append({'imageKey': response.body.get('imageKey'), 'isPrimary': False})
            results[0]['isPrimary'] = True
        elif isinstance(image_list, Image):
            response = self.client.post(
                url=upload_url,
                files={'file': (image_list.name, image_list.content)},
                headers={'X-AGENT-TYPE': 'Android App', 'App-Version': file_version}
            )
            response.is_valid(raise_exception=True)
            results.append({'imageKey': response.body.get('imageKey'), 'isPrimary': True})
        return results

    @staticmethod
    def __create_remote_image_directory():
        os.makedirs(settings.today_listing_image_path, exist_ok=True)

    @staticmethod
    def __remove_old_images():
        for directory in os.listdir(settings.listing_image_path):
            if datetime.strptime(directory, '%Y%m%d') < datetime.now() - timedelta(days=1):
                shutil.rmtree(os.path.join(settings.base_dir, 'listings', directory), ignore_errors=True)

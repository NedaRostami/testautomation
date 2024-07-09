import os
import random
from typing import List

from exceptions import ImageError
from .. import settings
from ..utils import Utils
from . import Image


class ImageSet:

    def __init__(self, image_list: List[Image] = None):
        self._image_list: List[Image] = image_list if image_list else list()

    @property
    def image_list(self) -> List[Image]:
        return self._image_list

    @image_list.setter
    def image_list(self, value: List[Image]):
        if not isinstance(value, list):
            raise ImageError(f'expected list but got {type(value).__name__}')
        for i in value:
            if not isinstance(i, Image):
                raise ImageError(f'item should be an Image but is {type(i).__name__}')
        self._image_list: List[Image] = value

    @classmethod
    def select_by_category(cls, category: str) -> 'ImageSet':
        mapped_category: str = Utils.map_category(category)
        image_path_list: List[str] = Utils.listdir_full_path(
            os.path.join(settings.static_image_path, mapped_category))
        if not image_path_list:
            raise ImageError(f'could not find any images for category {category}')
        image_list: List[Image] = [Image.by_category(i) for i in image_path_list]
        image_set: ImageSet = cls(image_list=image_list)
        return image_set

    @classmethod
    def select_by_listing_id(cls, listing_id: str) -> 'ImageSet':
        listing_image_path_list: List[str] = Utils.listdir_full_path(
            os.path.join(settings.today_listing_image_path, listing_id))
        print(listing_image_path_list)
        if not listing_image_path_list:
            raise ImageError(f'could not find any images for listing {listing_id}')
        image_list: List[Image] = [Image.by_listing_id(i) for i in listing_image_path_list]
        image_set: ImageSet = cls(image_list=image_list)
        return image_set

    @classmethod
    def save_by_url(cls, listing_id: str, url_list: List[str]) -> 'ImageSet':
        image_list = [Image.by_url(listing_id, i) for i in url_list]
        if not image_list:
            raise ImageError(f'could not fetch any images from given url list: {url_list}')
        image_set = cls(image_list=image_list)
        return image_set

    def random_images(self, count: int) -> 'ImageSet':
        if count > len(self.image_list):
            raise ImageError(f'Could not find {count} images, only {len(self.image_list)} is available')
        self.image_list = random.sample(self.image_list, int(count))
        return self

    def __add__(self, other: 'ImageSet') -> 'ImageSet':
        if not isinstance(other, ImageSet):
            raise ImageError(f'unsupported operand type should be ImageSet instead of {type(other).__name__}')
        self.image_list += other.image_list
        return self

    def __sub__(self, other: int) -> 'ImageSet':
        if not isinstance(other, int):
            raise ImageError(f'unsupported operand type should be int instead of {type(other).__name__}')
        if other < len(self.image_list):
            raise ImageError(f'image_list count could not be lower than zero')
        self.image_list = self.image_list[:-other]
        return self

    def __getitem__(self, item):
        return self.image_list[item]

    def __str__(self) -> str:
        return f'ImageSet: {len(self)} images'

    def __repr__(self) -> str:
        return self.__str__()

    def __len__(self) -> int:
        return self.image_list.__len__()

import base64
import os
import uuid
from typing import List

from exceptions import ImageError
from request import Request, Response
from .. import settings


class Image:

    name: str = None
    file_path: str = None
    category: str = None
    url: str = None
    listing_id: str = None
    content: bytes = None

    def __init__(self, **kwargs):
        self.name: str = kwargs.get('name')
        self.file_path: str = kwargs.get('file_path')
        self.url: str = kwargs.get('url')
        self.category: str = kwargs.get('category')
        self.listing_id: str = kwargs.get('listing_id')
        self.content: bytes = kwargs.get('content')
        self.client: Request = Request(retry=True, retry_count=3, timeout=10, exception=ImageError)

    @classmethod
    def by_category(cls, file_path: str) -> 'Image':
        split_path = cls.__split_path(file_path)
        print(split_path)
        content = cls.__read_file(file_path)
        image = cls(name=split_path[-1], file_path=file_path, category=split_path[-2], content=content)
        return image

    @classmethod
    def by_listing_id(cls, file_path: str) -> 'Image':
        print(file_path)
        split_path = cls.__split_path(file_path)
        content = cls.__read_file(file_path)
        image = cls(name=split_path[-1], file_path=file_path, listing_id=split_path[-2], content=content)
        return image

    @classmethod
    def by_url(cls, listing_id: str, url: str) -> 'Image':
        url = url.replace("www.sheypoor", "cdn.sheypoor")
        client: Request = Request(retry=True, retry_count=3, timeout=5, exception=ImageError)
        response: Response = client.get(url=url)
        response.is_valid(raise_exception=True)
        image = cls(url=url, listing_id=listing_id, content=response.content)
        image.generate_name()
        image.save_image()
        return image

    @property
    def base64(self) -> bytes:
        return base64.b64encode(self.content)


    def generate_name(self, name: str = None) -> str:
        self.name: str = name if name else uuid.uuid4().hex.upper()[0:6]
        self.name: str = f'{self.name}{settings.IMAGE_EXTENSION}'
        return self.name

    def save_image(self) -> str:
        directory_path = os.path.join(settings.today_listing_image_path, self.listing_id)
        self.file_path = os.path.join(directory_path, self.name)
        os.makedirs(directory_path, exist_ok=True)
        with open(self.file_path, 'wb') as file:
            file.write(self.content)
        return self.file_path

    @staticmethod
    def __read_file(file_path: str) -> bytes:
        with open(file_path, 'rb') as f:
            content: bytes = f.read()
        return content

    @staticmethod
    def __split_path(file_path: str) -> List[str]:
        return file_path.split(os.sep)

    def __str__(self) -> str:
        return f'Image {self.name}'

    def __repr__(self) -> str:
        return self.__str__()

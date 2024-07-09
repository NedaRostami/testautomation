import os
from typing import List

from exceptions import ImageError
from .. import settings


class Utils:

    @staticmethod
    def map_category(category: str) -> str:
        if category in settings.category_map.keys():
            return settings.category_map[category]
        elif category in settings.category_map.values():
            return category
        raise ImageError(f'Please provide a valid category id or one of: '
                         f'{", ".join(settings.category_map.values())}')

    @staticmethod
    def listdir_full_path(directory: str) -> List[str]:
        return [f'{os.path.join(directory, i)}' for i in os.listdir(directory)]

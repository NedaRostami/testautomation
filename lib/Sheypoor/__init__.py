import os
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from . import libraries
from .pylibcore import DynamicCore


class Sheypoor(DynamicCore):

    ALL_PLATFORMS = 'all'

    def __init__(self, platform: str, *args, **kwargs):
        platform = platform.lower()
        library_list = []
        for i in libraries.__all__:
            obj = getattr(libraries, i)
            if platform in obj.platform_list or platform == self.ALL_PLATFORMS:
                library_list.append(obj(*args, **kwargs))
        super().__init__(library_list)

from typing import List, Union
from exceptions import SheypoorError

from environment import Environment


class BaseSheypoorLibrary:

    platform_list: List[str] = None

    def __init__(self, env: Union[str, Environment], *args, **kwargs):
        if self.platform_list is None:
            raise SheypoorError("platform list should be set in libraries")
        self.general_api_version = kwargs.get('general_api_version', '6.4.0')
        self.ServerType = kwargs.get('ServerType', 'PR')
        self.env = env if isinstance(env, Environment) else Environment(env, self.general_api_version, self.ServerType)

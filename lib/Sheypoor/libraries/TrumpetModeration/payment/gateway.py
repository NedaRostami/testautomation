from typing import Tuple, Dict

from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from request import Response


class Gateway(BaseTrumpetModeration):

    __VALID_GATEWAY_LIST: Tuple[str] = ('success', 'failure', 'default',)

    def set(self, _type: str):
        data = self.__create_request_data(_type)
        url = f'{self.env.url}/trumpet/test-settings'
        response: Response = self.client.post(url, data=data)
        response.is_valid(raise_exception=True)

    def __create_request_data(self, _type: str) -> Dict[str, str]:
        _type = _type.lower()
        self.__validate_type(_type)
        data = {'payment': _type}
        return data

    def __validate_type(self, _type: str):
        if _type not in self.__VALID_GATEWAY_LIST:
            raise TrumpetModerationError(f'gateway input should be one of {", ".join(self.__VALID_GATEWAY_LIST)}')

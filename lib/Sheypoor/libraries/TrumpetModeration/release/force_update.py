from concurrent.futures import ThreadPoolExecutor
from typing import Tuple, List

from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration


class ForceUpdate(BaseTrumpetModeration):

    __VALID_OS_LIST: Tuple[str] = ('Android', 'iOS',)

    def delete_release_list(self, os_type: str):
        self.__validate_os_type(os_type)
        release_list: List[str] = self.fetch_release_list(os_type)
        with ThreadPoolExecutor(max_workers=5) as executor:
            executor.map(self.__request_delete_release, release_list)

    def fetch_release_list(self, os_type: str) -> List[str]:
        url = f'{self.env.url}/trumpet/settings/app-releases/fetch'
        response = self.client.get(url)
        response.is_valid(raise_exception=True)
        app_releases = response.body.get('data', {}).get('app-releases')
        release_list = [i.get('ID') for i in app_releases if i.get('OS') == os_type]
        return release_list

    def __validate_os_type(self, os_type: str):
        if os_type not in self.__VALID_OS_LIST:
            raise TrumpetModerationError(f'os_type should be one of {", ".join(self.__VALID_OS_LIST)}')

    def __request_delete_release(self, release: str):
        url = f'{self.env.url}/trumpet/settings/app-releases/delete/{release}'
        response = self.client.delete(url)
        response.is_valid(raise_exception=True)

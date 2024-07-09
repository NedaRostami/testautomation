import logging
from typing import Dict

import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from requests.models import Response

from .base import BaseRequestDecorator
from .response import ResponseDecorator

logging.getLogger('chardet').setLevel(logging.WARNING)


class RequestDecorator(BaseRequestDecorator):

    def _get(self, url: str, params: Dict = None, **kwargs) -> ResponseDecorator:
        response: Response = requests.get(url, params=params, timeout=self.timeout, **kwargs)
        return self._decorate_response(response)

    def _post(self, url: str, data: Dict = None, json: Dict = None, **kwargs) -> ResponseDecorator:
        response: Response = requests.post(url, data, json, timeout=self.timeout, **kwargs)
        return self._decorate_response(response)

    def _put(self, url: str, data: Dict = None, **kwargs) -> ResponseDecorator:
        response: Response = requests.put(url, data, timeout=self.timeout, **kwargs)
        return self._decorate_response(response)

    def _delete(self, url: str, **kwargs) -> ResponseDecorator:
        response: Response = requests.delete(url, timeout=self.timeout, **kwargs)
        return self._decorate_response(response)


class SessionDecorator(BaseRequestDecorator):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.session = requests.session()
        retry = Retry(connect=3, backoff_factor=0.7)
        adapter = requests.adapters.HTTPAdapter(pool_connections=5000, pool_maxsize=5000, max_retries=retry, pool_block=False)
        self.session.mount('http://', adapter)
        self.session.mount('https://', adapter)
        # self.session.keep_alive = False
        self.session.auth = self.auth
        self.session.headers.update(self.headers)

    def _get(self, url: str, params: Dict = None, **kwargs) -> ResponseDecorator:
        response: Response = self.session.get(url, params=params, timeout=self.timeout, **kwargs)
        return self._decorate_response(response)

    def _post(self, url: str, data: Dict = None, json: Dict = None, **kwargs) -> ResponseDecorator:
        response: Response = self.session.post(url, data, json, timeout=self.timeout, **kwargs)
        return self._decorate_response(response)

    def _put(self, url: str, data: Dict = None, **kwargs) -> ResponseDecorator:
        response: Response = self.session.put(url, data, timeout=self.timeout, **kwargs)
        return self._decorate_response(response)

    def _delete(self, url: str, **kwargs) -> ResponseDecorator:
        response: Response = self.session.delete(url, timeout=self.timeout, **kwargs)
        return self._decorate_response(response)

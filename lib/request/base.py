import time
from urllib3.exceptions import NewConnectionError
from typing import Dict, Callable, Tuple

import requests
from requests.models import Response

from robot.api.logger import info, console

from .exceptions import RequestError
from request.response import ResponseDecorator

from . import settings

import os
base_dir: str = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'request/keys')
key_path: str = os.path.join(base_dir, 'mielse-com_certChain.pem')
# key_path: str = os.path.abspath("auto-tests/lib/request/keys/mielse-com_certChain.pem")

class AbstractBaseRequestDecorator:


    def _get(self, url: str, verify=False, params: Dict = None, **kwargs):
        raise NotImplemented()

    def _post(self, url: str, verify=False, data: Dict = None, json: Dict = None, **kwargs):
        raise NotImplemented()

    def _put(self, url: str, verify=False, data: Dict = None, **kwargs):
        raise NotImplemented()

    def _delete(self, url: str, verify=False, **kwargs):
        raise NotImplemented()


class BaseRequestDecorator(AbstractBaseRequestDecorator):

    def __init__(self, retry_count: int = 3, timeout: int = 10, exception=RequestError,
                 retry_timeout: int = 2, raise_exception=True, **kwargs):
        if retry_count <= 0:
            raise RequestError("provide a valid retry_count")
        self.retry_count: int = retry_count
        self.retry_timeout: int = retry_timeout
        self.timeout: int = timeout
        self.exception = exception
        self.raise_exception = raise_exception
        self.headers: Dict[str, str] = kwargs.get('headers', settings.headers)
        self.auth: Tuple = settings.auth

    def get(self, url: str, params: Dict = None, **kwargs) -> ResponseDecorator:
        return self.__send_request(self._get, url, params, **kwargs)

    def post(self, url: str, data: Dict = None, json: Dict = None, **kwargs):
        return self.__send_request(self._post, url, data, json, **kwargs)

    def put(self, url: str, data: Dict = None, **kwargs):
        return self.__send_request(self._put, url, data, **kwargs)

    def delete(self, url: str, **kwargs):
        return self.__send_request(self._delete, url, **kwargs)

    def _decorate_response(self, response: Response):
        return ResponseDecorator(response=response, exception=self.exception)

    def __send_request(self, method: Callable, *args, **kwargs) -> ResponseDecorator:
        _error = None
        headers = self.headers.copy()
        if 'headers' in kwargs:
            headers.update(kwargs.pop('headers'))
        for i in range(self.retry_count):
            try:
                info(f'requesting {args[0]}')
                console(f'requesting {args[0]}')
                response: ResponseDecorator = method(headers=headers, verify=key_path, auth=self.auth, *args, **kwargs)
                response.is_valid(raise_exception=self.raise_exception)
                return response
            except (requests.ReadTimeout, requests.ConnectTimeout, requests.Timeout, ConnectionError, NewConnectionError) as e:
                info(f"retry errors: {e}")
                _error = e
                continue
            except self.exception as e:
                info(f"retry errors: {e}")
                time.sleep(self.retry_timeout)
                _error = e
                continue
        raise self.exception(f"{method.__name__} {args[0]} encountered an error: {_error}")

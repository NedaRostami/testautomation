from typing import Dict

from json.decoder import JSONDecodeError

from requests.models import Response
from requests.models import Request


class ResponseDecorator:

    def __init__(self, response: Response, exception=Exception):
        self.response: Response = response
        self.request: Request = response.request
        self.exception = exception
        self.body = self.__get_body()

    @property
    def status_code(self) -> int:
        return self.response.status_code

    @property
    def text(self) -> str:
        return self.response.text

    @property
    def headers(self) -> Dict[str, str]:
        return self.response.headers

    @property
    def content(self):
        return self.response.content

    @property
    def url(self):
        return self.response.url

    @property
    def history(self):
        return self.response.history

    def is_valid(self, validate_success: bool = False, raise_exception: bool = True) -> bool:
        if not validate_success and self.__status_code_valid():
            return True
        if validate_success and (self.__body_success_valid() and self.__status_code_valid()):
            return True
        if raise_exception is True:
            self.raise_exception_failed_status()

    def raise_exception_failed_status(self):
        raise self.exception(f"{self.response.request.method} {self.response.request.url}"
                             f" responded with status {self.response.status_code} and body:"
                             f"{self.response.text}")

    def __status_code_valid(self) -> bool:
        return self.response.status_code < 400

    def __body_success_valid(self) -> bool:
        return False if ('success' in self.body and not self.body.get('success')) else True

    def __get_body(self):
        try:
            body = self.response.json()
        except JSONDecodeError:
            body = self.response.text
        return body

from exceptions import MockError
from ..base import BaseMock


class Throttle(BaseMock):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.base_url = f"{self.env.url}/trumpet/mock/captcha-code"


    def get_throttling_code(self, token: str):
        url = self.base_url + f'/{token}'
        response = self.client.get(url)
        response.is_valid(validate_success=True, raise_exception=True)
        code = response.body.get('data', {}).get('code')
        if code is None:
            raise MockError('could not fetch throttling code')
        return code

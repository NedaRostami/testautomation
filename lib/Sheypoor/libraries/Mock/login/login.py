import time

from exceptions import MockError
from ..base import BaseMock


class Login(BaseMock):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = f"{self.env.url}/mock/getCode"
        self.login_url = f"{self.env.url}/api/v{self.env.file_version}/auth/state-request"


    def get_verification_code(self, number: str, retry: int = 3):
        if retry < 0:
            raise MockError('could not fetch login code')
        response = self.client.get(self.url, params={"mobile": number})
        response.is_valid(validate_success=True, raise_exception=True)
        print(response.body)
        code = response.body.get('code')
        if code is None:
            response = self.client.post(self.login_url,
                                        json={'username': number},
                                        headers={'X-AGENT-TYPE': 'Android App', 'App-Version': self.env.file_version,
                                                 'user-agent': f'Android/8.1 Sheypoor/{self.env.file_version}-Debug-PlayStore '
                                                 'VersionCode/594 Manufacturer/Samsung Model/Samsung Galaxy '
                                                 'S10 E - 8.1 - API 27 - 1080x2280'})
            message = response.body.get('message')
            if message == "یک کد تایید به شماره موبایل شما ارسال شد":
                time.sleep(2)
                code = self.get_verification_code(number, retry - 1)
        return code

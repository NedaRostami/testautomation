from exceptions import JsonServerError
from request import Session
from environment import Environment

class BaseJsonServer:

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # self.client = Session(retry=True, exception=JsonServerError, headers={'X-AGENT-TYPE': 'Android App', 'App-Version': f'{self.env.general_api_version}'})
        self.client = Session(retry=True, exception=JsonServerError, headers={'X-AGENT-TYPE': 'Android App', 'App-Version': '5.8.1'})

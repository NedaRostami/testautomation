from exceptions import MockError
from request import Request
from environment import Environment


class BaseMock:

    client: Request = Request(exception=MockError, retry_count=3, timeout=10)

    def __init__(self, env: Environment):
        self.env = env

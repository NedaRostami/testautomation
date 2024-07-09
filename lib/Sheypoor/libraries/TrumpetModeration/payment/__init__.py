from environment import Environment
from request import Session

from .gateway import Gateway


class Payment:

    def __init__(self, env: Environment, client: Session):
        self.gateway = Gateway(env, client)

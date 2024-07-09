from environment import Environment
from request import Session

from .prices import Prices


class Packages:

    def __init__(self, env: Environment, client: Session):
        self.prices = Prices(env, client)

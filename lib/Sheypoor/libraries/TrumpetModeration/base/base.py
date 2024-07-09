from environment import Environment
from request import Session


class BaseTrumpetModeration:

    def __init__(self, env: Environment, client: Session):
        self.env: Environment = env
        self.client: Session = client

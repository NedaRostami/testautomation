from environment import Environment
from request import Session
from .force_update import ForceUpdate


class Release:

    def __init__(self, env: Environment, client: Session):
        self.force_update = ForceUpdate(env, client)

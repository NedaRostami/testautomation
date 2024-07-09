from environment import Environment
from request import Session

from .block_reasons import BlockReasons

class Settings:

    def __init__(self, env: Environment, client: Session):
        self.block_reasons = BlockReasons(env, client)

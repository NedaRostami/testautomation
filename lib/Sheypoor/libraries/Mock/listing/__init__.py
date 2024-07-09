from environment import Environment
from .moderate import Moderate
from .expire import Expire
from .shift import Shift
from .bump import Bump


class Listing:

    def __init__(self, env: Environment):
        self.moderation = Moderate(env)
        self.expire = Expire(env)
        self.shift = Shift(env)
        self.bump = Bump(env)

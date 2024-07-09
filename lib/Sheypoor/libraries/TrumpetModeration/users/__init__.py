from environment import Environment
from request import Session
from .user_comments import UserComments
from .search_users import SearchUsers


class Users:

    def __init__(self, env: Environment, client: Session):
        self.user_comments = UserComments(env, client)
        self.search_users = SearchUsers(env, client)

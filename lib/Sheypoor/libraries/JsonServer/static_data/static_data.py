from typing import Dict, List

from environment import Environment
from ..base import BaseJsonServer


class StaticData(BaseJsonServer):

    id_list: List[str] = ['categoryID', 'attributeID', 'optionID', 'provinceID', 'cityID', 'districtID']

    def __init__(self, env: Environment, general_api_version: str):
        super().__init__()
        self.env: Environment = env
        self.general_api_version: str = general_api_version
        self.url: str = f'http://qa2.mielse.com:9500/static-data/{self.env.trumpet_prenv_id}/v{self.env.general_api_version}'


    def get_object(self):
        raise NotImplemented("implement on children")

    def _get_id(self, body: Dict[str, str]) -> str:
        for i in self.id_list:
            if i in body:
                return body.get(i)
        raise Exception("could not get ID")

    @staticmethod
    def _add_to_url(key, value):
        return f'/{key}/{value}'

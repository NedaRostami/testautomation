from typing import Dict

from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from request import Response

class BlockReasons(BaseTrumpetModeration):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = f'{self.env.url}/trumpet/settings/chat-block-reasons'


    def new(self, reason: str, placeholder: str, priority: int, analytics_key: str, has_input: int):
        data_form: Dict = {"Reason": reason, "PlaceHolder": placeholder, "Priority": priority,
                            "AnalyticsKey": analytics_key, "HasInput": has_input}
        response: Response = self.client.post(f'{self.url}/new', data=data_form)
        response.is_valid(raise_exception=True)
        block_reasons = self.search(reason)
        block_reasons_id = []
        for block_reason in block_reasons:
            block_reasons_id.append(block_reason['ID'])
        block_reasons_id.sort(reverse=True)
        latest_created_block_reason_id = block_reasons_id[0]
        return latest_created_block_reason_id

    def search(self, reason: str):
        data_form: Dict = {"q": reason}
        response: Response = self.client.post(f'{self.url}/fetch', data=data_form)
        response.is_valid(raise_exception=True)
        results = response.body.get('data', {}).get('chatBlockReasons', {})
        return results

    def delete(self, id: str):
        response: Response = self.client.delete(f'{self.url}/delete/{id}')
        response.is_valid(raise_exception=True)

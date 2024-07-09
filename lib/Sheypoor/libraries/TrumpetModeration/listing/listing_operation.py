from typing import Dict, List

from libraries.TrumpetModeration.base import BaseTrumpetModeration
from request import Response

class ListingOperation(BaseTrumpetModeration):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = f'{self.env.url}/trumpet/listing'

    def delete(self, ids: List, msg: str, notify: str, delete_reason_id: str):
        form_data: Dict = {"message": msg, "notify": notify, "deleteReasonId": delete_reason_id}
        for id in ids:
            form_data["id"] = id
            response: Response = self.client.post(url=f'{self.url}/delete', data=form_data)
            response.is_valid(raise_exception=True, validate_success=True)

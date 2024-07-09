from typing import Dict, Any

from exceptions import MockError
from libraries.Mock.base import BaseMock


class PushNotification(BaseMock):

    # FIXME: Firebase auth is not working
    __FIREBASE_AUTH = 'key=AIzaSyAUnHxzUiZX75EZ2qKYKMcV-9IdIQdJKOQ'
    __HEADERS = {'Authorization': __FIREBASE_AUTH, 'Content-Type': 'application/json', }
    __DEFAULT_BUTTONS = [
                {
                    "viewID": 1,
                    "text": "آگهی جدید",
                    "link": ""
                },
                {
                    "offerId": "22751311",
                    "viewID": 3,
                    "text": "مشاهده آگهی",
                    "link": ""
                }
            ]

    def send(self, firebase_token: str, message: str, buttons: Dict[str, Any], image_url: str):
        raise MockError('Update firebase authentication and remove this line')
        if buttons is None:
            buttons = self.__DEFAULT_BUTTONS
        data = {
            "to": firebase_token,
            "data": {
                "jsonButton": {
                    "messageId": 1926242033,
                    "buttons": buttons,
                    "title": "شیپور",
                    "message": message,
                    "iconUrl": "",
                    "link": "",
                    "NotificationPageImage": image_url,
                    "type": 1
                }
            },
            "priority": "high"
        }
        response = self.client.post('http://fcm.googleapis.com/fcm/send', json=data)
        response.is_valid(raise_exception=True)

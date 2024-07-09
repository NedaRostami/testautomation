from typing import Union,Tuple, Dict, List

from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from request import Response
import robot.api.logger as logger
from robot.utils.asserts import fail

import lxml.html
import json
import re
import random

class History(BaseTrumpetModeration):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = f'{self.env.url}/trumpet/listing/moderation?AdsId='

    def check_blacklist(self, listing_id: Union[str, int]):
        is_blacklisted = False
        moderation_form = self.get_listing_history(listing_id)

        for history in moderation_form['params']['history']:
            if history['status'] == 'آگهی مسدود شده':
                is_blacklisted = True
                break

        return is_blacklisted

    def get_listing_history(self, listing_id: Union[str, int]):
        history_url = f'{self.url}{listing_id}'
        response: Response = self.client.get(history_url)

        history_page = lxml.html.fromstring(response.content)
        moderation_form = history_page.xpath('/html/body/main/comment()[3]')[0]
        moderation_form = str(moderation_form).replace("<!-- ko component: ", "").replace(" -->", "")

        moderation_form = moderation_form.strip()
        error = moderation_form[:moderation_form.index("{\"name\":\"moderation-form\"")]

        if error != "":

            logger.error(error, html=True)
            moderation_form = moderation_form.split("</b><br />")[-1]
            # moderation_form = json.loads(moderation_form)
            logger.trace(moderation_form)
            # fail(msg="there is Problem in checking black list status.  see the  Is BlackListed keyword")
            # return False

        # moderation_form = re.findall(r'.*{\"name\":\"moderation-form\".*', moderation_form)[0]
        moderation_form = json.loads(str(moderation_form))
        print(json.dumps(moderation_form, indent=4, sort_keys=False, ensure_ascii=False))
        return moderation_form

    def random_rejection_deletion_reasons(self, listing_id: Union[str, int], type:str):
        admin_data = self.get_admin_data(listing_id)
        result = admin_data['params'][f'{type}Reasons']
        Reasons = [d['name'] for d in result]
        Reason = random.choice(Reasons)
        return Reason

    def get_admin_data(self, listing_id: Union[str, int]):
        admin_data_url = f'{self.url}{listing_id}'
        response: Response = self.client.get(admin_data_url)

        admin_data_page = lxml.html.fromstring(response.content)
        admin_data_form = admin_data_page.xpath('/html/body/main/comment()[1]')[0]
        admin_data_form = str(admin_data_form).replace("<!-- ko component: ", "").replace(" -->", "")

        admin_data_form = admin_data_form.strip()
        admin_data_form = json.loads(str(admin_data_form))
        # print(json.dumps(admin_data_form, indent=4, sort_keys=False, ensure_ascii=False))
        return admin_data_form

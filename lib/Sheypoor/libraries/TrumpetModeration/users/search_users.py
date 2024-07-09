from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from typing import Union, Dict


class SearchUsers(BaseTrumpetModeration):


        def change_user_profile_photo_status(self, name: str, phone: str, activity_status: str,
        seller_type: str, photo_status: str, change_status: str):
            users = self.search(name = name, phone = phone, activity_status = activity_status,
            seller_type = seller_type, photo_status = photo_status)
            if users:
                user = users[0]
                user_id = user['ID']
                id_status = user['IDStatus']
                data: Dict = {'Id': user_id, 'IDStatus': id_status}
                if change_status == 'accept':
                    profile_photo = user['ProfilePhoto']
                    data['ProfilePhoto'] = profile_photo
                elif change_status == 'reject':
                    data['RemoveProfilePhoto'] = True
                else:
                    raise Exception('Enter one of the accept or reject modes to change the profile photo status')
                response: Response = self.client.post(
                    url=f'{self.env.url}/trumpet/user/edit',data=data)
                response.is_valid(raise_exception=True, validate_success=True)
            else:
                raise Exception('Could not find this user')


        def search(self, start_date: Union[str, int] = None, end_date: Union[str, int] = None, user_id: Union[str, int] = None,
        name: str = None, email: str = None, unique_id: str = None, ip: str = None, phone: str = None, activity_status: Union[str, int] = None,
        suspicious: Union[str, int] = None, seller_type: str = None, name_status: str = None, photo_status: Union[str, int] = None, sort: str = None):
            response: Response = self.client.post(
                url=f'{self.env.url}/trumpet/user/fetch',
                data={'date_from': start_date, 'date_to': end_date, 'id': user_id,
                    'first_name': name, 'email': email, 'uuid': unique_id,
                    'ip': ip, 'phone': phone, 'status': activity_status,
                    'is_suspicious': suspicious, 'seller_type': seller_type,
                    'first_name_status': name_status, 'photo_status': photo_status, 'sort': sort}
            )
            response.is_valid(raise_exception=True, validate_success=True)
            users = response.body.get('data', {}).get('user', {})
            return users

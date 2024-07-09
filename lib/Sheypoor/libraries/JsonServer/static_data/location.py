from typing import Dict, Union

from request import Response
from exceptions import JsonServerError
from .static_data import StaticData


class Location(StaticData):

    def get_object(self, location: str = None, city: str = None,
                   district: str = None, id: bool = False) -> Union[Dict[str, str], str]:

        url = self.url

        if city and not location:
            raise JsonServerError('Please provide a location for city.')
        if district and not city:
            raise JsonServerError('Please provide a city for district')
        if location:
            url += '/locations/{}'.format(location)
        if city:
            url += '/cities/{}'.format(city)
        if district:
            url += '/districts/{}'.format(district)

        response: Response = self.client.get(url=url)
        location: Dict[str, str] = response.body
        if id:
            return self._get_id(location)
        return location

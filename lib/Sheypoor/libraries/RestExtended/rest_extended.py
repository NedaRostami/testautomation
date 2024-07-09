from typing import List
from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword

from libraries.base import BaseSheypoorLibrary

class RestExtended(BaseSheypoorLibrary):

    platform_list: List[str] = ['api', ]


    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.rest = BuiltIn().get_library_instance('REST')

    @keyword(name='Get String')
    def get_string(self, *args, **kwargs):
        value = self.rest.string(*args, **kwargs)
        return self.__get_value_from_list(value)

    @keyword(name='Get Integer')
    def get_integer(self, *args, **kwargs):
        value = self.rest.integer(*args, **kwargs)
        return self.__get_value_from_list(value)

    @keyword(name='Get Number')
    def get_number(self, *args, **kwargs):
        value = self.rest.number(*args, **kwargs)
        return self.__get_value_from_list(value)

    @keyword(name='Get Boolean')
    def get_boolean(self, *args, **kwargs):
        value = self.rest.boolean(*args, **kwargs)
        return self.__get_value_from_list(value)

    @keyword(name='Get Null')
    def get_null(self, *args, **kwargs):
        value = self.rest.null(*args, **kwargs)
        return self.__get_value_from_list(value)

    @keyword(name='Get Array')
    def get_array(self, *args, **kwargs):
        value = self.rest.array(*args, **kwargs)
        return self.__get_value_from_list(value)

    @keyword(name='Get Object')
    def get_object(self, *args, **kwargs):
        value = self.rest.object(*args, **kwargs)
        return self.__get_value_from_list(value)


    @staticmethod
    def __get_value_from_list(value):
        return value[0]

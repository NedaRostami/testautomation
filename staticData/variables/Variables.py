import re
import os
import json
from json import JSONDecodeError
from robot.api.logger import info, console

from lib.request import Request

class Variables:

    def __init__(self):
        self.json_server = 'http://qa2.mielse.com:9500'
        self.trumpet_prenv_id = ''
        self.version = ''
        self.server = ''
        self.client = Request(retry_count=3)

    def get_test_environment(self):
        subdomain = self.trumpet_prenv_id
        if re.match('\d{4,5}', self.trumpet_prenv_id):
            subdomain = 'pr{}'.format(self.trumpet_prenv_id)
        server = 'https://' + subdomain + '.mielse.com'
        return server

    def get_variables(self, trumpet_prenv_id='staging', version='6.4.0'):
        self.trumpet_prenv_id = trumpet_prenv_id
        self.version = version
        self.server = self.get_test_environment()
        variables = {
            'server': self.server,
            'version': self.version,
            'trumpet_prenv_id': self.trumpet_prenv_id,
            'json_server': self.json_server,
        }

        variables = self.set_static_vars(variables)

        return variables


    def set_static_vars(self, variables):
        variables.update(
            #Homepage
            home_title = "شیپور - نیازمندیهای رایگان خرید و فروش، استخدام و خدمات",

        )
        return variables

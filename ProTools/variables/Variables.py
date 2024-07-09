import re
import os

class Variables(object):

    def __init__(self):
        self.trumpet_prenv_id = ''
        self.server = ''
        self.version = ''
        self.ServerType = ''

    def get_test_environment(self):
        subdomain = self.trumpet_prenv_id
        # self.ServerType: bool = os.environ.get('ServerType', 'PR')
        if self.ServerType == 'ProTools':
            subdomain = 'protools{}'.format(self.trumpet_prenv_id)
        elif re.match(r'\d{4,5}', self.trumpet_prenv_id):
            subdomain = 'pr{}'.format(self.trumpet_prenv_id)
        elif self.ServerType == 'SheypoorX':
            subdomain = 'shx{}'.format(self.trumpet_prenv_id)
        server = 'https://' + subdomain + '.mielse.com'
        return server

    def get_variables(self, trumpet_prenv_id='staging', version='2', ServerType='PR'):
        self.trumpet_prenv_id = trumpet_prenv_id
        self.ServerType = ServerType
        self.server = self.get_test_environment()
        self.version = version

        variables = {
            'server': self.server,
            'version': self.version,
            'ServerType': self.ServerType,
            'trumpet_prenv_id': self.trumpet_prenv_id,
        }

        return variables

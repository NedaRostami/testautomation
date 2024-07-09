import re
from json import JSONDecodeError

from lib.request import Request


class Variables(object):

    def __init__(self):
        self.json_server = 'http://qa2.mielse.com:9500'
        self.trumpet_prenv_id = ''
        self.version = ''
        self.server = ''
        self.static_data = {}
        self.client = Request(retry_count=3, headers={'X-AGENT-TYPE': 'Android App', 'App-Version': '5.8.1'})

    def get_test_environment(self):
        subdomain = self.trumpet_prenv_id
        if re.match('\d{4,5}', self.trumpet_prenv_id):
            subdomain = 'pr{}'.format(self.trumpet_prenv_id)
        elif self.ServerType == 'SheypoorX':
            subdomain = 'shx{}'.format(self.trumpet_prenv_id)
        server = 'https://' + subdomain + '.mielse.com'
        return server

    def get_static_data(self):
        url = '{}/static-data/{}/v{}'.format(self.json_server, self.trumpet_prenv_id, self.version)
        backup_url = '{}/api/v{}/general/static-data'.format(self.server, self.version)
        static_data = self.client.get(url)

        if static_data.status_code >= 400:
            print('Cannot retrieve static data from json server: {}'.format(static_data.text))

        try:
            return static_data.body
        except JSONDecodeError:
            static_data = self.client.get(backup_url)

        if static_data.status_code >= 400:
            raise Exception('Cannot retrieve static data')

        return static_data.body

    def get_variables(self, trumpet_prenv_id='staging', version='6.4.0', ServerType='PR'):
        self.trumpet_prenv_id = trumpet_prenv_id
        self.version = version
        self.ServerType = ServerType
        self.server = self.get_test_environment()
        # self.static_data = self.get_static_data()

        variables = {
            'server': self.server,
            'version': self.version,
            'ServerType': self.ServerType,
            'trumpet_prenv_id': self.trumpet_prenv_id,
            'json_server': self.json_server,
            'static_data': self.static_data
        }

        return variables

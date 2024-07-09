import warnings
import re
import os

from robot.errors import DataError
import sentry_sdk



class Environment:

    URL_PATTERN: str = r'^http'
    PR_PATTERN: str = r'^\d{4,5}'
    PROTOOLS_PATTERN: str = r'protools'
    SHEYPOORX_PATTERN: str = r'shx'
    STAGING_PATTERN: str = r'staging'
    PRODUCTION_PATTERN: str = r'^sheypoor'
    HTTPS: str = 'https'
    ADMIN_STAGING: str = 'admin1060@mielse.com'
    ADMIN_PR: str = 'admin1060@mielse.com'
    ADMIN_PASSWORD: str = 'trumpet'


    def __init__(self, trumpet_prenv_id: str, general_api_version: str, ServerType: str):
        # self.trumpet_prenv_id: str = trumpet_prenv_id
        self.trumpet_prenv_id: str = os.environ.get('trumpet_prenv_id', trumpet_prenv_id)
        self.general_api_version: str = os.environ.get('general_api_version', general_api_version)
        self.file_version: str = os.environ.get('file_version', general_api_version)
        self.ServerType: str = os.environ.get('ServerType', ServerType)
        self.output_directory = os.environ.get('logs', 'Reports')
        self.type: str = 'custom'
        # for k, v in sorted(os.environ.items()):
        #     print(k+':', v)
        # print('\n')
        self._url: str = self.handle()
        self._admin_user: str = self.admin_user
        self._admin_password: str = self.admin_password
        sentry_sdk.init(
            "http://39766c11b72a4d9a94eeebb77dd56904@sentry.mielse.com/84",
            traces_sample_rate=1.0,
            environment=self.trumpet_prenv_id,
        )

    @property
    def url(self) -> str:
        return f'{self.HTTPS}://{self._url}'

    @property
    def admin_user(self) -> str:
        if self.is_pr:
            return self.ADMIN_PR
        else:
            return self.ADMIN_STAGING

    @property
    def admin_password(self) -> str:
        return self.ADMIN_PASSWORD

    @property
    def raw_url(self) -> str:
        return self._url

    @property
    def is_pr(self) -> bool:
        return self.type == 'pr'

    @property
    def is_protool(self) -> bool:
        return self.type == 'protools'

    @property
    def is_sheypoorx(self) -> bool:
        return self.type == 'sheypoorx'

    @property
    def is_staging(self) -> bool:
        return self.type == 'staging'

    @property
    def is_production(self) -> bool:
        return self.type == 'production'

    def handle(self) -> str:
        if self.ServerType == 'ProTools':
            return self.protool()
        if self.ServerType == 'SheypoorX':
            return self.sheypoorx()
        elif re.match(self.URL_PATTERN, self.trumpet_prenv_id):
            return self.trumpet_prenv_id
        elif re.match(self.PR_PATTERN, self.trumpet_prenv_id):
            return self.pr()
        elif re.match(self.STAGING_PATTERN, self.trumpet_prenv_id):
            return self.staging()
        elif re.match(self.PRODUCTION_PATTERN, self.trumpet_prenv_id):
            return self.production()
        raise DataError("Please provide a valid trumpet_prenv_id")

    def pr(self) -> str:
        self.type = 'pr'
        return f'pr{self.trumpet_prenv_id}.mielse.com'

    def sheypoorx(self) -> str:
        self.type = 'sheypoorx'
        return f'shx{self.trumpet_prenv_id}.mielse.com'

    def protool(self) -> str:
        self.type = 'protool'
        return f'protools{self.trumpet_prenv_id}.mielse.com'

    def staging(self) -> str:
        self.type = 'staging'
        return f'{self.trumpet_prenv_id}.mielse.com'

    def production(self) -> str:
        warnings.warn("you're testing in production environment!")
        self.type = 'production'
        return f'www.sheypoor.com'

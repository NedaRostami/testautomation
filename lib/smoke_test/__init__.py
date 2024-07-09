import os
from robot.api.deco import keyword

from .smoke_test import SmokeTest


@keyword(name='Run Smoke Test')
def run_smoke_test(trumpet_prenv_id: str, general_api_version: str, ServerType: str):
    os.environ['trumpet_prenv_id'] = trumpet_prenv_id
    os.environ['general_api_version'] = general_api_version
    os.environ['ServerType'] = ServerType
    s = SmokeTest(trumpet_prenv_id, general_api_version, ServerType)
    return s.execute()

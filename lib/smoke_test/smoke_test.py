import os
import unittest

from HtmlTestRunner import HTMLTestRunner

from environment import Environment
from smoke_test.base import BaseSmokeTestCase


class SmokeTest:

    def __init__(self, trumpet_prenv_id: str, general_api_version: str, ServerType: str):
        self.env = Environment(trumpet_prenv_id, general_api_version, ServerType)

    def execute(self) -> unittest.TestResult:
        suite = self.get_test_suite()
        runner = HTMLTestRunner(output=self.env.output_directory, report_name=f'{self.env.trumpet_prenv_id}_smoke_test_log',
                                report_title=f'Smoke test on {self.env.trumpet_prenv_id}',
                                combine_reports=True, add_timestamp=False)
        results = runner.run(suite)
        if not results.wasSuccessful():
            raise RuntimeError('Smoke Test Failed')

    def get_test_suite(self) -> unittest.TestSuite:
        import smoke_test.tests
        suite = unittest.TestSuite()
        test_loader = unittest.TestLoader()
        subclasses = BaseSmokeTestCase.__subclasses__()
        for subclass in subclasses:
            suite.addTest(test_loader.loadTestsFromTestCase(subclass))
        return suite

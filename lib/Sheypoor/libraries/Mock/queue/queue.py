from libraries.Mock.base import BaseMock


class Queue(BaseMock):

    def empty_default(self):
        response = self.client.get(f'{self.env.url}/trumpet/test-settings/empty-default-queue')
        response.is_valid(raise_exception=True, validate_success=True)

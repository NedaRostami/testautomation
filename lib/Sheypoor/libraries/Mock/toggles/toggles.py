from ..base import BaseMock


class Toggle(BaseMock):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url = f"{self.env.url}/trumpet/mock/features/toggle"
        # self.set('web', 'post-moderation', 1)
        # self.set('mobile', 'post-moderation', 1)
        # self.set('android', 'post-moderation', 1)
        # self.set('ios', 'post-moderation', 1)

    def get(self, source: str, name: str) -> bool:
        self.reset()
        response = self.client.get(self.url, params={"source": source, "name": name})
        response.is_valid(validate_success=True, raise_exception=True)
        data = response.body.get('data')
        status = data.get("status", None)
        return bool(status)

    def set(self, source: str, name: str, status: str) -> bool:
        data = {"name": name, "source": source, "status": status}
        response = self.client.post(self.url, data=data)
        print(response.body)
        self.reset()
        return response.is_valid(validate_success=True, raise_exception=True)

    def reset(self) -> bool:
        response = self.client.get(f'{self.env.url}/trumpet/mock/features/toggles/reset')
        print(response.body)
        return response.is_valid(validate_success=True, raise_exception=True)

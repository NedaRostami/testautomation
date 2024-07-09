from ..base import BaseMock


class Shift(BaseMock):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.url: str = f'{self.env.url}/trumpet/mock/timeShiftListing'

    def shift(self, shift_at: str, listing_id: str) -> bool:
        params = {'shiftAt': shift_at, 'listingId': listing_id, 'USERNAME': self.env.admin_user}
        response = self.client.get(url=self.url, params=params)
        return response.is_valid(validate_success=True, raise_exception=True)

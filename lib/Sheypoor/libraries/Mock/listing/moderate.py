from request import Response
from ..base import BaseMock


class Moderate(BaseMock):

    def moderate(self, action: str, listing_id: str) -> bool:
        ResetIsDone = True
        action = action.lower()
        url = f"{self.env.url}/trumpet/mock/{action}Listing?listingId={listing_id}&username={self.env.admin_user}"
        response: Response = self.client.get(url)
        MockeIsDone = response.is_valid(validate_success=True, raise_exception=True)
        if action == 'accept':
            url = f"{self.env.url}/{listing_id}"
            reset: Response = self.client.get(url)
            ResetIsDone = reset.is_valid(validate_success=False, raise_exception=True)
        ret = MockeIsDone and ResetIsDone
        return ret

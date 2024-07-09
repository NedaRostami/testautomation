from Sheypoor.libraries.Images import Images

from smoke_test.base import BaseSmokeTestCase


class ImageSmokeTest(BaseSmokeTestCase):

    def setUp(self) -> None:
        self.image_handler = Images(self.env)

    def test_image_upload_api(self) -> None:
        image_list = self.image_handler.select_images('cars', count=3)
        for i in image_list:
            response = self.client.post(url=f'{self.env.url}/api/v{self.env.general_api_version}/listings/images',
                                        files={'file': (i.name, i.content, 'image/jpeg')},
                                        headers={'X-AGENT-TYPE': 'Android App', 'App-Version': self.env.file_version})
            self.assertResponseStatusCodeLess(response, 400)
            self.assertIsInstance(response.body, dict, 'invalid image response')
            self.assertIn('imageKey', response.body, 'imageKey not found in image upload response')

    # def test_image_upload_protools(self) -> None:
    #     try:
    #         image_list = self.image_handler.select_images('cars', count=8)
    #         for i in image_list:
    #             response = self.client.post(url=f'{self.env.url}/api/protools/v2/image',
    #                                         files={'file': (i.name, i.content, 'image/jpeg')},
    #                                         headers={'X-AGENT-TYPE': 'Android App', 'App-Version': self.env.file_version})
    #             self.assertResponseStatusCodeLess(response, 400)
    #             self.assertIsInstance(response.body, dict, 'invalid image response')
    #             self.assertIn('id', response.body, 'id not found in protools image upload response')
    #     except :
    #         print(response.request)
    #         print("<br>")
    #         print(response.body)
    #     if response.status_code >= 400:
    #         self.assertResponseStatusCodeLess(response, 400)
    #
    # def test_image_upload_protools_base64(self) -> None:
    #     try:
    #         image_list = self.image_handler.select_images('personal', count=8)
    #         for i in image_list:
    #             response = self.client.post(url=f'{self.env.url}/api/protools/v2/image',
    #                                         json={'image': i.base64.decode('utf-8')},
    #                                         headers={'X-AGENT-TYPE': 'Android App', 'App-Version': self.env.file_version})
    #             self.assertResponseStatusCodeLess(response, 400)
    #             self.assertIsInstance(response.body, dict, 'Invalid protools base64 response')
    #             self.assertIn('id', response.body, 'id not found in protools base64 response')
    #     except :
    #         print(response.request)
    #         print("<br>")
    #         print(response.body)
    #     if response.status_code >= 400:
    #         self.assertResponseStatusCodeLess(response, 400)

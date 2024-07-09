from exceptions import TrumpetModerationError
from libraries.TrumpetModeration.base import BaseTrumpetModeration
from typing import Union,List, Dict
import lxml.html


class Landing(BaseTrumpetModeration):

    def create(self, path: str, params: str, title: str, description: str, activity: Union[str, int],
            alternativeTitle: str, anchorTitle: str, cat1: str, cat2: str, province1: str, city1: str,
            district1: str, province2: str, city2: str, district2: str, allNeighborhoods: Union[str, int],
            redirectPath: str, searchTerms: str, redirectCode: Union[str, int], content: str, note: str, faq: str):
            create_data: Dict = {
                'Path': '/' + path, 'Params': 'q=' + params, 'IsActive': activity, 'Title': title,
                'AlternativeTitle': alternativeTitle, 'AnchorTitle': anchorTitle,
                'Description': description, 'CategoriesLandingShow[]': cat1,
                'CategoriesShowLanding[]': cat2, 'CategoriesRegion': province1,
                'CategoriesCity': city1, 'CategoriesNeighborhood': district1,
                'Region': province2, 'City': city2, 'Neighborhood': district2,
                'ExtendedLocation': allNeighborhoods, 'SearchTerms': searchTerms,
                'RedirectCode': redirectCode, 'Content': content, 'Note': note, 'Faq': faq
                                }
            if redirectPath:
                create_data['RedirectTo'] = '/' + redirectPath
            if content:
                create_data['Content'] = '<p>' + content + '</p>'

            response = self.client.post(
                url=f'{self.env.url}/trumpet/landings/new',
                data=create_data
            )
            response.is_valid(raise_exception=True, validate_success=True)

            results = self.search(path, activity)
            results_id = []
            for result in results:
                results_id.append(result['ID'])
            results_id.sort(reverse=True)
            return results_id[0]


    def edit_by_search(self, searchPath: str, searchActivity: Union[str, int], path: str, params: str,
            activity: Union[str, int], title: str, alternativeTitle: str, anchorTitle: str, description: str,
            cat1: str, cat2: str, province1: str, city1: str, district1: str, province2: str, city2: str, district2: str,
            allNeighborhoods: Union[str, int], redirectPath: str, searchTerms: str, redirectCode: Union[str, int],
            content: str, note: str, faq: str):
        result = self.search(searchPath, searchActivity)[0]
        result_id = result['ID']
        result_path = result['Path']
        result_params = result['Params']
        result_title = result['Title']
        result_description = result['Description']
        edit_data: Dict = {
            'Path': result_path, 'Params': result_params,
            'Title': result_title, 'Description': result_description
                            }
        if path:
            edit_data['Path'] = '/' + path
        if params:
            edit_data['Params'] = 'q=' + params
        if activity:
            edit_data['IsActive'] = activity
        if title:
            edit_data['Title'] = title
        if alternativeTitle:
            edit_data['AlternativeTitle'] = alternativeTitle
        if anchorTitle:
            edit_data['AnchorTitle'] = anchorTitle
        if description:
            edit_data['Description'] = description
        if cat1:
            edit_data['CategoriesLandingShow[]'] = cat1
        if cat2:
            edit_data['CategoriesShowLanding[]'] = cat2
        if province1:
            edit_data['CategoriesRegion'] = province1
        if city1:
            edit_data['CategoriesCity'] = city1
        if district1:
            edit_data['CategoriesNeighborhood'] = district1
        if province2:
            edit_data['Region'] = province2
        if city2:
            edit_data['City'] = city2
        if district2:
            edit_data['Neighborhood'] = district2
        if allNeighborhoods:
            edit_data['ExtendedLocation'] = allNeighborhoods
        if redirectPath:
            edit_data['RedirectTo'] = '/' + redirectPath
        if searchTerms:
            edit_data['SearchTerms'] = searchTerms
        if redirectCode:
            edit_data['RedirectCode'] = redirectCode
        if content:
            edit_data['Content'] = '<p>' + content + '</p>'
        if note:
            edit_data['Note'] = note
        if faq:
            edit_data['Faq'] = faq

        response = self.client.post(
            url=f'{self.env.url}/trumpet/landings/edit/{result_id}',
            data=edit_data
        )
        response.is_valid(raise_exception=True, validate_success=True)


    def delete_by_searching_by_path(self, path: str):
        results = self.search(path, '1')
        for result in results:
            result_id = result['ID']
            response = self.client.delete(
                url=f'{self.env.url}/trumpet/landings/delete/{result_id}'
            )
            response.is_valid(raise_exception=True, validate_success=True)


    def search(self, search: str = None, activity: str = None):
        response: Response = self.client.post(
            url=f'{self.env.url}/trumpet/landings/fetch',
            data={'q': search, 'is_active': activity}
        )
        response.is_valid(raise_exception=True, validate_success=True)
        results = response.body.get('data', {}).get('landings', {})
        return results


    def delete_by_id(self, *ids: List[str]):
        for id in ids:
            response = self.client.delete(
                url=f'{self.env.url}/trumpet/landings/delete/{id}'
            )
            response.is_valid(raise_exception=True, validate_success=True)

*** Settings ***
resource                              resources/static.resource
Library                               String
Library                               Collections
Library                               Sheypoor                          platform=seo              env=${trumpet_prenv_id}    general_api_version=${general_api_version}
Variables                             variables/Variables.py            ${trumpet_prenv_id}       ${general_api_version}

Test Setup                            Set Test Environment
Force Tags                            Seo
# brand	Model	bodyType	paymentType	isCertified	new_used	realestateType


*** Variables ***
# robot -P auto-tests/:auto-tests/lib/ -L trace -d  reports/temp  -v trumpet_prenv_id:staging -v general_api_version:6.4.0 auto-tests/staticData/temp.robot


*** Test Cases ***
temp cases
    get Cats



*** Keywords ***
get Cats
    ${locations}                                Check Slugs
    log                                         ${locations}

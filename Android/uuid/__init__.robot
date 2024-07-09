*** Settings ***
Documentation                                                        [command run: pabot --pabotlib --testlevelsplit --processes 50 -P auto-tests/lib/:auto-tests/ -L trace -d Reports/app/uuid -v general_api_version:6.4.0 -v trumpet_prenv_id:staging auto-tests/Android/uuid]
Resource                                                             ../resources/common.resource
Library                                                              pabot.PabotLib
Suite Setup                                                          Run Setup Only Once                                            Set Suite Requirement

*** Keywords ***
Set Suite Requirement
    Create File Containing All The SubCategories
    Enable uuid Limitation Toggle

Create File Containing All The SubCategories
    Create csv File Containing All Categories And SubCategories      ${CURDIR}/01_listing_limits_with_uuid_on_all_subCategories

Enable uuid Limitation Toggle
    Mock Toggle Set                                                  android                                                        device-id-limitation                ${1}

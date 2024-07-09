*** Settings ***
Resource                                      ../../../../resources/versions/v1-resource.resource
Suite Setup                                   Set Test Environment
Test Setup                                    Setup Environment


*** Variables ***


*** Test Cases ***
ProTools Files Sort
    Create Some Files To Validate Sort        5
    Edit File To Check Updated Refreshed At
    Going Top The List Of Files After Edit

*** Keywords ***
Edit File To Check Updated Refreshed At
    Set To Dictionary	                        ${attributes}	      title=ویرایش آگهی ${Key[0]}
    # Post In Retry                             /listings/${Key[0]}                        {"title":"ویرایش آگهی ${Key[0]}"}
    Post In Retry                             /listings/${Key[0]}                       ${attributes}
    String                                    response body message                      آگهی با موفقیت ثبت شد.
    Get In Retry                              /listings/${Key[0]}
    Integer                                   response status                            200
    ${Updated_Refreshed_At}                   Get Integer                                response body refreshed_at
    Set Suite Variable                        ${Updated_Refreshed_At}
    Should Be True                            ${Updated_Refreshed_At} > ${Value[0]}

Going Top The List Of Files After Edit
    Get In Retry                              /listings?active=true&published=false
    Integer                                   response status                                  200
    String                                    response body items 0 human_readable_id          ${Key[0]}

Create Some Files To Validate Sort
    [Arguments]                               ${Repeat}
    &{Dict}                                   Create Dictionary
    @{Key}                                    Create List
    @{Value}                                  Create List
    Login To Service                          real-estate
    Set Headers                               {"X-Ticket":"${Refresh_Token}"}
    FOR    ${INDEX}     IN RANGE    0    ${Repeat}
      Create a File In Real Estate Category
      Append To List                          ${Key}     ${human_readable_id}
      Append To List                          ${Value}   ${Refreshed_At}
      Set To Dictionary                       ${Dict}    ${human_readable_id}    ${Refreshed_At}
    END
    Set Suite Variable                        ${Key}
    Set Suite Variable                        ${Value}

Create a File In Real Estate Category
    Set Listing Limit For Cat per locations   parentid=${43603}  catid=${43607}  regid=${8}  cityid=${301}  nghid=${888}  limitcount=${30}  limitprice=${11000}
    Get Random Listing And Images             ${Attributes}                              3
    Post In Retry                             /listings                                  ${attributes}
    Integer                                   response status                            200
    Get User Human Readable Id
    Get In Retry                              /listings/${human_readable_id}
    Integer                                   response status                            200
    ${Refreshed_At}                           Get Integer                                response body refreshed_at
    Set Suite Variable                        ${Refreshed_At}

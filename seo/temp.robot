*** Settings ***
resource                              resources/seo.resource
Library                               String
Library                               Collections
Library                               Sheypoor                             platform=seo              env=${trumpet_prenv_id}    general_api_version=${general_api_version}
Variables                             variables/Variables.py               ${trumpet_prenv_id}       ${general_api_version}

Test Setup                            Set Test Environment
Force Tags                            Seo
# brand	Model	bodyType	paymentType	isCertified	new_used	realestateType


*** Variables ***
# robot -P auto-tests/:auto-tests/lib/ -L trace -d  reports/temp  -v trumpet_prenv_id:staging -v general_api_version:6.2.0 auto-tests/seo/temp.robot
# robot -P auto-tests/:auto-tests/lib/ -L trace -d  reports/temp  -v trumpet_prenv_id:staging  -v general_api_version:6.2.0 auto-tests/seo/seo.tests/general/21__Home_Appliances.robot
# pabot  --verbose --processes 50 --ordering auto-tests/seo//order.txt -P auto-tests/:auto-tests/lib/ -L trace -d  reports/temp  -v trumpet_prenv_id:staging -v general_api_version:6.2.0 -e notest auto-tests/seo/seo.tests
# cat	subcat	categoryName	attributes	locationName	Seo Type	title currrent	title exp	desc current	desc exp	h1 current	h1 exp	URL	Status

*** Test Cases ***
temp cases
  ${Brand_List}                                       Make Brand List               category=موبایل، تبلت و لوازم      subcategory=موبایل و تبلت     counter=30


*** Keywords ***
get Cats
    ${CATS}                                Get Categories
    Create Excel Document	                 doc_id=docname1
    ${row}                                 Set Variable                    1
    # ${col_num}                            Set Variable                    1
    FOR   ${cat}   IN      @{CATS.keys()}
      # ${col}                              Set Variable                    ${i + ${col_num}}
      Write Excel Cell                    row_num=${row}                  col_num=1          value=${cat}
      Write Excel Cell                    row_num=${row}                  col_num=2          value=-
      @{Subcats}                          Get From Dictionary             ${CATS}            ${cat}
      Write ${Subcats} of ${cat} in ${row}
      ${length}                           Get Length    ${Subcats}
      ${row}                              Evaluate      ${length} + ${row} + 1
    END
    Save Excel Document	                  filename=${CURDIR}/data/cats.xlsx
    Close Current Excel Document

Write ${Subcats} of ${cat} in ${row}
    FOR   ${Subcat}  IN  @{Subcats}
      ${row}                            Evaluate                        ${row} + 1
      Write Excel Cell                  row_num=${row}                  col_num=1        value=${cat}
      Write Excel Cell                  row_num=${row}                  col_num=2        value=${Subcat}
    END

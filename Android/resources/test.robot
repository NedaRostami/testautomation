*** Settings ***
Library           String
Library           Collections
Library           OperatingSystem


*** Test Cases ***
List Version Files
   # @{VERSIONS_LIST}      List Files In Directory    versions/ 	         *.resource
   ${VERSIONS_LIST}        run                        ls versions -1 | sed -e 's/\.resource$//'
   @{VERSIONS_LIST}                 Split String               ${VERSIONS_LIST}     ${\n}
   Reverse List      ${VERSIONS_LIST}
   Set Suite Variable    name    *values     ${VERSIONS_LIST}

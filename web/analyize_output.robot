*** Settings ***
Metadata                    VERSION     0.1
Library                     XML
Library                     OperatingSystem

*** variables ***
# ${pass}      ${689}
# ${fail}      ${1}

*** Test Cases ***
Parsing output File
    Set Log Level    Trace
    #TODO: criticals
    ${pass}                  Get Element Attribute    ${xmlFile}    pass   statistics/total/stat[1]
    ${fail}                  Get Element Attribute    ${xmlFile}    fail   statistics/total/stat[1]
    ${Total}                 Evaluate   ${fail} + ${pass}
    ${percent}               Evaluate   int(100 * ${pass}/${Total})
    ${Success}               Convert To String    ${percent}
    Create File	             ${LogPath}/${TestKind}_SP_log.txt	 ${Success}
    Log To Console           ******************************** ${TestKind} Results ****************************************
    Log To Console           ********************* percent is ${Success} on ${TestKind} **********************************
    Log To Console           *********************************************************************************************

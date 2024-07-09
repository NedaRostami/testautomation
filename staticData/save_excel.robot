*** Settings ***
Documentation                                    made reporting excel ready
Library                                          ExcelLibrary
Library                                          OperatingSystem
Library                                          String
Library                                          Collections

*** Variables ***
${Log_path}                                      ${CURDIR}/resources/data


*** Test Cases ***
Crate New Excel file
    Copy File                                    ${Log_path}/temp.xlsx      ${Log_path}/report.xlsx
    @{Report}                                    Create List
    ${contents}                                  OperatingSystem.Get File                 ${Log_path}/log.txt
    @{lines}                                     Split to lines  ${contents}
    FOR  ${line}  IN                             @{lines}
      @{log}                                     Split String    ${line}    ;;;
      Append To List                             ${Report}       ${log}
    END
    Save To Excel                                ${Report}
    Remove File                                  ${Log_path}/log.txt

*** Keywords ***
Save To Excel
    [Arguments]                                  ${Report}
    Open Excel Document                          filename=${Log_path}/report.xlsx    doc_id=docname1
    # ${sheet}                                   Get sheet    Sheet
    # ${row}                                     Set Variable                             ${sheet.max_row + 1}
    FOR  ${row_index}  ${log_list}   IN ENUMERATE       @{Report}
      Write Log To Excel                         ${row_index + 2}     ${log_list}
    END
    Save Excel Document	                         filename=${Log_path}/report.xlsx
    Close Current Excel Document
    Set Suite Metadata                           report   value=[${Log_path}/report.xlsx | report.xlsx]    append=True    top=True


Write Log To Excel
    [Arguments]                                  ${row_index}                    ${log_list}
    FOR   ${col_index}   ${log}   IN ENUMERATE   @{log_list}
      Write Excel Cell                           row_num=${row_index}            col_num=${col_index + 1}          value=${log}
    END

*** Settings ***
Documentation                               Test static data
Library                                     String
Library                                     Collections
Library                                     Sheypoor                             platform=seo              env=${trumpet_prenv_id}    general_api_version=${general_api_version}
Library                                     OperatingSystem
Variables                                   ../variables/Variables.py            ${trumpet_prenv_id}       ${general_api_version}

*** Variables ***


*** Keywords ***
Set Test Environment
  Set Log Level                             Trace

TearDown Tasks
    No Operation

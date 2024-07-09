*** Settings ***
resource                             mobile.resource
resource                             teardown.resource
# Variables                            ../vars/mobile.py
Variables                            ../../web/vars/desktop.py

*** Variables ***


*** Keywords ***
Close App Alert
    Wait Until Keyword Succeeds       3x    2s              click element             //*[@id="app-suggest"]//span[contains(@class, "icon-cancel-circled")]

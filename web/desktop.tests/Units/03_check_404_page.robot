*** Settings ***
Documentation                          check unvalid url 404 custom page
Test Setup                             Open test browser
Test Teardown                          Clean Up Tests
Resource                               ../../resources/setup.resource

*** Variables ***


***Test Case***
check unvalid url 404 custom page
    check 404

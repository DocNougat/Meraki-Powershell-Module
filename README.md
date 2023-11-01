# Introduction

The Meraki PowerShell module provides a set of cmdlets for managing and interacting with the Cisco Meraki cloud-based network management platform. This module allows you to automate common tasks and manage your Meraki network using PowerShell.

Current Progress: Commands have been written for all endpoints, but I do not have the capability to test all of the commands (if someone from Cisco is reading this feel free to send a box of everything you make + licensing for me to test with...). About 80% of the Get- commands have been tested, but I've only had the oppoortunity to test a small portion of the commands starting with Invoke-, New-, Remove-, or Set-. The method is the same for every request, so they should all work as long as the JSON is properly formatted to what the API expects and I don't have a typo in the script somewhere. For up-to-date examples check the [Meraki API Documentation](https://developer.cisco.com/meraki/api-v1/introduction/) for the endpoint you're trying to access. 

**NOTE: This module and its documentation were created and are currently maintained by Alex Heimbuch. This is not an official Cisco product and should be used with caution. This current work in progress and this document is subject to periodic change as the functionality expands.**

## Prerequisites

Before you can use the Meraki PowerShell module, you need to meet the following prerequisites:

1.  Install PowerShell v5 or later on your system.
2.  Obtain an API key for the Meraki dashboard. You can find instructions for generating an API key in the [Meraki documentation](https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API).

## Installation
### PowerShell Gallery
### Manual Installation
To install the Meraki PowerShell module, follow these steps:
1.  Copy the Meraki folder into "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"  
    *   **LINUX or MAC:** Copy the Meraki folder into "/usr/local/share/powershell/Modules"
2.  In PowerShell, run the following command to import the module:\
``` Import-Module Meraki ```

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
```powershell
Import-Module Meraki
```
## Usage
* **Use caution if you're in an environment with multiple Organizations.** OrganizationID is an optional parameter in all commands that specify an organization except Remove-MerakiOrganization which will require you to specify the Organization you want to delete. If the OrganizationID is not provided the commandlet will call Get-MerakiOrganization and use the first OrganizationID returned. 
* All commands are written using PowerShell approved verbs. Here is a quick conversion guide from Meraki verbs:
   * Get = Get
   * Create = New
   * Delete = Remove
   * Update = Set
   * Other Actions = Invoke, Copy, or Find
* Every command requires an API key provided to the -AuthToken parameter. You can find instructions for generating an API key in the [Meraki documentation](https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API).
* Get-,Copy-, & Find-, Commands are fully parameterized. Check the documentation to see what is required and what is optional
   * Example: The command to call the Get Network Policies By Client endpoint is Get-MerakiNetworkPoliciesByClient. It has two required parameters, AuthToken & NetworkID, and several optional parameters that the command can use to build out a query to narrow the results:  perPage, startingAfter, endingBefore, t0, & timespan.
```powershell
Get-MerakiNetworkPoliciesByClient -AuthToken "your-api-token" -perPage 5 -timespan 200
```
* Other commands (Invoke-, New-, Remove-,  or Set-) may require JSON formatted inputs:
   * Example: The command to call the Create Organization Network endpoint is New-MerakiOrganizationNetwork. It has one required parameter, AuthToken, one optional parameter, OrganizationID (required in systems with multiple organizations under the same auth token), & also requires a JSON formatted string of next defining the details of the network being created.
```powershell
$NetworkConfig = '{
   "name": "Main Office",
   "productTypes": [
      "appliance",
      "switch",
      "wireless"
   ],
   "tags": [ "tag1", "tag2" ],
   "timeZone": "America/Los_Angeles",
   "copyFromNetworkId": "N_24329156",
   "notes": "Additional description of the network"
}'
$NetworkConfig = $NetworkConfig | ConvertTo-JSON -compress
New-MerakiOrganizationNetwork -AuthToken "your-api-token" -NetworkConfig $NetworkConfig`
```
   * Compress JSON before sending it to a command with `ConvertTo-JSON -compress` 
```powershell
$NetworkConfig = $NetworkConfig | ConvertTo-JSON -compress
```

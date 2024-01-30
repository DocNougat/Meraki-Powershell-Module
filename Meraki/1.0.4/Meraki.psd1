@{
    # Required module metadata
    RootModule = 'Meraki.psm1'
    ModuleVersion = '1.0.5'
    GUID = 'a4c78621-53d6-4d07-a3c2-18986038ae94'
    Author = 'Alex Heimbuch'
    CompanyName = ''
    Description = 'A PowerShell module for the Cisco Meraki API'
    PowerShellVersion = '5.1'

    # Required module dependencies
    # RequiredModules = @(
    # )

    # Optional module metadata
    FunctionsToExport = @(
        'Copy-MerakiOrganization',
        'Get-MerakiAdministeredIdentitiesMe',
        'Get-MerakiDevice',
        'Get-MerakiDeviceApplianceDHCPSubnets',
        'Get-MerakiDeviceAppliancePerformance',
        'Get-MerakiDeviceAppliancePrefixesDelegated',
        'Get-MerakiDeviceAppliancePrefixesDelegatedVlanAssignments',
        'Get-MerakiDeviceApplianceUplinksSettings',
        'Get-MerakiDeviceCameraAnalyticsLive',
        'Get-MerakiDeviceCameraAnalyticsOverview',
        'Get-MerakiDeviceCameraAnalyticsRecent',
        'Get-MerakiDeviceCameraAnalyticsZoneHistory',
        'Get-MerakiDeviceCameraAnalyticsZones',
        'Get-MerakiDeviceCameraCustomAnalytics',
        'Get-MerakiDeviceCameraQualityAndRetention',
        'Get-MerakiDeviceCameraSense',
        'Get-MerakiDeviceCameraSenseObjectDetectionModels',
        'Get-MerakiDeviceCameraVideoLink',
        'Get-MerakiDeviceCameraVideoSettings',
        'Get-MerakiDeviceCameraWirelessProfiles',
        'Get-MerakiDeviceCellularGatewayLan',
        'Get-MerakiDeviceCellularGatewayPortForwardingRules',
        'Get-MerakiDeviceCellularSims',
        'Get-MerakiDeviceClients',
        'Get-MerakiDeviceLiveToolsPing',
        'Get-MerakiDeviceLiveToolsPingDevice',
        'Get-MerakiDeviceLldpCdp',
        'Get-MerakiDeviceLossAndLatencyHistory',
        'Get-MerakiDeviceManagementInterface',
        'Get-MerakiDeviceSwitchPort',
        'Get-MerakiDeviceSwitchPorts',
        'Get-MerakiDeviceSwitchPortsStatuses',
        'Get-MerakiDeviceSwitchPortsStatusesPackets',
        'Get-MerakiDeviceSwitchRoutingInterface',
        'Get-MerakiDeviceSwitchRoutingInterfaceDHCP',
        'Get-MerakiDeviceSwitchRoutingInterfaces',
        'Get-MerakiDeviceSwitchRoutingStaticRoute',
        'Get-MerakiDeviceSwitchRoutingStaticRoutes',
        'Get-MerakiDeviceSwitchWarmSpare',
        'Get-MerakiDeviceWirelessBluetoothSettings',
        'Get-MerakiDeviceWirelessConnectionStats',
        'Get-MerakiDeviceWirelessLatencyStats',
        'Get-MerakiDeviceWirelessRadioSettings',
        'Get-MerakiDeviceWirelessStatus',
        'Get-MerakiNetwork',
        'Get-MerakiNetworkAlertsHistory',
        'Get-MerakiNetworkAlertsSettings',
        'Get-MerakiNetworkApplianceClientSecurityEvents',
        'Get-MerakiNetworkApplianceConnectivityMonitoringDestinations',
        'Get-MerakiNetworkApplianceContentFiltering',
        'Get-MerakiNetworkApplianceContentFilteringCategories',
        'Get-MerakiNetworkApplianceFirewallCellularFirewallRules',
        'Get-MerakiNetworkApplianceFirewallFirewalledService',
        'Get-MerakiNetworkApplianceFirewallFirewalledServices',
        'Get-MerakiNetworkApplianceFirewallInboundCellularFirewallRules',
        'Get-MerakiNetworkApplianceFirewallInboundFirewallRules',
        'Get-MerakiNetworkApplianceFirewallL3FirewallRules',
        'Get-MerakiNetworkApplianceFirewallL7FirewallRules',
        'Get-MerakiNetworkApplianceFirewallL7FirewallRulesApplicationCategories',
        'Get-MerakiNetworkApplianceFirewallOneToManyNatRules',
        'Get-MerakiNetworkApplianceFirewallOneToOneNatRules',
        'Get-MerakiNetworkApplianceFirewallPortForwardingRules',
        'Get-MerakiNetworkApplianceFirewallSettings',
        'Get-MerakiNetworkAppliancePort',
        'Get-MerakiNetworkAppliancePorts',
        'Get-MerakiNetworkApplianceSecurityEvents',
        'Get-MerakiNetworkApplianceSettings',
        'Get-MerakiNetworkApplianceSingleLan',
        'Get-MerakiNetworkApplianceSsid',
        'Get-MerakiNetworkApplianceSsids',
        'Get-MerakiNetworkApplianceStaticRoute',
        'Get-MerakiNetworkApplianceStaticRoutes',
        'Get-MerakiNetworkApplianceTrafficShaping',
        'Get-MerakiNetworkApplianceTrafficShapingCPC',
        'Get-MerakiNetworkApplianceTrafficShapingCPCs',
        'Get-MerakiNetworkApplianceTrafficShapingRules',
        'Get-MerakiNetworkApplianceTrafficShapingUplinkBandwidth',
        'Get-MerakiNetworkApplianceTrafficShapingUplinkSelection',
        'Get-MerakiNetworkApplianceUplinksUsageHistory',
        'Get-MerakiNetworkApplianceVlan',
        'Get-MerakiNetworkApplianceVlans',
        'Get-MerakiNetworkApplianceVlansSettings',
        'Get-MerakiNetworkApplianceVPNBgp',
        'Get-MerakiNetworkApplianceVPNSiteToSiteVPN',
        'Get-MerakiNetworkApplianceWarmSpare',
        'Get-MerakiNetworkAuthUser',
        'Get-MerakiNetworkAuthUsers',
        'Get-MerakiNetworkBluetoothClient',
        'Get-MerakiNetworkBluetoothClients',
        'Get-MerakiNetworkCameraQualityRetentionProfile',
        'Get-MerakiNetworkCameraQualityRetentionProfiles',
        'Get-MerakiNetworkCameraSchedules',
        'Get-MerakiNetworkCameraWirelessProfile',
        'Get-MerakiNetworkCameraWirelessProfiles',
        'Get-MerakiNetworkCellularGatewayConnectivityMonitoringDestinations',
        'Get-MerakiNetworkCellularGatewayDHCP',
        'Get-MerakiNetworkCellularGatewaySubnetPool',
        'Get-MerakiNetworkCellularGatewayUplink',
        'Get-MerakiNetworkClient',
        'Get-MerakiNetworkClientPolicy',
        'Get-MerakiNetworkClients',
        'Get-MerakiNetworkClientsApplicationUsage',
        'Get-MerakiNetworkClientsBandwidthUsageHistory',
        'Get-MerakiNetworkClientsOverview',
        'Get-MerakiNetworkClientSplashAuthorization',
        'Get-MerakiNetworkClientsUsageHistories',
        'Get-MerakiNetworkClientTrafficHistory',
        'Get-MerakiNetworkClientUsageHistory',
        'Get-MerakiNetworkDevices',
        'Get-MerakiNetworkEvents',
        'Get-MerakiNetworkEventsEventTypes',
        'Get-MerakiNetworkFirmwareUpgrades',
        'Get-MerakiNetworkFirmwareUpgradesStagedEvents',
        'Get-MerakiNetworkFirmwareUpgradesStagedGroup',
        'Get-MerakiNetworkFirmwareUpgradesStagedGroups',
        'Get-MerakiNetworkFirmwareUpgradesStagedStages',
        'Get-MerakiNetworkFloorPlan',
        'Get-MerakiNetworkFloorPlans',
        'Get-MerakiNetworkGroupPolicies',
        'Get-MerakiNetworkGroupPolicy',
        'Get-MerakiNetworkHealthAlerts',
        'Get-MerakiNetworkInsightApplicationHealthByTime',
        'Get-MerakiNetworkMqttBroker',
        'Get-MerakiNetworkMqttBrokers',
        'Get-MerakiNetworkNetflow',
        'Get-MerakiNetworkNetworkHealthChannelUtilization',
        'Get-MerakiNetworkPiiPiiKeys',
        'Get-MerakiNetworkPiiRequest',
        'Get-MerakiNetworkPiiRequests',
        'Get-MerakiNetworkPiiSmDevicesForKey',
        'Get-MerakiNetworkPiiSmOwnersForKey',
        'Get-MerakiNetworkPoliciesByClient',
        'Get-MerakiNetworkPrefixesDelegatedStatic',
        'Get-MerakiNetworkPrefixesDelegatedStatics',
        'Get-MerakiNetworkSecurityIntrusion',
        'Get-MerakiNetworkSecurityMalware',
        'Get-MerakiNetworkSensorAlertsCurrentOverviewByMetric',
        'Get-MerakiNetworkSensorAlertsOverviewByMetric',
        'Get-MerakiNetworkSensorAlertsProfile',
        'Get-MerakiNetworkSensorAlertsProfiles',
        'Get-MerakiNetworkSettings',
        'Get-MerakiNetworkSmBypassActivationLockAttempt',
        'Get-MerakiNetworkSmDeviceCellularUsageHistory',
        'Get-MerakiNetworkSmDeviceCerts',
        'Get-MerakiNetworkSmDeviceConnectivity',
        'Get-MerakiNetworkSmDeviceDesktopLogs',
        'Get-MerakiNetworkSmDeviceDeviceCommandLogs',
        'Get-MerakiNetworkSmDeviceDeviceProfiles',
        'Get-MerakiNetworkSmDeviceNetworkAdapters',
        'Get-MerakiNetworkSmDevicePerformanceHistory',
        'Get-MerakiNetworkSmDeviceRestrictions',
        'Get-MerakiNetworkSmDevices',
        'Get-MerakiNetworkSmDeviceSecurityCenters',
        'Get-MerakiNetworkSmDeviceSoftwares',
        'Get-MerakiNetworkSmDeviceWlanLists',
        'Get-MerakiNetworkSmProfiles',
        'Get-MerakiNetworkSmTargetGroup',
        'Get-MerakiNetworkSmTargetGroups',
        'Get-MerakiNetworkSmTrustedAccessConfigs',
        'Get-MerakiNetworkSmUserAccessDevices',
        'Get-MerakiNetworkSmUserDeviceProfiles',
        'Get-MerakiNetworkSmUsers',
        'Get-MerakiNetworkSmUserSoftwares',
        'Get-MerakiNetworkSNMP',
        'Get-MerakiNetworkSplashLoginAttempts',
        'Get-MerakiNetworkSwitchACLs',
        'Get-MerakiNetworkSwitchAccessPolicies',
        'Get-MerakiNetworkSwitchAccessPolicy',
        'Get-MerakiNetworkSwitchAlternateManagementInterface',
        'Get-MerakiNetworkSwitchDHCPServerPolicy',
        'Get-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServers',
        'Get-MerakiNetworkSwitchDHCPServerPolicyArpInspWarningsByDevice',
        'Get-MerakiNetworkSwitchDHCPV4ServersSeen',
        'Get-MerakiNetworkSwitchDscpToCosMappings',
        'Get-MerakiNetworkSwitchLinkAggregations',
        'Get-MerakiNetworkSwitchMtu',
        'Get-MerakiNetworkSwitchPortSchedules',
        'Get-MerakiNetworkSwitchQosRule',
        'Get-MerakiNetworkSwitchQosRules',
        'Get-MerakiNetworkSwitchQosRulesOrder',
        'Get-MerakiNetworkSwitchRoutingMulticast',
        'Get-MerakiNetworkSwitchRoutingMulticastRendezvousPoint',
        'Get-MerakiNetworkSwitchRoutingMulticastRendezvousPoints',
        'Get-MerakiNetworkSwitchRoutingOspf',
        'Get-MerakiNetworkSwitchSettings',
        'Get-MerakiNetworkSwitchStack',
        'Get-MerakiNetworkSwitchStackRoutingInterface',
        'Get-MerakiNetworkSwitchStackRoutingInterfaceDHCP',
        'Get-MerakiNetworkSwitchStackRoutingInterfaces',
        'Get-MerakiNetworkSwitchStackRoutingStaticRoute',
        'Get-MerakiNetworkSwitchStackRoutingStaticRoutes',
        'Get-MerakiNetworkSwitchStacks',
        'Get-MerakiNetworkSwitchStormControl',
        'Get-MerakiNetworkSwitchStp',
        'Get-MerakiNetworkSyslogServers',
        'Get-MerakiNetworkTopologyLinkLayer',
        'Get-MerakiNetworkTraffic',
        'Get-MerakiNetworkTrafficAnalysis',
        'Get-MerakiNetworkTrafficShapingApplicationCategories',
        'Get-MerakiNetworkTrafficShapingDscpTaggingOptions',
        'Get-MerakiNetworkVlan',
        'Get-MerakiNetworkVlans',
        'Get-MerakiNetworkWebhooksHttpServer',
        'Get-MerakiNetworkWebhooksHttpServers',
        'Get-MerakiNetworkWebhooksPayloadTemplate',
        'Get-MerakiNetworkWebhooksPayloadTemplates',
        'Get-MerakiNetworkWebhooksWebhookTest',
        'Get-MerakiNetworkWirelessAirMarshal',
        'Get-MerakiNetworkWirelessAlternateManagementInterface',
        'Get-MerakiNetworkWirelessBilling',
        'Get-MerakiNetworkWirelessBluetoothSettings',
        'Get-MerakiNetworkWirelessChannelUtilizationHistory',
        'Get-MerakiNetworkWirelessClientConnectionStats',
        'Get-MerakiNetworkWirelessClientConnectivityEvents',
        'Get-MerakiNetworkWirelessClientCountHistory',
        'Get-MerakiNetworkWirelessClientLatencyHistory',
        'Get-MerakiNetworkWirelessClientLatencyStats',
        'Get-MerakiNetworkWirelessClientsConnectionStats',
        'Get-MerakiNetworkWirelessClientsLatencyStats',
        'Get-MerakiNetworkWirelessConnectionStats',
        'Get-MerakiNetworkWirelessDataRateHistory',
        'Get-MerakiNetworkWirelessDevicesConnectionStats',
        'Get-MerakiNetworkWirelessDevicesLatencyStats',
        'Get-MerakiNetworkWirelessFailedConnections',
        'Get-MerakiNetworkWirelessLatencyHistory',
        'Get-MerakiNetworkWirelessLatencyStats',
        'Get-MerakiNetworkWirelessMeshStatuses',
        'Get-MerakiNetworkWirelessRfProfile',
        'Get-MerakiNetworkWirelessRfProfiles',
        'Get-MerakiNetworkWirelessSettings',
        'Get-MerakiNetworkWirelessSignalQualityHistory',
        'Get-MerakiNetworkWirelessSsid',
        'Get-MerakiNetworkWirelessSsidBonjourForwarding',
        'Get-MerakiNetworkWirelessSsidDeviceTypeGroupPolicies',
        'Get-MerakiNetworkWirelessSsidEapOverride',
        'Get-MerakiNetworkWirelessSsidFirewallL3FirewallRules',
        'Get-MerakiNetworkWirelessSsidFirewallL7FirewallRules',
        'Get-MerakiNetworkWirelessSsidHotspot20',
        'Get-MerakiNetworkWirelessSsidIdentityPsk',
        'Get-MerakiNetworkWirelessSsidIdentityPsks',
        'Get-MerakiNetworkWirelessSsids',
        'Get-MerakiNetworkWirelessSsidSchedules',
        'Get-MerakiNetworkWirelessSsidSplashSettings',
        'Get-MerakiNetworkWirelessSsidTrafficShapingRules',
        'Get-MerakiNetworkWirelessSsidVPN',
        'Get-MerakiNetworkWirelessUsageHistory',
        'Get-MerakiOrganization',
        'Get-MerakiOrganizationActionBatch',
        'Get-MerakiOrganizationActionBatches',
        'Get-MerakiOrganizationAdaptivePolicies',
        'Get-MerakiOrganizationAdaptivePolicy',
        'Get-MerakiOrganizationAdaptivePolicyACL',
        'Get-MerakiOrganizationAdaptivePolicyACLs',
        'Get-MerakiOrganizationAdaptivePolicyGroup',
        'Get-MerakiOrganizationAdaptivePolicyGroups',
        'Get-MerakiOrganizationAdaptivePolicyOverview',
        'Get-MerakiOrganizationAdaptivePolicySettings',
        'Get-MerakiOrganizationAdmins',
        'Get-MerakiOrganizationAlertsProfiles',
        'Get-MerakiOrganizationApiRequests',
        'Get-MerakiOrganizationApiRequestsOverview',
        'Get-MerakiOrganizationApiRequestsOverviewResponseCodesByInterval',
        'Get-MerakiOrganizationApplianceSecurityEvents',
        'Get-MerakiOrganizationApplianceSecurityIntrusion',
        'Get-MerakiOrganizationApplianceTrafficShapingVpnExclusionsByNet',
        'Get-MerakiOrganizationApplianceUplinkStatuses',
        'Get-MerakiOrganizationApplianceVPNStats',
        'Get-MerakiOrganizationApplianceVPNStatuses',
        'Get-MerakiOrganizationApplianceVPNThirdPartyVPNPeers',
        'Get-MerakiOrganizationApplianceVPNFirewallRules',
        'Get-MerakiOrganizationBrandingPolicies',
        'Get-MerakiOrganizationBrandingPoliciesPriorities',
        'Get-MerakiOrganizationBrandingPolicy',
        'Get-MerakiOrganizationCameraCustomAnalyticsArtifact',
        'Get-MerakiOrganizationCameraCustomAnalyticsArtifacts',
        'Get-MerakiOrganizationCameraOnboardingStatuses',
        'Get-MerakiOrganizationCameraRole',
        'Get-MerakiOrganizationCameraRoles',
        'Get-MerakiOrganizationCellularGatewayUplinkStatuses',
        'Get-MerakiOrganizationClientsBandwidthUsageHistory',
        'Get-MerakiOrganizationClientsOverview',
        'Get-MerakiOrganizationClientsSearch',
        'Get-MerakiOrganizationConfigTemplate',
        'Get-MerakiOrganizationConfigTemplates',
        'Get-MerakiOrganizationConfigTemplateSwitchProfilePort',
        'Get-MerakiOrganizationConfigTemplateSwitchProfilePorts',
        'Get-MerakiOrganizationConfigTemplateSwitchProfiles',
        'Get-MerakiOrganizationConfigurationChanges',
        'Get-MerakiOrganizationDevices',
        'Get-MerakiOrganizationDevicesAvailabilities',
        'Get-MerakiOrganizationDevicesPowerModulesStatusesByDevice',
        'Get-MerakiOrganizationDevicesStatuses',
        'Get-MerakiOrganizationDevicesStatusesOverview',
        'Get-MerakiOrganizationDevicesUplinksAddressesByDevice',
        'Get-MerakiOrganizationDevicesUplinksLossAndLatency',
        'Get-MerakiOrganizationEarlyAccessFeatures',
        'Get-MerakiOrganizationEarlyAccessFeaturesOptIn',
        'Get-MerakiOrganizationEarlyAccessFeaturesOptIns',
        'Get-MerakiOrganizationFirmwareUpgrades',
        'Get-MerakiOrganizationFirmwareUpgradesByDevice',
        'Get-MerakiOrganizationInsightApplications',
        'Get-MerakiOrganizationInsightMonitoredMediaServer',
        'Get-MerakiOrganizationInsightMonitoredMediaServers',
        'Get-MerakiOrganizationInventoryDevice',
        'Get-MerakiOrganizationInventoryDevices',
        'Get-MerakiOrganizationInventoryOnboardingCloudMonitoringImports',
        'Get-MerakiOrganizationLicense',
        'Get-MerakiOrganizationLicenses',
        'Get-MerakiOrganizationLicensesOverview',
        'Get-MerakiOrganizationLicensingCotermLicenses',
        'Get-MerakiOrganizationLoginSecurity',
        'Get-MerakiOrganizationNetworks',
        'Get-MerakiOrganizationOpenapiSpec',
        'Get-MerakiOrganizationPiiPiiKey',
        'Get-MerakiOrganizationPiiRequest',
        'Get-MerakiOrganizationPiiRequests',
        'Get-MerakiOrganizationPiiSmDevicesForKey',
        'Get-MerakiOrganizationPiiSmOwnersForKey',
        'Get-MerakiOrganizationPolicyObject',
        'Get-MerakiOrganizationPolicyObjects',
        'Get-MerakiOrganizationPolicyObjectsGroup',
        'Get-MerakiOrganizationPolicyObjectsGroups',
        'Get-MerakiOrganizations',
        'Get-MerakiOrganizationSAML',
        'Get-MerakiOrganizationSAMLIDP',
        'Get-MerakiOrganizationSAMLIDPs',
        'Get-MerakiOrganizationSAMLRole',
        'Get-MerakiOrganizationSAMLRoles',
        'Get-MerakiOrganizationSensorReadingsHistory',
        'Get-MerakiOrganizationSensorReadingsLatest',
        'Get-MerakiOrganizationSmApnsCert',
        'Get-MerakiOrganizationSmVppAccount',
        'Get-MerakiOrganizationSmVppAccounts',
        'Get-MerakiOrganizationSNMP',
        'Get-MerakiOrganizationSummaryTopAppliancesByUtilization',
        'Get-MerakiOrganizationSummaryTopClientsByUsage',
        'Get-MerakiOrganizationSummaryTopClientsManufacturersByUsage',
        'Get-MerakiOrganizationSummaryTopDevicesByUsage',
        'Get-MerakiOrganizationSummaryTopDevicesModelsByUsage',
        'Get-MerakiOrganizationSummaryTopSsidsByUsage',
        'Get-MerakiOrganizationSummaryTopSwitchesByEnergyUsage',
        'Get-MerakiOrganizationSwitchPortsBySwitch',
        'Get-MerakiOrganizationWebhooksAlertTypes',
        'Get-MerakiOrganizationWebhooksLogs',
        'Get-MerakiOrganizationWirelessDevicesEthernetStatuses',
        'Get-MerakiOrganizationUplinksStatuses',
        'Invoke-MerakiDeviceBlinkLEDs',
        'Invoke-MerakiDeviceCycleSwitchPorts',
        'Invoke-MerakiDeviceGenerateCameraSnapshot',
        'Invoke-MerakiDeviceLiveToolsPing',
        'Invoke-MerakiDeviceLiveToolsPingDevice',
        'Invoke-MerakiDeviceReboot',
        'Invoke-MerakiNetworkAddSwitchToStack',
        'Invoke-MerakiNetworkApplianceSwapWarmSpare',
        'Invoke-MerakiNetworkBindNetwork',
        'Invoke-MerakiNetworkCheckinSmDevices',
        'Invoke-MerakiNetworkClaimDevices',
        'Invoke-MerakiNetworkDevicesvMXClaim',
        'Invoke-MerakiNetworkFirmwareUpgradesDeferStagedEvents',
        'Invoke-MerakiNetworkFirmwareUpgradesRollbackStagedEvents',
        'Invoke-MerakiNetworkInstallSmDeviceApps',
        'Invoke-MerakiNetworkLockSmDevices',
        'Invoke-MerakiNetworkModifySmDevicesTags',
        'Invoke-MerakiNetworkMoveSmDevices',
        'Invoke-MerakiNetworkProvisionClients',
        'Invoke-MerakiNetworkRefreshSmDevice',
        'Invoke-MerakiNetworkRemoveSwitchFromStack',
        'Invoke-MerakiNetworkSmBypassActivationLockAttempt',
        'Invoke-MerakiNetworkSplitNetwork',
        'Invoke-MerakiNetworkUnbindNetwork',
        'Invoke-MerakiNetworkUnenrollSmDevice',
        'Invoke-MerakiNetworkUninstallSmDeviceApps',
        'Invoke-MerakiNetworkWirelessAssignEthernetPortsProfile',
        'Invoke-MerakiNetworkWirelessSetDefaultEthernetPortsProfile',
        'Invoke-MerakiNetworkWipeSmDevices',
        'Invoke-MerakiOrganizationAssignLicensesSeats',
        'Invoke-MerakiOrganizationCloneSwitchDevices',
        'Invoke-MerakiOrganizationCombineNetworks',
        'Invoke-MerakiOrganizationInventoryClaim',
        'Invoke-MerakiOrganizationInventoryRelease',
        'Invoke-MerakiOrganizationMoveLicenses',
        'Invoke-MerakiOrganizationMoveLicensesSeats',
        'Invoke-MerakiOrganizationMoveLicensingCotermLicenses'
        'Invoke-MerakiOrganizationRenewLicensesSeats',
        'New-MerakiDeviceSwitchRoutingInterface',
        'New-MerakiDeviceSwitchRoutingStaticRoute',
        'New-MerakiNetworkAppliancePrefixesDelegatedStatic',
        'New-MerakiNetworkApplianceRFProfile',
        'New-MerakiNetworkApplianceStaticRoute',
        'New-MerakiNetworkApplianceTrafficShapingCPC',
        'New-MerakiNetworkApplianceVLAN',
        'New-MerakiNetworkAppliancevMXAuthenticationToken',
        'New-MerakiNetworkAuthUser',
        'New-MerakiNetworkCameraQualityRetentionProfile',
        'New-MerakiNetworkCameraWirelessProfile',
        'New-MerakiNetworkFirmwareUpgradesRollback',
        'New-MerakiNetworkFirmwareUpgradesStagedEvent',
        'New-MerakiNetworkFirmwareUpgradesStagedGroup',
        'New-MerakiNetworkFloorPlan',
        'New-MerakiNetworkGroupPolicy',
        'New-MerakiNetworkMqttBroker',
        'New-MerakiNetworkPiiRequest',
        'New-MerakiNetworkSensorAlertsProfile',
        'New-MerakiNetworkSmTargetGroup',
        'New-MerakiNetworkSwitchAccessPolicy',
        'New-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer',
        'New-MerakiNetworkSwitchLinkAggregation',
        'New-MerakiNetworkSwitchPortSchedule',
        'New-MerakiNetworkSwitchQOSRule',
        'New-MerakiNetworkSwitchRoutingMulticastRendezvousPoint',
        'New-MerakiNetworkSwitchStack',
        'New-MerakiNetworkSwitchStackRoutingInterface',
        'New-MerakiNetworkSwitchStackRoutingStaticRoute',
        'New-MerakiNetworkVLANProfile',
        'New-MerakiNetworkWebhooksHttpServer',
        'New-MerakiNetworkWebhooksPayloadTemplate',
        'New-MerakiNetworkWebhooksWebhookTest',
        'New-MerakiNetworkWirelessEthernetPortsProfile',
        'New-MerakiNetworkWirelessRFProfile',
        'New-MerakiNetworkWirelessSSIDIdentityPSK',
        'New-MerakiOrganization',
        'New-MerakiOrganizationActionBatch',
        'New-MerakiOrganizationAdaptivePolicy',
        'New-MerakiOrganizationAdaptivePolicyACL',
        'New-MerakiOrganizationAdaptivePolicyGroup',
        'New-MerakiOrganizationAdmin',
        'New-MerakiOrganizationAlertsProfile',
        'New-MerakiOrganizationBrandingPolicy',
        'New-MerakiOrganizationCameraCustomAnalyticsArtifact',
        'New-MerakiOrganizationCameraRole',
        'New-MerakiOrganizationConfigTemplate',
        'New-MerakiOrganizationEarlyAccessFeaturesOptIn',
        'New-MerakiOrganizationInsightMonitoredMediaServer',
        'New-MerakiOrganizationInventoryOnboardingCloudMonitoringExportEvent',
        'New-MerakiOrganizationInventoryOnboardingCloudMonitoringImport',
        'New-MerakiOrganizationInventoryOnboardingCloudMonitoringPrepare',
        'New-MerakiOrganizationNetwork',
        'New-MerakiOrganizationPolicyObject',
        'New-MerakiOrganizationPolicyObjectsGroup',
        'New-MerakiOrganizationSamlIdp',
        'New-MerakiOrganizationSAMLRole',
        'Remove-MerakiDeviceSwitchRoutingInterface',
        'Remove-MerakiDeviceSwitchRoutingStaticRoute',
        'Remove-MerakiNetwork',
        'Remove-MerakiNetworkAppliancePrefixesDelegatedStatic',
        'Remove-MerakiNetworkApplianceRfProfile',
        'Remove-MerakiNetworkApplianceStaticRoute',
        'Remove-MerakiNetworkApplianceTrafficShapingCPC',
        'Remove-MerakiNetworkApplianceVLAN',
        'Remove-MerakiNetworkAuthUser',
        'Remove-MerakiNetworkCameraQualityRetentionProfile',
        'Remove-MerakiNetworkCameraWirelessProfile',
        'Remove-MerakiNetworkDevice',
        'Remove-MerakiNetworkFirmwareUpgradesStagedGroup',
        'Remove-MerakiNetworkFloorPlan',
        'Remove-MerakiNetworkGroupPolicy',
        'Remove-MerakiNetworkMqttBroker',
        'Remove-MerakiNetworkPiiRequest',
        'Remove-MerakiNetworkSensorAlertsProfile',
        'Remove-MerakiNetworkSmTargetGroup',
        'Remove-MerakiNetworkSmUserAccessDevice',
        'Remove-MerakiNetworkSwitchAccessPolicy',
        'Remove-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer',
        'Remove-MerakiNetworkSwitchLinkAggregation',
        'Remove-MerakiNetworkSwitchPortSchedule',
        'Remove-MerakiNetworkSwitchQOSRule',
        'Remove-MerakiNetworkSwitchRoutingMulticastRendezvousPoint',
        'Remove-MerakiNetworkSwitchStack',
        'Remove-MerakiNetworkSwitchStackRoutingInterface',
        'Remove-MerakiNetworkSwitchStackRoutingStaticRoute',
        'Remove-MerakiNetworkVLANProfile',
        'Remove-MerakiNetworkWebhooksHttpServer',
        'Remove-MerakiNetworkWebhooksPayloadTemplate',
        'Remove-MerakiNetworkWirelessEthernetPortsProfile',
        'Remove-MerakiNetworkWirelessRFProfile',
        'Remove-MerakiNetworkWirelessSSIDIdentityPSK',
        'Remove-MerakiOrganization',
        'Remove-MerakiOrganizationActionBatch',
        'Remove-MerakiOrganizationAdaptivePolicy',
        'Remove-MerakiOrganizationAdaptivePolicyACL',
        'Remove-MerakiOrganizationAdaptivePolicyGroup',
        'Remove-MerakiOrganizationAdmin',
        'Remove-MerakiOrganizationAlertsProfile',
        'Remove-MerakiOrganizationBrandingPolicy',
        'Remove-MerakiOrganizationCameraCustomAnalyticsArtifact',
        'Remove-MerakiOrganizationCameraRole',
        'Remove-MerakiOrganizationConfigTemplate',
        'Remove-MerakiOrganizationEarlyAccessFeaturesOptIn',
        'Remove-MerakiOrganizationInsightMonitoredMediaServer',
        'Remove-MerakiOrganizationPiiRequest',
        'Remove-MerakiOrganizationPolicyObject',
        'Remove-MerakiOrganizationPolicyObjectsGroup',
        'Remove-MerakiOrganizationSamlIdp',
        'Remove-MerakiOrganizationSamlRole',
        'Set-MerakiDevice',
        'Set-MerakiDeviceApplianceRadioSettings',
        'Set-MerakiDeviceApplianceUplinksSettings',
        'Set-MerakiDeviceCameraCustomAnalytics',
        'Set-MerakiDeviceCameraQualityAndRetention',
        'Set-MerakiDeviceCameraSense',
        'Set-MerakiDeviceCameraVideoSettings',
        'Set-MerakiDeviceCameraWirelessProfile',
        'Set-MerakiDeviceCellularGatewayLAN',
        'Set-MerakiDeviceCellularGatewayPortForwardingRules'
        'Set-MerakiDeviceCellularSims',
        'Set-MerakiDeviceManagementInterface',
        'Set-MerakiDeviceSensorRelationships',
        'Set-MerakiDeviceSwitchPort',
        'Set-MerakiDeviceSwitchRoutingInterface',
        'Set-MerakiDeviceSwitchRoutingInterfaceDHCP',
        'Set-MerakiDeviceSwitchRoutingStaticRoute',
        'Set-MerakiDeviceSwitchWarmSpare',
        'Set-MerakiDeviceWirelessBluetoothSettings',
        'Set-MerakiDeviceWirelessRadioSettings',
        'Set-MerakiNetwork',
        'Set-MerakiNetworkAlertSettings',
        'Set-MerakiNetworkApplianceConnectivityMonitoringDestinations',
        'Set-MerakiNetworkApplianceContentFiltering',
        'Set-MerakiNetworkApplianceFirewallCellularFirewallRules',
        'Set-MerakiNetworkApplianceFirewallFirewalledService',
        'Set-MerakiNetworkApplianceFirewallInboundCellularFirewallRules',
        'Set-MerakiNetworkApplianceFirewallInboundFirewallRules',
        'Set-MerakiNetworkApplianceFirewallL3FirewallRules',
        'Set-MerakiNetworkApplianceFirewallL7FirewallRules',
        'Set-MerakiNetworkApplianceFirewallOneToManyNatRules',
        'Set-MerakiNetworkApplianceFirewallOneToOneNatRules',
        'Set-MerakiNetworkApplianceFirewallPortForwardingRules',
        'Set-MerakiNetworkApplianceFirewallSettings',
        'Set-MerakiNetworkAppliancePort',
        'Set-MerakiNetworkAppliancePrefixesDelegatedStatic',
        'Set-MerakiNetworkApplianceRFProfile',
        'Set-MerakiNetworkApplianceSecurityIntrusion',
        'Set-MerakiNetworkApplianceSecurityMalware',
        'Set-MerakiNetworkApplianceSettings',
        'Set-MerakiNetworkApplianceSingleLan',
        'Set-MerakiNetworkApplianceSSID',
        'Set-MerakiNetworkApplianceStaticRoute',
        'Set-MerakiNetworkApplianceTrafficShaping',
        'Set-MerakiNetworkApplianceTrafficShapingCPC',
        'Set-MerakiNetworkApplianceTrafficShapingRules',
        'Set-MerakiNetworkApplianceTrafficShapingUplinkBandwidth',
        'Set-MerakiNetworkApplianceTrafficShapingUplinkSelection',
        'Set-MerakiNetworkApplianceTrafficShapingVPNExclusions',
        'Set-MerakiNetworkApplianceVLAN',
        'Set-MerakiNetworkApplianceVLANsSettings',
        'Set-MerakiNetworkApplianceVPNBGP',
        'Set-MerakiNetworkApplianceVPNSiteToSiteVPN',
        'Set-MerakiNetworkApplianceWarmSpare',
        'Set-MerakiNetworkAuthUser',
        'Set-MerakiNetworkCameraQualityRetentionProfile',
        'Set-MerakiNetworkCameraWirelessProfile',
        'Set-MerakiNetworkCellularGatewayConnectivityMonitoringDests',
        'Set-MerakiNetworkCellularGatewayDHCP',
        'Set-MerakiNetworkCellularGatewaySubnetPool',
        'Set-MerakiNetworkCellularGatewayUplink',
        'Set-MerakiNetworkClientPolicy',
        'Set-MerakiNetworkClientSplashAuthorizationStatus',
        'Set-MerakiNetworkFirmwareUpgrades',
        'Set-MerakiNetworkFirmwareUpgradesStagedEvent',
        'Set-MerakiNetworkFirmwareUpgradesStagedGroup',
        'Set-MerakiNetworkFirmwareUpgradesStagedStages',
        'Set-MerakiNetworkFloorPlan',
        'Set-MerakiNetworkGroupPolicy',
        'Set-MerakiNetworkMqttBroker',
        'Set-MerakiNetworkNetflow',
        'Set-MerakiNetworkSensorAlertsProfile',
        'Set-MerakiNetworkSensorMQTTBroker',
        'Set-MerakiNetworkSettings',
        'Set-MerakiNetworkSmDevicesFields',
        'Set-MerakiNetworkSmTargetGroup',
        'Set-MerakiNetworkSNMP',
        'Set-MerakiNetworkSwitchAccessPolicy',
        'Set-MerakiNetworkSwitchACLs',
        'Set-MerakiNetworkSwitchAlternateManagementInterface',
        'Set-MerakiNetworkSwitchDHCPServerPolicy',
        'Set-MerakiNetworkSwitchDHCPServerPolicyArpInspTrustedServer',
        'Set-MerakiNetworkSwitchDSCPToCOSMappings',
        'Set-MerakiNetworkSwitchLinkAggregation',
        'Set-MerakiNetworkSwitchMTU',
        'Set-MerakiNetworkSwitchPortSchedule',
        'Set-MerakiNetworkSwitchQOSRule',
        'Set-MerakiNetworkSwitchQOSRulesOrder',
        'Set-MerakiNetworkSwitchRoutingMulticast',
        'Set-MerakiNetworkSwitchRoutingMulticastRendezvousPoint',
        'Set-MerakiNetworkSwitchRoutingOSPF',
        'Set-MerakiNetworkSwitchSettings',
        'Set-MerakiNetworkSwitchStackRoutingInterface',
        'Set-MerakiNetworkSwitchStackRoutingInterfaceDHCP',
        'Set-MerakiNetworkSwitchStackRoutingStaticRoute',
        'Set-MerakiNetworkSwitchStormControl',
        'Set-MerakiNetworkSwitchSTP',
        'Set-MerakiNetworkSyslogServers',
        'Set-MerakiNetworkTrafficAnalysis',
        'Set-MerakiNetworkVLANProfile',
        'Set-MerakiNetworkVLANProfilesAssignments',
        'Set-MerakiNetworkWebhooksHttpServer',
        'Set-MerakiNetworkWebhooksPayloadTemplate',
        'Set-MerakiNetworkWirelessAlternateManagementInterface',
        'Set-MerakiNetworkWirelessAlternateManagementInterfaceIPv6',
        'Set-MerakiNetworkWirelessBilling',
        'Set-MerakiNetworkWirelessBluetoothSettings',
        'Set-MerakiNetworkWirelessEthernetPortsProfile',
        'Set-MerakiNetworkWirelessRFProfile',
        'Set-MerakiNetworkWirelessSettings',
        'Set-MerakiNetworkWirelessSSID',
        'Set-MerakiNetworkWirelessSSIDBonjourForwarding',
        'Set-MerakiNetworkWirelessSSIDDeviceTypeGroupPolicies',
        'Set-MerakiNetworkWirelessSSIDEAPOverride',
        'Set-MerakiNetworkWirelessSSIDFirewallL3FirewallRules',
        'Set-MerakiNetworkWirelessSSIDFirewallL7FirewallRules',
        'Set-MerakiNetworkWirelessSSIDHotspot20',
        'Set-MerakiNetworkWirelessSSIDIdentityPSK',
        'Set-MerakiNetworkWirelessSSIDSchedules',
        'Set-MerakiNetworkWirelessSSIDSplashSettings',
        'Set-MerakiNetworkWirelessSSIDTrafficShapingRules',
        'Set-MerakiNetworkWirelessSSIDVPN',
        'Set-MerakiOrganization',
        'Set-MerakiOrganizationActionBatch',
        'Set-MerakiOrganizationAdaptivePolicy',
        'Set-MerakiOrganizationAdaptivePolicyACL',
        'Set-MerakiOrganizationAdaptivePolicyGroup',
        'Set-MerakiOrganizationAdaptivePolicySettings',
        'Set-MerakiOrganizationAdmin',
        'Set-MerakiOrganizationAlertsProfile',
        'Set-MerakiOrganizationApplianceSecurityIntrusion',
        'Set-MerakiOrganizationApplianceVPNFirewallRules',
        'Set-MerakiOrganizationApplianceVPNThirdPartyVPNPeers',
        'Set-MerakiOrganizationBrandingPoliciesPriorities',
        'Set-MerakiOrganizationBrandingPolicy',
        'Set-MerakiOrganizationCameraOnboardingStatuses',
        'Set-MerakiOrganizationCameraRole',
        'Set-MerakiOrganizationConfigTemplate',
        'Set-MerakiOrganizationConfigTemplateSwitchProfilePort',
        'Set-MerakiOrganizationEarlyAccessFeaturesOptIn',
        'Set-MerakiOrganizationInsightMonitoredMediaServer',
        'Set-MerakiOrganizationLicense',
        'Set-MerakiOrganizationLoginSecurity',
        'Set-MerakiOrganizationPolicyObject',
        'Set-MerakiOrganizationPolicyObjectsGroup',
        'Set-MerakiOrganizationSAML',
        'Set-MerakiOrganizationSAMLIdp',
        'Set-MerakiOrganizationSAMLRole',
        'Set-MerakiOrganizationSnmp'
    )
    # AliasesToExport = @()
    # CmdletsToExport = @()
    # VariablesToExport = @()
    # FileList = @()
    #PrivateData = @{
    #   PSData = @{
            # Add any private module data here
    #    }
    #}
    # HelpInfoURI = ''
    # LicenseUri = ''
    # ProjectUri = ''
    # IconUri = ''
}
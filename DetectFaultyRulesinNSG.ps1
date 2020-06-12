Add-AzAccount
Select-AzSubscription -SubscriptionId ""


$RG = ""
$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $RG
$nsgrule = Get-AzNetworkSecurityGroup -ResourceGroupName $RG | Get-AzNetworkSecurityRuleConfig
$nsgarray = $nsg.Name
$rulearray = $nsgrule.Name

foreach($nsgitem in $nsgarray)
{
$nsg = Get-AzNetworkSecurityGroup -Name $nsgitem
    foreach ($ruleitem in $rulearray)
    {
        $rule = Get-AzNetworkSecurityRuleConfig -Name $ruleitem -NetworkSecurityGroup $nsg
        if($rule.DestinationPortRange -eq "*" -and $rule.SourcePortRange -eq "*" -and $rule.SourceAddressPrefix -eq "*" -and $rule.DestinationAddressPrefix -eq "*")
        {
            write-host Detected faulty rule $rule.Name in $nsg.Name -BackgroundColor DarkRed
        }
    }
}

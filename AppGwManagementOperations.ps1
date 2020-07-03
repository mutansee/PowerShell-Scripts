function login()
{
Add-AzAccount
$SubscriptionID = Read-Host -Prompt "Enter the Azure Subscription ID"
Select-AzSubscription -SubscriptionId $SubscriptionID
$(ResourceDetails)
}

function ResourceDetails()
{
$APPGWName = Read-Host -Prompt "Enter Application Gateway Name"
$RGName = Read-Host -Prompt "Enter the Resource Group Name"
$(state)
}

function state()
{
   $APPGW = Get-AzApplicationGateway -Name $APPGWName -ResourceGroupName $RGName
   if($APPGW.ProvisioningState -eq "Failed")
   {
   Write-Host The Application Gateway $APPGW.Name is in FAILED State. However, you would still be able to access Application. Allow us few minutes to update the App Gateway status -BackgroundColor DarkRed -ForegroundColor White
   Write-Host We have started updating the status for $APPGW.Name Kindly allow us few minutes. -ForegroundColor Cyan
   Set-AzApplicationGateway -ApplicationGateway $APPGW
        if($APPGW.ProvisioningState -eq "Failed")
        {Write-Host Unable to update the status. Kindly contact Microsoft support}
   }

   else
   {
    if($APPGW.OperationalState -eq "Stopped")
    {
      Write-Host The Application Gateway $APPGW.Name is in STOP state -BackgroundColor Red -ForegroundColor White
            $StartAppGw = Read-Host -Prompt "Would  you like to START the Application Gateway? Y/N"
           if($StartAppGw -eq "Y")
            {
                Write-Host Application Gateway $APPGW.Name is starting -ForegroundColor Green
                Start-AzApplicationGateway -ApplicationGateway $APPGW
                $APPGW = Get-AzApplicationGateway -Name $APPGWName -ResourceGroupName $RGName 
                Write-Host The Application Gateway $APPGW.Name has been started successully -ForegroundColor Green
            }
            else
            {break}
     }
    else
    {
     Write-Host The Application Gateway $APPGW.Name is Running -ForegroundColor Green
     $StopAppGw = Read-Host -Prompt "Would  you like to STOP the Application Gateway? Y/N"
     if($StopAppGw -eq "Y")
     {
         if(($APPGW.Sku.Tier -contains "Standard_v2") -or ($APPGW.Sku.Tier -contains "WAF_v2") )
         {
            Write-Host Application Gateway $APPGW.Name is of Version 2. The Public IP will remains the same. We have initiated the STOP operation -ForegroundColor Yellow
            Stop-AzApplicationGateway -ApplicationGateway $APPGW
            Write-Host The Application Gateway $APPGW.Name has been successully Stopped -ForegroundColor Green
         }
         else
          {
          Write-Host The Application Gateway $APPGW.Name is of Version 1. The STOP operation would release the current Public IP which would not be possible to Recover -ForegroundColor Yellow
          Start-Sleep -Seconds 7
         $StopAppGwConfirm = Read-Host -Prompt "Do you still wants to STOP the Application Gateway ? Y/N"
            if($StopAppGwConfirm -eq "Y")
            {
            Write-Host Application Gateway $APPGW.Name will be stopped in few minutes -ForegroundColor Yellow
            Stop-AzApplicationGateway -ApplicationGateway $APPGW
            Write-Host The Application Gateway $APPGW.Name has been successully Stopped -ForegroundColor Green
            }
            else
            {break}
           }
      }
      else
      {break}
     }
   }     
}

$(login)
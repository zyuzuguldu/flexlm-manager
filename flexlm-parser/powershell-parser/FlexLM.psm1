function Get-FlexLMUsage {
param(
    [Parameter(Mandatory=$True)]
    [string]$LogFile
)
    $Log = Get-Content $LogFile -ErrorAction Stop
    
    $Log | ForEach-Object {
        if ($_ -match '.* TIMESTAMP (.*)') {
            $Date = $matches[1]
        }
        elseif ($_ -match '(\d+:\d+:\d+)\s\((.*)\)\s(OUT|IN):\s"(.*)"\s(.*)@(.*)') {
            $Properties = @{
                'DateTime'     = Get-Date ('{0} {1}' -f $Date,$Matches[1])
                'Server'       = $Matches[2]
                'Action'       = $Matches[3]
                'License'      = $Matches[4]
                'UserName'     = $Matches[5].Trim()
                'ComputerName' = $Matches[6].Trim()
            }
            Write-Output (New-Object -TypeName PSObject -Property $Properties )
        }
        
    }
}

function Get-FlexLmServices {
    $FlexLMBaseKey = 'HKLM:\SOFTWARE\FLEXlm License Manager'
    
    if (Test-Path $FlexLMBaseKey) {
        Get-ChildItem 'HKLM:\SOFTWARE\FLEXlm License Manager' | foreach-object { 
            $RegProperties = Get-ItemProperty $_.PSPath
            $WMIService    = Get-WmiObject Win32_Service | Where {$_.PathName -eq $RegProperties.lmgrd}
            
            $Properties = @{
                'ServiceName'    = $_.Name
                'LicensePath'    = $RegProperties.License
                'LicenseExists'  = Test-Path $RegProperties.License
                'LogFilePath'    = $RegProperties.lmgrd_log_file
                'ServicePath'    = $RegProperties.lmgrd
                'Service'        = $(if ($WMIService.Name) {Get-Service -Name $WMIService.Name})
                'ServiceProcess' = $(if ($WMIService.ProcessId ) {Get-Process -Id $WMIService.ProcessId})
            }
            Write-Output (New-Object -TypeName PSObject -Property $Properties)
        } 
    }
    else {
        Write-Error "No FLEXlm License Manager Found"
    }
}
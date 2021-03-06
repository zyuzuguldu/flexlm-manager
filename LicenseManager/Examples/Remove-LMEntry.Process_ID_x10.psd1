@{
    Parameters   = @{
        LicenseManager  = @{
            DirectoryPath = '%ProjectRoot%\dev\LicenseManager'
            Processes     = @{
                '19f3c7a5-8e6a-4379-ab73-b65c2f0a0ea7' = 2
                'notepad.exe'                          = 5
                'Calculator.exe'                       = 10
            }
        }
        ProcessName     = '19f3c7a5-8e6a-4379-ab73-b65c2f0a0ea7'
        ProcessId       = 19
        ProcessUserName = 'Test\Pester'
    }
    <#
        ExpectedJson
        {0}:$env:ComputerName
    #>
    ExistingJson = @'
{
    "UserName":  "Test\\Pester",
    "ProcessId":  [
                      11, 22, 33, 44, 55, 66, 77, 88, 99, 1010, 19
                  ],
    "ComputerName":  "{0}",
    "TimeStamp":  "Thursday, June 22, 2017 5:43:33 PM"
}
'@
    <#
        ExpectedJson
        {0}:$env:ComputerName
        {1}:Timestamp within last minute
    #>
    ExpectedJson = @'
{
    "UserName":  "Test\\Pester",
    "ProcessId":  [
                      11, 22, 33, 44, 55, 66, 77, 88, 99, 1010
                  ],
    "ComputerName":  "{0}",
    "TimeStamp":  "{1}"
}
'@
    NoChange = $false
}
$Url = "http://10.9.5.41:8080/zbx/zabbix_win.zip"
$Path = "C:\zabbix_win.zip"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile( $Url, $Path )
cd C:\
ls
Function Unzip-File()
            {
                param([string]$ZipFile,[string]$TargetFolder)
                if(!(Test-Path $TargetFolder))
                {
                 mkdir $TargetFolder
                }
                    $shellApp = New-Object -ComObject Shell.Application
                    $files = $shellApp.NameSpace($ZipFile).Items()
                    $shellApp.NameSpace($TargetFolder).CopyHere($files)
            }

Unzip-File -ZipFile $Path -TargetFolder C:\
C:\zabbix\bin\win64\zabbix_agentd.exe -c c:\zabbix\conf\zabbix_agentd.win.conf -i
start-service "Zabbix Agent"
netsh firewall set allowedprogram C:\zabbix\bin\win64\zabbix_agentd.exe zabbix_agentd ENABLE

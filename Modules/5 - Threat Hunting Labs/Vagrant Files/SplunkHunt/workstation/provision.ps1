Set-ExecutionPolicy Bypass -Scope LocalMachine -Force 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# Install Chocolatey
refreshenv
# Sysmon
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile "c:\users\vagrant\Desktop\Sysmon.zip"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" -OutFile "c:\users\vagrant\Desktop\sysmonconfig-export.xml"
Expand-Archive -F c:\users\vagrant\desktop\Sysmon.zip -DestinationPath c:\users\vagrant\desktop\sysmon
c:\users\vagrant\desktop\sysmon\sysmon.exe -accepteula -i c:\users\vagrant\desktop\sysmonconfig-export.xml

# SysInternals tools
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/SysinternalsSuite.zip" -OutFile "c:\users\vagrant\Desktop\sysinternals.zip"
Expand-Archive -F c:\users\vagrant\desktop\sysinternals.zip -DestinationPath c:\users\vagrant\desktop\sysinternals


choco install splunk-universalforwarder -y --install-arguments="SPLUNK_APP=SplunkForwarder AGREETOLICENSE=Yes"

Move-Item  "c:\users\vagrant\desktop\outputs.conf" -Destination "C:\Program Files\SplunkUniversalForwarder\etc\system\local" -Force
Move-Item  "c:\users\vagrant\desktop\inputs.conf" -Destination "C:\Program Files\SplunkUniversalForwarder\etc\system\local" -Force

Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n10.10.1.1`tothf.local" -Force

$domain = "othf.local"
$password = "!P@ssword123456" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\administrator" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential -Force
Import-Module WebAdministration

Set-Location IIS:\

$Location="C:\inetpub\wwwroot\"

New-Item -Path $Location -Name "cust4.net2connect.com" -ItemType "directory"

New-Item IIS:\AppPools\cust4.net2connect.com

New-Item IIS:\Sites\cust4.net2connect.com -physicalPath c:\inetpub\wwwroot\cust4.net2connect.com –bindings `
@{protocol="http";bindingInformation=":80:cust4.net2connect.com"}


Set-ItemProperty IIS:\Sites\cust4.net2connect.com -name applicationPool -value cust4.net2connect.com

Set-Content C:\inetpub\wwwroot\cust4.net2connect.com\default.htm `
"Customer1 Default Page"

New-WebBinding -Name "cust4.net2connect.com" -IP "*" -Port 443 -Protocol https –HostHeader cust4.net2connect.com -SslFlags 1

$CertThumbprint = Get-ChildItem -Path Cert:\LocalMachine\My | where-Object {$_.subject -like "*net2connect.com*"} | Select-Object -ExpandProperty Thumbprint

New-Item -Path "IIS:\SslBindings\*!443!cust4.net2connect.com" -Thumbprint $CertThumbprint -SSLFlags 1

$result = Invoke-WebRequest -Uri “http://cust4.net2connect.com”

Write-Output $Result
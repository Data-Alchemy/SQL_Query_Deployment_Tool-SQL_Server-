###################################################################################################################
#### Create Application Database
#### Description: This script executes any sql script in the query.sql file
#### Author: Sebastian Hansen                                             
###################################################################################################################

###################################################################################################################
#### Variables ####

# Connection Variables #
param($Server_Name, $Database)
If ($Server_Name -eq $null){$Server_Name = 'VAN-VPP-DBA-01\DOCMAP'}
If ($Database -eq $null){$Database = 'Master'}

# Script Variables #
$Collect_Meta_Sql = '.\SQL_Metadata\Collect_Metadata.sql'
$Output_Meta = '.\SQL_Metadata\Metadata.csv'
$Main_Script = '.\Main\query.sql'

###################################################################################################################

# Make sure powershell is on tls1.2 since default is deprecated
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


#Add Dependencies for Invoke-SQLCMD
Install-PackageProvider -Name NuGet -Force
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name SqlServer -Force -AllowClobber  -Confirm:$false
Import-Module SqlServer -Force

###################################################################################################################

# Collect Metadata before executing script #

Invoke-Sqlcmd -ServerInstance $Server_Name  -Database "Master" -Query "Select @@VERSION"
Invoke-Sqlcmd -ServerInstance $Server_Name  -Database $Database -InputFile $Collect_Meta_sql | Out-File -FilePath $Output_Meta

#
git add $Output_Meta
git commit -am "Added Before Snapshot"
git push origin master

### Main Execute SQL Script #### 
Measure-Command{
Invoke-Sqlcmd -ServerInstance $Server_Name  -Database $Database -InputFile $Main_Script | Out-File -FilePath Log.txt
}
################################


Invoke-Sqlcmd -ServerInstance $Server_Name  -Database $Database -InputFile $Collect_Meta_sql | Out-File -FilePath $Output_Meta

git add $Output_Meta
git commit -am "Added After Snapshot"
git push origin master
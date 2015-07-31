$schemaComparePath = 'C:\\Program Files\\Red Gate\\Schema Compare for Oracle 3\\SCO.exe'
$targetSchemaName = "${bamboo.OracleDbLiveSchema}"
$username = "${bamboo.OracleDbUser}"
$password = "${bamboo.OracleDbPassword}"
$sourceName = "${bamboo.SourceSchemaName}"
Write-Output "Using the following variables:"
Write-Output "schemaComparePath: $schemaComparePath"
Write-Output "targetSchemaName: $targetSchemaName"
Write-Output "username: $username"
Write-Output "password: has been set to the bamboo variable OracleDbPassword"
Write-Output "sourceName: $sourceName"

Write-Warning "Upgrading $targetSchemaName"

# Create upgrade script using compare
& $schemaComparePath -source "${bamboo.build.working.directory}\extractedNuGet\state{$sourceName}" -target "$username/$password@localhost{$targetSchemaName}" -deploy -verbose -scriptfile "${bamboo.build.working.directory}\artifacts\upgradeScript.sql" -report  "${bamboo.build.working.directory}\artifacts\diffReport.html" -reporttype Simple -includeidentical | Out-Host

Write-Output "Schema Compare for Oracle exited with code $lastExitCode"
Write-Output "UpgradeScript and diff report created and saved to ${bamboo.build.working.directory}\artifacts"

# Exit code 61 is simply telling us there are differences that have been deployed.
if( $lastExitCode -eq 61)
{
    exit 0
}

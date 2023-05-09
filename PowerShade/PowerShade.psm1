#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue -Recurse )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue -Recurse )

$ErrorsFound = @(
  #Dot source the files
  Foreach ($Import in @($Public + $Private))
  {
    Try
    {
      . $Import.Fullname
    } Catch
    {
      Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
      $true
    }
  }
)

if ($ErrorsFound.Count -gt 0)
{
  $ModuleName = (Get-ChildItem $PSScriptRoot\*.psd1).BaseName
  Write-Warning "Importing module $ModuleName failed. Fix errors before continuing."
  break
}

$script:ansiStyler = $null
$script:commandSpec = $null

function Get-ChildItemAlias()
{
  Get-ChildItem @args | Out-String -Stream | ConvertTo-ShadedString -Styler $ansiStyler -RegexToStyles $commandSpec['Get-ChildItem'] 
}

function Get-HelpAlias()
{
  Get-Help @args | Out-String -Stream | ConvertTo-ShadedString -Styler $ansiStyler -RegexToStyles $commandSpec['Get-Help']
}

function Get-LocationAlias()
{
  Get-Location @args | ConvertTo-ShadedString -Styler $ansiStyler -RegexToStyles $commandSpec['Get-Location']
}

function Set-PowerShadeAliasList()
{
  [CmdletBinding(SupportsShouldProcess = $true)]
  param()
  $colorPalette = Get-PowerShadePalette
  $script:ansiStyler = New-PowerShadeStyler -Palette $ColorPalette
  $script:commandSpec = Get-PowerShadeBuiltinSpec

  Set-Alias -Name ls -Value Get-ChildItemAlias -Scope Global
  Set-Alias -Name chelp -Value Get-HelpAlias -Scope Global
  Set-Alias -Name pwd -Value Get-LocationAlias -Scope Global
}


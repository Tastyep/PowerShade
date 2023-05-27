$script:ansiStyler = $null
$script:commandSpec = $null

function Get-ChildItemAlias()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )

  Add-PowerShadeStyle -Styler $ansiStyler -CommandToSpec $commandSpec -CommandName 'Get-ChildItem' @Params
}

function Get-HelpAlias()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )
  
  Add-PowerShadeStyle -Styler $ansiStyler -CommandToSpec $commandSpec -CommandName 'Get-Help' @Params
}

function Get-LocationAlias()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )
  
  Add-PowerShadeStyle -Styler $ansiStyler -CommandToSpec $commandSpec -CommandName 'Get-Location' @Params
}

function Set-PowerShadeAliases()
{
  $colorPalette = Get-PowerShadePalette
  $script:ansiStyler = New-PowerShadeStyler -Palette $ColorPalette
  $script:commandSpec = Get-PowerShadeBuiltinSpec

  Set-Alias -Name ls -Value Get-ChildItemAlias -Scope Global
  Set-Alias -Name chelp -Value Get-HelpAlias -Scope Global
  Set-Alias -Name pwd -Value Get-LocationAlias -Scope Global
}


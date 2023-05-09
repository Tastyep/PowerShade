Import-Module -Name "$PSScriptRoot\PowerShade"

$ansiStyle = NewAnsiStyle -Palette $ColorPalette

function Get-ChildItemAlias()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )
    
  ColorCommand -AnsiStyle $ansiStyle -CommandToSpec $CommandToAnsiSpec -CommandName 'Get-ChildItem' @Params
}

Remove-Item Alias:ls -ErrorAction SilentlyContinue
New-Alias -Name ls -Value Get-ChildItemAlias

function Get-HelpAlias()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )
  
  ColorCommand -AnsiStyle $ansiStyle -CommandToSpec $CommandToAnsiSpec -CommandName 'Get-Help' @Params
}

Remove-Item Alias:chelp -ErrorAction SilentlyContinue
New-Alias -Name chelp -Value Get-HelpAlias

function Get-LocationAlias()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )
  
  ColorCommand -AnsiStyle $ansiStyle -CommandToSpec $CommandToAnsiSpec -CommandName 'Get-Location' @Params
}

Remove-Item Alias:pwd -ErrorAction SilentlyContinue
New-Alias -Name pwd -Value Get-LocationAlias

$script:ansiStyle = $null

function Get-ChildItemAlias()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )

  ColorCommand -AnsiStyle $script:ansiStyle -CommandToSpec $CommandToAnsiSpec -CommandName 'Get-ChildItem' @Params
}
#   
function Get-HelpAlias()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )
  
  ColorCommand -AnsiStyle $script:ansiStyle -CommandToSpec $CommandToAnsiSpec -CommandName 'Get-Help' @Params
}

function Get-LocationAlias()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )
  
  ColorCommand -AnsiStyle $script:ansiStyle -CommandToSpec $CommandToAnsiSpec -CommandName 'Get-Location' @Params
}


function Add-PowerShadeAliases()
{
  $script:ansiStyle = NewAnsiStyle -Palette $ColorPalette

  Set-Alias -Name ls -Value Get-ChildItemAlias -Scope Global
  Set-Alias -Name chelp -Value Get-HelpAlias -Scope Global
  Set-Alias -Name pwd -Value Get-LocationAlias -Scope Global
}


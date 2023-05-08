. "class/ansi_color.ps1"

function ColorCommand() {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    $AnsiStyle,
    [Parameter(Mandatory = $true)]
    [hashtable]$CommandToSpec,
    [Parameter(Mandatory = $true)]
    [string]$CommandName,
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params
  )
  $commandInfo = $(Get-Command -Name $CommandName)
  $command = $commandInfo.Name
  if ($commandInfo.ResolvedCommand) {
    $command = $commandInfo.ResolvedCommand.Name
  }

  if (!$CommandToSpec.ContainsKey($command)) {
    Write-Host "No color available for $command"
    Invoke-Expression ($command + ' ' + $Params -join ' ') 
  }
  else {
    $regexStyleMap = $CommandToSpec[$command]
        
    Invoke-Expression ($command + ' ' + $Params -join ' ') | Out-String -Stream | ForEach-Object -Process {
      $coloredLine = $AnsiStyle.ColorizeLine($_, $regexStyleMap)
      Write-Host $coloredLine
    }
  }
}

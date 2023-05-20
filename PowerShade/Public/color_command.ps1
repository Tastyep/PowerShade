function Add-PowerShadeStyle()
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    $AnsiStyler,
    [Parameter(Mandatory = $true, Position = 1)]
    [hashtable]$CommandToSpec,
    [Parameter(Mandatory = $true, Position = 2)]
    [string]$CommandName,
    [Parameter(ValueFromRemainingArguments = $true)]
    $Params,
    [int]$BufferSize = 20
  )

  $commandInfo = $(Get-Command -Name $CommandName)
  $command = $commandInfo.Name
  if ($commandInfo.ResolvedCommand)
  {
    $command = $commandInfo.ResolvedCommand.Name
  }

  if (!$CommandToSpec.ContainsKey($command))
  {
    Write-Host "No color available for $command"
    Invoke-Expression ($command + ' ' + $Params -join ' ') 
  } else
  {
    $regexStyleMap = $CommandToSpec[$command]
    $lines = [System.Text.StringBuilder]::new()
    $lineCount = 0
    Invoke-Expression ($command + ' ' + $Params -join ' ') | Out-String -Stream | ForEach-Object -Process {
      $coloredLine = $AnsiStyler.ColorizeLine($_, $regexStyleMap)
      
      [void]($lines.Append($coloredLine))
      $lineCount += 1
      if ($lineCount -ge $BufferSize)
      {
        Write-Output $lines.ToString()
        [void]($lines.Clear())
        $lineCount = 0
      } else
      {
        [void]($lines.Append("`r`n"))
      }
    }
  }
  if ($lineCount -gt 0)
  {
    Write-Host $lines.ToString()
  }
}

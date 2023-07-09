<#
.SYNOPSIS
This function takes an input and applies styles to it based on the specified regular expressions, buffering the output to improve performance.

.DESCRIPTION
The `ConvertTo-ShadedString` function colorizes the input text based on a provided `Styler` object and an ordered dictionary mapping regular expressions to styles. The function also introduces a buffering mechanism which will flush the output to the console either when the buffer line limit has been reached or a specified duration has elapsed, whichever comes first.

.PARAMETER Styler
An object responsible for colorizing a line of text. It must have a `ColorizeLine` method that takes two parameters: the input text to colorize, and an ordered dictionary where each key is a regular expression and each value is the corresponding style.

.PARAMETER RegexToStyles
An ordered dictionary where each key is a regular expression and each value is the corresponding style. The `ColorizeLine` method of the `Styler` object uses this dictionary to apply styles to the input text.

.PARAMETER BufferSize
The maximum number of lines that the function will hold in the buffer before writing the output to the console. Defaults to 20 lines.

.PARAMETER BufferMaxDuration
The maximum amount of time (in milliseconds) that the function will hold lines in the buffer before writing the output to the console. Defaults to 100ms.

.PARAMETER Input
The input text to be colorized. This parameter accepts pipeline input.

.EXAMPLE
```powershell
$styler = New-PowerShadeStyler -Palette $ColorPalette
$regexToStyles = @{
    'Error' = New-PowerSHadeSpec -Color 'Red'
    'Warning' = New-PowerSHadeSpec -Color 'Yellow'
    'Success' = New-PowerSHadeSpec -Color 'Green'
}

Get-Content log.txt | ConvertTo-ShadedString -Styler $styler -RegexToStyles $regexToStyles
```
This example reads a file named `log.txt` and pipes its content to `ConvertTo-ShadedString`. The function uses the `Styler` object to colorize the lines based on the `RegexToStyles` dictionary. For instance, lines containing 'Error' will be colored red, 'Warning' will be colored yellow, and 'Success' will be colored green.

.NOTES
The `ColorizeLine` method of the `Styler` object should return a string with appropriate styling applied.
#>
function ConvertTo-ShadedString()
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    $Styler,
    [Parameter(Mandatory = $true)]
    [System.Collections.Specialized.OrderedDictionary]$RegexToStyles,
    
    [int]$BufferSize = 20, # lines
    [int]$BufferMaxDuration = 100, # ms
    
    [Parameter(ValueFromPipeline = $true)]
    [object]$Input
  )
  
  begin
  {
    if (!(Test-Path variable:lines))
    {
      $Script:shadedLines = [System.Text.StringBuilder]::new()
      $Script:lineCount = 0
      $Script:lastWriteTime = Get-Date
    }
  }
 
  process
  {
    $writeTime = Get-Date
    [void]($Script:shadedLines.Append($Styler.ColorizeLine($Input, $RegexToStyles)))
    $Script:lineCount += 1
    if ($Script:lineCount -ge $BufferSize -or ($writeTime - $Script:lastWriteTime) -ge $bufferMaxDuration)
    {
      Write-Output $Script:shadedLines.ToString()
      [void]($Script:shadedLines.Clear())
      $Script:lineCount = 0
      $Script:lastWriteTime = $writeTime
    } else
    {
      [void]($Script:shadedLines.Append("`r`n"))
    }
  }

  end
  {
    if ($Script:lineCount -gt 0)
    {
      Write-Output $Script:shadedLines.ToString()
    }

  }
}

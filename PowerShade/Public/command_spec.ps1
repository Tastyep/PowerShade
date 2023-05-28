$filenamePattern = "([\s\w.\-_]+)"
$gciFilenamePattern = "\s+\d*\s+$filenamePattern$"

$commandToAnsiSpec = @{
  'Get-Help'      = [ordered]@{
    '^\bNAME|SYNOPSIS|SYNTAX|DESCRIPTION|RELATED LINKS|PARAMETERS|ALIASES|REMARKS|INPUTS|OUTPUTS\b$' = New-PowerShadeSpec -Color 'Crimson' # sections
    '<CommonParameters>'                                         = New-PowerShadeSpec -Color 'Ebony'
    '"[^`"]*"'                                                    = New-PowerShadeSpec -Color 'Pale Green'  # "..."
    "'[^']*'"                                                     = New-PowerShadeSpec -Color 'Khaki'  # '...'
    "``[^``]*``"                                                  = New-PowerShadeSpec -Color "Khaki"  # `...`
    '-*\s?(EXAMPLE \d+) - .*\s?-*$'                                  = New-PowerShadeSpec -Color 'Dark Red' -Style 'Bold'
    'https?:/\S+'                                                 = New-PowerShadeSpec -Color 'Cornflower Blue'  # hyperlink
    '[\s\[]+(-\w+)'                                                    = New-PowerShadeSpec -Color 'Dodger Blue'  # parameters
    '[{}|]'                                                       = New-PowerShadeSpec -Color 'Crimson'  # { }
    '[\[\]]'                                                      = New-PowerShadeSpec -Color 'Yellow'  # [ ]
    '[\(\)]'                                                      = New-PowerShadeSpec -Color 'Dark Gray'  # ( )
    '[<>,\.]'                                                     = New-PowerShadeSpec -Color 'Gray'  # < >
    ' \$\w+'                                                      = New-PowerShadeSpec -Color 'Beige'  # $Var
  }
  'Get-ChildItem' = [ordered]@{
    '^\s*(Directory:\s.*)'                         = New-PowerShadeSpec -Color 'Orange' -Style 'underline' # Header
    '^\bMode|\bLastWriteTime|\bLength\b|\bName\b'  = New-PowerShadeSpec -Color 'Crimson' # SubHeader
    '^d'                                           = New-PowerShadeSpec -Color 'Royal Blue' # Directory
    "^d.*$gciFilenamePattern"                      = New-PowerShadeSpec -Color 'Royal Blue'
    '^l'                                           = New-PowerShadeSpec -Color 'Orange' # Link
    '^l.*\s+(link ->)'                             = New-PowerShadeSpec -Color 'Orange'
    '^.(a)'                                        = New-PowerShadeSpec -Color 'Khaki' # Archive
    "^.(a).*$gciFilenamePattern"                   = New-PowerShadeSpec -Color 'Khaki'
    '^.{2}(r)'                                     = New-PowerShadeSpec -Color 'Lime Green' # Read-Only
    "^.
    {2
    }(r).*$gciFilenamePattern"                = New-PowerShadeSpec -Color 'Lime Green'
    '^.{3}(h)'                                     = New-PowerShadeSpec -Color 'Dark Gray' # Hidden
    "^.
    {3
    }(h).*$gciFilenamePattern"                = New-PowerShadeSpec -Color 'Dark Gray'
    '^.{4}(s)'                                     = New-PowerShadeSpec -Color 'Red' # System
    "^.
    {4
    }(s).*$gciFilenamePattern"                = New-PowerShadeSpec -Color 'Red'
  }
  'Get-Location'  = [ordered]@{
    '^Path'             = New-PowerShadeSpec -Color 'Crimson' # Header
    '^C:'               = New-PowerShadeSpec -Color 'Deep Sky Blue'
    '^D:'               = New-PowerShadeSpec -Color 'Sea Green'
    '^E:'               = New-PowerShadeSpec -Color 'Gold'
    '^F:'               = New-PowerShadeSpec -Color 'Violet'
    '^G:'               = New-PowerShadeSpec -Color 'Crimson'
    '^H:'               = New-PowerShadeSpec -Color 'Dark Goldenrod'
    '^I:'               = New-PowerShadeSpec -Color 'Cornflower Blue'
    '^J:'               = New-PowerShadeSpec -Color 'Spring Green'
    '^K:'               = New-PowerShadeSpec -Color 'Tomato'
    '^L:'               = New-PowerShadeSpec -Color 'Steel Blue'
    '\\([^\\]+)(?<! )$' = New-PowerShadeSpec -Color 'Beige' -Style 'Underline'
    '\\'                = New-PowerShadeSpec -Color 'Ebony'
  }
  'Write-Output'  = [ordered]@{
  }
}

function Get-PowerShadeBuiltinSpec()
{
  return $commandToAnsiSpec
}

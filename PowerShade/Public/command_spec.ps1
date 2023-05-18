$commandToAnsiSpec = @{
  'Get-Help'      = [ordered]@{
    '^\bNAME|SYNTAX|PARAMETERS|ALIASES|REMARKS|INPUTS|OUTPUTS\b$' = New-AnsiSpec -Color 'Crimson' # sections
    '<CommonParameters\>'                                         = New-AnsiSpec -Color 'Ebony'
    'https?:/\S+'                                                 = New-AnsiSpec -Color 'Cornflower Blue'  # hyperlink
    '^\s+-\w+'                                                    = New-AnsiSpec -Color 'Dodger Blue'  # parameters
    '[{}|]'                                                       = New-AnsiSpec -Color 'Crimson'  # { }
    '[<>,\.]'                                                     = New-AnsiSpec -Color 'Gray'  # < >
    '[\[\]]'                                                      = New-AnsiSpec -Color 'Yellow'  # [ ]
    '[\(\)]'                                                      = New-AnsiSpec -Color 'Green'  # ( )
    '\".*\"'                                                      = New-AnsiSpec -Color 'Pale Green'  # '...'
  }
  'Get-ChildItem' = [ordered]@{
    '^\s*(Directory:\s.*)'                         = New-AnsiSpec -Color 'Orange' -Style 'underline' # Header
    '^\bMode|\bLastWriteTime|\bLength\b|\bName\b'  = New-AnsiSpec -Color 'Crimson' # SubHeader
    '^d'                                           = New-AnsiSpec -Color 'Royal Blue' # Directory
    '^d.*\s+\b(.*)\b'                              = New-AnsiSpec -Color 'Royal Blue'
    '^l'                                           = New-AnsiSpec -Color 'Orange' # Link
    '^l.*\s+(link ->)'                             = New-AnsiSpec -Color 'Orange'
    '^.(a)'                                        = New-AnsiSpec -Color 'Khaki' # Archive
    '^.(a).*\s+\b(.*)\b'                           = New-AnsiSpec -Color 'Khaki'
    '^.{2}(r)'                                     = New-AnsiSpec -Color 'Lime Green' # Read-Only
    '^.{2}(r).*\s+\b(.*)\b'                        = New-AnsiSpec -Color 'Lime Green'
    '^.{3}(h)'                                     = New-AnsiSpec -Color 'Dark Gray' # Hidden
    '^.{3}(h).*\s+\b(.*)\b'                        = New-AnsiSpec -Color 'Dark Gray'
    '^.{4}(s)'                                     = New-AnsiSpec -Color 'Red' # System
    '^.{4}(s).*\s+\b(.*)\b'                        = New-AnsiSpec -Color 'Red'
  }
  'Get-Location'  = [ordered]@{
    '^Path'             = New-AnsiSpec -Color 'Crimson' # Header
    '^C:'               = New-AnsiSpec -Color 'Deep Sky Blue'
    '^D:'               = New-AnsiSpec -Color 'Sea Green'
    '^E:'               = New-AnsiSpec -Color 'Gold'
    '^F:'               = New-AnsiSpec -Color 'Violet'
    '^G:'               = New-AnsiSpec -Color 'Crimson'
    '^H:'               = New-AnsiSpec -Color 'Dark Goldenrod'
    '^I:'               = New-AnsiSpec -Color 'Cornflower Blue'
    '^J:'               = New-AnsiSpec -Color 'Spring Green'
    '^K:'               = New-AnsiSpec -Color 'Tomato'
    '^L:'               = New-AnsiSpec -Color 'Steel Blue'
    '\\([^\\]+)(?<! )$' = New-AnsiSpec -Color 'Beige' -Style 'Underline'
    '\\'                = New-AnsiSpec -Color 'Ebony'
  }
  'Write-Output'  = [ordered]@{
  }
}

function Get-PowerShadeBuiltinSpec()
{
  return $commandToAnsiSpec
}

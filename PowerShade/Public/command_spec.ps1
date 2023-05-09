$CommandToAnsiSpec = @{
  'Get-Help'      = [ordered]@{
    '^\bNAME|SYNTAX|PARAMETERS|ALIASES|REMARKS|INPUTS|OUTPUTS\b$' = NewAnsiSpec -Color 'Crimson' # sections
    '<CommonParameters\>'                                         = NewAnsiSpec -Color 'Ebony'
    'https?:/\S+'                                                 = NewAnsiSpec -Color 'Cornflower Blue'  # hyperlink
    '^\s+-\w+'                                                    = NewAnsiSpec -Color 'Dodger Blue'  # parameters
    '[{}|]'                                                       = NewAnsiSpec -Color 'Crimson'  # { }
    '[<>,\.]'                                                     = NewAnsiSpec -Color 'Gray'  # < >
    '[\[\]]'                                                      = NewAnsiSpec -Color 'Yellow'  # [ ]
    '[\(\)]'                                                      = NewAnsiSpec -Color 'Green'  # ( )
    '\".*\"'                                                      = NewAnsiSpec -Color 'Pale Green'  # '...'
  }
  'Get-ChildItem' = [ordered]@{
    '^\s*(Directory:\s.*)'                         = NewAnsiSpec -Color 'Orange' -Style 'underline' # Header
    '^\bMode|\bLastWriteTime|\bLength\b|\bName\b'  = NewAnsiSpec -Color 'Crimson' # SubHeader
    '^d'                                           = NewAnsiSpec -Color 'Royal Blue' # Directory
    '^d.*\s+\b(.*)\b'                              = NewAnsiSpec -Color 'Royal Blue'
    '^l'                                           = NewAnsiSpec -Color 'Orange' # Link
    '^l.*\s+(link ->)'                             = NewAnsiSpec -Color 'Orange'
    '^.(a)'                                        = NewAnsiSpec -Color 'Khaki' # Archive
    '^.(a).*\s+\b(.*)\b'                           = NewAnsiSpec -Color 'Khaki'
    '^.{2}(r)'                                     = NewAnsiSpec -Color 'Lime Green' # Read-Only
    '^.{2}(r).*\s+\b(.*)\b'                        = NewAnsiSpec -Color 'Lime Green'
    '^.{3}(h)'                                     = NewAnsiSpec -Color 'Dark Gray' # Hidden
    '^.{3}(h).*\s+\b(.*)\b'                        = NewAnsiSpec -Color 'Dark Gray'
    '^.{4}(s)'                                     = NewAnsiSpec -Color 'Red' # System
    '^.{4}(s).*\s+\b(.*)\b'                        = NewAnsiSpec -Color 'Red'
  }
  'Get-Location'  = [ordered]@{
    '^Path'             = NewAnsiSpec -Color 'Crimson' # Header
    '^C:'               = NewAnsiSpec -Color 'Deep Sky Blue'
    '^D:'               = NewAnsiSpec -Color 'Sea Green'
    '^E:'               = NewAnsiSpec -Color 'Gold'
    '^F:'               = NewAnsiSpec -Color 'Violet'
    '^G:'               = NewAnsiSpec -Color 'Crimson'
    '^H:'               = NewAnsiSpec -Color 'Dark Goldenrod'
    '^I:'               = NewAnsiSpec -Color 'Cornflower Blue'
    '^J:'               = NewAnsiSpec -Color 'Spring Green'
    '^K:'               = NewAnsiSpec -Color 'Tomato'
    '^L:'               = NewAnsiSpec -Color 'Steel Blue'
    '\\([^\\]+)(?<! )$' = NewAnsiSpec -Color 'Beige' -Style 'Underline'
    '\\'                = NewAnsiSpec -Color 'Ebony'
  }
  'Write-Output'  = [ordered]@{
  }
}

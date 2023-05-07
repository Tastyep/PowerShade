. "class/ansi_color.ps1"

$CommandToAnsiSpec = @{
  'Get-Help'      = [ordered]@{
    '^\bNAME|SYNTAX|PARAMETERS|ALIASES|REMARKS|INPUTS|OUTPUTS\b$' = NewAnsiSpec('Crimson') # sections
    '<CommonParameters\>'                                         = NewAnsiSpec('Ebony')
    'https?:/\S+'                                                 = NewAnsiSpec('Cornflower Blue')  # hyperlink
    '^\s+-\w+'                                                    = NewAnsiSpec('Dodger Blue')  # parameters
    '[{}|]'                                                       = NewAnsiSpec('Crimson')  # { }
    '[<>,\.]'                                                     = NewAnsiSpec('Gray')  # < >
    '[\[\]]'                                                      = NewAnsiSpec('Yellow')  # [ ]
    '[\(\)]'                                                      = NewAnsiSpec('Green')  # ( )
    '\".*\"'                                                      = NewAnsiSpec('Pale Green')  # '...'
  }
  'Get-ChildItem' = [ordered]@{
    '\s*(Directory:\s.*)'                         = NewAnsiSpec -Color 'Orange' -Style 'underline' # Header
    '\w+$'                                        = NewAnsiSpec -Color 'Orange' -Style 'underline'
    '^\bMode|\bLastWriteTime|\bLength\b|\bName\b' = NewAnsiSpec('Crimson') # SubHeader
    '^d'                                          = NewAnsiSpec('Royal Blue') # Directory
    '^d.*\s+\b(.*)\b'                             = NewAnsiSpec('Royal Blue')
    '^.(a)'                                       = NewAnsiSpec('Khaki') # Archive
    '^.(a)----.*\s+\b(.*)\b'                      = NewAnsiSpec('Khaki')
    '^.{2}(r)'                                    = NewAnsiSpec('Lime Green') # Read-Only
    '^.{2}(r).*\s+\b(.*)\b'                       = NewAnsiSpec('Lime Green')
    '^.{3}(h)'                                    = NewAnsiSpec('Dark Gray') # Hidden
    '^.{3}(h).*\s+\b(.*)\b'                       = NewAnsiSpec('Dark Gray')
    '^.{4}(s)'                                    = NewAnsiSpec('Red') # System
    '^.{4}(s).*\s+\b(.*)\b'                       = NewAnsiSpec('Red')
    '^.{5}(l)'                                    = NewAnsiSpec('Orange') # Link
    '^.{5}(l).*\s+\b(.*)\b'                       = NewAnsiSpec('Orange')
  }
  'Write-Output'  = [ordered]@{
  }
}

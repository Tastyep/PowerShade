Import-Module -Name '.\color.psm1'

$ansiStyle = NewAnsiStyle($ColorPalette)

function PrintColors() {
    foreach ($item in $ansiStyle.palette.GetEnumerator()) {
        Write-Host $item.Key -NoNewline
        $text = -Join @("$([char]27)[38;2;", $item.Value, 'm===')
        Write-Host " $text"
    }
}

$commandToColors = @{
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
        '^\bMode|\bLastWriteTime|\bLength\b|\bName\b' = NewAnsiSpec('Crimson') # header
        '^d'                                          = NewAnsiSpec('Deep Sky Blue')
        '^(?+)r(?+)\s'                                = NewAnsiSpec('Red')
        '^.?(a)'                                      = NewAnsiSpec('Yellow')
        '\s*(Directory:\s.*)'                         = NewAnsiSpec -Color 'Orange' -Style 'underline'
        '\w+$'                                        = NewAnsiSpec -Color 'Orange' -Style 'underline'
    }
    'Write-Output'  = [ordered]@{
    }
}

function Color() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$CommandName,
        [Parameter(ValueFromRemainingArguments = $true)]
        $Params
    )
    $commandInfo = $(Get-Command -Name $CommandName).Name
    $command = $commandInfo.Name
    if ($commandInfo.ResolvedCommand) {
        $command = $commandInfo.ResolvedCommand.Name
    }

    if (!$commandToColors.ContainsKey($command)) {
        Write-Host 'No color available for $command'
        Invoke-Expression ($command + ' ' + $Params -join ' ') 
    }
    else {
        $regexStyleMap = $commandToColors[$command]
        
        Invoke-Expression ($command + ' ' + $Params -join ' ') | Out-String -Stream | ForEach-Object -Process {
            $coloredLine = $ansiStyle.ColorizeLine($_, $regexStyleMap)
            Write-Host $coloredLine
        }
    }
}
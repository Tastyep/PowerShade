Import-Module -Name '.\color.psm1'

$ansiStyle = NewAnsiStyle($ColorPalette)

function PrintColors() {
    foreach ($item in $ansiStyle.palette.GetEnumerator()) {
        Write-Host $item.Key -NoNewline
        $text = -Join @('$([char]27)[38;2;', $item.Value, 'm===')
        Write-Host ' $text'
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
    #     $ColorPalette = @{
    #     'd' = 'Deep Sky Blue'
    #     'a' = 'Yellow'
    #     'r' = 'Red'
    #     'h' = 'Dark Gray'
    #     's' = 'Green'
    #     'l' = 'Gray'
    #     'c' = 'Magenta'
    #     'e' = 'Cyan'
    #     'n' = 'Gray'
    # }
}

function Color() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$CommandName,
        [Parameter(ValueFromRemainingArguments = $true)]
        $Params
    )
    $commandInfo = $(Get-Command -Name $CommandName)
    $command = $commandInfo.Name
    if ($commandInfo.ResolvedCommand) {
        $command = $commandInfo.ResolvedCommand.Name
    }


    # $proxy = [System.Management.Automation.ProxyCommand]::Create($command)
    # $proxy.Invoke($Params)
    $text = Invoke-Expression ($command + ' ' + $Params -join ' ') | Out-String
    if ($commandToColors.ContainsKey($command)) {
        $regexColorMap = $commandToColors[$command]
        $coloredText = $ansiStyle.ColorizeText($text, $regexColorMap)
        Write-Host $coloredText
    }
    else {
        Write-Host 'No color available for $command'
        Write-Host $text
    }
}
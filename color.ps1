Import-Module -Name ".\color.psm1"

$ansiColors = NewAnsiColors($ColorPalette)

function PrintColors() {
    foreach ($item in $ansiColors.palette.GetEnumerator()) {
        Write-Host $item.Key -NoNewline
        $text = -Join @("$([char]27)[38;2;", $item.Value, "m===")
        Write-Host " $text"
    }
}

$commandToColors = @{
    "Get-Help"      = [ordered]@{
        "^\bNAME|SYNTAX|PARAMETERS|ALIASES|REMARKS|INPUTS|OUTPUTS\b$" = "Crimson" # sections
        "<CommonParameters\>"                                         = "Ebony"
        'https?:/\S+'                                                 = 'Cornflower Blue'  # hyperlink
        '^\s+-\w+'                                                    = "Dodger Blue"  # parameters
        '[{}|]'                                                       = "Crimson"  # { }
        '[<>,\.]'                                                     = "Gray"  # < >
        '[\[\]]'                                                      = "Yellow"  # [ ]
        '[\(\)]'                                                      = "Green"  # ( )
        '".*"'                                                        = "Pale Green"  # "..."
    }
    "Get-ChildItem" = [ordered]@{
        "^\bDirectory:|\bMode|\bLastWriteTime|\bLength\b|\bName\b" = "Crimson" # header
        "^d"                                                       = "Deep Sky Blue"
        "^(?+)r(?+)\s"                                             = "Red"
        "^.?(a)"                                                   = "Yellow"
    }
    #     $ColorPalette = @{
    #     "d" = "Deep Sky Blue"
    #     "a" = "Yellow"
    #     "r" = "Red"
    #     "h" = "Dark Gray"
    #     "s" = "Green"
    #     "l" = "Gray"
    #     "c" = "Magenta"
    #     "e" = "Cyan"
    #     "n" = "Gray"
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
    $text = Invoke-Expression ($command + ' ' + $Params -join " ") | Out-String
    $text = "-a----         4/29/2023   8:23 PM             45 test.cpp"
    if ($commandToColors.ContainsKey($command)) {
        $regexColorMap = $commandToColors[$command]
        $coloredText = $ansiColors.ColorizeText($text, $regexColorMap)
        Write-Host $coloredText
    }
    else {
        Write-Host $text
    }
}
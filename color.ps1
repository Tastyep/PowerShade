Import-Module -Name ".\color.psm1"


function PrintColors() {
    $ansiColors = NewAnsiColors($ColorPalette)
    foreach ($item in $ansiColors.palette.GetEnumerator()) {
        Write-Host $item.Key -NoNewline
        $text = -Join @("$([char]27)[38;2;", $item.Value, "m===")
        Write-Host " $text"
    }
}

PrintColors
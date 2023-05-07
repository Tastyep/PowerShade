Import-Module -Name '.\color.psm1'

$ansiStyle = NewAnsiStyle -Palette $ColorPalette

function Get-ChildItemAlias() {
    ColorCommand -AnsiStyle $ansiStyle -CommandToSpec $CommandToAnsiSpec -CommandName 'Get-ChildItem'
}

New-Alias -Name ls -Value Get-ChildItemAlias
# ColorCommand -AnsiStyle $ansiStyle -CommandToSpec $CommandToAnsiSpec -CommandName ls
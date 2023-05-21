function Show-ColorPalette([System.Collections.Specialized.OrderedDictionary]$Palette)
{
  foreach ($item in $Palette.GetEnumerator())
  {
    Write-Output $item.Key -NoNewline
    $text = -Join @("$([char]27)[38;2;", $item.Value, 'm##')
    Write-Output " $text"
  }
}

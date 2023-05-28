function Show-ColorPalette([System.Collections.Specialized.OrderedDictionary]$Palette)
{
  foreach ($item in $Palette.GetEnumerator())
  {
    $colorCode = -Join @("$([char]27)[38;2;", $item.Value, 'm')
    Write-Output "$colorCode ${item}: ##" 
  }
}

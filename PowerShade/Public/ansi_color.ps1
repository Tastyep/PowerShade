class AnsiSpec
{
  [string]$color
  [string]$style

  AnsiSpec([string]$Color)
  {
    $this._init($Color)
  }
  AnsiSpec([string]$Color, [string]$Style)
  {
    $this._init($Color, $Style)
  }

  hidden _init([string]$Color)
  {
    $this._init($Color, "")
  }
  hidden _init([string]$Color, [string]$Style)
  {
    $this.color = $Color
    $this.style = $Style
  }
}

function New-PowerShadeSpec()
{
  param (
    [string]$Color,
    [string]$Style
  )

  return [AnsiSpec]::new("$Color", $Style)
}

class SegmentMatch
{
  [int32]$startIndex
  [int32]$matchedLength
  [AnsiSpec]$spec

  SegmentMatch([int32]$startIndex, [int32]$matchedLength, [AnsiSpec]$spec)
  {
    $this.startIndex = $startIndex
    $this.matchedLength = $matchedLength
    $this.spec = $spec
  }
}

class AnsiStyler
{
  [System.Collections.Specialized.OrderedDictionary]$palette
  [System.Collections.Generic.SortedList[int32, SegmentMatch]] $_segments
  [Comparison[SegmentMatch]] $_startIndexSorter
  [System.Text.StringBuilder] $_coloredLine
  [System.Text.StringBuilder] $_coloredText
  [AnsiSpec] $_defaultSpec

  AnsiStyler([System.Collections.Specialized.OrderedDictionary]$colorPalette)
  {
    $this.palette = $colorPalette
    $this._segments = [System.Collections.Generic.SortedList[int32, SegmentMatch]]::new()
    $this._startIndexSorter = { $args[0].startIndex - $args[1].startIndex }
    $this._coloredLine = [System.Text.StringBuilder]::new()
    $this._coloredText = [System.Text.StringBuilder]::new()
    $this._defaultSpec = [AnsiSpec]::new("Light Gray")
  }


  hidden [Boolean]_intersectsSegment($segments, $capture)
  {
    [int32]$left = 0
    [int32]$right = $segments.Count - 1
    [int32]$pivot = 0
   
    # Write-Host "$($capture | Out-String) $($segments | Out-String)"
    for ($fullyTested = !($right -ge $left); !$fullyTested; )
    {
      $fullyTested = ($right - $left) -le 0 
            
      $pivot = $left + ($right - $left) / 2
      # Write-Output "$left $pivot $right"
      $segment = $segments.Values[$pivot]
      # Write-Host "$($segment | Out-String)"
      $updatedBounds = $false
      $captureEndIndex = $capture.Index + $capture.Length - 1
      if ($captureEndIndex -lt $segment.startIndex)
      {
        $right = $pivot - 1
        # Write-Host "Update right"
        $updatedBounds = $true
      }
                  
      $segmentEndIndex = $segment.startIndex + $segment.matchedLength - 1
      if ($capture.Index -gt $segmentEndIndex)
      {
        $left = $pivot + 1
        # Write-Host "Update Left $left"
        $updatedBounds = $true
      }

      if (!$updatedBounds)
      {
        if ($capture.Index -le $segmentEndIndex -and $captureEndIndex -ge $segment.startIndex)
        {
          return $true
        }
        break
      }
    }

    return $false
  } 

  [string]ColorizeSegment([string]$segment, [AnsiSpec]$spec)
  {
    $esc = [char]27
    $styles = [System.Text.StringBuilder]::new()
    $code = $this.palette[$spec.color]
    switch ($spec.style)
    {
      'bold'
      {
        $styles.append("$esc[1m")
      }
      'underline'
      {
        $styles.append("$esc[4m")
      }
      ''
      {
      }
      default
      {
        Write-Output "Unknown style: '$($spec.style)'"
      }
    }
    $styles.Append("$esc[38;2;$($code)m")
    $styles.Append($segment)
    switch ($spec.style)
    {
      'bold'
      {
        $styles.append("$esc[22m")
      }
      'underline'
      {
        $styles.append("$esc[24m")
      }
      ''
      {
      }
      default
      {
        Write-Output "Unknown style: '$($spec.style)'"
      }
    }
    return $styles.ToString()
  }

  [string]ColorizeLine([string]$Line, [System.Collections.Specialized.OrderedDictionary]$RegexStyleMap)
  {
    $this._segments.Clear()
    $currentIndex = 0
     
    # Match regexes
    foreach ($regexStyleIt in $RegexStyleMap.GetEnumerator())
    {
      $matchResults = [regex]::Matches($line, $regexStyleIt.Key)
      foreach ($match in $matchResults)
      {
        # Write-Output " === Match ==="
        $i = 0;
        if ($match.Groups.Count -gt 1)
        {
          $i = 1
        }
        for (; $i -lt $match.Groups.Count; $i += 1)
        {
          $group = $match.Groups[$i]
          # Write-Output "$($regexColor.Key) Group: $($group | Format-List | Out-String)"
          # Write-Output "$($regexColor.Key) Captures: $($group.Captures | Format-List | Out-String)"
          $intersection = $this._intersectsSegment($this._segments, $group)
          if (!$intersection)
          {
            $this._segments.Add($group.Index, [SegmentMatch]::new(
                $group.Index,
                $group.Length,
                $regexStyleIt.Value
              ))
          }
        }
      }
    }
        
    # Sort by index
    $this._coloredLine.Clear()

    # Compose the colored text
    foreach ($segmentIt in $this._segments.GetEnumerator())
    {
      $segment = $segmentIt.Value
      if ($segment.startIndex - $currentIndex -gt 0)
      {
        $unmatchedText = $Line.Substring($currentIndex, $segment.startIndex - $currentIndex)
        $coloredSegment = $this.ColorizeSegment($unmatchedText, $this._defaultSpec) 
        $this._coloredLine.Append($coloredSegment)
      }
        
      $matchedText = $Line.Substring($segment.startIndex, $segment.matchedLength)
      $coloredSegment = $this.ColorizeSegment($matchedText, $segment.spec) 
      $this._coloredLine.Append($coloredSegment)
        
      $currentIndex = $segment.startIndex + $segment.matchedLength
    }
    
    if ($currentIndex -lt $Line.Length)
    {
      $unmatchedText = $Line.Substring($currentIndex)
      $coloredSegment = $this.ColorizeSegment($unmatchedText, $this._defaultSpec)

      $this._coloredLine.Append($coloredSegment)
    }

    return $this._coloredLine.ToString()
  }

  [string]ColorizeText([string]$text, [System.Collections.Specialized.OrderedDictionary]$RegexStyleMap)
  {
    $this._coloredText.Clear()
    $lines = $text.Split("`r`n")
    foreach ($line in $lines)
    {
      if ($line.Length -eq 0)
      {
        $this._coloredText.Append("`r`n")
      } else
      {
        $coloredLine = $this.ColorizeLine($line, $RegexStyleMap)
        $this._coloredText.Append($coloredLine)
      }
    }
        

    return $this._coloredText.ToString()
  }
}

function New-PowerShadeStyler($Palette)
{
  return [AnsiStyler]::new($Palette)
}

function WriteVar($var) {
    Write-Host ($var | Format-Table | Out-String)
}

$ColorPalette = [ordered]@{
    #Red
    "Indian Red"      = "205;92;92"
    "Tomato"          = "255;99;71"
    "Red"             = "255;0;0"
    "Crimson"         = "220;20;60"
    "Firebrick"       = "178;34;34"
    "Dark Red"        = "139;0;0"

    # Blue
    "Deep Sky Blue"   = "0;191;255"
    "Cornflower Blue" = "100;149;237"
    "Dodger Blue"     = "30;144;255"
    "Steel Blue"      = "70;130;180"
    "Royal Blue"      = "65;105;225"
    "Medium Blue"     = "0;0;205"
    "Dark Blue"       = "0;0;139"
    "Navy"            = "0;0;128"

    # Green
    "Pale Green"      = "152;251;152"
    "Spring Green"    = "0;255;127"
    "Lime Green"      = "50;205;50"
    "Medium Green"    = "0;250;154"
    "Sea Green"       = "46;139;87"
    "Forest Green"    = "34;139;34"
    "Green"           = "0;128;0"
    "Dark Green"      = "0;100;0"

    # Yellow
    "Lemon Chiffon"   = "255;250;205"
    "Khaki"           = "240;230;140"
    "Yellow"          = "255;255;0"
    "Gold"            = "255;215;0"
    "Dark Goldenrod"  = "184;134;11"
    
    # Brown
    "Tan"             = "210;180;140"
    "Brown"           = "165;42;42"
    "Saddle Brown"    = "139;69;19"
    "Maroon"          = "128;0;0"
    "Dark Brown"      = "101;67;33"
    
    # Purple
    "Lavender"        = "230;230;250"
    "Violet"          = "238;130;238"
    "Purple"          = "128;0;128"
    "Dark Purple"     = "128;0;128"
    "Indigo"          = "75;0;130"
    
    # Pink
    "Pink"            = "255;192;203"
    "Light Pink"      = "255;182;193"
    "Hot Pink"        = "255;105;180"
    "Deep Pink"       = "255;20;147"
    
    # Orange
    "Peach"           = "255;218;185"
    "Orange"          = "255;165;0"
    "Dark Orange"     = "255;140;0"
    "Coral"           = "255;127;80"
   
    # White - Black
    "White"           = "255;255;255"
    "Ivory"           = "255;255;240"
    "Beige"           = "245;245;220"
    "Light Gray"      = "211;211;211"
    "Dark Gray"       = "169;169;169"
    "Gray"            = "128;128;128"
    "Ebony"           = "85;93;80"
    "Charcoal"        = "54;69;79"
    "Jet"             = "52;52;52"
    "Black"           = "0;0;0"
}
        
class ColorMatch {
    [int32]$startIndex
    [int32]$matchedLength
    [string]$colorCode
}

class ColorBuilder {
    [System.Collections.Specialized.OrderedDictionary]$colors
    [System.Collections.Generic.SortedList[int32, ColorMatch]] $_segments
    [Comparison[ColorMatch]] $_startIndexSorter
    [System.Text.StringBuilder] $_coloredLine
    [System.Text.StringBuilder] $_coloredText

    ColorBuilder([System.Collections.Specialized.OrderedDictionary]$colorPalette) {
        $this.colors = $colorPalette
        $this._segments = [System.Collections.Generic.SortedList[int32, ColorMatch]]::new()
        $this._startIndexSorter = { $args[0].startIndex - $args[1].startIndex }
        $this._coloredLine = [System.Text.StringBuilder]::new()
        $this._coloredText = [System.Text.StringBuilder]::new()
    }

    [Boolean]_intersectsSegment($segments, $group) {
        [int32]$left = 0
        [int32]$right = $segments.Count - 1
        [int32]$pivot = 0
        # WriteVar $segments
        # WriteVar $group
        # Write-Host "$left $pivot $right ($right - gt $left)"
        # return $this._segments.ContainsKey($group.Index)
        for ($fullyTested = !($right -ge $left); !$fullyTested; ) {
            $fullyTested = ($right - $left) -le 0 
            
            $pivot = $left + ($right - $left) / 2
            # Write-Host "$left $pivot $right"
            $colorMatch = $segments.Values[$pivot]
            $updatedBounds = $false
            if ($group.Index + $group.Length -lt $colorMatch.startIndex) {
                $right = $pivot - 1
                # Write-Host "Update right"
                $updatedBounds = $true
            }
                   
            if ($group.Index -gt ($colorMatch.startIndex + $colorMatch.matchedLength)) {
                $left = $pivot + 1
                # Write-Host "Update Left $left"
                $updatedBounds = $true
            }

            if (!$updatedBounds) {
                if ($group.Index -lt ($colorMatch.startIndex + $colorMatch.matchedLength) -and
                ($group.Index + $group.Length) -gt $colorMatch.startIndex) {
                    return $true
                }
                if ($pivot -eq $left) {
                    $left += 1
                }
                else {
                    $right -= 1

                }
            }
        }

        return $false
    } 

    [string]ColorSegment([string]$segment, [string]$color) {
        $code = $this.colors[$color]
        return -Join @("$([char]27)[38;2;", $code, "m$segment") 
    }

    [string]ColorLine([string]$Line, [System.Collections.Specialized.OrderedDictionary]$RegexColorMap) {
        $this._segments.Clear()
        $currentIndex = 0
     
        # Match regexes
        foreach ($regexColor in $RegexColorMap.GetEnumerator()) {
            $matchResults = [regex]::Matches($line, $regexColor.Key)
            # WriteVar $matchResults.Count
            foreach ($match in $matchResults) {
                foreach ($group in $match.Groups) {
                    # $intersection = $this._segments | Where-Object {
                    #     return $group.Index -lt ($_.startIndex + $_.matchedLength) -and ($group.Index + $group.Length) -gt $_.startIndex
                    # }
                    $intersection = $this._intersectsSegment($this._segments, $group)
                    if (!$intersection) {
                        $this._segments.Add($group.Index, (New-Object ColorMatch -Property @{
                                    "startIndex"    = $group.Index
                                    "matchedLength" = $group.Length
                                    "colorCode"     = $regexColor.Value
                                }))
                    }
                }
            }
        }
 
        
        # Sort by index
        $this._coloredLine.Clear()

        # Compose the colored text
        foreach ($segmentIt in $this._segments.GetEnumerator()) {
            $segment = $segmentIt.Value
            if ($segment.startIndex - $currentIndex -gt 0) {
                $unmatchedText = $Line.Substring($currentIndex, $segment.startIndex - $currentIndex)
                $coloredSegment = $this.ColorSegment($unmatchedText, "Light Gray") 
                $this._coloredLine.Append($coloredSegment)
            }
        
            $matchedText = $Line.Substring($segment.startIndex, $segment.matchedLength)
            $coloredSegment = $this.ColorSegment($matchedText, $segment.colorCode) 
            $this._coloredLine.Append($coloredSegment)
        
            $currentIndex = $segment.startIndex + $segment.matchedLength
        }
    
        if ($currentIndex -lt $Line.Length) {
            $unmatchedText = $Line.Substring($currentIndex)
            $coloredSegment = $this.ColorSegment($unmatchedText, "Light Gray")

            $this._coloredLine.Append($coloredSegment)
        }

        return $this._coloredLine.ToString()
    }

    [string]ColorText([string]$text, [System.Collections.Specialized.OrderedDictionary]$RegexColorMap) {
        $this._coloredText.Clear()
        $lines = $text.Split("`r`n", [System.StringSplitOptions]::RemoveEmptyEntries)
        foreach ($line in $lines) {
            $coloredLine = $this.ColorLine($line, $RegexColorMap)
            $this._coloredText.Append( -Join @($coloredLine, "`r`n"))
        }
        

        return $this._coloredText.ToString()
    }
}

function DisplayHelp($command) {
    $regexColorMap = [ordered]@{
        "^\bNAME|SYNTAX|PARAMETERS|ALIASES|REMARKS\b$" = "Crimson" # sections
        "<CommonParameters\>"                          = "Ebony"
        'https?:/\S+'                                  = 'Cornflower Blue'  # hyperlink
        '^\s+-\w+'                                     = "Dodger Blue"  # parameters
        '[{}|]'                                        = "Crimson"  # { }
        '[<>,\.]'                                      = "Gray"  # < >
        '[\[\]]'                                       = "Yellow"  # [ ]
        '[\(\)]'                                       = "Green"  # ( )
        '".*"'                                         = "Pale Green"  # "..."
    }

    $helpMsg = $(Get-Help $command -Detailed) | Out-String
    # $helpMsg = @"
    # -- To download and install Help files for the module that includes this cmdlet, use Update-Help.
    # "@
    # $helpMsg = "] -CNotIn ["
    # $helpMsg = "NAME`r`n  test"
    # $helpMsg = "    Where-Object [-Property] <string> [[-Value] <Object>] [-InputObject <psobject>] [-EQ]  [<CommonParameters>]"

    # $colorBuilder = New-Object -TypeName ColorBuilder
    $colorBuilder = [ColorBuilder]::new($ColorPalette)
    $coloredText = $colorBuilder.ColorText($helpMsg, $regexColorMap)
    Write-Host $coloredText
}

function mls() {
    # $regexColorMap = [ordered]@{
    #     # Directories
    #     "^\d{2}/\d{2}/\d{4} \d{2}:\d{2} [A|P]M +<DIR> +.*$"   = "Dodger Blue" # directories
    #     "^Directory of.*$"                                    = "Deep Sky Blue" # directory header

    #     # Files
    #     "^\d{2}/\d{2}/\d{4} \d{2}:\d{2} [A|P]M +\d+ +.*\..*$" = "Green" # files
    #     "^Mode +LastWriteTime +Length +Name"                  = "Yellow" # file header
    # }
    # $regexColorMap = [ordered]@{
    #     # Directories
    #     "^d.* +.{10} +.{8} +(.*?)$"          = "Steel Blue" # directories
    #     "^Directory of.*$"                   = "Deep Sky Blue" # directory header

    #     # Files
    #     "^-.{5} +.{10} +.{8} +(.*?)$"        = "Green" # files
    #     "^Mode +LastWriteTime +Length +Name" = "Yellow" # file header
    # } 
    $regexColorMap = [ordered]@{
        # Directories
        "^\d{2}/\d{2}/\d{4} \d{2}:\d{2} [A|P]M +<DIR> +(.*)$"   = "Dodger Blue" # directories
        "^Directory of.*$"                                      = "Deep Sky Blue" # directory header

        # Files
        "^\d{2}/\d{2}/\d{4} \d{2}:\d{2} [A|P]M +\d+ +(.*\..*)$" = "Green" # files
        "^Mode +(.*)$"                                          = "Crimson" # mode column
        "^LastWriteTime +(.*)$"                                 = "Yellow" # last write time column
        "^Length +(.*)$"                                        = "Indian Red" # length column
        "^Name$"                                                = "Ebony" # name column
    }
    $text = $(Get-ChildItem) | Out-String

    $colorBuilder = [ColorBuilder]::new($ColorPalette)
    $coloredText = $colorBuilder.ColorText($text, $regexColorMap)
    Write-Host $coloredText
}

function PrintColors() {
    $builder = [ColorBuilder]::new($ColorPalette)
    foreach ($item in $builder.colors.GetEnumerator()) {
        Write-Host $item.Key -NoNewline
        $text = -Join @("$([char]27)[38;2;", $item.Value, "m===")
        Write-Host " $text"
    }
}

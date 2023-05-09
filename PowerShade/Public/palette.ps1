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

New-Variable -Name ColorPalette -Value $ColorPalette -Option Constant -Scope Private -Force -ErrorAction SilentlyContinue

function Get-PowerShadePalette()
{
  return $ColorPalette
}

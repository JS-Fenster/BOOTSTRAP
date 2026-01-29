# Claude Code Statusline v5
# Nutzt used_percentage direkt aus Hook-Daten
# Autocompact triggert bei ~85% (16.5% Buffer)

$ErrorActionPreference = "SilentlyContinue"

$input_json = [Console]::In.ReadToEnd()

try {
    $data = $input_json | ConvertFrom-Json

    # Direkt aus Hook-Daten
    $model = $data.model.display_name
    $usedPercent = $data.context_window.used_percentage
    $remainingPercent = $data.context_window.remaining_percentage
    $contextSize = $data.context_window.context_window_size

    # Fallbacks
    if ($null -eq $usedPercent) { $usedPercent = 0 }
    if ($null -eq $contextSize) { $contextSize = 200000 }

    # Freie Tokens berechnen
    $freeTokens = [math]::Round($remainingPercent * $contextSize / 100 / 1000, 0)
    $freeDisplay = "{0:N0}K" -f $freeTokens

    # Progress Bar (20 chars) - skaliert auf 85% = volle Leiste
    $barSize = 20
    $scaledPercent = [math]::Min(100, [math]::Round($usedPercent / 0.85, 0))
    $filled = [math]::Floor($scaledPercent * $barSize / 100)
    $empty = $barSize - $filled

    $bar = ("=" * $filled) + ("-" * $empty)

    # ANSI Colors - Warnung basierend auf echtem Prozent
    $esc = [char]27
    if ($usedPercent -gt 80) {
        $color = "$esc[91m"      # Rot - kritisch, Autocompact bald
        $prefix = "$esc[91m[!]$esc[0m "
    } elseif ($usedPercent -gt 65) {
        $color = "$esc[93m"      # Gelb - Warnung
        $prefix = ""
    } elseif ($usedPercent -gt 45) {
        $color = "$esc[96m"      # Cyan - halb voll
        $prefix = ""
    } else {
        $color = "$esc[92m"      # Gruen - gut
        $prefix = ""
    }
    $reset = "$esc[0m"
    $dim = "$esc[90m"
    $bold = "$esc[1m"

    # Output: [Model] [====----] 49% | 102K frei
    Write-Host "$prefix[$model] $color[$bar]$reset $bold$usedPercent%$reset $dim|$reset $freeDisplay frei"

} catch {
    Write-Host "[Claude] [Error]"
}

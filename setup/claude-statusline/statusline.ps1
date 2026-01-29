# Claude Code Statusline - v3
# Zeigt: Model | Fortschritt | Prozent | Frei-Token
#
# v3: Nutzt current_usage fuer ECHTEN Kontext-Verbrauch
#
# WICHTIG:
# - total_input_tokens ist KUMULATIV (Summe aller API-Calls)
# - current_usage.input_tokens ist der AKTUELLE Kontext
# - Claude Code Auto-Compact greift bei ~200K (unabhaengig vom Modell!)

$ErrorActionPreference = "SilentlyContinue"

# Read JSON from stdin
$input_json = [Console]::In.ReadToEnd()

try {
    $data = $input_json | ConvertFrom-Json

    # Extract model info
    $modelDisplay = $data.model.display_name

    # Claude Code Auto-Compact Limit ist IMMER 200K (nicht modellabhaengig!)
    $contextSize = if ($data.context_window.context_window_size) {
        $data.context_window.context_window_size
    } else {
        200000
    }

    # ECHTER Kontext-Verbrauch aus current_usage (nicht kumulativ!)
    $currentUsage = $data.context_window.current_usage

    if ($null -ne $currentUsage -and $null -ne $currentUsage.input_tokens) {
        # Aktueller Kontext = input_tokens + cache_read (beides zaehlt zum Kontext)
        $tokensUsed = $currentUsage.input_tokens
        if ($currentUsage.cache_read_input_tokens) {
            $tokensUsed += $currentUsage.cache_read_input_tokens
        }
    } else {
        # Fallback auf kumulative Werte wenn current_usage nicht verfuegbar
        $tokensUsed = $data.context_window.total_input_tokens
        if ($null -eq $tokensUsed) { $tokensUsed = 0 }
    }

    # Prozent-Berechnung
    $percentUsed = [math]::Min(100, [math]::Round(($tokensUsed / $contextSize) * 100, 1))

    # Build progress bar (20 chars)
    $barSize = 20
    $filled = [math]::Floor($percentUsed * $barSize / 100)
    $empty = $barSize - $filled

    # ASCII-Stil: = (gefuellt) / - (leer)
    $filledBar = "=" * $filled
    $emptyBar = "-" * $empty
    $bar = $filledBar + $emptyBar

    # ANSI Colors
    $esc = [char]27
    if ($percentUsed -gt 90) {
        $color = "$esc[91m"      # Bright Red - kritisch (>90%)
        $prefix = "$esc[91m[!]$esc[0m "
    } elseif ($percentUsed -gt 75) {
        $color = "$esc[93m"      # Bright Yellow - Warnung (>75%)
        $prefix = ""
    } elseif ($percentUsed -gt 50) {
        $color = "$esc[96m"      # Bright Cyan - halb voll
        $prefix = ""
    } else {
        $color = "$esc[92m"      # Bright Green - gut
        $prefix = ""
    }
    $reset = "$esc[0m"
    $dim = "$esc[90m"
    $bold = "$esc[1m"

    # Remaining tokens
    $remainingTokens = [math]::Max(0, $contextSize - $tokensUsed)
    $remainingDisplay = "{0:N0}K" -f [math]::Round($remainingTokens / 1000, 0)

    # Output: [!] [Opus 4.5] [████----] 42% | 120K frei
    Write-Host "$prefix[$modelDisplay] $color[$bar]$reset $bold$($percentUsed.ToString("0"))%$reset $dim|$reset $remainingDisplay frei"

} catch {
    Write-Host "[Claude] [--]"
}

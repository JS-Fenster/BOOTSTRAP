# Claude Code Statusline - Block Style v1
# Zeigt: Model | Fortschritt | Prozent | Frei-Token
# Benoetigt: JetBrainsMono Nerd Font (oder andere Nerd Font)

$ErrorActionPreference = "SilentlyContinue"

# ============================================
# KONFIGURATION
# ============================================
# Geschaetzter Basis-Overhead (System-Prompt, Tools, CLAUDE.md, MCP-Server)
# Typisch: 25-40K je nach Setup. Anpassen basierend auf /context Ausgabe!
$BASE_OVERHEAD_TOKENS = 35000

# Read JSON from stdin
$input_json = [Console]::In.ReadToEnd()

try {
    $data = $input_json | ConvertFrom-Json

    # Extract values
    $model = $data.model.display_name
    $conversationTokens = $data.context_window.total_input_tokens + $data.context_window.total_output_tokens
    $contextSize = $data.context_window.context_window_size
    $currentDir = $data.workspace.current_dir

    # Handle nulls
    if ($null -eq $conversationTokens) { $conversationTokens = 0 }
    if ($null -eq $contextSize) { $contextSize = 200000 }

    # Berechne nutzbaren Space
    $usableSpace = $contextSize - $BASE_OVERHEAD_TOKENS

    # Prozent basierend auf nutzbarem Space
    $percentOfUsable = [math]::Min(100, [math]::Round(($conversationTokens / $usableSpace) * 100, 1))

    # Build progress bar (20 chars)
    $barSize = 20
    $filled = [math]::Floor($percentOfUsable * $barSize / 100)
    $empty = $barSize - $filled

    # Block-Stil: █ (gefuellt) / ░ (leer)
    $filledBar = "█" * $filled
    $emptyBar = "░" * $empty
    $bar = $filledBar + $emptyBar

    # ANSI Colors
    $esc = [char]27
    if ($percentOfUsable -gt 85) {
        $color = "$esc[91m"      # Bright Red - kritisch
        $prefix = "$esc[91m[!]$esc[0m "
    } elseif ($percentOfUsable -gt 70) {
        $color = "$esc[93m"      # Bright Yellow - Warnung
        $prefix = ""
    } elseif ($percentOfUsable -gt 50) {
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
    $remainingTokens = [math]::Max(0, $usableSpace - $conversationTokens)
    $remainingDisplay = "{0:N0}K" -f [math]::Round($remainingTokens / 1000, 0)

    # Output: [!] [Model] [████░░░░] 42% | 85K frei
    Write-Host "$prefix[$model] $color[$bar]$reset $bold$($percentOfUsable.ToString("0"))%$reset $dim|$reset $remainingDisplay frei"

} catch {
    Write-Host "[Claude] [--]"
}

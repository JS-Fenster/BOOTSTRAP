# Claude Code Statusline - ASCII Style v2
# Zeigt: Model | Fortschritt | Prozent | Frei-Token
# Funktioniert mit jeder Schriftart
#
# v2: Direkte Berechnung ohne Overhead-Schaetzung
#     total_input_tokens ENTHAELT bereits System-Prompt, Tools, MCP, etc.

$ErrorActionPreference = "SilentlyContinue"

# Read JSON from stdin
$input_json = [Console]::In.ReadToEnd()

try {
    $data = $input_json | ConvertFrom-Json

    # Extract values
    $model = $data.model.display_name
    $contextSize = $data.context_window.context_window_size
    $currentDir = $data.workspace.current_dir

    # total_input_tokens enthaelt ALLES: System-Prompt, Tools, MCP, CLAUDE.md, Messages
    # Wir rechnen direkt ohne Overhead-Schaetzung
    $totalTokensUsed = $data.context_window.total_input_tokens + $data.context_window.total_output_tokens

    # Handle nulls
    if ($null -eq $totalTokensUsed) { $totalTokensUsed = 0 }
    if ($null -eq $contextSize) { $contextSize = 200000 }

    # Direkte Prozent-Berechnung (keine Overhead-Subtraktion mehr!)
    $percentUsed = [math]::Min(100, [math]::Round(($totalTokensUsed / $contextSize) * 100, 1))

    # Build progress bar (20 chars)
    $barSize = 20
    $filled = [math]::Floor($percentUsed * $barSize / 100)
    $empty = $barSize - $filled

    # ASCII-Stil: = (gefuellt) / - (leer)
    $filledBar = "=" * $filled
    $emptyBar = "-" * $empty
    $bar = $filledBar + $emptyBar

    # ANSI Colors - Schwellwerte angepasst fuer direkte Berechnung
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

    # Remaining tokens (direkt: contextSize - totalTokensUsed)
    $remainingTokens = [math]::Max(0, $contextSize - $totalTokensUsed)
    $remainingDisplay = "{0:N0}K" -f [math]::Round($remainingTokens / 1000, 0)

    # Output: [!] [Model] [████░░░░] 42% | 85K frei
    Write-Host "$prefix[$model] $color[$bar]$reset $bold$($percentUsed.ToString("0"))%$reset $dim|$reset $remainingDisplay frei"

} catch {
    Write-Host "[Claude] [--]"
}

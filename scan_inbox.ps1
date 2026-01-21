$headers = @{
    "x-api-key" = "xVA$buHU7U0M!qLryAX%i7ERA*yoMY&ZsJ#XiL!1Ng^yBhMpmloPARWlp34kK^QR"
}

$result = Invoke-RestMethod -Uri "https://rsmjgdujlpnydbsfuiek.supabase.co/functions/v1/scan-mailbox?mailbox=info@js-fenster.de&folder=inbox&count=15" -Method GET -Headers $headers

Write-Host "=== Inbox Emails (mit Anhang-Info) ===" -ForegroundColor Cyan
Write-Host ""

foreach ($email in $result.emails) {
    $hasAtt = if ($email.anhaenge_vorhanden) { "[ATT]" } else { "     " }
    $color = if ($email.anhaenge_vorhanden) { "Green" } else { "White" }
    Write-Host "$hasAtt $($email.betreff.Substring(0, [Math]::Min(60, $email.betreff.Length)))" -ForegroundColor $color
    Write-Host "      Von: $($email.von_email)" -ForegroundColor Gray
    Write-Host "      ID: $($email.id)" -ForegroundColor DarkGray
    Write-Host "      MsgID: $($email.immutable_id)" -ForegroundColor DarkGray
    Write-Host ""
}

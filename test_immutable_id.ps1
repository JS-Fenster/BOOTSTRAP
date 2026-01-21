$headers = @{
    'x-api-key' = 'xVA$buHU7U0M!qLryAX%i7ERA*yoMY&ZsJ#XiL!1Ng^yBhMpmloPARWlp34kK^QR'
}

$result = Invoke-RestMethod -Uri 'https://rsmjgdujlpnydbsfuiek.supabase.co/functions/v1/scan-mailbox?mailbox=info@js-fenster.de&folder=inbox&count=20' -Method GET -Headers $headers

# Show all emails with attachment info
Write-Host "=== Inbox Emails ===" -ForegroundColor Cyan
Write-Host ""

foreach ($email in $result.emails) {
    $hasAtt = if ($email.anhaenge_vorhanden) { "[ATT]" } else { "     " }
    $color = if ($email.anhaenge_vorhanden) { 'Green' } else { 'White' }
    $betreff = $email.betreff
    if ($betreff.Length -gt 55) { $betreff = $betreff.Substring(0, 55) + "..." }
    Write-Host "$hasAtt $betreff" -ForegroundColor $color
    Write-Host "      Von: $($email.von_email)" -ForegroundColor Gray
    Write-Host "      MsgID: $($email.id)" -ForegroundColor DarkGray
    Write-Host ""
}

$headers = @{
    'x-api-key' = 'xVA$buHU7U0M!qLryAX%i7ERA*yoMY&ZsJ#XiL!1Ng^yBhMpmloPARWlp34kK^QR'
}

$result = Invoke-RestMethod -Uri 'https://rsmjgdujlpnydbsfuiek.supabase.co/functions/v1/scan-mailbox?mailbox=info@js-fenster.de&folder=inbox&count=20' -Method GET -Headers $headers

# Find Test 7
$test7 = $result.emails | Where-Object { $_.betreff -like "*Test 7*" }

if ($test7) {
    Write-Host "=== Test 7 gefunden! ===" -ForegroundColor Green
    Write-Host "ID: $($test7.id)"
    Write-Host "Betreff: $($test7.betreff)"
    Write-Host "Von: $($test7.von_email)"
    Write-Host "Hat Anhaenge: $($test7.hat_anhaenge)"
} else {
    Write-Host "Test 7 NICHT in Inbox gefunden!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Alle Emails in Inbox:"
    $result.emails | ForEach-Object { Write-Host "  - $($_.betreff) (von: $($_.von_email))" }
}

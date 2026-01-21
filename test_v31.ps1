$headers = @{
    'Content-Type' = 'application/json'
    'x-api-key' = 'xVA$buHU7U0M!qLryAX%i7ERA*yoMY&ZsJ#XiL!1Ng^yBhMpmloPARWlp34kK^QR'
}

$body = @{
    document_id = '9b3e1ea4-545c-41bc-ab2d-b8a4ce71704f'
    email_message_id = 'AAMkADYzMjQ5OWQ0LTNlMzQtNDUyZS05MWM3LTBjY2M5Y2VmMzE2NwBGAAAAAADCzyK7GPGrTrv1l2oFpfcuBwAkMl8EfAioT4JdkrC8dg-QAAAAAAEMAADCj-hLTgN6Sp1I-hx9BnssAAcfHRvvAAA='
    postfach = 'info@js-fenster.de'
} | ConvertTo-Json

$result = Invoke-RestMethod -Uri 'https://rsmjgdujlpnydbsfuiek.supabase.co/functions/v1/process-email' -Method POST -Headers $headers -Body $body

Write-Host "=== process-email v3.1.0 E2E Test ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Success: $($result.success)" -ForegroundColor $(if ($result.success) { 'Green' } else { 'Red' })
Write-Host "Kategorie: $($result.kategorie)" -ForegroundColor White
Write-Host "Attachments processed: $($result.attachments_processed)" -ForegroundColor White
Write-Host ""

if ($result._debug.attachments_raw) {
    Write-Host "=== Attachments ===" -ForegroundColor Yellow
    foreach ($att in $result._debug.attachments_raw) {
        $color = if ($att.decision -eq 'YES') { 'Green' } else { 'Gray' }
        Write-Host "  $($att.decision): $($att.name) (doc_id: $($att.attachmentDocId))" -ForegroundColor $color
    }
}

$result | ConvertTo-Json -Depth 10

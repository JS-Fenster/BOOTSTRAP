$headers = @{
    'Content-Type' = 'application/json'
    'x-api-key' = 'xVA$buHU7U0M!qLryAX%i7ERA*yoMY&ZsJ#XiL!1Ng^yBhMpmloPARWlp34kK^QR'
}

$body = @{
    document_id = '2888d513-dad7-4c99-ba29-db88cf71d94b'
    email_message_id = 'AAMkADYzMjQ5OWQ0LTNlMzQtNDUyZS05MWM3LTBjY2M5Y2VmMzE2NwBGAAAAAADCzyK7GPGrTrv1l2oFpfcuBwAkMl8EfAioT4JdkrC8dg-QAAAAAAEMAADCj-hLTgN6Sp1I-hx9BnssAAcfHRvsAAA='
    postfach = 'info@js-fenster.de'
} | ConvertTo-Json

$result = Invoke-RestMethod -Uri 'https://rsmjgdujlpnydbsfuiek.supabase.co/functions/v1/process-email' -Method POST -Headers $headers -Body $body
$result | ConvertTo-Json -Depth 10

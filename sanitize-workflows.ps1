$WorkflowsDir = Join-Path $PSScriptRoot "workflows"

if (!(Test-Path $WorkflowsDir)) {
    Write-Host "No existe la carpeta workflows" -ForegroundColor Red
    exit 1
}

# Patrones comunes de secretos (emergencia hoy)
$replacements = @{
    '(token=)[A-Za-z0-9_\-]+'                = 'token={{$env.APIFY_TOKEN}}'
    '("token"\s*:\s*")[^"]+"'               = '"token":"{{$env.APIFY_TOKEN}}"'
    '("apiKey"\s*:\s*")[^"]+"'              = '"apiKey":"{{$env.APIFY_TOKEN}}"'
    '("access_key"\s*:\s*")[^"]+"'          = '"access_key":"{{$env.APIFY_TOKEN}}"'
    '(Authorization:\s*Bearer\s+)[^\s"]+'   = 'Authorization: Bearer {{$env.APIFY_TOKEN}}'
}

Get-ChildItem $WorkflowsDir -Filter *.json | ForEach-Object {

    $path = $_.FullName
    $content = Get-Content $path -Raw -Encoding UTF8
    $original = $content

    foreach ($pattern in $replacements.Keys) {
        $content = [regex]::Replace($content, $pattern, $replacements[$pattern])
    }

    if ($content -ne $original) {
        Write-Host "Sanitizado: $($_.Name)" -ForegroundColor Yellow
        Set-Content -Path $path -Value $content -Encoding UTF8
    }
}

Write-Host "Sanitización completada" -ForegroundColor Green

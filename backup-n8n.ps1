# ===============================
# Backup n8n workflows -> JSON -> GitHub
# ===============================

$N8N_BASE_URL = "https://kiroxon-n8n.mqjope.easypanel.host"
$API_KEY = $env:N8N_API_KEY

if (-not $API_KEY) {
    Write-Host "ERROR: Falta la variable de entorno N8N_API_KEY" -ForegroundColor Red
    Write-Host "Ejecuta: setx N8N_API_KEY 'TU_API_KEY'"
    exit 1
}

$Headers = @{
    "X-N8N-API-KEY" = $API_KEY
    "Accept"       = "application/json"
}

$OutDir = Join-Path $PSScriptRoot "workflows"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

function Get-AllWorkflows {
    $all = @()
    $limit = 100
    $cursor = $null

    while ($true) {
        if ($cursor) {
            $url = "$N8N_BASE_URL/api/v1/workflows?limit=$limit&cursor=$cursor"
        } else {
            $url = "$N8N_BASE_URL/api/v1/workflows?limit=$limit"
        }

        $resp = Invoke-RestMethod -Method GET -Uri $url -Headers $Headers
        $all += $resp.data

        if ($resp.nextCursor) {
            $cursor = [System.Web.HttpUtility]::UrlEncode($resp.nextCursor)
        } else {
            break
        }
    }

    return $all
}

Write-Host "Listando workflows..." -ForegroundColor Cyan
$workflows = Get-AllWorkflows
Write-Host "Encontrados $($workflows.Count) workflows" -ForegroundColor Green

foreach ($wf in $workflows) {

    $id = $wf.id
    $name = $wf.name

    $safeName = ($name -replace '[\\/:*?"<>|]', '_')
    $safeName = ($safeName -replace '\s+', ' ').Trim()
    if ([string]::IsNullOrWhiteSpace($safeName)) { $safeName = "workflow" }

    $filePath = Join-Path $OutDir "$safeName--$id.json"

    Write-Host "Exportando: $name ($id)"

    # ✅ PEDIR JSON "CRUDO" y guardarlo tal cual (evita ConvertTo-Json depth)
    $url = "$N8N_BASE_URL/api/v1/workflows/$id"
    $jsonRaw = Invoke-WebRequest -Method GET -Uri $url -Headers $Headers -UseBasicParsing
    [System.IO.File]::WriteAllText($filePath, $jsonRaw.Content, [System.Text.Encoding]::UTF8)
}

Write-Host "Export terminado en: $OutDir" -ForegroundColor Green

# ---- GIT COMMIT + PUSH ----
Set-Location $PSScriptRoot

git add workflows | Out-Null

$changes = git status --porcelain
if ($changes) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "backup: n8n workflows ($ts)" | Out-Null
    git push | Out-Null
    Write-Host "Push a GitHub realizado correctamente" -ForegroundColor Green
} else {
    Write-Host "INFO: No hay cambios para commitear." -ForegroundColor Yellow
}

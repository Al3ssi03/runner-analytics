# Pubblica le 10 issue PaceUp v1 su GitHub
# Prerequisiti: gh CLI installato + gh auth login eseguito
#
# Uso: .\publish-issues.ps1

$issues = @(
    @{ file = "01-scaffold.md";          title = "feat(scaffold): project setup — React+Vite, Fastify, PostgreSQL, Railway CI";   label = "ready-for-agent" },
    @{ file = "02-strava-oauth.md";      title = "feat(auth): Strava OAuth 2.0 + initial Activity sync + Profilo tab";            label = "ready-for-agent" },
    @{ file = "03-webhook.md";           title = "feat(sync): Strava webhook real-time Activity sync";                             label = "ready-for-agent" },
    @{ file = "04-verdict-dashboard.md"; title = "feat(dashboard): Verdict engine + pace trend + volume barchart";                label = "ready-for-agent" },
    @{ file = "05-training-load.md";     title = "feat(analytics): CTL/ATL/TSB training load + Race predictor";                   label = "ready-for-agent" },
    @{ file = "06-hr-metrics.md";        title = "feat(analytics): HR Tier 2 metrics — efficiency, decoupling, VO2max";           label = "ready-for-agent" },
    @{ file = "07-activities.md";        title = "feat(activities): Activity list with infinite scroll + detail view";             label = "ready-for-agent" },
    @{ file = "08-goals.md";             title = "feat(goals): Goal feature — create, track, project (race/pace/volume)";         label = "ready-for-agent" },
    @{ file = "09-push-notifications.md";title = "feat(notifications): Web Push post-run recap + goal milestone";                 label = "ready-for-agent" },
    @{ file = "10-pwa-offline.md";       title = "feat(pwa): offline read-only mode — service worker + IndexedDB cache";          label = "ready-for-agent" }
)

$dir = Join-Path $PSScriptRoot "issues"

foreach ($issue in $issues) {
    $body = Get-Content (Join-Path $dir $issue.file) -Raw
    Write-Host "Creando issue: $($issue.title)..."
    gh issue create --title $issue.title --label $issue.label --body $body
    Start-Sleep -Seconds 1
}

Write-Host "Fatto! 10 issue pubblicate su GitHub."

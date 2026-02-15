$project_id = "697121c70024e4e94ac3"
# WARNING: DO NOT hardcode the API Key. Use an environment variable or prompt for it.
$api_key = $env:APPWRITE_API_KEY 
if (-not $api_key) {
    $api_key = Read-Host "Please enter your Appwrite API Key (Secret)" -AsSecureString
    $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($api_key)
    $api_key = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
}

$endpoint = "https://cloud.appwrite.io/v1"
$db_id = "6971223f003e5f162359"

$headers = @{
    "X-Appwrite-Project" = $project_id
    "X-Appwrite-Key"     = $api_key
    "Content-Type"       = "application/json"
}

function Update-CollectionPerms($coll_id, $perms) {
    Write-Host "Updating permissions for collection: $coll_id ..." -ForegroundColor Cyan
    $url = "$endpoint/databases/$db_id/collections/$coll_id"
    $body = @{
        permissions = $perms
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri $url -Method Put -Headers $headers -Body $body
        Write-Host "✅ Successfully updated $coll_id" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to update $coll_id : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 1. Products: Guests can read
Update-CollectionPerms "products" @('read("any")')

# 2. Feedback: Guests can create (write)
Update-CollectionPerms "feedback" @('create("any")')

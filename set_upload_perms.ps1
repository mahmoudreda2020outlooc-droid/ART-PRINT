
$project_id = "697121c70024e4e94ac3"
# WARNING: DO NOT hardcode the API Key. Use an environment variable or prompt for it.
$api_key = $env:APPWRITE_API_KEY 
if (-not $api_key) {
    $api_key = Read-Host "Please enter your Appwrite API Key (Secret)" -AsSecureString
    $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($api_key)
    $api_key = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
}

$endpoint = "https://cloud.appwrite.io/v1"
$bucket_id = "product_images"

$headers = @{
    "X-Appwrite-Project" = $project_id
    "X-Appwrite-Key"     = $api_key
    "Content-Type"       = "application/json"
}

# Update Bucket Permissions to allow public create
$body = @{
    permissions = @('read("any")', 'create("any")', 'update("users")', 'delete("users")')
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "$endpoint/storage/buckets/$bucket_id" -Method Put -Headers $headers -Body $body
    Write-Host "Success: Bucket permissions updated to allow public uploads."
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
}

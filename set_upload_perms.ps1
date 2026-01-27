
$project_id = "697121c70024e4e94ac3"
$api_key = "standard_208e78d117a964a92ef0c6b318ad1a7df83ad00fe3f02209293202be0ac9a25dcb4418cdbaf99c609833d0d6f2cac138d99e47500664630d10e027a0b600212c89aec607458f0f58c13527b9ba968354cdecf8a082dcc15b31e7efa021aa1c792c6040dab7bff16cff4b1db45908513738bba5dff2c01c1aa1af0bceb5a1595a"
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

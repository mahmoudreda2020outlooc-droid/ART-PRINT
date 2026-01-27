
$project_id = "697121c70024e4e94ac3"
$api_key = "standard_208e78d117a964a92ef0c6b318ad1a7df83ad00fe3f02209293202be0ac9a25dcb4418cdbaf99c609833d0d6f2cac138d99e47500664630d10e027a0b600212c89aec607458f0f58c13527b9ba968354cdecf8a082dcc15b31e7efa021aa1c792c6040dab7bff16cff4b1db45908513738bba5dff2c01c1aa1af0bceb5a1595a"
$endpoint = "https://cloud.appwrite.io/v1"
$db_id = "6971223f003e5f162359"
$coll_id = "products"

$headers = @{
    "X-Appwrite-Project" = $project_id
    "X-Appwrite-Key"     = $api_key
    "Content-Type"       = "application/json"
}

Write-Host "--- Updating Products Collection Permissions ---"

$body = @{
    permissions = @('read("any")') # Allow anyone to read documents
} | ConvertTo-Json

try {
    $res = Invoke-RestMethod -Uri "$endpoint/databases/$db_id/collections/$coll_id" -Method Put -Headers $headers -Body $body
    Write-Host "Success: Products collection permissions updated to public read."
}
catch {
    $streamReader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    $errBody = $streamReader.ReadToEnd()
    Write-Host "Error: $errBody"
}

Write-Host "--- Done ---"

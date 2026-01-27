
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

# Get all documents
try {
    $docs_url = "$endpoint/databases/$db_id/collections/$coll_id/documents"
    $response = Invoke-RestMethod -Uri $docs_url -Method Get -Headers $headers
    
    foreach ($doc in $response.documents) {
        $id = $doc.'$id'
        Write-Host "Updating permissions for doc: $id"
        
        # Add read("any") to existing permissions
        $permissions = @('read("any")')
        # Preserve update/delete for creation user if implicit, but here we can just grant full rights or read any
        # Since this is admin script, effectively we want read("any")
        
        $body = @{
            permissions = @('read("any")', 'update("users")', 'delete("users")')
        } | ConvertTo-Json
        
        # We need a specific endpoint to update permissions? 
        # Actually in Appwrite API updateDocument takes permissions param
        # Note: updateDocument overwrites data if not careful? No, it's patch for data.
        # But permissions is top level.
        
        # Re-construct body for Update Document
        # We trigger an update just to set permissions. Appwrite Update Document allows passing permissions.
        # However, passing empty 'data' {} might be required.
        
        $update_body = @{
            permissions = @('read("any")', 'update("users")', 'delete("users")')
            data        = @{} 
        } | ConvertTo-Json -Depth 5
        
        Invoke-RestMethod -Uri "$docs_url/$id" -Method Patch -Headers $headers -Body $update_body
        Write-Host "Success for $id"
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $streamReader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host $streamReader.ReadToEnd()
    }
}

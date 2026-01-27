
$project_id = "697121c70024e4e94ac3"
$api_key = "standard_208e78d117a964a92ef0c6b318ad1a7df83ad00fe3f02209293202be0ac9a25dcb4418cdbaf99c609833d0d6f2cac138d99e47500664630d10e027a0b600212c89aec607458f0f58c13527b9ba968354cdecf8a082dcc15b31e7efa021aa1c792c6040dab7bff16cff4b1db45908513738bba5dff2c01c1aa1af0bceb5a1595a"
$endpoint = "https://cloud.appwrite.io/v1"
$db_id = "6971223f003e5f162359"
$products_coll_id = "products"
$mobile_ip = "192.168.1.7"

$headers = @{
    "X-Appwrite-Project" = $project_id
    "X-Appwrite-Key"     = $api_key
    "Content-Type"       = "application/json"
}

function Invoke-Appwrite {
    param($Uri, $Method = "Get", $Body = $null)
    try {
        if ($Body) {
            Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers -Body ($Body | ConvertTo-Json)
        }
        else {
            Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers
        }
    }
    catch {
        if ($_.Exception.Response) {
            $streamReader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $errText = $streamReader.ReadToEnd()
            return $errText | ConvertFrom-Json
        }
        else {
            return @{ code = 500; message = $_.Exception.Message }
        }
    }
}

Write-Host "--- Starting Ultimate Appwrite Fix ---" -ForegroundColor Cyan

# 1. Update Products Collection Permissions
Write-Host "1. Setting 'products' collection permissions to Public Read..."
$productsBody = @{
    permissions = @('read("any")')
}
$res = Invoke-Appwrite -Uri "$endpoint/databases/$db_id/collections/$products_coll_id" -Method Put -Body $productsBody
if ($res.code) { Write-Host "   - Error: $($res.message)" -ForegroundColor Red } else { Write-Host "   - Success: 'products' is now public." -ForegroundColor Green }

# 2. Add Platforms (including the common 127.0.0.1 and the user's IP)
Write-Host "2. Adding Platforms (CORS) for Mobile and Local access..."
$platforms = @(
    @{ type = "web"; name = "Live Server"; key = "127.0.0.1" },
    @{ type = "web"; name = "Local Machine"; key = "localhost" },
    @{ type = "web"; name = "Mobile Connection"; key = $mobile_ip }
)

foreach ($plat in $platforms) {
    $res = Invoke-Appwrite -Uri "$endpoint/projects/$project_id/platforms" -Method Post -Body $plat
    if ($res.code -eq 409) { Write-Host "   - Info: Platform '$($plat.key)' already exists." -ForegroundColor Yellow }
    elseif ($res.code) { Write-Host "   - Error adding '$($plat.key)': $($res.message)" -ForegroundColor Red }
    else { Write-Host "   - Success: Added '$($plat.key)'." -ForegroundColor Green }
}

Write-Host "--- All Fixes Applied ---" -ForegroundColor Cyan

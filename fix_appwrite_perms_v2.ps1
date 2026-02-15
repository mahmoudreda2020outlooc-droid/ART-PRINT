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
    Write-Host "جاري تحديث صلاحيات: $coll_id ..." -ForegroundColor Cyan
    $url = "$endpoint/databases/$db_id/collections/$coll_id"
    
    try {
        # Get current collection
        $current = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
        
        # Prepare update body with all required fields
        $body = @{
            name             = $current.name
            permissions      = $perms
            documentSecurity = $current.documentSecurity
            enabled          = $true
        } | ConvertTo-Json
        
        # Update collection
        $result = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -Body $body
        Write-Host "✅ تم تحديث $coll_id بنجاح!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ فشل تحديث $coll_id" -ForegroundColor Red
        Write-Host "الخطأ: $($_.Exception.Message)" -ForegroundColor Yellow
        
        # Try to get more details
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "التفاصيل: $responseBody" -ForegroundColor Yellow
        }
        return $false
    }
}

Write-Host "`n🚀 بدء إصلاح صلاحيات Appwrite...`n" -ForegroundColor Magenta

# 1. Products: Allow anyone to read
$success1 = Update-CollectionPerms "products" @('read("any")')

# 2. Feedback: Allow anyone to create
$success2 = Update-CollectionPerms "feedback" @('create("any")')

Write-Host "`n" -NoNewline
if ($success1 -and $success2) {
    Write-Host "🎉 تم إصلاح جميع الصلاحيات بنجاح!" -ForegroundColor Green
    Write-Host "يمكنك الآن تجربة الموقع على الهاتف 📱" -ForegroundColor Cyan
}
else {
    Write-Host "⚠️ حدثت بعض المشاكل. يرجى التحقق من الأخطاء أعلاه." -ForegroundColor Yellow
}

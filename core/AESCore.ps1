function New-AESKey {
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.KeySize = 256
    $aes.GenerateKey()
    $aes.GenerateIV()
    return @{
        Key = [Convert]::ToBase64String($aes.Key)
        IV  = [Convert]::ToBase64String($aes.IV)
    }
}

function Encrypt-Text {
    param (
        [string]$PlainText,
        [string]$KeyBase64,
        [string]$IVBase64
    )

    $key = [Convert]::FromBase64String($KeyBase64)
    $iv  = [Convert]::FromBase64String($IVBase64)
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.IV = $iv

    $encryptor = $aes.CreateEncryptor()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText)
    $cipher = $encryptor.TransformFinalBlock($bytes, 0, $bytes.Length)
    return [Convert]::ToBase64String($cipher)
}

function Decrypt-Text {
    param (
        [string]$CipherTextBase64,
        [string]$KeyBase64,
        [string]$IVBase64
    )

    $key = [Convert]::FromBase64String($KeyBase64)
    $iv  = [Convert]::FromBase64String($IVBase64)
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.IV = $iv

    $decryptor = $aes.CreateDecryptor()
    $cipher = [Convert]::FromBase64String($CipherTextBase64)
    $plain = $decryptor.TransformFinalBlock($cipher, 0, $cipher.Length)
    return [System.Text.Encoding]::UTF8.GetString($plain)
}

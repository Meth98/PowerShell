############################################################################################
## Description: Script to understand the functionality of the encode and decode a string
##
## Author: Matteo Z.
############################################################################################
function Base64Encode {
        $encode = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($to_encode))

        return $encode
}

function Base64Decode {
        $decode = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($encode))

        return $decode
}


########## MAIN ##########

$to_encode = Read-Host "Type a string to encode and decode"

if ($to_encode.Length -ne 0) {
        $encode = Base64Encode
        Write-Host "Encode = $encode"

        $decode = Base64Decode
        Write-Host "Decode = $decode"
} else {
        Write-Host -ForegroundColor "red" "Error!!"
}
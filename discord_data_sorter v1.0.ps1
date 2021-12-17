# Defining paths
$dataFolderPath = Read-Host "Enter the Discord data folder path "
$destination = Read-Host "Enter the path where you want the output to be sent to "

# Testing if the output folder already exists or not and empties it does
if (-not (Test-Path -LiteralPath $destination\private_messages)) {
    New-Item -Path $destination\private_messages -ItemType Directory | Out-Null 
} else {
    Remove-Item -Path $destination\private_messages -Recurse
    New-Item -Path $destination\private_messages -ItemType Directory | Out-Null
}

# Verify the type of message channel that the folder contains (1 being private messages)
$numberOfFiles = 0
foreach ($file in Get-ChildItem $dataFolderPath\messages) {
    if (!($file -like "*.json")) {
        if (Select-String -Pattern '"type": 1' -Path $dataFolderPath\messages\$file\channel.json) {
            Copy-Item -Path $dataFolderPath\messages\$file -Destination $destination\private_messages\$file -recurse
            $numberOfFiles++
        }
    }
}

Write-Host
Write-Host $numberOfFiles private messages folders found and copied to $destination\private_messages
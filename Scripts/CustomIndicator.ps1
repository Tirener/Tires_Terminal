function prompt {
    # Get full current path
    $fullPath = (Get-Location).Path

    # Get current folder name
    $currentFolder = Split-Path -Leaf $fullPath

    # Get parent folder name
    $parentFolder = Split-Path -Leaf (Split-Path $fullPath)

    # Compose prompt string with parent and current folder, separated by backslash
    if ($parentFolder) {
        $pathDisplay = "$parentFolder\$currentFolder"
    }
    else {
        $pathDisplay = $currentFolder
    }

    # Define prompt symbol
    $promptSymbol = ">"

    # Set colors for parts of the prompt
    $host.UI.RawUI.ForegroundColor = "Red"
    Write-Host "$pathDisplay " -NoNewline

    $host.UI.RawUI.ForegroundColor = "Red"
    Write-Host "$promptSymbol " -NoNewline

    # Reset color to default for user input
    $host.UI.RawUI.ForegroundColor = "White"

    return " "
}

param(
    [Parameter(Mandatory = $true)]
    [string] $PrivateKeyPath
)

$ErrorActionPreference = 'Stop'

$terraformDirectory = Join-Path $PSScriptRoot '..\terraform'
$inventoryDirectory = Join-Path $PSScriptRoot 'inventory'
$inventoryPath = Join-Path $inventoryDirectory 'hosts.ini'

# Read Terraform outputs
Push-Location $terraformDirectory
try {
    $outputs = terraform output -json | ConvertFrom-Json

    if (
        -not $outputs.web_public_ip.value -or
        -not $outputs.web_private_ip.value -or
        -not $outputs.database_private_ip.value
    ) {
        throw 'Terraform outputs are missing. Apply the reviewed infrastructure first.'
    }
}
finally {
    Pop-Location
}

# Validate the private key path
if ([string]::IsNullOrWhiteSpace($PrivateKeyPath)) {
    throw 'Provide the private key path when running this script.'
}

$keyForWsl = $PrivateKeyPath

# Create inventory directory
New-Item -ItemType Directory -Path $inventoryDirectory -Force |
    Out-Null

# Generate Ansible inventory
$lines = @(
    '[web]'
    "web1 ansible_host=$($outputs.web_public_ip.value) ansible_private_ip=$($outputs.web_private_ip.value) ansible_user=ubuntu ansible_ssh_private_key_file=$keyForWsl"
    ''
    '[database]'
    "db1 ansible_host=$($outputs.database_private_ip.value) ansible_user=ubuntu ansible_ssh_private_key_file=$keyForWsl ansible_ssh_common_args='-o ProxyCommand=""ssh -i $keyForWsl -W %h:%p ubuntu@$($outputs.web_public_ip.value)""'"
)

[System.IO.File]::WriteAllLines(
    $inventoryPath,
    $lines,
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host "Generated $inventoryPath. Review it before running Ansible."

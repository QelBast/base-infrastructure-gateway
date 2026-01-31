# Launch with proxy if you have regional restrictions

param(
    [string]$ConfigPath = "../config/tofu.rc",
    [string]$MirrorPath = "../ot-mirror",
    [string]$TfPath = "../src-new",
    [string]$Proxy = "http://localhost:34822"
)

$env:HTTP_PROXY = "$Proxy"
$env:HTTPS_PROXY = "$Proxy"

$env:TF_CLI_CONFIG_FILE = "$ConfigPath"

#winget install tofu
tofu version
New-Item -Path $MirrorPath -ItemType "Directory" -Force
tofu -chdir="$TfPath" init
tofu -chdir="$TfPath" providers mirror $MirrorPath

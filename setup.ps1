# We winget
$wingetInstalled = Get-Command -ErrorAction SilentlyContinue winget
if (-not $wingetInstalled) {
    $url = "http://aka.ms/getwinget"
    $outputPath = "$env:USERPROFILE\Downloads\winget.DesktopAppInstaller.msixbundle"
    Invoke-WebRequest -Uri $url -OutFile $outputPath
    Start-Process -FilePath $outputPath -Wait
    # no garbage here!!
    Remove-Item -Path $outputPath -Force
}

# We gaming
winget install -e --id Valve.Steam
winget install -e --id RiotGames.Valorant.BR
winget install -e --id RiotGames.Valorant.BR

# We util
winget install -e --id Spotify.Spotify
winget install -e --id Discord.Discord.Canary
winget install -e --id VideoLAN.VLC
winget install -e --id Nvidia.GeForceExperience
winget install -e --id M2Team.NanaZip.Preview
winget install -e --id Opera.OperaGX

# We dev (on linux even tho we microsoft)
winget install -e --id Git.Git
winget install -e --id Microsoft.WindowsTerminal
winget install -e --id Canonical.Ubuntu.2204
winget install -e --id Insomnia.Insomnia
winget install -e --id Microsoft.VCRedist.2015+.x64

# Yeah we make videos
winget install -e --id OBSProject.OBSStudio.Pre-release
winget install -e --id Audacity.Audacity
winget install -e --id HandBrake.HandBrake

# yayaya we config stuff
$wslInstalled = Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -ErrorAction SilentlyContinue
if ($wslInstalled -eq $null) {
    wsl --install
}

# ze fonts
$url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaMono.zip"
$outputPath = "$env:USERPROFILE\Downloads\CascadiaMono.zip"
Invoke-WebRequest -Uri $url -OutFile $outputPath
$fontFolder = "$env:USERPROFILE\Downloads\CascadiaMono"
if (-not (Test-Path -Path $fontFolder -PathType Container)) {
    New-Item -Path $fontFolder -ItemType Directory -Force
}
Expand-Archive -Path $outputPath -DestinationPath $fontFolder
$fontFiles = Get-ChildItem -Path $fontFolder -Filter "*.ttf" -File
foreach ($fontFile in $fontFiles) {
    Install-Font -FilePath $fontFile.FullName
}
Remove-Item -Path $fontFolder -Force -Recurse
Remove-Item -Path $outputPath -Force

# find that ms terminal folder lol
$searchPath = "$env:LOCALAPPDATA\Packages"
$matchingFolders = Get-ChildItem -Path $searchPath -Directory | Where-Object { $_.Name -like 'Microsoft.WindowsTerminal*' }
$settingsPath = Join-Path -Path $matchingFolders[0].FullName -ChildPath "LocalState"
$githubRawUrl = "https://raw.githubusercontent.com/wllfaria/windots/main/microsoft-terminal/settings.json"
Invoke-WebRequest -Uri $githubRawUrl -OutFile $settingsPath
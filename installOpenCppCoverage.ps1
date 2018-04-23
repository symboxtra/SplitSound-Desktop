#########################################################
#                                                       #
#     Download OpenCppCoverage to generate reports      #
#                                                       #
#########################################################


# Downloads are done from the oficial github release page links
$downloadUrl = "https://github.com/OpenCppCoverage/OpenCppCoverage/releases/download/release-0.9.6.1/OpenCppCoverageSetup-x64-0.9.6.1.exe"
$installerPath = "./OpenCppCoverageSetup.exe"
""

# Download executable from source
if(-Not (Test-Path $installerPath)) {
    Write-Host "Downloading OpenCppCoverage from: " -Foreground Cyan -NoNewline
	Write-Host $downloadUrl -Foreground White
	
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
}

Write-Host "===== Installing OpenCppCoverage... =====" -Foreground Yellow
""

# Install OpenCppCoverage
$installProcess = (Start-Process $installerPath -ArgumentList '/VERYSILENT' -PassThru -Wait)
if($installProcess.ExitCode -ne 0) {
    throw [System.String]::Format("Failed to install OpenCppCoverage, ExitCode: {0}.", $installProcess.ExitCode)
}

# Assume standard, boring, installation path of ".../Program Files/OpenCppCoverage"
$installPath = [System.IO.Path]::Combine(${Env:ProgramFiles}, "OpenCppCoverage")
$env:Path="$env:Path;$installPath"

# Inform user installation has completed
Write-Host "Installation Complete." -Foreground Green
""

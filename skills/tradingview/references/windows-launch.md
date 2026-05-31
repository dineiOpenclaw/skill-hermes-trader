# Windows launch notes for TradingView Desktop

Use this when TradingView Desktop is installed from the Microsoft Store / Appx and you need the skill to attach to the running app.

## Preferred launch paths

1. Prefer a user-writable portable extraction of the MSIX first, and launch that executable with a CDP port:
   - `TradingView.exe --remote-debugging-port=9222`
2. If no portable copy exists, resolve the installed app location from PowerShell:
   - `Get-AppxPackage *TradingView* | Select-Object InstallLocation`
3. If a direct executable launch is blocked, launch the packaged app via its Start menu AppID:
   - `Get-StartApps *TradingView*`
   - `shell:AppsFolder\TradingView.Desktop_n534cwy3pjxzj!TradingView.Desktop`

## Verification

After launch, confirm the CDP endpoint responds before using the skill:

- `curl http://127.0.0.1:9222/json/version`
- Check for a valid `webSocketDebuggerUrl` and a `User-Agent` that includes TradingView/Electron.

## Practical fallback

Create a small launcher script that resolves `InstallLocation` and starts `TradingView.exe` with the debugging port already set.

If direct execution from `WindowsApps` is blocked, extract the `.msix` package to a user-writable portable directory and have the launcher target that copy first. Keep the portable path as the primary launch target, with the AppX install location as fallback.

Keep the launcher alongside your other local TradingView helpers so the skill can attach consistently across sessions.

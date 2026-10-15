# netbird-client-setup

Sets up the NetBird VPN client with one profile per environment, so your laptop is connected to one environment at a time. Server: `https://netbird.brandlive.cloud`.

You need a Brandlive Google account. You sign in with Google once per profile.

## Mac

No Homebrew is needed. The script downloads NetBird's installer package, checks that it is signed by NetBird GmbH and notarized by Apple, and installs it. It asks for your Mac password. Prefer to click through? Download the installer from https://pkgs.netbird.io/macos/universal, open it, and follow the prompts, then continue at step 2.

In Terminal:

1. Download the script and check it.

   ```
   cd ~/Downloads
   curl -fsSLO https://github.com/brandlive1941/netbird-client-setup/releases/download/v0.1.1/mac-setup.sh
   curl -fsSLO https://github.com/brandlive1941/netbird-client-setup/releases/download/v0.1.1/SHA256SUMS
   grep mac-setup.sh SHA256SUMS | shasum -a 256 -c
   ```

   The last command must print `mac-setup.sh: OK`. If it doesn't, stop. Read the script before you run it.

2. Run it with your first name.

   ```
   chmod +x mac-setup.sh
   ./mac-setup.sh yourname
   ```

   Your browser opens once per environment so you can sign in with Google.

3. Tell your NetBird admin you have finished. Your access has to be added on the server side, and nothing is reachable until then.

4. Test it, after the admin confirms.

   ```
   netbird profile select dev-qa
   netbird up
   netbird networks list
   ```

   `netbird networks list` should show the environment's network. Then try something you really use there, such as the database.

## Windows

Run PowerShell as Administrator:

1. Download the script and check it.

   ```
   cd $env:USERPROFILE\Downloads
   Invoke-WebRequest https://github.com/brandlive1941/netbird-client-setup/releases/download/v0.1.1/windows-setup.ps1 -OutFile windows-setup.ps1
   Invoke-WebRequest https://github.com/brandlive1941/netbird-client-setup/releases/download/v0.1.1/SHA256SUMS -OutFile SHA256SUMS
   (Get-FileHash windows-setup.ps1 -Algorithm SHA256).Hash
   Select-String windows-setup.ps1 SHA256SUMS
   ```

   The hash printed by `Get-FileHash` must match the one on the `windows-setup.ps1` line of `SHA256SUMS` (case does not matter). If it doesn't, stop. Read the script before you run it.

2. Run it.

   ```
   powershell -ExecutionPolicy Bypass -File .\windows-setup.ps1
   ```

   It asks for your first name, installs the client and opens your browser once per environment to sign in with Google.

3. Tell your NetBird admin you have finished, as for Mac.

4. Test it, after the admin confirms. Open a new PowerShell window:

   ```
   netbird profile select dev-qa
   netbird up
   netbird networks list
   ```

## Switching environments

You are connected to one environment at a time. Each environment is its own profile.

```
netbird profile select staging
netbird up
netbird status
```

Selecting a profile does not always connect it. If `netbird status` does not say Connected, run `netbird up` and finish the Google sign-in if your browser opens.

Disconnect any other VPN client first. Test connectivity against a real service address. The routing peer's own IP will not answer.

## If something fails

- Run `netbird status -d` and send the output to your admin.
- `netbird: command not found` on Mac: open the NetBird app once, then run the script again.
- `netbird networks list` is empty: your admin may not have added your access yet. If they have, run `netbird down` and `netbird up` on that profile.
- Each profile appears as its own device named `<yourname>-<environment>`.

## Status

Both scripts are untested end to end. If you are one of the first to run one, tell your admin what happened.

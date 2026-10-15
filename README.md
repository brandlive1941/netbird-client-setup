# netbird-client-setup

Sets up the NetBird VPN client with one profile per environment, so your laptop is connected to one environment at a time. Server: `https://netbird.brandlive.cloud`.

You need a Brandlive Google account. You sign in with Google once per profile. Prefer clicking to typing? See [Simple install](#simple-install-no-terminal).

## Simple install (no Terminal)

If you would rather not use Terminal or PowerShell, install the app by clicking:

1. Download the installer:
   - Windows: https://pkgs.netbird.io/windows/x64
   - Mac (any Mac): https://pkgs.netbird.io/macos/universal
2. Double-click the downloaded file and click through the prompts. It may ask for your computer password.
3. Open **NetBird** from the Start menu (Windows) or Applications (Mac).
4. When it asks which server to use, choose the option for your own (self-hosted) server and enter `https://netbird.brandlive.cloud`.
5. Click **Connect** and sign in with your Brandlive Google account.
6. Notify devops that you are connected. They have to switch your access on from their side before anything works.

You will be connected to one environment. If you need more than one, devops will tell you what to add.

The Mac installer is signed by NetBird GmbH and notarized by Apple. The Windows installer was not inspected. Do not use the app until step 6 is done; it connects but shows nothing.

## Advanced install

### Mac

The script downloads NetBird's installer package, checks that it is signed by NetBird GmbH and notarized by Apple, and installs it. It asks for your Mac password. Prefer to click through? Download the installer from https://pkgs.netbird.io/macos/universal, open it, and follow the prompts, then continue at step 2.

In Terminal:

1. Download the script and validate it.

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

3. Enable your access. Nothing is reachable until your devices are switched on from the server side. In GitHub, open the
   `netbird-access` repository, go to **Actions**, choose **Enable-Netbird-Clients**, and click **Run workflow** (the defaults are right).
   It takes about half a minute and checks your Identity Center groups. Can't open that repository? Notify devops and they will run it.

4. Test it, once Enable-Netbird-Clients has finished.

   ```
   netbird profile select dev-qa
   netbird up
   netbird networks list
   ```

   `netbird networks list` should show the environment's network. Then try something you really use there, such as the database.

### Windows

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

3. Enable your access by running **Enable-Netbird-Clients**, as in the Mac steps.

4. Test it, once Enable-Netbird-Clients has finished. Open a new PowerShell window:

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
- `netbird networks list` is empty: Enable-Netbird-Clients may not have run since you signed in. Run it (see step 3), and then run `netbird down` and `netbird up` on that profile.
- Each profile appears as its own device named `<yourname>-<environment>`.

## Alternative: install NetBird with Homebrew (Mac)

You do not need this. The Mac steps above install NetBird without Homebrew. Use this only if you prefer Homebrew-managed software.

1. Check for Homebrew with `brew --version`. If you get `command not found`, install it with Homebrew's official command (from [brew.sh](https://brew.sh); read it there first if you like):

   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

   It may ask for your Mac password, and it installs Apple's command line tools if you don't have them, which can take a few minutes. When it finishes it prints a **Next steps** section. Run the lines it shows (on Apple Silicon Macs they add Homebrew to your PATH), then close and reopen Terminal.

2. Trust NetBird's tap, then install the app. Current Homebrew refuses to load a third-party tap until you trust it:

   ```
   brew tap netbirdio/tap
   brew trust netbirdio/tap
   brew install --cask netbirdio/tap/netbird-ui
   ```

3. Download and run `mac-setup.sh` as in the Mac steps above. It skips the install when `netbird` is already present.

If step 2 fails with `Refusing to load formula ... from untrusted tap`, you skipped `brew trust`. These Homebrew steps have not been tested end to end.

## Status

Both scripts are untested end to end. If you are one of the first to run one, tell your admin what happened.

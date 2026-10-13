# netbird-client-setup

Installs the NetBird client and creates one profile per environment, so a laptop is connected to one environment at a time. Server: `https://netbird.brandlive.cloud`.

## Mac

```
./mac-setup.sh <yourname>
```

Installs the app with Homebrew, then creates a profile for each environment and signs in with Google once per profile.

## Windows

Run PowerShell as Administrator:

```
.\windows-setup.ps1
```

## Switching environments

```
netbird profile select dev-qa    # or staging
netbird status
```

Only one profile is active at a time. Each profile is its own peer named `<yourname>-<environment>`.

## Notes

- A new profile has no access until an admin adds its peer to the environment group. Prod access is limited to named people; add `prod` to the `ENVS` list in the script only if you have been given access.
- Test connectivity against a real service address, not the routing peer's IP.
- Both scripts are untested end to end. Run one on a machine, with a throwaway profile name first, before rolling out.

# Implementation Guide: Digital Identity Resilience

## Create passphrase and hardware keys
- Create master passphrase for memorization (diceware)
- Create a story to memorize it
- Purchase at least 3 hardware keys (Yubikey)
    - Carry one with you
    - Have one in another safe space you can easily access
    - Have another in a safe space tucked away (family member, safely deposit box)

## Secure SIM
- Use a physical SIM
- Enable SIM PIN lock
- Lock SIM to carrier
- (Optional with commentary) Enable extra protection for changing device of SIM (trade-off is stealing device vs someone impersonating)
- (Optional) set up burner phone
- (Optional) make sure you only use companies that let you disable SMS 2FA

## Secure devices
- Enable disk encryption
- Configure screen lock (always lock, 0 min, etc, especially for password manager)
- Enable ability to remote wipe
- Enable extra security features (e.g. Apple’s)
- Configure notifications to private
- Configure browser notifications to private
- (Optional) set biometric unlock 
- (Optional) create additional layers (biometric to unlock apps too)
- (Optional) create mixed layers (e.g. biometric to unlock app, pin on device)
- (Optional) install physical privacy screen
- (Optional) VPN
- (Optional) USB port hardening

## Secure authenticator app
- Use one that isn’t single point of failure (e.g. Authy and not Google Authenticator)
- Install on multiple devices
- [TODO WZ to investigate] Turn off multi-device after installing on multiple devices

## Secure critical accounts (password manager, authenticator, email, bank, etc.)
- Enable 2FA
- Register hardware keys for 2FA
- Restrict 2FA to hardware keys, or at least not SMS
- Create backup code and put in password manager
- QA both hardware keys
- Set up trusted recovery contact
- Set to advanced protection features (turn off mobile app 2FA, require 2x face scan, etc.)
- Make sure to avoid circular dependency and multiple points of threat (e.g. Chrome password manager)

## Set up recovery bundle
- You have to do this
- Two options to do this:
    - Encrypt in command line
    - Encrypt with software app
- Compile
    - Create note to future self including priorities
    - Export password manager vault
    - SSH keys
- Organize and encrypt
- Post to public location

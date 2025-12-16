# Digital Identity Resilience

---

## Purpose

This is a how-to guide to secure your online accounts and digital identity. To see the guide itself, go to the Key Documents section.

These guidelines prevent, mitigate, and recover from these scenarios:
- I lost my phone or somebody has stolen my laptop
- I lost my money because my bank password was cracked
- I can't get into an account through my own user stupidity
- I got locked out of an account and now can't use it to 2FA other accounts
- I store all my passwords in one place and that service got taken out by a volcano

They are not meant to prevent sophisticated attacks, extreme coercion, or nation-state actors.

---

## Overview

### Principles
- Layers of security. For example, 2FA means just stealing a password is insufficient, secure vaults protect less secure informtion, etc.
- Prioritize the most secure options. For example, biometric authentication requires your presence, hardware 2FA requires the physical item, etc.
- Must be practical ot use. The world's most secure method may be so inconvenient that you'd never use it regularly in day to day life.
- Recovery balanced with access prevention. You don't want to limit access so much that you can never recover your account when needed.
- Avoid circular dependencies. For example, using Google Voice as a 2FA for your Google email may lock you out permanently.

### Core Approach
We believe the best way to achieve all the above principles is using 4 things at the core:
1. Master diceware passphrase you remember
2. Hardware 2FA device such as a Yubikey
3. Password manager such as Bitwarden
4. Encrypted recovery bundle in accessible place

### Components

*Your Devices*
- Configure so if somebody has only the device, they can't compromise your accounts.
  
*Key Accounts (email, banking, social media, etc.)*
- These are ultimately what we're trying to protect.
- Each should have a unique password, so they are isolated from each other.
- Each should require a 2FA method. When possible, choose the best 2FA method (biometric > hardware > TOTP > email / SMS).

*Password manager (Bitwarden, 1Password, etc.)*
- This is what you'll use on a daily basis as the most secure practical option.
- Secured by a diceware password and a hardware 2FA method.

*Other 2FA methods (SMS, TOTP, etc.)*
- Each of these has unique weaknesses that we mitigate in further detail.

*Recovery bundle*
- Necessary for you to make sure you never lose your accounts.
- Needs to be encrypted, obscure, and difficult for anybody to connect to you.
- Needs to be accessible in event of emergency where you've lost devices and account access.

---

## Key Documents

- Guide for securing your accounts

---

## Support & Feedback

This is a living document. If you:
- Found errors or unclear instructions
- Have suggestions for improvement
- Want to share your recovery story
- Need clarification on specific scenarios

**Open an issue:** (Keep it anonymous, no personal details)

---

## License

[CC0 1.0 Universal (Public Domain)](LICENSE) - This work is dedicated to the public domain.

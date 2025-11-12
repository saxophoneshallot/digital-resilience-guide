# Implementation Guide: Digital Identity Resilience

**Step-by-step technical setup for Levels 0-2 threat defense**

---

## Overview

This guide walks you through implementing a resilient digital identity system that survives:
- Device theft (phone, laptop)
- Home burglary (all devices stolen)
- Mugging/robbery (everything taken)
- Account lockouts
- Provider service disruptions

**Time Investment:**
- Initial setup: 4-6 hours
- Monthly maintenance: 15 minutes
- Quarterly updates: 30 minutes
- Annual full test: 2 hours

**Cost:**
- Hardware keys: $50-100 (two keys)
- Optional: Cloud storage $5-10/month (or free tier)
- Total one-time: ~$100

---

## Prerequisites

### Risk Profile Assessment

Which threat levels do you need to defend against?

**Level 0-1 (Basic):**
- Daily device usage
- Opportunistic theft (stolen laptop, lost phone)
- **Setup time:** 2-3 hours
- **Key controls:** Biometrics, screen locks, remote wipe

**Level 2 (Standard):**
- All of Level 0-1, plus:
- Complete loss of all physical possessions
- Home burglary or mugging
- **Setup time:** 4-6 hours
- **Key controls:** Off-site encrypted backups, hardware keys, memorized recovery

**Level 3 (Advanced):**
- All of Level 2, plus:
- Sophisticated surveillance and social engineering
- Targeted attacks on your backup systems
- **Setup time:** 8-12 hours
- **Key controls:** Defense in depth, operational security, trust network

**This guide focuses on Level 2** (sufficient for most people).

### Required Materials

**Essential:**
- [ ] Password manager account (Bitwarden recommended)
- [ ] Two hardware security keys (YubiKey 5 NFC recommended)
- [ ] Primary computer (Linux, macOS, or Windows)
- [ ] Primary smartphone (iOS or Android)
- [ ] Cloud storage account (separate from email provider)
- [ ] Notepad and pen (for temporary notes during setup)

**Optional but Recommended:**
- [ ] Second phone or tablet (for testing)
- [ ] USB drive for temporary file transfers
- [ ] Printer (for emergency reference card)
- [ ] Safe or lockbox (for backup key storage)

### Knowledge Prerequisites

You should be comfortable with:
- [ ] Using a terminal/command line (basic commands)
- [ ] Installing software on your devices
- [ ] Creating strong passwords
- [ ] Basic understanding of 2FA/MFA

### Integration Strategy

**Don't throw away your existing setup.** Add resilience layers:

1. **Keep:** Your existing password manager (if it's reputable)
2. **Verify:** Master password is actually strong (not "password123")
3. **Add:** Hardware keys if you don't have them
4. **Add:** Backup key stored off-site (critical for resilience)
5. **Add:** Encrypted recovery bundle (even if you think your current backup is sufficient)
6. **Add:** Testing schedule (this is what most people skip)

**The goal:** Move from "I think it works" to "I've verified it works"

### Understanding Security vs. Availability

This guide balances two competing goals:

**Goal 1: Security (Protecting from attackers)**
- Disk encryption → Protects data if device stolen while off
- Hardware keys → Strong authentication, resists phishing
- Separate encryption passphrases → Defense in depth
- Off-site backups → Prevents single-location compromise

**Goal 2: Availability (Ensuring YOU can access)**
- Memorized passphrases → Recovery anchor (no device needed)
- Redundant hardware keys → Primary + backup
- Off-site encrypted backups → Survive physical loss
- Regular testing → Verify recovery actually works

**The trade-off:**
- More security → Harder to recover if you forget/lose something
- More availability → More attack surface for adversaries

**This guide optimizes for:**
"High security against opportunistic and moderately sophisticated attackers (Levels 1-3), but recoverable after total device loss using only memory + internet access"

**What we accept:**
- If you forget BOTH passphrases, recovery is extremely difficult
- If a Level 4 adversary (coercion/torture) targets you, this won't help
- Some convenience is sacrificed for security (manual unlocks, testing time)

**What we reject:**
- "Convenient" security that fails during actual crisis
- Single points of failure
- Untested recovery procedures

---

## Phase 1: Foundation (2 hours)

### Step 1.1: Generate Your Master Passphrase

This is your **root credential** - the only thing you must memorize.

**Requirements:**
- High entropy (at least 77 bits)
- Memorable but not guessable
- Not used anywhere else
- Not written down (except during initial memorization)

**Recommended Method: Diceware**

1. **Get materials:**
   - 5 physical dice (or use digital: `https://diceware.rempe.us`)
   - Diceware word list (8k version recommended)

2. **Generate 7-8 words:**
```bash
# Using physical dice:
# Roll 5 dice, note numbers (e.g., 4-3-5-2-1)
# Look up word in Diceware list (e.g., 43521 = "recipe")
# Repeat 7-8 times

# Example result:
# recipe-tractor-kindly-dolphin-marker-cabin-fidget
```

3. **Entropy calculation:**
   - 7 words = 90.5 bits (excellent)
   - 8 words = 103.4 bits (paranoid)

4. **Memorization technique:**
   - Create a mental story linking the words
   - Practice typing it 10 times
   - Test yourself after 1 hour, 1 day, 1 week
   - Don't write it down after you've memorized it

**Example (fictional):**
```
recipe-tractor-kindly-dolphin-marker-cabin-fidget

Story: "I follow a recipe on my tractor when a kindly
dolphin uses a marker to draw a cabin where I fidget."
```

**Security note:** Your actual passphrase should be different from any examples. Never share it.

### Step 1.2: Set Up Password Manager (Bitwarden)

**1. Create Bitwarden Account**

```bash
# Go to: https://vault.bitwarden.com
# Click "Create Account"
```

**Account details:**
- **Email:** Use an email you control that has its own 2FA
- **Master Password:** Use your Diceware passphrase from Step 1.1
- **Hint:** Leave empty (hints weaken security)

**Important:** Use a **different email** than what you'll use for cloud storage later.

**2. Install Bitwarden Apps**

```bash
# Desktop (Linux example)
# Download from: https://bitwarden.com/download/

# Browser Extension
# Install from your browser's extension store

# Mobile
# Install from App Store (iOS) or Play Store (Android)
```

**3. Initial Configuration**

In Bitwarden settings:

```
Settings → Security → Vault Timeout
  - Set to: 15 minutes (aggressive)
  - Timeout Action: Lock (not Log out)

Settings → Security → Vault Timeout Action
  - Require master password on restart: Enabled

Settings → Security → Unlock with PIN
  - Disable for now (until biometrics configured)

Settings → Two-step Login
  - Skip for now (will configure with hardware key in Phase 2)
```

**4. Import Existing Passwords**

If migrating from another password manager:

```bash
# From Chrome/Firefox
# Export passwords as CSV (Settings → Passwords → Export)

# Import to Bitwarden
# Settings → Import Data
# Select format, upload CSV
# Verify import, then DELETE the CSV file securely

# Linux: Securely delete
shred -uvz passwords_export.csv

# macOS: Securely delete
srm passwords_export.csv
# Or if srm not installed:
rm -P passwords_export.csv

# Windows: Use SDelete
sdelete -p 3 passwords_export.csv
```

**5. Create Account Categories**

Organize your vault with folders:

```
Critical (require hardware key):
  - Primary email
  - Password manager email
  - Banking/financial
  - Cloud storage with recovery bundle
  - Domain registrar

Important (require strong 2FA):
  - Secondary email accounts
  - Social media
  - Work accounts
  - Shopping with stored payment

Standard (TOTP is fine):
  - Forums, communities
  - News sites
  - Streaming services
  - Low-value accounts
```

### Step 1.3: Enable Disk Encryption

**Desktop/Laptop:**
- **Linux:** LUKS (usually enabled during install) - verify: `lsblk -f`
- **macOS:** System Settings → Privacy & Security → FileVault
- **Windows:** Settings → Device Encryption (or BitLocker)

**Mobile:** Enabled by default on iOS 8+ and Android 10+.

**Important:** Save recovery key in password manager, NOT cloud provider (iCloud/Microsoft).

### Step 1.4: Configure Screen Locks

**Desktop/Laptop:**
- **Linux:** Settings → Privacy → Screen Lock (timeout: 5 min, lock on suspend)
- **macOS:** System Settings → Lock Screen (require password immediately)
- **Windows:** Settings → Accounts → Sign-in options (require sign-in on wake)

**Mobile:** Auto-lock 1 minute, require passcode immediately, hide lock screen notifications.

**Public spaces:** 1-minute timeout, manually lock when stepping away.

### Step 1.5: Enable Biometric Unlock

**Purpose:** Convenience only, not security for recovery.

**Setup:** Enroll 2-3 fingerprints (or face) in device settings. Enable for screen unlock and password autofill.

**Critical:** Biometrics are device-local only. After reboot, PIN/password required first. Never rely on biometrics for account recovery.

---

## Phase 2: Hardware Security Keys (1 hour)

### Step 2.1: Purchase Hardware Keys

**Recommended: YubiKey 5 NFC**

Why:
- FIDO2 / WebAuthn support (modern standard)
- NFC for mobile device compatibility
- USB-A and USB-C versions available
- Durable (water resistant, crush resistant)
- Widely supported

**Buy TWO keys:**
- Primary: Keep on your keychain or in your daily bag
- Backup: Store off-site (safe deposit box, trusted family member, office)

**Where to buy:**
- Direct: `https://www.yubico.com`
- Amazon (verify seller is "Yubico Store")
- Local electronics retailers

**Alternatives:**
- Google Titan (USB-A/USB-C + NFC)
- Thetis FIDO2
- Solo Keys (open source)
- Nitrokey (open source, EU-based)

**Cost:** $50 per key × 2 = $100 total

### Step 2.2: Register Keys with Bitwarden

**1. Log into Bitwarden web vault**
```
https://vault.bitwarden.com
```

**2. Enable Two-Step Login**
```
Settings → Security → Two-step Login → FIDO2 WebAuthn
```

**3. Register Primary Key**
```
1. Click "Manage" next to FIDO2 WebAuthn
2. Click "Add Security Key"
3. Insert/tap your primary YubiKey
4. Give it a name: "YubiKey Primary" or "Blue YubiKey"
5. Follow browser prompt to touch the key
```

**4. Register Backup Key**
```
1. Remove primary key
2. Click "Add Security Key" again
3. Insert/tap your backup YubiKey
4. Name it: "YubiKey Backup" or "Red YubiKey"
5. Follow browser prompt
```

**5. Generate Recovery Code**
```
Settings → Security → Two-step Login → Recovery Code
  - View your recovery code
  - Copy to password manager (create a new entry: "Bitwarden Recovery Code")
  - DO NOT print or write down physically
```

**6. Test Both Keys**
```
1. Log out of Bitwarden
2. Log back in
3. After master password, you'll be prompted for hardware key
4. Test primary key: should work
5. Log out again
6. Log in again, test backup key: should work
```

**Important:** Never disable 2FA until you've verified both keys work.

### Step 2.3: Register Keys with Critical Accounts

Prioritize accounts in this order:

**1. Primary Email**
```
# Gmail example:
myaccount.google.com → Security → 2-Step Verification
  → Security keys
  → Add security key
  → Register both keys
  → Name them clearly

# Important: Also set up backup phone or backup codes
```

**2. Cloud Storage (for recovery bundle)**
```
# Pick a DIFFERENT provider than your email
# Examples: Dropbox, Backblaze, mega.nz

# In account security settings:
  → Two-factor authentication
  → Add security key
  → Register both keys
```

**3. Banking/Financial**
```
# Check if your bank supports FIDO2/WebAuthn
# Many banks only support SMS or app-based 2FA

# If FIDO2 supported:
  → Security settings
  → Add hardware key
  → Register both keys

# If not supported:
  → Use strongest available option (usually TOTP app)
  → Make note to switch banks if this is critical to you
```

**4. Domain Registrar**
```
# If you own domains (important for email recovery)
# Register keys with registrar (e.g., Namecheap, Cloudflare)

Account → Security → Two-factor
  → Hardware keys
  → Register both
```

**5. Password Manager Email (if different from primary)**
```
# The email address you used for Bitwarden signup
# Register keys, generate backup codes
```

**Account Priority Matrix:**

| Account Type                    | Hardware Key   | Backup Method               |
| --------------                  | -------------- | ---------------             |
| Primary email                   | Required       | Backup key + recovery codes |
| Password manager                | Required       | Backup key + recovery codes |
| Cloud storage (recovery bundle) | Required       | Backup key + recovery codes |
| Banking                         | If supported   | Backup key or TOTP          |
| Domain registrar                | Required       | Backup key + recovery codes |
| Secondary email                 | Recommended    | TOTP or backup key          |
| Social media                    | Optional       | TOTP                        |
| Shopping                        | Optional       | TOTP                        |

### Step 2.4: Configure Backup Codes

For every account with hardware key 2FA, generate backup codes:

**Process:**
```
1. In account security settings, find "Backup codes" or "Recovery codes"
2. Generate codes (usually 10 single-use codes)
3. Copy all codes
4. Create new entry in Bitwarden password manager:

   Name: "[Service Name] Backup Codes"
   Username: your email for that service
   Notes:
   Code 1: xxxx-xxxx
   Code 2: xxxx-xxxx
   ...

5. DO NOT print or save as plaintext file
6. Store only in encrypted password manager
```

**Mark used codes:**
```
When you use a backup code, immediately:
1. Open Bitwarden entry
2. Delete the used code
3. If codes are running low, generate new set
```

### Step 2.5: Test Hardware Key Flow

Simulate losing your primary key:

**Test procedure:**
```
1. Remove primary key from keychain (put in drawer)
2. Use only backup key for 1 day
3. Log into all critical accounts using backup key:
   - Bitwarden
   - Primary email
   - Cloud storage
   - Banking (if key-enabled)

4. Verify everything works

5. If backup key works for everything:
   ✅ Your setup is resilient

6. Return primary key to keychain
```

**What if backup key doesn't work for an account?**
```
1. Log in using primary key (or backup code)
2. Re-register backup key
3. Test again
4. Don't proceed until both keys work
```

---

## Phase 3: Recovery Bundle Creation (1 hour)

This is your **anchor for total loss scenarios** (mugging, burglary).

### Step 3.1: Export Bitwarden Vault

**1. Export from web vault:**
```
vault.bitwarden.com → Tools → Export Vault

File Format: .json (encrypted)
Master Password Confirmation: [enter your master password]

Download → Save as: bitwarden_export_YYYY-MM-DD.json
```

**2. Verify export:**
```bash
# Check file exists and is not empty
ls -lh bitwarden_export_*.json

# View first few lines (should be JSON)
head -n 20 bitwarden_export_*.json

# Should see: "encrypted": true, "items": [...]
```

**Security note:** Even though Bitwarden exports are encrypted, we'll encrypt them AGAIN with a different key for defense in depth.

### Step 3.2: Document Your Recovery Information

Create a plain text file with recovery information:

```bash
cat > recovery_info.txt << 'EOF'
# Digital Identity Recovery Information
# Created: 2025-11-11
# Last Updated: 2025-11-11

## Emergency Contacts
Trusted contact: [name - no phone/email yet, fill in your private copy]

## Account Structure
Primary email: [domain only, e.g., gmail.com]
Password manager: Bitwarden
Cloud storage: [provider name only]

## Recovery Process Overview
1. Access this bundle from any device with internet
2. Decrypt using memorized passphrase
3. Restore Bitwarden vault
4. Access all accounts

## Hardware Keys
Primary: YubiKey 5 NFC (blue) - usually on keychain
Backup: YubiKey 5 NFC (red) - stored at [location - fill in private copy]

## Backup Locations
This encrypted bundle is stored at:
1. [Cloud provider] - account: [fill in private copy]
2. [Secondary location] - [fill in private copy]
3. [Tertiary location] - [fill in private copy]

## Critical Passwords Structure
- Master passphrase: [memorized, 7-8 Diceware words]
- This bundle encryption: [different passphrase, also memorized]
- Both passphrases required for full recovery

## Recovery Scenarios
See: RECOVERY_PROCEDURES.md in this bundle
EOF
```

**Customize this file:**
- Fill in generic information only (no actual credentials)
- You'll create a separate private version with real details
- This template goes in the public GitHub repo

### Step 3.3: Gather Additional Recovery Materials

**1. Create backup codes document:**
```bash
# Export backup codes from Bitwarden
# This is already in your vault, but we'll extract for convenience

cat > backup_codes.txt << 'EOF'
# 2FA Backup Codes
# DO NOT SHARE - Keep only in encrypted bundle

## Bitwarden Recovery Code
[Retrieve from Bitwarden vault entry: "Bitwarden Recovery Code"]

## Google Account Backup Codes
[Copy from Google account security settings, if not already in Bitwarden]

## [Other Critical Services]
[List any services with backup codes not in Bitwarden vault]
EOF
```

**2. Optional: Export SSH keys or signing keys:**
```bash
# Only if you use SSH keys for server access or git signing
# Skip if not applicable

# Copy SSH private key (encrypted version)
mkdir -p recovery_bundle/ssh
cp ~/.ssh/id_ed25519 recovery_bundle/ssh/
cp ~/.ssh/id_ed25519.pub recovery_bundle/ssh/

# Copy GPG keys (if you use them)
gpg --export-secret-keys -a > recovery_bundle/gpg_private_key.asc
```

**3. Create bundle structure:**
```bash
# Create directory structure
mkdir -p recovery_bundle
cd recovery_bundle

# Move files into bundle
mv ~/Downloads/bitwarden_export_*.json ./
mv ~/backup_codes.txt ./
mv ~/recovery_info.txt ./

# Optional: Copy documentation
cp ~/resilience/THREAT_SCENARIOS.md ./
cp ~/resilience/RECOVERY_PROCEDURES.md ./

# Directory structure should look like:
# recovery_bundle/
# ├── bitwarden_export_2025-11-11.json
# ├── backup_codes.txt
# ├── recovery_info.txt
# ├── THREAT_SCENARIOS.md
# ├── RECOVERY_PROCEDURES.md
# └── ssh/ (optional)
#     ├── id_ed25519
#     └── id_ed25519.pub
```

### Step 3.4: Encrypt the Recovery Bundle

We'll use `age` (modern, simple encryption tool).

**Install age:**

```bash
# Linux (Debian/Ubuntu)
sudo apt install age

# macOS
brew install age

# Or download from: https://github.com/FiloSottile/age/releases
```

**Generate encryption passphrase:**

Use Diceware again to generate a **different** passphrase than your Bitwarden master password:

```bash
# Generate 7-8 words
# Example (don't use this): "balloon-kitchen-forest-plastic-voyage-justice-puzzle"

# This passphrase:
# - Must be different from your Bitwarden master password
# - Must be memorized
# - Will decrypt your recovery bundle
# - Protects you if cloud storage is compromised
```

**Encrypt the bundle:**

```bash
# Create tarball of recovery bundle
tar -czf recovery_bundle.tar.gz recovery_bundle/

# Encrypt with age (using passphrase)
age --encrypt --passphrase --output recovery_bundle.tar.gz.age recovery_bundle.tar.gz

# Enter your NEW encryption passphrase when prompted
# Enter it again to confirm

# Verify encrypted file exists
ls -lh recovery_bundle.tar.gz.age

# IMPORTANT: Securely delete unencrypted versions
shred -uvz recovery_bundle.tar.gz
rm -rf recovery_bundle/

# You should now have only:
# recovery_bundle.tar.gz.age (encrypted)
```

**Test decryption:**

Before uploading, verify you can decrypt:

```bash
# Decrypt
age --decrypt recovery_bundle.tar.gz.age > recovery_bundle_test.tar.gz

# Enter your encryption passphrase

# Extract
tar -xzf recovery_bundle_test.tar.gz

# Verify contents
ls -la recovery_bundle/

# Should see all your files

# Cleanup test files
shred -uvz recovery_bundle_test.tar.gz
rm -rf recovery_bundle/
```

If decryption works, you're ready to upload. If not, don't proceed - fix the issue first.

### Step 3.5: Upload to Cloud Storage

**1. Choose cloud provider:**

Requirements:
- Different from your primary email provider (no single point of failure)
- Supports 2FA with hardware keys
- Reliable (uptime, company stability)
- Accessible from any device

Options:
- Dropbox (good UI, reliable, hardware key support)
- Backblaze B2 (cheap, reliable, good for pure backup)
- mega.nz (privacy-focused, generous free tier)
- Your own server (if you have one)

**2. Create account:**

```
Important: Use a DIFFERENT email than your primary email

Email for cloud storage: secondary-email@protonmail.com
Password: Generate strong password, save in Bitwarden
2FA: Enable with hardware keys (both keys)
```

**3. Upload encrypted bundle:**

```bash
# Via web interface:
# - Log into cloud storage provider
# - Create folder: "recovery_bundles"
# - Upload: recovery_bundle.tar.gz.age
# - Verify upload completed
# - Check file size matches local file

# Or via CLI (example: rclone)
rclone copy recovery_bundle.tar.gz.age remote:recovery_bundles/
```

**4. Test download:**

```bash
# From a different device (or different browser profile)
# - Log into cloud storage
# - Download recovery_bundle.tar.gz.age
# - Verify file is identical (check size and hash)

sha256sum recovery_bundle.tar.gz.age
# Note the hash

# After downloading from cloud:
sha256sum recovery_bundle.tar.gz.age
# Should be identical
```

**5. Set up versioning:**

Keep multiple versions in case of corruption:

```
recovery_bundles/
├── recovery_bundle_2025-11-11.tar.gz.age (latest)
├── recovery_bundle_2025-08-15.tar.gz.age (previous)
└── recovery_bundle_2025-05-10.tar.gz.age (older)

Keep 3 most recent versions, delete older ones
```

### Step 3.6: Create Additional Backup Locations

Don't rely on a single cloud provider.

**Option 1: Second cloud provider**
```
- Create account with different provider (e.g., Backblaze if you used Dropbox)
- Different email address
- Hardware key 2FA
- Upload same encrypted bundle
- Test download
```

**Option 2: Safe deposit box**
```
- Save encrypted bundle to USB drive
- Store USB drive in bank safe deposit box
- Include printed instructions (how to decrypt)
- Update annually
```

**Option 3: Trusted contact**
```
- Give encrypted bundle on USB drive to trusted family/friend
- They can't decrypt without your passphrase
- Include instructions: "If I lose everything, I'll ask for this USB drive"
- Update when you visit them
```

**Option 4: Physical printout (QR codes)**
```bash
# For paranoid level backup: print as QR codes
# Split encrypted file into QR codes, print them

# Install qrencode
sudo apt install qrencode

# Split file into chunks and encode
split -b 2000 recovery_bundle.tar.gz.age recovery_chunk_

# Generate QR for each chunk
for chunk in recovery_chunk_*; do
    qrencode -o "$chunk.png" < "$chunk"
done

# Print all PNG files
# Store papers in fireproof safe

# To recover:
# Scan QR codes, decode, concatenate chunks, decrypt
```

**Recommended setup:**
- Primary: Cloud storage with hardware key 2FA
- Secondary: Different cloud provider
- Tertiary: USB drive in safe deposit box or with trusted contact

### Step 3.7: Configure Emergency Access (Optional but Recommended)

Bitwarden (and some other password managers) offer "Emergency Access" - a trusted contact can request access to your vault after a waiting period.

**Use case:**
- You're in an accident, can't access devices for weeks
- You're robbed, can't retrieve recovery bundle immediately
- You forget both passphrases (catastrophic but happens)
- Trusted contact can help you recover after waiting period

**How it works:**
1. You invite a trusted contact (family member, close friend)
2. They accept and create their own Bitwarden account
3. You set waiting period (7-30 days recommended)
4. If they request emergency access:
   - You receive email alert
   - You can approve immediately (if legitimate)
   - OR waiting period expires and they get access automatically
5. They can view your vault and help you recover

**This is NOT a replacement for your recovery bundle. It's an additional safety net.**

**Setup:**

```
1. Bitwarden web vault → Settings → Emergency Access
2. Click "Add emergency contact"
3. Enter their email address
4. Set user access level:
   - "View" (recommended) - can see passwords, can't change them
   - "Takeover" (use carefully) - can reset your master password
5. Set wait time:
   - 7 days: For spouse/partner you deeply trust
   - 14 days: For close family member (recommended)
   - 30 days: For friend or extended family
6. Send invitation
7. They accept via email
8. Verify they received it

9. **Test the mechanism:**
   - Ask them to initiate emergency access request
   - Verify you receive the alert email
   - Deny the request (just testing)
   - Confirm you can deny and it stops the process
```

**Who to choose as emergency contact:**
- ✅ Spouse or life partner
- ✅ Parent or adult sibling
- ✅ Very close friend you've known 10+ years
- ❌ Coworker (relationship may change)
- ❌ Anyone you don't trust with your life
- ❌ Anyone not tech-savvy enough to use password manager

**Security considerations:**
- Waiting period prevents impulsive/malicious requests
- You get email alert, can deny if unauthorized
- Choose someone who respects privacy and security
- Document this arrangement in your recovery bundle

**1Password alternative:**
1Password calls this "Family organizer" or "Recovery contact" with similar functionality.

### Step 3.8: Document Account Recovery Priority

Not all accounts need immediate recovery. Pri oritize your effort.

**Tier 0: Recovery Anchors (Restore first, within 1 hour)**
- Cloud storage account (where recovery bundle lives)
- Password manager
- Primary email

**Why first:** These unlock everything else.

**Tier 1: Critical (Restore within 24 hours)**
- Banking and financial accounts
- Phone carrier (get replacement SIM)
- Secondary email accounts
- Domain registrar (if you own domains)
- Work email and accounts (if employed)

**Why critical:** Financial security, identity verification, livelihood.

**Tier 2: Important (Restore within 1 week)**
- Social media (prevent account takeover/impersonation)
- Healthcare portals
- Government accounts (IRS, SSA, DMV)
- Insurance accounts
- Utility accounts

**Why important:** Risk of impersonation, need for ongoing services.

**Tier 3: Standard (Restore within 1 month)**
- Shopping accounts (Amazon, eBay)
- Streaming services (Netflix, Spotify)
- Forums and communities
- News subscriptions
- Loyalty programs

**Why standard:** Convenience, but not urgent.

**Tier 4: Can Wait (Restore as needed)**
- Old accounts you rarely use
- Games and entertainment
- Promotional accounts
- One-time registrations

**Why wait:** Low priority, restore only if needed.

**How to use this:**

During recovery after total loss:
1. Focus on Tier 0 first (get your recovery tools working)
2. Then Tier 1 (protect finances and identity)
3. Then Tier 2 as you have time
4. Tier 3-4 can wait weeks or months

**Document this in your recovery bundle:**

Create a file: `recovery_priority.txt`

```
# Account Recovery Priority

## Tier 0 (First hour):
- Dropbox (recovery bundle storage)
- Bitwarden
- Gmail (primary email)

## Tier 1 (First day):
- Chase Bank
- Verizon (phone carrier)
- ProtonMail (secondary email)
- Namecheap (domain registrar)
- Work email (company.com)

## Tier 2 (First week):
- Twitter, LinkedIn
- Doctor's patient portal
- IRS account
- Car insurance

## Tier 3 (First month):
- Amazon, eBay
- Netflix, Spotify
- Reddit, HackerNews

## Tier 4 (As needed):
- Old forum accounts
- Games
```

This prevents decision fatigue during crisis. You know exactly what to do first.

---

## Phase 4: Device Hardening (1 hour)

### Step 4.1: Enable Remote Wipe

**iOS (Find My iPhone):**
```
Settings → [Your Name] → Find My
  → Find My iPhone: On
  → Enable Offline Finding: On
  → Send Last Location: On

Test:
- Go to icloud.com/find from another device
- Log in
- Select your iPhone
- Verify location shows
- Test "Play Sound"
- Familiarize with "Erase iPhone" (don't click it)
```

**Android (Find My Device):**
```
Settings → Security → Find My Device
  → Use Find My Device: On
  → Store recent location: On

Settings → Google → Find My Device
  → Remotely locate this device: On
  → Allow remote lock and erase: On

Test:
- Go to android.com/find from another device
- Log in with Google account
- Select your phone
- Verify location shows
- Test "Play Sound"
- Familiarize with "Erase Device"
```

**macOS (Find My Mac):**
```
System Settings → Apple ID → iCloud
  → Find My Mac: On

Test:
- Go to icloud.com/find
- Select your Mac
- Verify location shows (approximate)
- Familiarize with "Erase Mac"
```

**Windows (Find My Device):**
```
Settings → Privacy & Security → Find My Device
  → Find My Device: On

Settings → Accounts → Your Microsoft account
  → Sign in with Microsoft account (required for remote features)

Test:
- Go to account.microsoft.com/devices
- Select your PC
- Verify last seen location
- Familiarize with device lock/wipe options
```

**Linux (no built-in solution):**
```
Options:
1. Use Prey (https://preyproject.com/)
   - Install agent on laptop
   - Free tier: 3 devices
   - Features: location tracking, remote wipe, screenshots

2. Use custom solution with cron + API:
   - Script that periodically reports location/status
   - Triggered wipe on command from server

3. Just rely on disk encryption:
   - If laptop is stolen while off, data is safe
   - No remote wipe needed if always shut down when leaving
```

### Step 4.2: Configure Privacy Settings

**Mobile notification privacy:**

iOS:
```
Settings → Notifications
  For sensitive apps (Messages, Mail, Banking):
    → Show Previews: Never
    → Lock Screen: Off (or Show Previews: Never)

Settings → Face ID & Passcode
  → Allow Access When Locked:
    → All toggles OFF except Emergency SOS
```

Android:
```
Settings → Notifications → Lock screen
  → Sensitive notifications: Hide content

For each sensitive app (Messages, Gmail, Banking):
  Settings → Apps → [App Name] → Notifications
    → Lock screen: Don't show notifications
```

**Desktop notification privacy:**

```
# macOS
System Settings → Notifications
  → Show previews: Never (or When Unlocked)

# Windows
Settings → System → Notifications
  → Show notifications on the lock screen: Off

# Linux (GNOME)
Settings → Notifications
  → Lock Screen Notifications: Off
```

**Browser privacy settings:**

```
All browsers:
- Disable password auto-fill (use password manager instead)
- Disable payment method saving
- Disable address auto-fill
- Enable "Clear cookies on exit" for sensitive sites
- Use container tabs or profiles for different contexts

Firefox:
  → Settings → Privacy & Security
  → Enhanced Tracking Protection: Strict
  → Cookies and Site Data: Delete cookies and site data when Firefox is closed
  → History: Use custom settings, clear history when Firefox closes

Chrome/Chromium:
  → Settings → Privacy and Security
  → Clear browsing data on exit
  → Disable "Offer to save passwords"
  → Disable "Payment methods"
```

### Step 4.3: Install Privacy Screens

**Physical privacy filters:**

For laptops and monitors used in public:
- Purchase 3M privacy filter or similar
- Blocks viewing angle beyond ~30 degrees
- Cost: $30-60 depending on screen size

For phones:
- Tempered glass privacy screen protector
- Cost: $10-20

**When to use:**
- Coffee shops, libraries, coworking spaces
- Planes, trains, buses
- Any public location where strangers can see your screen

**Not needed:**
- Home office
- Private office at work
- Situations where you control the environment

### Step 4.4: Configure USB Port Controls

Protects against malicious USB devices (rubber ducky attacks, juice jacking).

**Linux (USBGuard):**

```bash
# Install USBGuard
sudo apt install usbguard

# Generate initial policy (allow currently connected devices)
sudo usbguard generate-policy > /etc/usbguard/rules.conf

# Start service
sudo systemctl enable usbguard
sudo systemctl start usbguard

# Add your hardware key to allowed devices
# Insert your YubiKey
lsusb | grep Yubico
# Note the vendor:product ID

# Allow it
sudo usbguard allow-device [device-id]
sudo usbguard add-rule [device-id] allow

# Test: Insert unknown USB device
# Should be blocked, check logs:
sudo journalctl -u usbguard
```

**macOS:**

```bash
# No built-in USB filtering, but you can:
# 1. Disable USB ports in Accessibility settings when not in use
# 2. Use third-party tools like USB Guardian

# Or just use physical discipline:
# - Never insert unknown USB drives
# - Use only your own cables and chargers
# - Avoid public USB charging ports (use AC adapter)
```

**Windows (Device Installation Settings):**

```
Settings → System → Device Installation Settings
  → Automatically install device drivers: No
  → Let Windows try to fix drivers that fail: No

Or use GPO (for Pro/Enterprise):
  gpedit.msc
  → Computer Configuration → Administrative Templates
  → System → Device Installation → Device Installation Restrictions
  → Prevent installation of devices not described by other policy settings: Enabled
```

**Practical USB security:**

✅ **Do:**
- Use your own hardware keys
- Use your own USB drives (labeled)
- Use your own charging cables
- Inspect USB devices before inserting

❌ **Don't:**
- Insert USB drives found in parking lots (common attack)
- Use public USB charging ports (juice jacking risk)
- Leave USB ports exposed when laptop is unattended
- Insert devices with unknown provenance

### Step 4.5: Configure VPN for Public WiFi

**Purpose:** Protect against man-in-the-middle attacks on untrusted networks.

**VPN selection criteria:**

- No-logs policy (verified by audit)
- WireGuard or OpenVPN support
- Hardware-root of trust (if available)
- Supports kill switch
- Based in privacy-friendly jurisdiction

**Options:**
- Mullvad (privacy-focused, no accounts, pay with cash/crypto)
- ProtonVPN (good privacy policy, free tier available)
- IVPN (privacy-focused, audited)
- Self-hosted (WireGuard on your own VPS)

**Setup (Mullvad example):**

```bash
# Linux
# Download from: https://mullvad.net/download/
sudo apt install mullvad-vpn

# Configure
mullvad-gui
  → Settings → Auto-connect: On (for untrusted networks)
  → Kill switch: On
  → LAN sharing: Off

# macOS / Windows
# Download app from mullvad.net
# Enable auto-connect and kill switch
```

**Testing VPN:**

```bash
# Check your IP before VPN
curl ifconfig.me

# Enable VPN
mullvad connect

# Check IP after VPN (should be different)
curl ifconfig.me

# Check for leaks
# Visit: https://mullvad.net/en/check
# Or: https://ipleak.net/

# Verify no DNS leaks, WebRTC leaks, or IP leaks
```

**When to use VPN:**

✅ **Use VPN:**
- Public WiFi (cafes, hotels, airports)
- Untrusted networks (conference networks, friend's WiFi)
- When accessing sensitive accounts on untrusted network
- When working on confidential projects

❌ **VPN not needed:**
- Home network (you control it)
- Corporate network with proper security
- Mobile data (cellular networks are encrypted)

### Step 4.6: SIM Card Protection (Critical for Level 2-3)

SMS 2FA is vulnerable to SIM swap attacks. An attacker can social engineer your carrier to port your number to their SIM, then receive your 2FA codes.

**Real threat:** SIM swap attacks are increasing and often precede major account compromises.

**1. Enable SIM PIN lock:**

This requires a PIN to make any changes to the SIM card.

```
iOS:
Settings → Cellular → SIM PIN
  → Toggle on
  → Enter default PIN (usually 1234 or 0000, check carrier docs)
  → Change to your own 4-6 digit PIN
  → DO NOT use same PIN as device unlock
  → Store SIM PIN in password manager

Android:
Settings → Security → SIM card lock
  → Lock SIM card: On
  → Enter default PIN
  → Change SIM PIN → Enter new PIN
  → Store SIM PIN in password manager
```

**Warning:** If you enter wrong SIM PIN 3 times, SIM locks permanently and requires PUK code from carrier. Store your PUK code in password manager too.

**2. Set carrier account security:**

Call your mobile carrier and request:

```
"I want to add extra security to prevent SIM swap attacks. Please:

1. Add a verbal password/PIN to my account
   - Required for any number porting or SIM changes
   - Different from my account login password

2. Add a note to my account:
   'Customer requires in-person ID verification for number
   porting or SIM changes. Do not port number without physical
   ID presented in retail store.'

3. Enable all available 2FA on my carrier account
   - Preferably hardware key if supported
   - Otherwise authenticator app, NOT SMS

4. Disable online/phone-based number porting
   - Require in-person visit for any porting requests"
```

**3. Avoid SMS 2FA whenever possible:**

Priority order for 2FA methods:

```
1. Hardware key (FIDO2/WebAuthn) - BEST
   - Phishing resistant
   - Not vulnerable to SIM swap
   - Use this whenever offered

2. TOTP app (Google Authenticator, Authy, Bitwarden) - GOOD
   - Not vulnerable to SIM swap
   - Requires device access
   - Backup codes critical

3. SMS - ONLY IF NOTHING ELSE AVAILABLE
   - Vulnerable to SIM swap
   - Vulnerable to SS7 attacks
   - Use only when no other option
```

**4. Monitor for SIM swap attempts:**

Signs your SIM may have been swapped:

- Your phone suddenly has no cellular service (but WiFi works)
- You receive notifications about number porting you didn't request
- You receive 2FA codes you didn't request
- Carrier sends confirmation of changes you didn't make

**If you suspect SIM swap in progress:**

```
IMMEDIATE (within 5 minutes):
1. Call carrier from another phone or use carrier's online chat
2. Report unauthorized SIM swap
3. Lock your account
4. Do NOT hang up until confirmed your number is secured

WITHIN 30 MINUTES:
5. Change passwords for all accounts using backup method (hardware key, not SMS)
6. Check for unauthorized access (email, banking, social media)
7. Enable fraud alerts with credit bureaus

WITHIN 24 HOURS:
8. File police report (needed for fraud protection)
9. Review all account activity logs
10. Consider changing phone number if severely compromised
```

**5. Geographic separation applies here too:**

If traveling to high-risk locations or storing backup phone:
- Remove SIM or use different carrier for backup phone
- Backup SIM should have different phone number
- Prevents single SIM swap from compromising all recovery paths

---

## ⚠️ Critical: Avoiding Circular Dependencies

**Before proceeding to Phase 5, verify you haven't created circular dependencies.**

### The Circular Dependency Trap

A circular dependency occurs when you need A to access B, but need B to access A.

**Common example that WILL fail:**
```
- Recovery bundle stored in cloud
- Cloud account requires 2FA from phone
- Phone destroyed in house fire
- Cannot access recovery bundle without phone
- Cannot restore phone without recovery bundle
- LOCKED OUT FOREVER
```

**Real-world failure:**
Blog post "I've locked myself out of my digital life" describes exactly this scenario. Author's house fire destroyed laptop, phone, and hardware key. Cloud backups existed but were inaccessible without destroyed hardware key.

### Circular Dependency Checklist

Ask yourself these questions. If ANY answer is "No," you have a circular dependency that WILL cause total loss:

- [ ] **If my house burns down, can I still access my cloud backups?**
  - Yes = Backup hardware key stored OFF-SITE (different building)
  - No = Fix now: Store backup key at relative's house, office, or safe deposit box

- [ ] **If I lose all devices, can I decrypt my recovery bundle?**
  - Yes = Recovery bundle passphrase is MEMORIZED (not stored on device)
  - No = Fix now: Memorize the passphrase, test decryption from memory

- [ ] **If my primary hardware key is destroyed, can I still access critical accounts?**
  - Yes = Backup hardware key exists AND is registered with all critical accounts
  - No = Fix now: Register backup key with every account primary key protects

- [ ] **If my phone is stolen, can I access my email without my phone?**
  - Yes = Email uses hardware key 2FA (not SMS), and backup key is accessible
  - No = Fix now: Switch email 2FA to hardware keys, test with backup key

- [ ] **Do I have at least 2 completely independent recovery paths?**
  - Yes = Example: Cloud backup (accessible with memorized credentials) + Physical USB backup (at friend's house)
  - No = Fix now: Create secondary backup location

### How to Break Circular Dependencies

**1. Memorized credentials as root anchor:**
- At least ONE recovery path must depend only on memory
- Recovery bundle encryption passphrase (different from vault master password)
- Cloud storage credentials (if not using hardware key)
- No devices required = survives any physical loss

**2. Geographic separation:**
- NEVER store all recovery materials in one location
- Primary hardware key: On your person
- Backup hardware key: Different city/building
- Cannot both be destroyed in same incident

**3. Multiple independent paths:**
- Path 1: Cloud backup + memorized decryption passphrase
- Path 2: USB backup at friend's house
- Path 3: Emergency access via trusted contact (Bitwarden feature)
- If one path fails, others still work

**4. Different authentication factors:**
- Don't protect everything with the same factor
- Email: Hardware key
- Cloud storage: Different hardware key OR strong memorized password
- Recovery bundle: Separately memorized passphrase (not same as vault)
- Password manager: Biometric + master password + hardware key 2FA

### Example: Properly Non-Circular Setup

✅ **This setup survives total loss:**

```
Scenario: House fire destroys laptop, phone, primary hardware key

Recovery path still works:
1. Borrow friend's laptop
2. Access cloud storage:
   - Login with memorized credentials
   - 2FA with backup hardware key (stored at relative's house, survived fire)
3. Download encrypted recovery bundle
4. Decrypt with memorized passphrase (different from vault master password)
5. Access Bitwarden vault backup
6. Restore all credentials
7. Purchase new hardware keys
8. Register new keys with all accounts
9. Full recovery complete

Time to recovery: 1-2 days
Cost: New devices + new hardware keys
Result: ✅ SUCCESSFUL RECOVERY
```

❌ **This setup FAILS:**

```
Scenario: Same house fire

Attempted recovery path fails:
1. Borrow friend's laptop
2. Try to access cloud storage:
   - Login with memorized password ✅
   - 2FA requires hardware key ❌
   - Primary key destroyed in fire
   - Backup key was at home, also destroyed
3. Cannot access cloud storage
4. Recovery bundle is inaccessible
5. Locked out of everything

Result: ❌ TOTAL LOSS
```

**Fix the failing setup:**
Store backup hardware key at relative's house (different location than your home).

---

## Phase 5: Verification & Testing (1 hour)

### Step 5.1: Verification Checklist

Before considering your setup complete, verify each component:

**Password Manager:**
- [ ] Bitwarden account created with strong master password
- [ ] Browser extension installed and working
- [ ] Mobile app installed and working
- [ ] Biometric unlock configured and working
- [ ] All critical passwords migrated to Bitwarden
- [ ] Vault organized into folders (Critical, Important, Standard)

**Hardware Keys:**
- [ ] Two hardware keys purchased (Primary + Backup)
- [ ] Both keys registered with Bitwarden
- [ ] Both keys tested with Bitwarden login
- [ ] Both keys registered with primary email
- [ ] Both keys registered with cloud storage
- [ ] Backup codes generated and stored in vault
- [ ] Backup key stored off-site (not at home)

**Disk Encryption:**
- [ ] Laptop/desktop disk encryption enabled
- [ ] Encryption verified (fdesetup/manage-bde/cryptsetup status)
- [ ] Recovery key stored in password manager (not on paper)
- [ ] Phone/tablet encrypted (default on modern devices)

**Screen Locks:**
- [ ] Auto-lock configured on all devices (1-5 min)
- [ ] Biometric unlock working on all devices
- [ ] Manual lock tested (hotkey/gesture)
- [ ] Lock on sleep/lid close enabled

**Recovery Bundle:**
- [ ] Bitwarden vault exported
- [ ] Recovery info document created
- [ ] Backup codes documented
- [ ] Bundle encrypted with separate passphrase
- [ ] Encryption passphrase memorized (different from vault password)
- [ ] Encrypted bundle uploaded to cloud storage
- [ ] Upload verified (downloaded and decrypted successfully)
- [ ] Backup location(s) established (USB, second cloud, etc.)

**Device Hardening:**
- [ ] Remote wipe configured on all devices
- [ ] Remote wipe tested (locate feature, not actual wipe)
- [ ] Notification privacy configured
- [ ] Browser security settings configured
- [ ] Privacy screen filters acquired (if needed)
- [ ] USB port controls configured (if applicable)
- [ ] VPN installed and configured for public WiFi

### Step 5.2: Full Recovery Drill

Use spare device, pretend you lost everything:
1. Access cloud storage → download encrypted bundle (use backup hardware key for 2FA)
2. Decrypt bundle → `age --decrypt bundle.tar.gz.age`
3. Import vault to Bitwarden → login with master password + backup key
4. Verify critical account access

**Success:** Complete recovery in <30 minutes. If anything fails, fix and re-test.

### Step 5.3: Test Hardware Key Redundancy

Lock away primary key, use only backup key for 24 hours. Verify access to Bitwarden, email, cloud storage, banking. If backup key fails anywhere, register it on that service immediately.

### Step 5.4: Test Memorization of Passphrases

Test both passphrases from memory (master password and recovery bundle encryption). Must distinguish between them correctly. If you fail, practice daily for a week before proceeding.

### Step 5.5: Document Your Setup

Create `my_security_setup.txt` documenting: hardware key locations, accounts with keys registered, cloud storage details, backup locations, last recovery test date. Store only in encrypted recovery bundle, never in plaintext.

---

## Phase 6: Maintenance Schedule

**Regular:** Check login alerts daily. Update Bitwarden weekly. Fix weak passwords. Review active sessions monthly.

**Quarterly (critical):**
1. Re-export vault → create new recovery bundle → upload to cloud
2. Full recovery drill on spare device (<30 min target)
3. Test backup key access to all critical accounts
4. Verify memorization of both passphrases

**Triggered:**
- New device: Install Bitwarden, enable encryption/locks, test hardware key
- Suspicious activity: Change passwords, revoke sessions, rotate credentials
- Travel to high-risk areas: Remove sensitive data, disable biometrics, leave backup key behind
- After incident: Follow RECOVERY_PROCEDURES.md, rotate everything, update bundle

---

## Troubleshooting Common Issues

**Hardware key not recognized:** Try different USB port, verify key is registered with service, test on demo.yubico.com. For NFC: hold to back of phone for 2-3 seconds.

**Forgot master passphrase:** If device unlocked, export vault immediately and create new account. If locked, catastrophic - begin manual account recovery for each service. **Prevention is critical**: practice daily.

**Recovery bundle won't decrypt:** Verify you're using bundle encryption passphrase (not master password). Re-download from cloud. Try secondary backup location.

**Locked out of cloud storage:** Use backup hardware key or backup codes from Bitwarden. Otherwise use provider's account recovery (24-48 hours).

**Lost backup hardware key:** Verify primary still works, order replacement ($50), register with all services when it arrives. If stolen (not lost), revoke old key immediately.

**Biometric unlock stopped:** Re-enroll biometrics or use PIN/password backup. Biometrics are convenience only.

---

## Threat-Level-Specific Configurations

**Level 0-1 (Basic):** Password manager + one hardware key + disk encryption. 2-3 hours, $50.

**Level 2 (Recommended):** Full guide implementation. Two hardware keys, off-site backup, encrypted recovery bundle, quarterly drills. 4-6 hours, $100.

**Level 3 (Advanced):** Everything from Level 2 + privacy screens, always-on VPN, SIM PIN lock, third hardware key, separate identities across services, Google Advanced Protection. For journalists, activists, executives. 8-12 hours, $200-500.

**Level 4 (Physical):** Digital security insufficient. Requires professional security consultation, physical security measures, legal preparation, K&R insurance. $5,000+.

---

## Next Steps

**Read:** [RECOVERY_PROCEDURES.md](RECOVERY_PROCEDURES.md) for incident response procedures.

**Test:** Run full recovery drill quarterly. Re-read [THREAT_SCENARIOS.md](THREAT_SCENARIOS.md) annually.

**Contribute:** Share improvements via GitHub. Help others implement security.

---

**You've completed the implementation. You're now resilient to Scenario 2.2 (total loss). Practice your recovery procedures regularly, and you'll never lose your digital identity.**

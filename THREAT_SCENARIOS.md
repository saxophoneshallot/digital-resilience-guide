# Digital Identity Resilience: Threat Scenarios

## Purpose

This document models security scenarios from routine operations through catastrophic compromise, establishing security controls and recovery procedures for each threat level.

**Core Question:** For each scenario, what are the:
- **Attack vectors** available to the adversary?
- **Assets at risk** (credentials, devices, recovery materials)?
- **Security controls** that should prevent compromise?
- **Detection mechanisms** that alert you to breach?
- **Recovery procedures** if compromise occurs?
- **Acceptable losses** we must tolerate?

---

## Scenario Classification

| Level   | Category                   | Example                             | Time to Recover            |
| ------- | ----------                 | ---------                           | -----------------          |
| 0       | Normal Operations          | Daily usage, no incidents           | N/A                        |
| 1       | Opportunistic Access       | Unattended device, pickpocket       | Minutes to hours           |
| 2       | Targeted Theft             | Burglary, mugging with surveillance | Hours to days              |
| 3       | Sophisticated Attack       | Surveillance + social engineering   | Days to weeks              |
| 4       | Extreme Coercion           | Kidnapping, detention, torture      | Weeks + legal intervention |
| 5       | Advanced Persistent Threat | Nation-state targeting              | May be unrecoverable       |

---

## Level 0: Normal Operations (Happy Paths)

### Scenario 0.1: Working on Laptop in Safe Environment

**Context:**
- You're at home or in a private office
- Laptop is encrypted, auto-locks after 5 minutes
- Hardware security key is nearby (or plugged in)
- Phone is within reach
- No adversaries present

**Security Posture:**
- ✅ Full access to password manager via biometric unlock
- ✅ 2FA available via hardware key or authenticator app
- ✅ Encrypted disk protects data at rest
- ✅ Screen lock protects data when briefly away

**What You Can Do:**
- Access all accounts and services
- Perform sensitive operations (banking, email)
- Update passwords, add new credentials
- Export vault backups

**Threats (minimal):**
- Shoulder surfing (low risk in private space)
- Malware on system (mitigated by OS security, AV)
- Network eavesdropping (use HTTPS, VPN if needed)

**Security Controls:**
- Screen privacy filter (if working in semi-public)
- Automatic screen lock (5 min idle)
- Disk encryption (LUKS/FileVault/BitLocker)
- Biometric unlock for password manager
- Hardware key for critical accounts

**If Something Goes Wrong:**
- Malware detected → Disconnect network, scan, restore from backup
- Suspicious login alerts → Change passwords immediately
- Hardware key lost → Use backup key, revoke compromised key

---

### Scenario 0.2: Using Phone in Public (Unsafe Environment)

**Context:**
- You're on a train, in a café, or walking on a busy street
- Phone has biometric lock (fingerprint/face)
- You need to check email or 2FA code
- Physical theft is a realistic threat
- Shoulder surfing is easy

**Security Posture:**
- ⚠️ Physical device more vulnerable than laptop
- ✅ Biometric unlock prevents casual access if stolen
- ⚠️ Screen visible to others nearby
- ✅ SIM lock prevents unauthorized calls/texts
- ⚠️ If phone is unlocked when grabbed, attacker has immediate access

**What You Can Do:**
- Quick account checks (email, messages)
- 2FA authentication for laptop logins
- Emergency access to critical accounts
- View (but not export) password vault

**Threats (moderate):**
- Pickpocketing / snatch theft
- Shoulder surfing of PIN or passwords
- Man-in-the-middle on public WiFi
- Malicious apps (if sideloaded)

**Security Controls:**
- **Never unlock phone while device is physically insecure** (e.g., standing on street)
- Privacy screen protector
- VPN for public WiFi
- Biometric unlock only (no PIN fallback in public)
- Password manager auto-lock after 1 minute
- Find My Device enabled for remote wipe
- Minimal notification previews on lock screen

**If Something Goes Wrong:**
- **Phone stolen while locked:**
  1. Use another device to trigger remote wipe (Find My Device)
  2. Disable SIM card with carrier
  3. Revoke device from password manager sessions
  4. Review account access logs for suspicious activity
  5. Rotate 2FA to new device

- **Phone stolen while unlocked:**
  1. Same as above, but assume attacker saw open apps
  2. Immediately change passwords for any accounts that were open
  3. Check for unauthorized transactions/emails sent
  4. Freeze financial accounts if banking app was open

---

## Level 1: Opportunistic Access

### Scenario 1.1: Unattended Laptop (Bathroom Break)

**Context:**
- You step away from laptop for 2-5 minutes
- You're in a semi-trusted space (office, library, coffee shop)
- Laptop is unlocked or locked but still on
- Adversary is a casual opportunist, not targeted

**Attack Vectors:**
- **If unlocked:** Direct access to all open sessions
- **If locked:** May attempt to guess password, insert USB, or steal device
- Quick data exfiltration (copy files, screenshot passwords)
- Install malware or keylogger
- Physical theft

**Security Controls (Preventative):**
- **Always lock screen before leaving** (Ctrl+Alt+L / Cmd+Ctrl+Q)
- Auto-lock after 1 minute idle (aggressive setting for public spaces)
- BIOS password prevents booting from USB
- Encrypted disk prevents data access if powered off
- USB port controls (disable unauthorized devices)
- Webcam cover or disable when not in use

**Detection:**
- Check `last` command to see login times
- Review bash/zsh history for unfamiliar commands
- Check browser history for unauthorized access
- Review password manager access logs
- Physical evidence (moved mouse, different window focus)

**Response:**
- **If you return to find laptop unlocked when you locked it:**
  1. Disconnect from network immediately
  2. Take photos of screen state as evidence
  3. Check running processes (`ps aux`, Task Manager)
  4. Review recent file access times
  5. Change passwords from a different, trusted device
  6. Scan for malware
  7. Consider full system reinstall if high-value target

- **If laptop is missing:**
  1. Remote wipe if possible (requires prior setup)
  2. Change all passwords from another device
  3. Revoke all active sessions
  4. Report theft to authorities (for insurance/tracking)
  5. Review account logs for unauthorized access

**Acceptable Losses:**
- Any data visible on screen at time of leaving
- Possibly: session cookies for open websites (if attacker acts quickly)
- **Not acceptable:** Password manager master password, hardware keys, credential theft

---

### Scenario 1.2: Phone Snatched from Hand

**Context:**
- You're using phone while walking or standing
- Attacker grabs phone and runs
- Phone may be unlocked at moment of theft
- You have 30-60 seconds before they're out of sight

**Attack Vectors:**
- If unlocked: immediate access to all apps currently open
- If locked: biometric data is safe (stored in secure enclave)
- SIM swap attack if they extract SIM quickly
- Social engineering (calling/texting your contacts)

**Time-Sensitive Actions (First 5 Minutes):**
1. Use nearby device or ask someone to borrow phone
2. Log into Find My Device / Find My iPhone
3. Trigger remote lock (if unlocked) or wipe
4. Call carrier to disable SIM card (prevents SMS 2FA bypass)

**Within 1 Hour:**
1. Change passwords for critical accounts (email, banking, password manager)
2. Revoke phone from authenticated devices
3. Check for unauthorized transactions
4. Enable login alerts on all accounts

**Security Controls (Preventative):**
- **Never use phone while walking in high-risk areas**
- Password manager auto-locks aggressively (30 seconds)
- Banking apps require biometric re-auth for each session
- No sensitive notifications on lock screen
- Remote wipe pre-configured
- Backup 2FA methods (hardware key, backup codes)

**Acceptable Losses:**
- Contents of apps that were open at moment of theft
- SMS messages sent in first few minutes
- Possibly: 2FA codes for non-critical accounts
- **Not acceptable:** Full account takeover, financial theft

---

## Level 2: Targeted Theft

### Scenario 2.1: Home Burglary (All Physical Devices Stolen)

**Context:**
- You're away for the day/weekend
- Thieves break in and take:
  - Laptop
  - Tablet
  - Backup phone
  - USB drives
  - Physical documents (possibly including printed recovery codes)
  - Hardware security keys (if found)
- You return to discover theft 6-24 hours later
- You have: clothes on your back, wallet, primary phone (was with you), some cash

**Attack Vectors:**
- Offline attacks on encrypted devices (if weak password)
- Recovery codes if stored physically at home
- Backup hardware keys
- USB drives with unencrypted vault exports
- Documents with account numbers, security questions

**Immediate Response (First Hour):**
1. Call police (for insurance, evidence)
2. Use phone to:
   - Change master passwords (email, password manager)
   - Revoke all stolen devices from accounts
   - Remote wipe stolen devices
   - Check for unauthorized access
3. Disable stolen hardware keys:
   - Log into accounts and remove YubiKey registrations
   - Add new hardware key if you have backup stored elsewhere

**Within 24 Hours:**
1. Assess what recovery materials were stolen:
   - Were printed recovery codes at home?
   - Were backup hardware keys taken?
   - Were USB backups encrypted?
2. Rotate all credentials if recovery materials compromised
3. Order replacement hardware keys
4. Re-establish backup storage locations

**Security Controls (Preventative):**
- **Critical:** Recovery bundle stored OFF-SITE
  - Cloud storage (encrypted)
  - Safe deposit box
  - Trusted friend/family member's house
- Encrypted backups (never plaintext USB drives)
- Backup hardware key stored separately from primary (not at home)
- Disk encryption on all devices (defeats offline attacks)
- No printed recovery codes, or stored in safe/separate location

**Recovery Path:**
1. You still have phone → access password manager → retrieve all credentials
2. Retrieve encrypted recovery bundle from cloud
3. Restore vault on new devices
4. Replace hardware keys
5. Re-enable biometrics on new devices

**Acceptable Losses:**
- Hardware costs (devices)
- Time to replace and reconfigure
- Possible exposure of old documents/data on stolen devices (if encryption broken)
- **Not acceptable:** Loss of access to accounts, compromise of current credentials

**Why You Survive This:**
- ✅ Phone was with you (still have access)
- ✅ Recovery bundle is off-site
- ✅ Disk encryption protects stolen devices
- ✅ Backup hardware key exists elsewhere

---

### Scenario 2.2: Mugging (Phone, Wallet, Laptop Stolen)

**Context:**
- You're robbed on the street
- Attacker takes:
  - Phone (may force you to unlock it)
  - Wallet (ID, credit cards)
  - Laptop bag (laptop, chargers, possibly hardware key)
- You're left with: clothes, some cash if hidden, your memory
- No access to any devices
- Potentially injured, stressed, in shock

**Attack Vectors:**
- **If forced to unlock phone:** Immediate access to all unlocked apps
- Attacker may watch you unlock (sees PIN/pattern)
- Can transfer money, make purchases before you can respond
- Identity theft using stolen ID + device access

**Immediate Response (First 30 Minutes):**
You have no devices. You must:
1. **Get to safety** (police station, hospital, friend's house)
2. **Borrow a device** to:
   - Remote wipe your phone
   - Freeze bank accounts (call bank fraud line)
   - Disable credit cards
3. Report theft to police (needed for identity theft protection)

**Within 24 Hours:**
1. Retrieve encrypted recovery bundle from cloud (use library/friend's computer)
2. Decrypt bundle with memorized passphrase
3. Access Bitwarden vault
4. Change critical passwords (email, banking, any account with payment info)
5. Order replacement ID, credit cards, hardware keys
6. Set up fraud alerts with credit bureaus

**Security Controls (Preventative):**
- **Critical:** Memorized high-entropy passphrase (your only anchor now)
- Recovery bundle in cloud (accessible without any device)
- Banking apps with aggressive auto-lock
- Transaction limits on financial accounts
- No auto-save of passwords in browsers (only in vault)

**Why This Is Harder Than Burglary:**
- ⚠️ No devices at all (vs burglary where phone was with you)
- ⚠️ Potential coercion to unlock device
- ⚠️ Identity theft risk from stolen ID
- ⚠️ Immediate financial risk (vs delayed discovery)

**Recovery Path:**
1. Borrow device or use public computer
2. Access cloud storage with memorized credentials
3. Download encrypted recovery bundle
4. Decrypt with memorized passphrase
5. Access Bitwarden, get all account credentials
6. Change passwords, revoke devices
7. Purchase new phone, restore access

**Acceptable Losses:**
- Money in wallet
- Time and stress of recovery
- Possible fraudulent charges (chargeback/insurance)
- **Not acceptable:** Permanent loss of identity access, unrecoverable fraud

**Why You Survive This:**
- ✅ Recovery bundle accessible from any device
- ✅ Memorized passphrase is your root credential
- ✅ No dependency on physical possessions
- ✅ Cloud backup survives physical theft

---

## Level 3: Sophisticated Attack

### Scenario 3.1: Surveillance + Social Engineering

**Context:**
- Adversary has observed your patterns for days/weeks
- They know:
  - Your common locations (home, work, gym)
  - Your device usage patterns
  - Your contacts and relationships
- Attack combines:
  - Physical theft at optimal moment
  - Social engineering of your contacts
  - Possible malware pre-installed (compromised USB, evil maid)
  - Knowledge of your backup strategies

**Attack Vectors:**
- Shoulder surfing to capture passwords/PINs
- Timing theft when devices are unlocked
- Calling your contacts pretending to be you (or authorities)
- SIM swap attack (calling carrier with social engineering)
- Compromised recovery email before primary attack
- Targeting your backup locations (cloud account, trusted contact)

**Example Attack Chain:**
1. **Week 1:** Attacker shoulder-surfs your email password at café
2. **Week 2:** Uses email to reset your cloud storage password, accesses recovery bundle (if not separately encrypted)
3. **Week 3:** SIM swap attack to receive 2FA codes
4. **Week 4:** Steals phone when unlocked, already has email access

**Security Controls (Preventative):**
- **Defense in depth:** Multiple independent factors
  1. Email has hardware key 2FA (can't be bypassed by SIM swap)
  2. Cloud storage has separate password + 2FA
  3. Recovery bundle has its own encryption passphrase (not same as vault master password)
  4. SIM has PIN lock (prevents easy swap)
  5. Contacts are educated not to reset passwords via phone call
- Privacy screen protectors (defeats shoulder surfing)
- Vary your patterns (don't always sit in same café spot)
- Monitor login alerts religiously

**Detection:**
- Login alerts from unfamiliar locations
- 2FA codes received when you didn't request them
- Carrier notifications of SIM changes
- Cloud storage access from unknown IPs
- Contacts reporting weird messages from you

**Response to Compromise:**
If you detect signs of surveillance or targeted attack:
1. **Assume all current credentials are compromised**
2. Use a completely fresh device (new laptop, factory reset phone)
3. Rotate ALL credentials from fresh device
4. Create new email address for critical account recovery
5. New cloud storage account for recovery bundle
6. New encryption passphrase for bundle
7. Consider legal/law enforcement involvement

**Acceptable Losses:**
- Existing email address (create new one)
- Some account history/data
- Time and cost of complete rotation
- **Not acceptable:** Loss of identity, financial theft, ongoing access

**Why This Is Dangerous:**
- Defeats single-layer security
- Exploits trust relationships
- Combines multiple attack vectors
- May compromise backup systems

**Why You Can Still Survive:**
- ✅ Hardware keys prevent SIM swap bypass
- ✅ Separately encrypted recovery bundle
- ✅ Memorized passphrase not observable
- ✅ Can detect and respond before complete compromise

---

## Level 4: Extreme Coercion

### Scenario 4.1: Kidnapping / Detention with Intent to Extract Access

**Context:**
- You're physically detained by adversaries
- They demand you unlock devices and accounts
- Potential for:
  - Physical coercion or torture
  - Drug-induced compliance
  - Extended captivity (hours to days)
- Adversary goals:
  - Financial theft (crypto, bank transfers)
  - Data exfiltration (corporate espionage)
  - Identity takeover
  - Ransomware against your contacts

**Critical Reality:**
**No digital security system can protect against this. Physical safety takes absolute priority.**

**Principles for This Scenario:**
1. **Comply to preserve your life** - no data is worth dying for
2. **Limit damage** - give access to low-value accounts first
3. **Trigger alerts** - if possible, use duress signals
4. **Delay** - slow down the process to allow rescue/detection
5. **Legal recourse** - focus on surviving, recovering, and prosecution

**Duress Mechanisms (Setup in Advance):**
- **Duress PIN:** Some password managers (not Bitwarden currently) support a duress password that opens a fake vault with plausible but fake accounts
- **Duress hardware key:** A third hardware key that, when used, triggers silent alerts to trusted contacts
- **Dead man's switch:** If you don't check in within 48 hours, automated alerts go out
- **Geofencing alerts:** Notify contacts if your phone travels outside normal areas

**Practical Duress Setup:**
Since Bitwarden doesn't support duress passwords, you'd need to:
1. Maintain a separate "decoy vault" with real-looking but low-value accounts
2. Have a second "duress" passphrase that opens this decoy
3. This requires a custom script/wrapper - not native Bitwarden

**Financial Damage Limitation:**
- Daily transfer limits on all accounts (can't be overridden without calling bank)
- Multi-signature wallets for crypto (requires multiple keys/people)
- Delayed withdrawal systems (24-48 hour hold on large transfers)
- Account monitoring by trusted contact (alerts if unusual activity)

**Response After Release:**
1. **Immediate medical care** (toxicology screen if drugged)
2. **Law enforcement report** (kidnapping, extortion)
3. **Complete credential rotation** from a trusted, secure device
4. **Forensic analysis** of what was accessed
5. **Credit freeze and fraud alerts**
6. **Account recovery** (dispute fraudulent transactions)
7. **Psychological support** (trauma counseling)

**Acceptable Losses:**
- Money transferred under duress (may be recoverable)
- Exposure of accounts and data
- Compromised devices and credentials
- **Not acceptable:** Your life, permanent physical harm

**Why Traditional Security Fails Here:**
- No amount of encryption helps if you're forced to decrypt
- Biometrics become a liability (can't "forget" your fingerprint)
- Hardware keys can be used while you're detained
- Memorized passwords will be extracted

**Legal and Physical Safeguards:**
- **Prevention:** High-risk individuals need physical security (bodyguards, secure transport)
- **Insurance:** Kidnap & ransom insurance for high-net-worth individuals
- **Monitoring:** Regular check-ins with trusted contacts
- **Legal preparation:** Pre-drafted affidavits for courts to freeze accounts
- **Network:** Trusted contacts who can act on your behalf

**Philosophical Boundary:**
This scenario represents the **limit of personal digital resilience**. Beyond this point, you need:
- Physical security measures
- Legal frameworks
- Trusted human networks
- Institutional support (law enforcement, banks, courts)

---

## Level 5: Advanced Persistent Threat (APT)

### Scenario 5.1: Nation-State Targeting

**This is beyond the scope of this guide.**

**Who this affects:**
- Journalists covering sensitive topics
- Political dissidents and activists
- Government employees with classified access
- Security researchers and tool developers
- Anyone caught in mass surveillance

**Why technical security fails:**
- **Zero-day exploits:** Unknown vulnerabilities you can't patch
- **Supply chain compromise:** Hardware backdoored before purchase
- **Legal compulsion:** Providers forced to cooperate via gag orders
- **Unlimited resources:** Nation-states spend $millions on targets
- **Physical access:** Professional teams bypass any security
- **Time:** Can wait years for the right opportunity

**What you need instead:**

**Legal & Organizational:**
- Constitutional/national security lawyers
- EFF (eff.org), ACLU, Amnesty International
- Reporters Without Borders, Committee to Protect Journalists
- Access Now Digital Security Helpline (accessnow.org/help)

**Operational Security:**
- Compartmentalization (separate identities, devices, locations)
- Air-gapped systems, dead drops, one-time pads
- Hardware from diverse supply chains
- Geographic mobility
- Trusted networks established before targeting

**Political Protection:**
- Public scrutiny and media attention
- International pressure and allies
- Legal frameworks and constitutional protections
- Sometimes: relocation, asylum, exile

**Key insight:** At Level 5, security is political and legal, not technical. The only real defenses are rights, oversight, accountability, and institutional support. If you believe you're targeted by a nation-state, seek professional help immediately.

**This guide focuses on Levels 0-4 where technical security can actually help.**

---

## Scenario Summary Matrix

| Scenario                   | Assets at Risk           | Critical Controls               | Recovery Time      | Survivability   |
| ----------                 | ----------------         | -------------------             | ---------------    | --------------- |
| 0.1: Laptop at home        | Session data             | Screen lock, disk encryption    | N/A                | 100%            |
| 0.2: Phone in public       | Device, visible data     | Biometric lock, remote wipe     | Hours              | 100%            |
| 1.1: Unattended laptop     | Session + device         | Auto-lock, BIOS password        | Hours              | 99%             |
| 1.2: Phone snatched        | Device + open apps       | Remote wipe, backup 2FA         | Hours-Days         | 95%             |
| 2.1: Home burglary         | All home devices         | Off-site backups, encryption    | Days               | 90%             |
| 2.2: Mugging               | All carried devices + ID | Cloud backup, memorized secret  | Days-Weeks         | 85%             |
| 3.1: Targeted surveillance | All devices + backups    | Defense in depth, hardware keys | Weeks              | 70%             |
| 4.1: Kidnapping/coercion   | Everything               | Legal/physical security         | Weeks-Months       | Variable\*       |
| 5.1: Nation-state/APT      | Everything + metadata    | Professional help required      | Unrecoverable      | <10%\*\*          |

\* Survivability depends on physical safety measures, not digital security
\*\* Technical security insufficient; requires legal, political, and organizational defenses

---

---

## Special Considerations

### SIM Swap Attacks (Scenario 3 Precursor)

**What is a SIM swap attack:**
- Attacker social engineers your mobile carrier
- Convinces carrier to port your number to attacker's SIM card
- Attacker now receives your SMS messages and calls
- Can bypass SMS-based 2FA
- Often precursor to larger attack (account takeover, financial fraud)

**How it works:**
```
1. Attacker researches you (social media, data breaches)
2. Calls your carrier pretending to be you
3. Claims they "lost their phone" and need new SIM
4. Provides stolen personal info to verify identity
5. Carrier ports your number to attacker's SIM
6. Your phone loses service
7. Attacker receives your SMS 2FA codes
```

**Prevention:**
- **SIM PIN lock:** Requires PIN to make any SIM changes
- **Carrier account PIN:** Verbal password required for account changes
- **In-person verification:** Require physical ID to port number
- **Avoid SMS 2FA:** Use hardware keys or TOTP apps instead
- **Monitor for suspicious activity:** Sudden loss of service is red flag

**Detection:**
- Your phone suddenly has no service (but WiFi works)
- You receive messages about number porting you didn't request
- You receive 2FA codes you didn't request

**Response (if you detect in progress):**
1. Call carrier from another phone IMMEDIATELY
2. Report unauthorized SIM swap
3. Lock your SIM/account
4. Change passwords for all accounts (before attacker can)
5. Review account activity for unauthorized access
6. File police report (for fraud protection)

**Response (if already completed):**
1. Same as above, plus:
2. Assume all SMS 2FA was compromised
3. Rotate credentials for any account using SMS 2FA
4. Check for unauthorized transactions
5. Enable fraud alerts with credit bureaus

**Why this matters:**
SIM swap is often **Step 1** of Scenario 3.1 (sophisticated attack). Attacker gets SMS 2FA access, then targets accounts one by one. Hardware keys prevent this attack vector entirely.

---

### High-Value Digital Assets (Cryptocurrency)

**Special threat model for cryptocurrency and irreversible digital assets:**

If you hold significant cryptocurrency or other high-value digital-only assets, standard password manager recovery may be insufficient.

**The problem:**
- Cryptocurrency transactions are irreversible
- No central authority to reverse fraudulent transfers
- "Not your keys, not your coins"
- Single point of failure = total loss

**Real-world example: QuadrigaCX**
- CEO Gerald Cotten died suddenly in 2018
- He was sole holder of cold wallet private keys
- $190 million in customer cryptocurrency became inaccessible
- Despite forensic experts, funds were never recovered
- Encrypted keys, no recovery method

**Additional security requirements:**

**1. Multi-signature wallets (2-of-3 or 3-of-5)**
```
- Requires multiple keys to authorize transaction
- Example: 2-of-3 means any 2 of 3 keys can sign
- You hold 2 keys in separate locations
- Trusted contact holds 1 key (as recovery backup)
- No single point of failure
```

**2. Geographic distribution of keys**
```
- Key 1: Hardware wallet at home (primary use)
- Key 2: Hardware wallet in safe deposit box (backup)
- Key 3: Paper wallet with trusted family member (emergency recovery)
- Never store all keys in one location
```

**3. Time-locked recovery**
```
- Smart contract or service that allows recovery after inactivity
- If you don't check in for 6-12 months, trusted contact can recover
- Protects against death or incapacity
- Prevents immediate theft (attacker must wait through time lock)
```

**4. Shamir's Secret Sharing**
```
- Split private key into N shares
- Require M shares to reconstruct (M-of-N threshold)
- Example: 3-of-5 shares
  - You keep 2 shares
  - 3 trusted contacts each get 1 share
  - Any 3 shares can recover the key
- No single person can access, but group can recover if you're lost
```

**5. Dead man's switch**
```
- Service that monitors for your activity
- If no check-in after X months, sends instructions to beneficiaries
- Can include partial key material or recovery instructions
- Used for estate planning
```

**Integration with this guide:**
- Store cryptocurrency wallet recovery seeds in encrypted recovery bundle
- Use hardware keys for exchange accounts (Coinbase, etc.)
- Document multi-sig setup in recovery instructions
- Test recovery procedures (with small amounts first)

**⚠️ Warning:**
Cryptocurrency security is complex and beyond full scope of this guide. If you hold significant crypto assets, consult specialized resources:
- Hardware wallet documentation (Ledger, Trezor)
- Multi-signature wallet guides (Electrum, Bitcoin Core)
- Cryptocurrency estate planning services

**Key principle:** For irreversible assets, redundancy is critical. Better to have complex recovery (multi-sig) than simple theft (single key).

---

### The Circular Dependency Trap

**A common failure mode that defeats otherwise good security:**

**The trap:**
```
1. You store encrypted backups in cloud storage
2. Cloud storage requires 2FA
3. 2FA requires your phone or hardware key
4. Phone and hardware key destroyed in same incident
5. Result: Locked out of cloud storage
6. Your backups are inaccessible
7. Total loss despite having backups
```

**Real-world example:**
- Blog post: "I've locked myself out of my digital life"
- Author's house fire destroyed: laptop, phone, home server, YubiKey
- Cloud backups existed but required 2FA from destroyed hardware key
- Circular dependency: needed device to access backup needed to restore device

**Other circular dependencies to avoid:**

**Circular Dependency 1: Email Recovery**
```
Bad:
- Primary email recovery → Secondary email
- Secondary email recovery → Primary email
- Both emails compromised = both lost forever

Good:
- Primary email recovery → Hardware key + backup codes
- Backup codes stored in password manager
- Password manager accessible via memorized passphrase
```

**Circular Dependency 2: Password Manager 2FA**
```
Bad:
- Password manager protected by hardware key
- Only one hardware key
- Hardware key lost = locked out of password manager
- Password manager contains all other credentials
- Total loss

Good:
- Password manager protected by hardware key
- TWO hardware keys (primary + backup)
- Backup key stored off-site
- Recovery codes in encrypted recovery bundle
- Multiple paths to recovery
```

**Circular Dependency 3: Cloud Storage Authentication**
```
Bad:
- Recovery bundle stored in cloud
- Cloud requires 2FA from phone
- Phone destroyed along with laptop
- Cannot access recovery bundle without phone
- Cannot recover phone without recovery bundle

Good:
- Recovery bundle stored in cloud
- Cloud protected by hardware key (not phone-based 2FA)
- Backup hardware key stored off-site (survives same incident)
- Can access cloud from any device with backup key
- Breaks the circle
```

**How to break circular dependencies:**

**1. Memorized credentials (your root anchor)**
- At least ONE recovery path must depend only on memory
- Example: Recovery bundle encryption passphrase
- No devices required, survives any physical loss

**2. Geographic separation**
- Never store all recovery materials in one location
- Backup hardware key in different building/city
- Cannot be destroyed in same incident as primary

**3. Multiple independent paths**
- Cloud backup (accessible with memorized credentials)
- Physical backup (USB at friend's house)
- Trusted contact (can help you recover)
- At least 2-3 independent recovery paths

**4. Different authentication factors**
- Don't protect everything with the same factor
- Email: Hardware key
- Cloud storage: Different hardware key OR memorized password
- Recovery bundle: Separately memorized passphrase

**Circular Dependency Checklist:**

Ask yourself:
- [ ] If my house burns down, can I still access my cloud backups? (Yes = hardware key stored off-site)
- [ ] If I lose all devices, can I decrypt my recovery bundle? (Yes = memorized passphrase)
- [ ] If my primary hardware key is destroyed, can I still access critical accounts? (Yes = backup key exists)
- [ ] If my phone is stolen, can I access my email without my phone? (Yes = hardware key 2FA, not SMS)
- [ ] Do I have at least 2 completely independent recovery paths? (Yes = cloud + physical backup)

If any answer is "No," you have a circular dependency. Fix it before disaster strikes.

---

## Next Steps

Now that we have the threat model, we need to design security controls that:

1. **Prevent** each scenario where possible
2. **Detect** when compromise occurs
3. **Respond** effectively to minimize damage
4. **Recover** to full operational capability

The next document should map specific technical implementations to these scenarios.

**Critical insights to carry forward:**
- Avoid circular dependencies (multiple independent recovery paths)
- Geographic separation prevents single-event total loss
- High-value assets need specialized protection (multi-sig)
- SIM swap attacks are real and preventable
- Testing is the only way to verify recovery works
- **This guide addresses Levels 0-4:** Technical security can help
- **Level 5 (APT) is beyond scope:** Requires professional organizational support

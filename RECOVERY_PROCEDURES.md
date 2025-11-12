# Recovery Procedures: Digital Identity Resilience

**Emergency response checklists for catastrophic digital loss**

---

## Purpose

This document provides step-by-step recovery procedures for each threat scenario from THREAT_SCENARIOS.md.

**When to use this:**
- Your phone was just stolen
- You were robbed and lost everything
- You detect unauthorized access to accounts
- You need to recover from total device loss

**Keep a copy:**
- In your encrypted recovery bundle
- Printed in safe deposit box
- Memorize the URL

---

## Device Stolen (Phone/Laptop)

**Time-critical: First 30 minutes matter**

**Immediate (0-5 min):**
1. Borrow device → go to Find My (icloud.com/find or android.com/find)
2. Remote wipe immediately (especially if unlocked when stolen)
3. Call carrier → disable SIM (prevents SMS 2FA bypass)

**Within 30 min:**
4. Change passwords: password manager, email, banking, any open apps
5. Revoke stolen device from all account sessions
6. Check for unauthorized activity (email, banking, social media)

**If device was unlocked:** Assume attacker saw open apps. Freeze bank accounts if banking was open. Check email for forwarding rules. Rotate any visible passwords immediately.

**Within 24 hours:**
7. File police report (insurance/fraud protection)
8. Enable credit fraud alerts (all 3 bureaus, free 90-day alert)
9. Order replacement device
10. Re-register 2FA on new device
- [ ] Sessions revoked
- [ ] No unauthorized activity detected
- [ ] Police report filed
- [ ] Fraud alerts enabled
- [ ] Replacement phone ordered

---

## Total Loss (Burglary/Mugging - All Devices Lost)

**Context:** Lost all devices (burglary or mugging). You have only your memory.

**Immediate (0-30 min):**
1. Get to safety. Call police if mugged.
2. Borrow device (friend, library, buy prepaid phone)
3. Call bank/carrier fraud lines → freeze accounts, disable SIM
4. Remote wipe devices if possible (Find My Device/iPhone)

**Within 1-2 hours - Recovery from Bundle:**

**Critical step:** Access your encrypted recovery bundle using only memory.

```
1. Access cloud storage (remember: email, password, location of backup hardware key)
2. Download encrypted bundle
3. Decrypt: `age --decrypt bundle.tar.gz.age` (enter memorized passphrase)
4. Extract: `tar -xzf bundle.tar.gz`
5. Import vault to Bitwarden
6. Access all passwords
```

**If backup hardware key not immediately available:** Call trusted contact who has it, or use backup codes from bundle.

**Next steps:**
- Change critical passwords (email, banking)
- File police report
- Insurance claims
- Order replacement devices and hardware keys
- Revoke stolen hardware keys from services
- Enable fraud alerts (credit bureaus)

**Success criteria:** Full recovery in <2 hours using only memory + borrowed device.
---

## Detected Unauthorized Access

**Signs:** Login alerts from unfamiliar locations, 2FA codes you didn't request, password changes, suspicious transactions, new connected devices.

**Severity Assessment:**

**Level 1 (Single account):** Change password, enable hardware key 2FA, revoke sessions, review activity.

**Level 2 (Multiple accounts):** Change email password FIRST (attacker may use it for resets). Check for forwarding rules, filters, connected apps. Change all compromised account passwords.

**Level 3 (Email compromised):** Critical - email controls everything. Change password from trusted device, enable hardware key 2FA, revoke all sessions, check for forwarding/filters/OAuth apps. Rotate passwords for all email-linked accounts.

**Level 4 (Password manager compromised):** Catastrophic. Change master password, revoke all sessions, rotate ALL passwords, create new recovery bundle with new encryption passphrase. Consider entire credential set compromised.

**Post-incident:**
- Enable fraud alerts
- Review account activity logs for 30 days
- Document what happened
- Update threat model

## SIM Swap Attack

**Sign:** Phone suddenly has no service, but WiFi works.

**Immediate (0-5 min):**
1. Call carrier from another device: "SIM swap attack - lock account now"
2. Verify your SIM is active (not attacker's), change account PIN, require in-person ID for changes
3. Change passwords NOW for any account with SMS 2FA (email, banking, password manager) - use hardware keys

**Race against time:** Attacker is trying to reset passwords using SMS codes.

**Within 30 min:**
4. Check for unauthorized access (email resets, bank transactions, account takeovers)
5. Rotate all SMS 2FA accounts → switch to hardware keys or TOTP
6. Enable fraud alerts (credit bureaus, banks)
7. File police report (IC3.gov, identitytheft.gov)

**Within 24 hours:**
8. Full security audit - review all account logins, changes, new devices
9. Consider changing phone number permanently
10. Never use SMS 2FA again

---

## Post-Recovery

**Within 1 week:** Document what happened, update recovery procedures, create fresh bundle, verify backups.

**Within 1 month:** Full security audit, strengthen weak points, update threat model, review insurance.

**Ongoing:** Maintain recovery bundle (quarterly), test procedures (quarterly), monitor activity (daily).

---

## Final Notes

**Remember:**
- Speed matters in emergencies
- Having a plan reduces panic
- Testing prevents surprises
- Recovery is possible if you prepare

**You prepared for this. You can recover.**

This document is your lifeline when disaster strikes. Keep it accessible, keep it updated, and practice using it.

The time to prepare for emergencies is before they happen.

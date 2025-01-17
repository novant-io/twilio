# Twilio API for Fantom

Native [Fantom](https://fantom.org) API for [Twilio](https://www.twilio.com).

Usage:

```fantom
tw := Twilio(accountId, authToken)
tw.verify(sid, to)
...
tw.verifyCheck(sid, to, code)
```
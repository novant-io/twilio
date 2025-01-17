//
// Copyright (c) 2025, Novant LLC
// Licensed under the MIT License
//
// History:
//   16 Jan 2025  Andy Frank  Creation
//

using util
using web

*************************************************************************
** Twilio
*************************************************************************

** Twilio client.
const class Twilio
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  ** Create a new Twilio API client using given credentials.
  new make(Str accountId, Str authToken)
  {
    this.accountId = accountId
    this.authToken = authToken
  }

//////////////////////////////////////////////////////////////////////////
// Verify API
//////////////////////////////////////////////////////////////////////////

  ** Send a new verification OTP to given recipient using given channel.
  Void verify(Str serviceId, Str to, Str channel := "sms")
  {
    uri := `https://verify.twilio.com/v2/Services/${serviceId}/Verifications`
    res := invoke(uri, ["To":to, "Channel":"sms"])
    echo("> $res")
  }

  ** Return 'true' if given code is verified, or 'false' otherwise.
  Bool verifyCheck(Str serviceId, Str to, Str code)
  {
    try
    {
      uri := `https://verify.twilio.com/v2/Services/${serviceId}/VerificationCheck`
      res := invoke(uri, ["To":to, "Code":code])
      return res["valid"] == true
    }
    catch (TwilioErr err)
    {
      if (err.code == 20404) return false   // no session found for recipient
      if (err.code == 60202) return false   // max_attemps exceeded
      throw err
    }
  }

//////////////////////////////////////////////////////////////////////////
// Support
//////////////////////////////////////////////////////////////////////////

  private Str:Obj? invoke(Uri uri, Str:Str form)
  {
    WebClient? c
    try
    {
      c = WebClient(uri)
      c.authBasic(accountId, authToken)

      // write request
      c.postForm(form)

      // read response
      res := c.resStr
      Map resMap := JsonInStream(res.in).readJson

      // throw if not OK
      if (c.resCode != 200 && c.resCode != 201)
      {
        ecode  := resMap["code"]
        emsg   := resMap["message"]
        throw TwilioErr(ecode, emsg)
      }

      return resMap
    }
    finally { c.close }
  }

  private const Str accountId
  private const Str authToken
}
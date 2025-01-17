//
// Copyright (c) 2025, Novant LLC
// Licensed under the MIT License
//
// History:
//   17 Jan 2025  Andy Frank  Creation
//

*************************************************************************
** TwilioErr
*************************************************************************

internal const class TwilioErr : Err
{

  ** Constructor.
  new make(Int code, Str msg, Err? cause := null) : super("${code}: $msg", cause)
  {
    this.code = code
  }

  ** Twilio error code.
  const Int code
}
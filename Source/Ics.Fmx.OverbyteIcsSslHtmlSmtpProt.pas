unit Ics.Fmx.OverbyteIcsSslHtmlSmtpProt;
{$IFDEF USE_SSL}
  {$DEFINE TSslHtmlSmtpCli_ONLY}
  {$DEFINE FMX}
  {$DEFINE ICS_INCLUDE_MODE}
  {$I OverbyteIcsSmtpProt.pas}
{$ELSE}
{$WARNINGS OFF}
  interface
  implementation
  end.
{$ENDIF USE_SSL}

(*
Wrapper unit for JwaWinCrypt.pas
https://jedi-apilib.svn.sourceforge.net/svnroot/jedi-apilib/jwapi/trunk
SVN rev. #1111 from Dez 2011
                                                                             *)
unit WinCrypt;

{$WEAKPACKAGEUNIT}

interface

uses
  Windows, Ics.Winapi.WinType;

{$IF CompilerVersion > 22}  // XE2+
  {$DEFINE DELAYED_LOADING}
{$ELSE}
  {$DEFINE DYNAMIC_LINK}
{$IFEND}

{ Custom enhancement of JwaWinCrypt to be inserted after }
//  CERT_TRUST_IS_CYCLIC                 = $00000080;
//  {$EXTERNALSYM CERT_TRUST_IS_CYCLIC}
const
  { from Win7 WinCrypt.h }
  CERT_TRUST_INVALID_EXTENSION                  = $00000100;
  {$EXTERNALSYM CERT_TRUST_INVALID_EXTENSION}
  CERT_TRUST_INVALID_POLICY_CONSTRAINTS         = $00000200;
  {$EXTERNALSYM CERT_TRUST_INVALID_POLICY_CONSTRAINTS}
  CERT_TRUST_INVALID_BASIC_CONSTRAINTS          = $00000400;
  {$EXTERNALSYM CERT_TRUST_INVALID_BASIC_CONSTRAINTS}
  CERT_TRUST_INVALID_NAME_CONSTRAINTS           = $00000800;
  {$EXTERNALSYM CERT_TRUST_INVALID_NAME_CONSTRAINTS}
  CERT_TRUST_HAS_NOT_SUPPORTED_NAME_CONSTRAINT  = $00001000;
  {$EXTERNALSYM CERT_TRUST_HAS_NOT_SUPPORTED_NAME_CONSTRAINT}
// In LH, this error will never be set.
  CERT_TRUST_HAS_NOT_DEFINED_NAME_CONSTRAINT    = $00002000;
  {$EXTERNALSYM CERT_TRUST_HAS_NOT_DEFINED_NAME_CONSTRAINT}
  CERT_TRUST_HAS_NOT_PERMITTED_NAME_CONSTRAINT  = $00004000;
  {$EXTERNALSYM CERT_TRUST_HAS_NOT_PERMITTED_NAME_CONSTRAINT}
  CERT_TRUST_HAS_EXCLUDED_NAME_CONSTRAINT       = $00008000;
  {$EXTERNALSYM CERT_TRUST_HAS_EXCLUDED_NAME_CONSTRAINT}
  CERT_TRUST_IS_OFFLINE_REVOCATION              = $01000000;
  {$EXTERNALSYM CERT_TRUST_IS_OFFLINE_REVOCATION}
  CERT_TRUST_NO_ISSUANCE_CHAIN_POLICY           = $02000000;
  {$EXTERNALSYM CERT_TRUST_NO_ISSUANCE_CHAIN_POLICY}
  CERT_TRUST_IS_EXPLICIT_DISTRUST               = $04000000;
  {$EXTERNALSYM CERT_TRUST_IS_EXPLICIT_DISTRUST}
  CERT_TRUST_HAS_NOT_SUPPORTED_CRITICAL_EXT     = $08000000;
  {$EXTERNALSYM CERT_TRUST_HAS_NOT_SUPPORTED_CRITICAL_EXT}

{ Custom enhancement of JwaWinCrypt to be inserted after }
//  CERT_CHAIN_REVOCATION_CHECK_CACHE_ONLY         = DWORD($80000000);
//  {$EXTERNALSYM CERT_CHAIN_REVOCATION_CHECK_CACHE_ONLY}

  { from Win7 WinCrypt.h }
  // By default, the dwUrlRetrievalTimeout in pChainPara is the timeout used
  // for each revocation URL wire retrieval. When the following flag is set,
  // dwUrlRetrievalTimeout is the accumulative timeout across all
  // revocation URL wire retrievals.
  CERT_CHAIN_REVOCATION_ACCUMULATIVE_TIMEOUT     = $08000000;
  {$EXTERNALSYM CERT_CHAIN_REVOCATION_ACCUMULATIVE_TIMEOUT}

// Revocation checking for an independent OCSP signer certificate.
//
// The above revocation flags indicate if just the signer certificate or all
// the certificates in the chain, excluding the root should be checked
// for revocation. If the signer certificate contains the
// szOID_PKIX_OCSP_NOCHECK extension, then, revocation checking is skipped
// for the leaf signer certificate. Both OCSP and CRL checking are allowed.
// However, recursive, independent OCSP signer certs are disabled.
  CERT_CHAIN_REVOCATION_CHECK_OCSP_CERT          = $04000000;
  {$EXTERNALSYM CERT_CHAIN_REVOCATION_CHECK_OCSP_CERT}

  // First pass determines highest quality based upon:
  //  - Chain signature valid (higest quality bit of this set)
  //  - Complete chain
  //  - Trusted root          (lowestest quality bit of this set)
  // By default, second pass only considers paths >= highest first pass quality
  CERT_CHAIN_DISABLE_PASS1_QUALITY_FILTERING     = $00000040;
  {$EXTERNALSYM CERT_CHAIN_DISABLE_PASS1_QUALITY_FILTERING}

  CERT_CHAIN_RETURN_LOWER_QUALITY_CONTEXTS       = $00000080;
  {$EXTERNALSYM CERT_CHAIN_RETURN_LOWER_QUALITY_CONTEXTS}

  CERT_CHAIN_DISABLE_AUTH_ROOT_AUTO_UPDATE       = $00000100;
  {$EXTERNALSYM CERT_CHAIN_DISABLE_AUTH_ROOT_AUTO_UPDATE}

  // When this flag is set, pTime will be used as the timestamp time.
  // pTime will be used to determine if the end certificate was valid at this
  // time. Revocation checking will be relative to pTime.
  // In addition, current time will also be used
  // to determine if the certificate is still time valid. All remaining
  // CA and root certificates will be checked using current time and not pTime.
  //
  // This flag was added 4/5/01 in WXP.
  CERT_CHAIN_TIMESTAMP_TIME = $00000200;
  {$EXTERNALSYM CERT_CHAIN_TIMESTAMP_TIME}

  // When this flag is set, 'My' certificates having a private key or end
  // entity certificates in the 'TrustedPeople' store are trusted without
  // doing any chain building. Neither the CERT_TRUST_IS_PARTIAL_CHAIN or
  // CERT_TRUST_IS_UNTRUSTED_ROOT dwErrorStatus bits will be set for
  // such certificates.
  //
  // This flag was added 6/9/03 in LH.
  CERT_CHAIN_ENABLE_PEER_TRUST = $00000400;
  {$EXTERNALSYM CERT_CHAIN_ENABLE_PEER_TRUST}

  // When this flag is set, 'My' certificates aren't considered for
  // PEER_TRUST.
  //
  // This flag was added 11/12/04 in LH.
  //
  // On 8-05-05 changed to never consider 'My' certificates for PEER_TRUST.
  CERT_CHAIN_DISABLE_MY_PEER_TRUST = $00000800;
  {$EXTERNALSYM CERT_CHAIN_DISABLE_MY_PEER_TRUST}

{$DEFINE JWA_INCLUDEMODE}
{$DEFINE JWA_OMIT_SECTIONS}
{$DEFINE JWA_INTERFACESECTION}
{$I JwaWinCrypt.pas}

implementation

const
  advapi32  = 'advapi32.dll';
  crypt32   = 'crypt32.dll';
  cryptnet  = 'cryptnet.dll';
  softpub   = 'softpub.dll';
{$IFDEF UNICODE}
  AWSuffix = 'W';
{$ELSE}
  AWSuffix = 'A';
{$ENDIF UNICODE}

{$UNDEF JWA_INTERFACESECTION}
{$DEFINE JWA_IMPLEMENTATIONSECTION}
{$I JwaWinCrypt.pas}

end.

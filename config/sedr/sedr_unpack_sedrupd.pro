;=============================================================================
;+
; NAME:
;	sedr_unpack_sedrupd
;
;
; PURPOSE:
;	Unpacks the sedrupd record from platform-independent to platform
;       format or vis-versa.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	sedr_unpack_sedrupd, upd
;
;
; ARGUMENTS:
;  INPUT:
;
;	upd:		A sedrupd formatted record read from a sedru file.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;
;	pack:		If set, the process is reversed.
;
;  OUTPUT: NONE
;
;
; PROCEDURE:
;	Floating and double precision numbers are converted from XDR format
;	to host floating format while integers are byteswapped into host
;	format.  If /pack is set, the process is reversed.
;
;
; RESTRICTIONS:
;	NONE.
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	S. Ewald, 10/1998
;	Modified by:    Haemmerle, 12/1998
;	
;-
;=============================================================================
pro sedr_unpack_sedrupd, upd, pack=pack

 ;-----------------------
 ; Unpack the structure
 ;-----------------------
 sctime = upd.sctime
 alpha = upd.alpha
 delta = upd.delta
 kappa = upd.kappa
 alpha_0 = upd.alpha_0
 delta_0 = upd.delta_0
 omega = upd.omega
 pb_position = upd.pb_position
 update_day = upd.update_day
 update_year = upd.update_year


 ;--------------------------------------
 ; Convert to Network byte order and XDR
 ;--------------------------------------
 if(keyword__set(pack)) then $
  begin
   BYTEORDER, sctime, /HTONL
   BYTEORDER, alpha, /DTOXDR
   BYTEORDER, delta, /DTOXDR
   BYTEORDER, kappa, /DTOXDR
   BYTEORDER, alpha_0, /DTOXDR
   BYTEORDER, delta_0, /DTOXDR
   BYTEORDER, omega, /DTOXDR

   BYTEORDER, pb_position, /FTOXDR

   BYTEORDER, update_day, /HTONS
   BYTEORDER, update_year, /HTONS
  end $
 ;--------------------------------------
 ; Convert to local byte order and float
 ;--------------------------------------
 else $
  begin
   BYTEORDER, sctime, /NTOHL
   BYTEORDER, alpha, /XDRTOD
   BYTEORDER, delta, /XDRTOD
   BYTEORDER, kappa, /XDRTOD
   BYTEORDER, alpha_0, /XDRTOD
   BYTEORDER, delta_0, /XDRTOD
   BYTEORDER, omega, /XDRTOD

   BYTEORDER, pb_position, /XDRTOF

   BYTEORDER, update_day, /NTOHS
   BYTEORDER, update_year, /NTOHS
  end


 ;--------------------------------
 ; Reload the sedrupd structure
 ;--------------------------------
 upd.sctime = sctime
 upd.alpha = alpha
 upd.delta = delta
 upd.kappa = kappa
 upd.alpha_0 = alpha_0
 upd.delta_0 = delta_0
 upd.omega = omega
 upd.pb_position = pb_position
 upd.update_day = update_day
 upd.update_year = update_year

return
end

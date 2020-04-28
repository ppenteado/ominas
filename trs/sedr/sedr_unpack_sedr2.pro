;=============================================================================
;+
; NAME:
;	sedr_unpack_sedr2
;
;
; PURPOSE:
;	Unpacks the sedr2 record from platform-independent to platform
;       format or vis-versa.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	sedr_unpack_sedr2, sedr
;
;
; ARGUMENTS:
;  INPUT:
;
;	sedr:		A sedr2 formatted record read from a sedr file.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;
;	pack:		If set, reverses the process.
;
;
;  OUTPUT: NONE
;
;
; PROCEDURE:
;	Floating and double precision numbers are converted from XDR format
;	to host floating format while integers are byteswapped into host
;	format.  If /pack is set, the processes is reversed.
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
pro sedr_unpack_sedr2, sedr, pack=pack

 ;-----------------------
 ; Unpack the structure
 ;-----------------------
 sctime = sedr.sctime
 alpha = sedr.alpha
 delta = sedr.delta
 kappa = sedr.kappa
 alpha_0 = sedr.alpha_0
 delta_0 = sedr.delta_0
 omega = sedr.omega
 sc_velocity = sedr.sc_velocity
 sc_position = sedr.sc_position
 pb_position = sedr.pb_position
 sun_position = sedr.sun_position
 target = sedr.target
 update_day = sedr.update_day
 update_year = sedr.update_year
 msec = sedr.msec
 year = sedr.year
 day = sedr.day


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

   BYTEORDER, sc_velocity, /FTOXDR
   BYTEORDER, sc_position, /FTOXDR
   BYTEORDER, pb_position, /FTOXDR
   BYTEORDER, sun_position, /FTOXDR

   BYTEORDER, target, /HTONS
   BYTEORDER, update_day, /HTONS
   BYTEORDER, update_year, /HTONS
   BYTEORDER, msec, /HTONS
   BYTEORDER, year, /HTONS
   BYTEORDER, day, /HTONS
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

   BYTEORDER, sc_velocity, /XDRTOF
   BYTEORDER, sc_position, /XDRTOF
   BYTEORDER, pb_position, /XDRTOF
   BYTEORDER, sun_position, /XDRTOF

   BYTEORDER, target, /NTOHS
   BYTEORDER, update_day, /NTOHS
   BYTEORDER, update_year, /NTOHS
   BYTEORDER, msec, /NTOHS
   BYTEORDER, year, /NTOHS
   BYTEORDER, day, /NTOHS
  end


 ;--------------------------------
 ; Reload the sedr2 structure
 ;--------------------------------
 sedr.sctime = sctime
 sedr.alpha = alpha
 sedr.delta = delta
 sedr.kappa = kappa
 sedr.alpha_0 = alpha_0
 sedr.delta_0 = delta_0
 sedr.omega = omega
 sedr.sc_velocity = sc_velocity
 sedr.sc_position = sc_position
 sedr.pb_position = pb_position
 sedr.sun_position = sun_position
 sedr.target = target
 sedr.msec = msec
 sedr.year = year
 sedr.day = day
 sedr.update_day = update_day
 sedr.update_year = update_year

return
end

;=============================================================================
;+
; NAME:
;	sedr_unpack_bcons
;
;
; PURPOSE:
;	Unpacks the body constants record from platform-independent to platform
;       format or vis-versa.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	sedr_unpack_bcons, bconst 
;
;
; ARGUMENTS:
;  INPUT:
;
;	bconst:		A bconst formatted record read from a bcons file.
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
;  OUTPUT:
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
;	Written by:    Haemmerle, 12/1998
;	
;-
;=============================================================================
pro sedr_unpack_bcons, bconst, pack=pack

 ;-----------------------
 ; Unpack the structure
 ;-----------------------
 a = bconst.a
 b = bconst.b
 c = bconst.c
 lora = bconst.lora
 rotation_rate = bconst.rotation_rate
 planet_number = bconst.planet_number
 sat_number = bconst.sat_number


 ;--------------------------------------------
 ; Convert to Network byte order and XDR float
 ;--------------------------------------------
 if(keyword__set(pack)) then $
  begin
   BYTEORDER, a, /FTOXDR
   BYTEORDER, b, /FTOXDR
   BYTEORDER, c, /FTOXDR
   BYTEORDER, lora, /FTOXDR
   BYTEORDER, rotation_rate, /FTOXDR

   BYTEORDER, planet_number, /HTONS
   BYTEORDER, sat_number, /HTONS
  end $
 ;--------------------------------------
 ; Convert to local byte order and float
 ;--------------------------------------
 else $
  begin
   BYTEORDER, a, /XDRTOF
   BYTEORDER, b, /XDRTOF
   BYTEORDER, c, /XDRTOF
   BYTEORDER, lora, /XDRTOF
   BYTEORDER, rotation_rate, /XDRTOF

   BYTEORDER, planet_number, /NTOHS
   BYTEORDER, sat_number, /NTOHS
  end


 ;--------------------------------
 ; Reload the bcons structure
 ;--------------------------------
 bconst.a = a
 bconst.b = b
 bconst.c = c
 bconst.lora = lora
 bconst.rotation_rate = rotation_rate
 bconst.planet_number = planet_number
 bconst.sat_number = sat_number

return
end

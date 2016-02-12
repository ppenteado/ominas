;=============================================================================
;+-+
; NAME:
;	sedr_read
;
;
; PURPOSE:
;	Reads a sedr2 and sedrupd file at a given sctime.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	result = sedr_read(sctime)
;
;
; ARGUMENTS:
;  INPUT:
;
;	sctime:		Spacecraft time (FDS count x 100)
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;
;       planet:         Planet, if given, one of 'jupiter', 'saturn',
;                       'uranus' or 'neptune'.  If not given, uses
;                       sctime to guess.
;
;       source:         SEDR source, if given one of 'SEDR', 'DAVI',
;                       'NAV ', 'FARE', 'NAV2', 'NEAR', 'AMOS'.  If
;                       not given, then default is 'SEDR'
;
;  OUTPUT: NONE
;
;
; PROCEDURE:
;
;
; RESTRICTIONS:
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Haemmerle, 1/1999
;                       using some ideas from S. Ewald, 10/1998
;	
;-
;=============================================================================
function sedr_read, sctime, planet=planet, source=source

 ;---------------
 ; Check inputs
 ;---------------
 if(NOT keyword__set(planet)) then $
  begin
   _planet = ' '
   if(sctime GE  708553 AND sctime LE 1245733) then _planet = 'neptune'
   if(sctime GE 1460413 AND sctime LE 2684629) then _planet = 'jupiter'
   if(sctime GE 3250013 AND sctime LE 4492459) then _planet = 'saturn'
   if(sctime GT 2684629 AND sctime LE 2762847) then _planet = 'uranus'
;  if(sctime GE 2447654 AND sctime LE 2684629) then _planet could be 'uranus'
   if(_planet EQ ' ') then return, 0
  end $
 else _planet = planet
 if(keyword__set(source)) then $
  begin
   _source = source
   if(source EQ 'NAV') then _source = 'NAV '
   if(_source NE 'SEDR' AND _source NE 'DAVI' AND _source NE 'NAV ' AND $
      _source NE 'FARE' AND _source NE 'NAV2' AND _source NE 'NEAR' AND $
      _source NE 'AMOS') then $
    begin
     nv_message, name='sedr_read', 'Invalid source specified', /continue
     return, 0
    end
  end $
  else _source = 'SEDR'


 ;-------------------------
 ; Get SEDR2 record
 ;-------------------------
 sedr2 = sedr_get_sedr2(sctime, _planet)
 _size = size(sedr2)
 if(_size[2] NE 8) then $
   if(NOT keyword__set(planet) AND sctime GE 2447654 AND sctime LE 2684629) $
    then begin
     _planet = 'uranus'
     sedr2 = sedr_get_sedr2(sctime, _planet)
     _size = size(sedr2)
     if(_size[2] NE 8) then return, 0
    end $
 else return, 0
 if(_source EQ 'SEDR') then $
  begin
   sedr2.spare_1[0:3] = BYTE('SEDR')
   return, sedr2
  end


 ;--------------------------------------
 ; If specifed get SEDRUPD source record
 ;--------------------------------------
 sedrupd = sedr_get_sedrupd(sctime, _planet, _source)
 _size = size(sedrupd)
 if(_size[2] NE 8) then return, 0


 ;---------------------------------------------
 ; Pack the SEDR2 record with the update values
 ;---------------------------------------------
 sedr2.alpha = sedrupd.alpha
 sedr2.delta = sedrupd.delta
 sedr2.kappa = sedrupd.kappa
 sedr2.alpha_0 = sedrupd.alpha_0
 sedr2.delta_0 = sedrupd.delta_0
 sedr2.omega = sedrupd.omega
 sedr2.pb_position = sedrupd.pb_position
 sedr2.update_year = sedrupd.update_year
 sedr2.update_day = sedrupd.update_day
 sedr2.spare_1[0:3] = sedrupd.source
 return, sedr2

end
;=============================================================================

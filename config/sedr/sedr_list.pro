;=============================================================================
;+
; NAME:
;	sedr_list
;
;
; PURPOSE:
;	Lists sedr2 and sedrupd records at a given sctime or for a given
;	data descriptor and returns the number or sedr records and updates.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	count = sedr_list([dd=dd],[sctime=sctime])
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;
;	    dd:		A data descriptor containing a Voyager VICAR
;			header
;
;       sctime:         Spacecraft time (FDS count x 100)
;
;       planet:         Planet, if given, one of 'jupiter', 'saturn',
;                       'uranus' or 'neptune'.  If not given, uses
;                       sctime to guess.
;
;	silent:		If set, function produces no output.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Returns the number of sedr records found (original + updates).
;
;
; PROCEDURE:
;	Finds the SEDR2 record for sctime and then searchs for updates
;	among all valid sources.
;
;
; RESTRICTIONS:
;	None.
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Haemmerle, 1/1999
;	
;-
;=============================================================================
function sedr_list, dd=dd, sctime=sctime, planet=planet, silent=silent

 ;----------------------------------------------------------
 ; If data descriptor given get sctime and planet and source
 ;----------------------------------------------------------
 if(keyword__set(dd)) then $
  begin
   sctime = long(vicar_vgrkey(dat_header(dd),'SCTIME'))
   planet = vicar_vgrkey(dat_header(dd),'PLANET')
  end $
 else $
  if(NOT keyword__set(sctime)) then $
   begin
    nv_message, 'Must have dd or sctime', /continue
    return, 0 
   end

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
 if(NOT keyword__set(silent)) then $
  begin
    print, 'SEDR info for sctime:',sctime, '   Central Body: ',_planet
    print, '   Source     Year    Day'
    print, '   ------     ----    ---'
    print, format='(4X,A4,6X,I4,4X,I3)', 'SEDR', $
           sedr2.update_year,sedr2.update_day
  end

 ;--------------------------------------
 ; Find SEDRUPD source records
 ;--------------------------------------
 valid_sources = ['DAVI', 'NAV ', 'FARE', 'NAV2', 'NEAR', 'AMOS']
 sources = 0
 count = 1
 for i=0,n_elements(valid_sources)-1 do $
  begin
   _source = valid_sources[i]
   sedrupd = sedr_get_sedrupd(sctime, _planet, _source)
   _size = size(sedrupd)
   if(_size[2] EQ 8) then $
    begin
     count = count + 1
     sources = sources + 2^i
     if(NOT keyword__set(silent)) then $
      print, format='(4X,A4,6X,I4,4X,I3)', string(sedrupd.source), $
             sedrupd.update_year, sedrupd.update_day
    end
  end

  if(sedr2.sedr_sources NE sources and NOT keyword__set(silent)) then $
   begin
    print,' '
    print,'SEDR_SOURCES variable in SEDR2 record not consistant with sources'
  end

 return, count

end
;=============================================================================

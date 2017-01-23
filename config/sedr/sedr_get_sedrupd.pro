;=============================================================================
;+
; NAME:
;	sedr_get_sedrupd
;
;
; PURPOSE:
;	Returns a sedrupd record from an IDL sedrupd file.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	result = sedr_get_sedrupd(sctime, planet, source)
;
;
; ARGUMENTS:
;  INPUT:
;
;	sctime:		Spacecraft time (FDS count x 100)
;
;       planet:         Planet, one of 'jupiter', 'saturn',
;                       'uranus' or 'neptune'.  
;
;	source:		One of 'DAVI', 'NAV ', 'FARE', 'NAV2', 'NEAR', 'AMOS'. 
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
;  ENVIRONMENT VARIABLES:
;	NV_SEDR_DATA:	Directory containing the SEDR data files.  The 
;			variable should contain a trailing slash.
;
;
; RETURN:
;	A sedrupd record.
;
;
; PROCEDURE:
;	Opens a sedrupd and its index file, then returns the appropriate
;	unpacked sedrupd record. It requires that the environment
;       variable NV_SEDR_DATA be set to the directory containing the
;       files.  The variable should contain a trailing slash.
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
function sedr_get_sedrupd, sctime, planet, source

 file_sedrupd = getenv('NV_SEDR_DATA') + planet + '.sdru_idl'
 file_sedrupd_index = getenv('NV_SEDR_DATA') + planet + '.sdru_idx'

 on_ioerror, eod
 ;----------------------------
 ; Read SEDRUPD index
 ;----------------------------
 openr, unit_sedrupd_index, file_sedrupd_index, /get_lun
 info = fstat(unit_sedrupd_index)
 index = lonarr(info.size/4)
 readu, unit_sedrupd_index, index
 byteorder, index, /NTOHL
 free_lun, unit_sedrupd_index

 ;-----------------------------
 ; Get record numbers
 ;-----------------------------
 subs = where(index EQ sctime)
 if(subs[0] EQ -1) then return, 0

 ;------------------------------
 ; Get SEDRUPD record
 ;------------------------------
 openr, unit_sedrupd, file_sedrupd, /get_lun
 record = {sedrupd}
 for i=0,n_elements(subs)-1 do $
  begin
   point_lun, unit_sedrupd, subs[i]*84
   readu, unit_sedrupd, record
   sedr_unpack_sedrupd, record
   if(record.sctime EQ sctime AND string(record.source) EQ source) then $
    begin
     free_lun, unit_sedrupd
     return, record
    end
  end

 free_lun, unit_sedrupd
 return, 0

eod:
 free_lun, unit_sedrupd
 nv_message, 'File not found or I/O error', /continue
 return, 0
end
;=============================================================================

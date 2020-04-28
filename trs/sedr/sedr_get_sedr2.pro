;=============================================================================
;+
; NAME:
;	sedr_get_sedr2
;
;
; PURPOSE:
;	Returns a sedr2 record from an IDL sedr2 file.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	result = sedr_get_sedr2(sctime ,planet)
;
;
; ARGUMENTS:
;  INPUT:
;
;	sctime:		Spacecraft time (FDS count x 100)
;
;       planet:         Planet, if given, one of 'jupiter', 'saturn',
;                       'uranus' or 'neptune'. 
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
;	OMINAS_SEDR_DATA:	
;			Directory containing the SEDR data files.  The 
;			variable should contain a trailing slash.
;
;
; RETURN:
;	An unpacked sedr2 record.
;
;
; PROCEDURE:
;	Opens a sedr2 and its index file, then returns the appropriate
;	unpacked sedr2 record.  It requires that the environment
;	variable OMINAS_SEDR_DATA be set to the directory containing the
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
;                       Fixed target_id for older Saturn sats 9/1999
;	
;-
;=============================================================================
function sedr_get_sedr2, sctime, planet

 file_sedr2 = getenv('OMINAS_SEDR_DATA') + planet + '.sdr2_idl'
 file_sedr2_index = getenv('OMINAS_SEDR_DATA') + planet + '.sdr2_idx'

 on_ioerror, eod
 ;----------------------------
 ; Read SEDR2 index
 ;----------------------------
 openr, unit_sedr2_index, file_sedr2_index, /get_lun
 info = fstat(unit_sedr2_index)
 index = lonarr(info.size/4)
 readu, unit_sedr2_index, index
 byteorder, index, /NTOHL
 free_lun, unit_sedr2_index

 ;-----------------------------
 ; Get record number
 ;-----------------------------
 subs = where(index EQ sctime)
 if(subs[0] EQ -1) then return, 0

 ;------------------------------
 ; Get SEDR2 record
 ;------------------------------
 openr, unit_sedr2, file_sedr2, /get_lun
 record = {sedr2}
 point_lun, unit_sedr2, subs[0]*134
 readu, unit_sedr2, record
 sedr_unpack_sedr2, record
 free_lun, unit_sedr2

 ;-----------------------------------------
 ; Fix target_id skew for Saturn satellites
 ;-----------------------------------------
 target = record.target
 if(target EQ 16) then record.target = 106
 if(target-10*(target/10) EQ 6) then $
  begin
    if(target/10 GT 1 AND target/10 LE 10) then $
    record.target = record.target - 10
  end

 if(record.sctime NE sctime) then $
  begin
   nv_message, 'SEDR2 file/index inconsistant', /continue
   return, 0
  end

 return, record
eod:
 nv_message, 'File not found or I/O error', /continue
 return, 0
end
;=============================================================================

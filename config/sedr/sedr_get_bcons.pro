;=============================================================================
;+
; NAME:
;	sedr_get_bcons
;
;
; PURPOSE:
;	Returns a bcons record from an IDL bcons file.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	result = sedr_get_bcons(target_id)
;
;
; ARGUMENTS:
;  INPUT:
;	target_id:	Target id for information to retrieve.  Target
;			id is sat_number*10 + planet_number as defined for
;			the Voyager project.
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
;	A body constant record.
;
; PROCEDURE:
;	Opens a bcons and its index file, then returns the appropriate
;	unpacked bcons record. It requires that the environment
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
;	
;-
;=============================================================================
function sedr_get_bcons, target_id

 file_bcons = getenv('NV_SEDR_DATA')+'bodyconst.dat_idl'
 file_bcons_index = getenv('NV_SEDR_DATA')+'bodyconst.dat_idx' 

 on_ioerror, eod
 ;----------------------------
 ; Read BCONS index
 ;----------------------------
 openr, unit_bcons_index, file_bcons_index, /get_lun
 info = fstat(unit_bcons_index)
 index = intarr(info.size/2)
 readu, unit_bcons_index, index
 byteorder, index, /NTOHS
 free_lun, unit_bcons_index

 ;-----------------------------
 ; Get record number
 ;-----------------------------
 subs = where(index EQ target_id)
 if(subs[0] EQ -1) then return, 0

 ;------------------------------
 ; Get BCONS record
 ;------------------------------
 openr, unit_bcons, file_bcons, /get_lun
 record = {bcons}
 point_lun, unit_bcons, subs[0]*165
 readu, unit_bcons, record
 sedr_unpack_bcons, record
 free_lun, unit_bcons

 if((record.sat_number*10 + record.planet_number) NE target_id) then $
  begin
   nv_message, 'BCONS file/index inconsistant', /continue
   return, 0
  end

 return, record

eod:
 nv_message, 'File not found or I/O error', /continue
 return, 0
end
;=============================================================================

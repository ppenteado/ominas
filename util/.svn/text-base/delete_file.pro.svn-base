;=============================================================================
;+
; NAME:
;	delete_file
;
;
; PURPOSE:
;	Deletes the specified file.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	delete_file, fname 
;
;
; ARGUMENTS:
;  INPUT:
;	fname:	Name of file to delete
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2002
;	
;-
;=============================================================================
pro delete_file, fname

 openw, unit, fname, /get_lun, /delete
 close, unit
 free_lun, unit


end
;=============================================================================

;=============================================================================
;+
; NAME:
;       eph_spice_read_label
;
;
; PURPOSE:
;       Reads a PDS LBL file for a SPICE kernel file
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       eph_spice_read_label, filename, unit, creation
;
;
; ARGUMENTS:
;  INPUT:
;       filename:	Path of the SPK files
;
;       unit:		IDL file unit to use
;
;  OUTPUT:
;	creation:	File creation date (string)
;
;
; KEYWORDS:
;  INPUT:
;	debug:		Outputs debug information
;
;  OUTPUT: NONE
;
;
; PROCEDURE:		Adds '.lbl' to input filename
;                       Checks for label file, reads if so
;                       Extracts value of PRODUCT_CREATION_TIME
;
;
; RESTRICTIONS:
;
;
; STATUS:
;       Complete.
;
;
; MODIFICATION HISTORY:
;       Written by:     V. Haemmerle,  Feb. 2017
;
;-
;=============================================================================
pro eph_spice_read_label, filename, unit, creation, debug=debug

 ;------------------------
 ; Local parameters
 ;------------------------
 debug_set = keyword_set(debug)
 creation = ''

 ;-----------------------
 ; open file
 ;-----------------------
 lbl_file = filename + '.lbl'
 
 on_ioerror, close_lbl
 openr, unit, lbl_file
 if debug_set then print, 'Label file ', lbl_file, ' detected'

 temporary = make_array(200,value=32b)
 stemp = string(temporary)

 while ~EOF(unit) do begin
   readf, unit, format='(a)', stemp
   line = strsplit(stemp,'=',/extract)
   keyword = strtrim(line[0],2)
   if keyword EQ 'PRODUCT_CREATION_TIME' then begin
     creation = line[1]
     goto, close_lbl
   endif
 endwhile

 close_lbl:
 close, unit

end

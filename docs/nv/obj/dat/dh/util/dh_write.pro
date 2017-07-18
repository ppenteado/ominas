;=============================================================================
;+-+
; NAME:
;	dh_write
;
;
; PURPOSE:
;	Writes a detached header file.
;
;
; CATEGORY:
;	UTIL/DH
;
;
; CALLING SEQUENCE:
;	dh_write, filename, dh
;
;
; ARGUMENTS:
;  INPUT:
;	filename:	Name of file to be written.
;
;	dh:		String array giving the detached header to write.
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
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dh_read
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/1998
;	
;-
;=============================================================================
pro dh_write, filename, dh

 ;----------------------------
 ; open file
 ;----------------------------
 openw, unit, filename, /get_lun, error=error
 if(error NE 0) then $
  begin
   nv_message, !err_string, /continue
   nv_message, 'Detached header not written.', /continue
   return
  end

 nv_message, verb=0.1, 'Writing ' + filename + '.', /continue

 ;----------------------------
 ; write the file
 ;----------------------------
 for i=0, n_elements(dh)-1 do printf, unit, dh[i]


 ;----------------------------
 ; clean up
 ;----------------------------
 close, unit
 free_lun, unit
end
;=============================================================================

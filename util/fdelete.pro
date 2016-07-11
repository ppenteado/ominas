;=============================================================================
;+
; NAME:
;	fdelete
;
;
; PURPOSE:
;	Delete files.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	fdelete, filespec
;
;
; ARGUMENTS:
;  INPUT:
;	filespec:	File specification of files to delete.
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/19/2001
;	
;-
;=============================================================================
pro fdelete, filespec

 files = file_search(filespec)
 nfiles = n_elements(files)

 for i=0, nfiles-1 do $
  case !version.os_family of
  	'unix' : 	spawn, 'rm -f ' + files[i]

	default : 	message, !version.os_family + 'not supported.'
  endcase

end
;=============================================================================

;==============================================================================
;+
; NAME:
;	nv_module_search
;
;
; PURPOSE:
;	Searches a directory for any OMINAS modules.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	abbr = nv_module_search(dir)
;
;
; ARGUMENTS:
;  INPUT:
;	dir:		Module code directory.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: 
;	dirs:		Module directories.
;
;
; RETURN:  Abbreviated module names or null string if none found.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		1/2020
;	
;-
;==============================================================================
function nv_module_search, dir, dirs=dirs

 dirs = file_search(dir + '/*/module', /test_directory)
 if(NOT keyword_set(dirs)) then return, ''

 abbr = file_basename(file_dirname(dirs))

 dirs = file_dirname(dirs)
 return, abbr
end
;=============================================================================

;=============================================================================
;+
; NAME:
;	dat_expand
;
;
; PURPOSE:
;	Expands file specifications.
;
;
; CATEGORY:
;	NV/OBJ/DAT
;
;
; CALLING SEQUENCE:
;	filenames = dat_expand(filetype, filespec, extension)
;
;
; ARGUMENTS:
;  INPUT:
;	filetype:	File type string from dat_detect_filetype.
;
;	filespec:	Array of file specification strings.
;
;	extension:	Array of strings giving file extensions to try.  
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	filetype:	Detecte file type for each returned file.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 4/2018
;	
;-
;=============================================================================
function dat_expand, filetype, filespec, extensions

 if(NOT keyword_set(extensions)) then extensions = '' $
 else extensions = unique([extensions, ''])

 query_fn = strlowcase('query_' + filetype)
 if(NOT routine_exists(query_fn)) then query_fn = 'file_search'

 for i=0, n_elements(extensions)-1 do $
        filenames = append_array(filenames, $
                           call_function(query_fn, filespec + extensions[i]))

 return, filenames
end
;=============================================================================

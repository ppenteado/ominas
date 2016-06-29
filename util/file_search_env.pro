;=============================================================================
;+
; NAME:
;       file_search_env
;
;
; PURPOSE:
;       Expands the IDL function file_search to handle colon separated
;		lists in UNIX environment variables
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = file_search_env(filespec)
;
;
; ARGUMENTS:
;  INPUT:
;       filespec:       A file that may be in on of several directories 
;						separated by a colon
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array of found filenames.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Ryan  6/2016
;
;-
;=============================================================================
function file_search_env, _filespec

 ; Check for environment variables
 b = strpos(_filespec, '$')
 if(b NE -1) then $
  begin
   e = strpos(_filespec, '/')
   env = strmid(_filespec, b+1,e-b-1)
   dlist = getenv(env)
   dlist = strsplit(dlist, ':', /extract)
   k = strmid(_filespec, e, strlen(_filespec)-e)
   files = file_search(dlist[where(file_test(dlist+k) EQ 1)]+k)
  end else begin
   files = file_search(_filespec)
  endelse
  return, files
end

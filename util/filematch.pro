;==============================================================================
; filematch
;
;  Same as findfile, except matches against a given array of filenames.
;
;==============================================================================
function filematch, files, filespec

 if(NOT keyword_set(files)) then return, ''

 ;-----------------------------------------
 ; make temp directory for the file list
 ;-----------------------------------------
 spawn, 'echo', unit=unit, pid=pid	; get a pid and keep it until finished

 dir = '/tmp/filematch-' + strtrim(pid,2)
 devnull = ' >& /dev/null'

 spawn, 'mkdir -p ' + dir + devnull, /sh
 spawn, 'rm -f ' + dir + '/*' + devnull, /sh

 ;-----------------------------------------
 ; write empty files
 ;-----------------------------------------
 makefiles = 'echo > ' + dir + '/' + files
 spawn, makefiles

 file_list = str_comma_list(files, delim=' ')
 spawn, 'for i in ' + file_list + '; do echo > ' + dir +  '/$i; done', /sh

 ;-----------------------------------------
 ; match the expression
 ;-----------------------------------------
 match = findfile(dir + '/' + filespec)
 split_filename, match, junk, result

 ;-----------------------------------------
 ; remove files and directory
 ;-----------------------------------------
 spawn, 'rm -f ' + dir + '/*' + devnull, /sh
 spawn, 'rmdir ' + dir + devnull, /sh

 close, unit
 free_lun, unit

 return, result
end
;==============================================================================

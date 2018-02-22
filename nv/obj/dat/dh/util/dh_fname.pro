;=============================================================================
; dhfn_filename
;
;=============================================================================
function dhfn_filename, raw_filename
; need to replace non-compliant characters with compliant characters
 return, raw_filename
end
;=============================================================================



;=============================================================================
; dhfn_findfile
;
;=============================================================================
function dhfn_findfile, dir, name, ext

 ;---------------------------------------------------------------
 ; try replacing existing extension
 ;---------------------------------------------------------------
 ff = file_search(dir + '/' + name + '.dh')
 if(keyword_set(ff)) then return, ff

 ;---------------------------------------------------------------
 ; try just adding .dh extension
 ;---------------------------------------------------------------
 if(keyword_set(ext)) then ff = findfile(dir + '/' + name + '.' + ext + '.dh')
 if(keyword_set(ff)) then return, ff

 return, ''
end
;=============================================================================



;=============================================================================
; dh_fname.pro
;
;=============================================================================
function dh_fname, raw_filename, write=write

 ;----------------------------------------------------
 ; check for DH_PATH
 ;----------------------------------------------------
 path = getenv('DH_PATH')
 if(NOT keyword_set(path)) then path = './'


 ;---------------------------------------------------------------
 ; create a file-system-compliant basename
 ;---------------------------------------------------------------
 filename = dhfn_filename(raw_filename)
 split_filename, filename, dir, full_name
 split_filename, filename, dir, name, ext
 if(NOT keyword_set(dir[0])) then dir = './'


 ;----------------------------------------------------------------------------
 ; if creating a new dh, put it in the desired path, and add '.dh'
 ;----------------------------------------------------------------------------
 if(keyword_set(write)) then return, path + '/' + full_name + '.dh'


 ;------------------------------------------------------------------
 ; Otherwise try various possibilities to find an existing dh file
 ;------------------------------------------------------------------

 ;- - - - - - - - - - - - - - - - - - -
 ; try same directory as the data file
 ;- - - - - - - - - - - - - - - - - - -
 ff = dhfn_findfile(dir, name, ext)
 if(keyword_set(ff)) then return, ff

 ;- - - - - - - - - - - - - - - - - - -
 ; try path directory
 ;- - - - - - - - - - - - - - - - - - -
 ff = dhfn_findfile(path, name, ext)
 if(keyword_set(ff)) then return, ff


 return, ''
end
;=============================================================================



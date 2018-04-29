;=============================================================================
;+
; NAME:
;       bat_expand
;
; PURPOSE:
;       Expands file specifications using read_txt_file.  Also, defines
;	global keywords for OMINAS shell commands.
;
;	  
; CATEGORY:
;       BAT
;
;
; CALLING SEQUENCE:
;       filespecs = bat_expand(keys, val_ps, input_files)
;
;
; ARGUMENTS:
;  INPUT: 
;	keys:	String array giving the names of keywords aruments.
;
;	val_ps:	Pointer array giving value for each keyword.
;
;	input_files: String array giving names of files to be read using
;	             read_txt_file.  
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS: NONE
;
;
; GLOBAL SHELL KEYWORDS: 
;	file_sample:
;		Sets file list sampling; see read_txt_file.
;
;	file_select:
;		Sets file selection criterion; see read_txt_file.
;
;
; RETURN:
;	String array giving the concatanated results of reading every 
;	input file, subject to the rules of read_txt_file.  Note that
;	the special keyowrds 'file_sample' and 'file_select' are detected
;	and passed to read_txt_file.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function bat_expand, filespecs, keys, val_ps, input_files, sample, select

 ;----------------------------------------------------------------
 ; expand file specs
 ;----------------------------------------------------------------
 if(keyword_set(input_files)) then $
  for i=0, n_elements(input_files)-1 do $
       filespecs = append_array(filespecs, $
          decrapify(read_txt_file(input_files[i], sample=sample, select=select)))

 if(NOT keyword_set(filespecs)) then return, ''
 return, filespecs
end
;==============================================================================

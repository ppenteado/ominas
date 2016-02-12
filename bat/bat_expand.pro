;=============================================================================
;+
; NAME:
;       bat_expand
;
; PURPOSE:
;       Expands file specifications using read_txt_file.
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
function bat_expand, filespecs, keys, val_ps, input_files

 n = n_elements(input_files)

 if(keyword_set(keys)) then $
  begin
   w = where(strlowcase(keys) EQ 'file_sample')
   if(w[0] NE -1) then $
    begin
     file_sample = (*val_ps[w[0]])[0]
     keys[w] = ''
    end

   w = where(strlowcase(keys) EQ 'file_select')
   if(w[0] NE -1) then $
    begin
     file_select = *val_ps[w[0]]
     keys[w] = ''
    end

   w = where(keys EQ '')
   if(w[0] NE -1) then $
    begin
     keys = rm_list_item(keys, w, only='')
     val_ps = rm_list_item(val_ps, w)
     if(NOT keyword_set(keys[0])) then $
      begin
       keys = ''
       val_ps = ptr_new()
      end
    end
  end

 for i=0, n-1 do $
       filespecs = append_array(filespecs, $
            read_txt_file(input_files[i], sample=file_sample, select=file_select))

 if(NOT keyword_set(filespecs)) then return, ''
 return, filespecs
end
;==============================================================================

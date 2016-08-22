;=============================================================================
;+
; NAME:
;	dat_detect_filetype
;
;
; PURPOSE:
;	Attempts to detect the type of the given file by calling the 
;	detectors in the filetype detectors table.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	filetype = dat_detect_filetype(filename)
;
;
; ARGUMENTS:
;  INPUT:
;	filename:	Name of file to test.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	silent:	If set, messages will be suppressed.
;
;	default:	If set, the 'default' filetype is returned.
;			The default filetype is the first item in the table
;			whose action is not 'IGNORE'.
;
;	all:	If set, all filetypes in the table are returned.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	String giving the filetype, or null string if none detected.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function dat_detect_filetype, filename, silent=silent, default=default, all=all, action=action
@nv_block.common
@core.include


 ;=====================================================
 ; read the filetype table if it doesn't exist
 ;=====================================================
 stat = 0
 if(NOT keyword_set(*nv_state.ftp_table_p)) then $
   dat_read_config, 'NV_FTP_DETECT', stat=stat, $
              nv_state.ftp_table_p, nv_state.ftp_detectors_filenames_p
 if(stat NE 0) then $
   nv_message, name='dat_detect_filetype', $
     'No filetype table.', /con, $
       exp=['The filetype table specifies the names of file type detector functions.', $
            'Without this table, OMINAS cannot read input data.']

 table = *nv_state.ftp_table_p
 actions = strupcase(table[*,2])

 ;=====================================================
 ; default type is the first entry that is not ignored
 ;=====================================================
 if(keyword_set(default)) then $
  begin
   w = where(actions NE 'IGNORE')
   if(w[0] EQ -1) then return, ''
   return, table[w[0],1] 
  end


 ;=====================================================
 ; /all means just return all filetypes
 ;=====================================================
 if(keyword_set(all)) then return, table[*,1] 


 ;=====================================================
 ; call filetype detectors until true is returned
 ;=====================================================
 s = size(table)
 n_ftp = s[1]
 for i=0, n_ftp-1 do $
  begin
   detect_fn = table[i,0]
   if(call_function(detect_fn, filename)) then $
    begin
     filetype = table[i,1]
     action = actions[i]
     return, filetype
    end
  end


 return, ''
end
;===========================================================================

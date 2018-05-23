;=============================================================================
;+
; NAME:
;	dat_detect_filetype
;
;
; PURPOSE:
;	Attempts to detect the type of the file (or header) associated with the
;	given data descriptor by calling the detectors in the filetype detectors 
;	table.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	filetype = dat_detect_filetype(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor containing filename or header to test.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	filename:	Filename to test.  If not given, it is taken from the
;			data descriptor.
;
;	header:		Header to test.  If not given, it is taken from the
;			data descriptor.
;
;	default:	If set, the 'DEFAULT' filetype is returned.
;			The default filetype is the first item in the table
;			whose action is not 'IGNORE'.
;
;	all:		If set, all filetypes in the table are returned.
;
;  OUTPUT: 
;	action:		Action string from matched file type entry.
;
;
; RETURN: 
;	String giving the type, or null string if none detected.  Detector 
;	functions take a single data descriptor argument and return a string
;	specifying the type.  If the data descriptor contains a header, then
;	the header type (htype) must be returned, otherwise the file type
;	is expected.
;	
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
function dat_detect_filetype, dd, filename=filename, header=header, $
                                         default=default, all=all, action=action
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
   nv_message, $
     'No filetype table.', /con, $
       exp=['The filetype table specifies the names of file type detector functions.', $
            'Without this table, OMINAS cannot read input data.']

 table = *nv_state.ftp_table_p

 ;=====================================================
 ; default type is the first entry that is not ignored
 ;=====================================================
 if(keyword_set(default)) then return, table[0,1] 


 ;=====================================================
 ; /all means just return all filetypes
 ;=====================================================
 if(keyword_set(all)) then return, table[*,1] 

 ;=====================================================
 ; call filetype detectors until true is returned
 ;=====================================================
 if(keyword_set(dd)) then $
  begin
   if(NOT keyword_set(filename)) then filename = dat_filename(dd)
   if(NOT keyword_set(header)) then header = dat_header(dd)
  end

 s = size(table)
 n_ftp = s[1]
 for i=0, n_ftp-1 do $
   if(call_function(table[i,0], $
             filename=filename, header=header)) then return, table[i,1]

 return, ''
end
;===========================================================================

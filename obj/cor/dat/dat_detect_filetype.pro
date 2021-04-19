;=============================================================================
;+
; NAME:
;	dat_detect_filetype
;
;
; PURPOSE:
;	Attempts to detect the type of the file (or header) associated with the
;	given data descriptor by calling the detectors in the filetype detectors 
;	table.  Detectors that crash are ignored and a warning is issued.  This
;	behavior is disabled if $OMINAS_DEBUG is set.
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
;			The default filetype is the first item in the table.
;
;	all:		If set, all filetypes in the table are returned.
;
;  OUTPUT: NONE
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
function dat_detect_filetype, dd, $
             filename=filename, header=header, all=all

 dat_sort_detectors, filetype_detectors=filetype_detectors

 if(keyword_set(dd)) then $
  begin
   if(NOT keyword_set(filename)) then filename = dat_filename(dd)
   if(NOT keyword_set(header)) then header = dat_header(dd)
  end
 if(NOT keyword_set(filename)) then filename = ''
 if(NOT keyword_set(header)) then header = ''

 return, dat_detect(dd, filetype_detectors, $
                               filename=filename, header=header, all=all)
end
;=============================================================================



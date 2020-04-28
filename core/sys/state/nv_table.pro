;=============================================================================
;+
; NAME:
;	nv_table
;
;
; PURPOSE:
;	Returns a configuration table.  Reads or constructs it if necessary.
;
;
; CATEGORY:
;	NV/SYS/STATE
;
;
; CALLING SEQUENCE:
;	table = nv_table(/<type>)
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	translator:	If set, the translator table is returned.
;
;	transform:	If set, the transform table is returned.
;
;	io:		If set, the io table is returned.
;
;	filetype:	If set, the filetype table is returned.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale: 2/2020
;	
;-
;=============================================================================



;=============================================================================
; nv_table_p
;
;=============================================================================
function nv_table_p, $
      instrument=instrument, translator=translator, transform=transform, io=io, filetype=filetype
@nv_block.common

 if(keyword_set(translator)) then return, nv_state.tr_table_p
 if(keyword_set(transform)) then return, nv_state.trf_table_p
 if(keyword_set(io)) then return, nv_state.io_table_p
 if(keyword_set(filetype)) then return, nv_state.ftp_table_p
 if(keyword_set(instrument)) then return, nv_state.ins_table_p

end
;===========================================================================



;=============================================================================
; nv_table_build
;
;=============================================================================
function nv_table_build

end
;===========================================================================



;=============================================================================
; nv_table
;
;=============================================================================
function nv_table, $
        instrument=instrument, translator=translator, transform=transform, io=io, filetype=filetype
@nv_block.common
@core.include
 
 env = nv_env_name(instrument=instrument, translator=translator, transform=transform, io=io, filetype=filetype)
 table_p = nv_table_p(instrument=instrument, translator=translator, transform=transform, io=io, filetype=filetype)


 return, *table_p
end
;===========================================================================

;=============================================================================
;+
; NAME:
;	nv_env_name
;
;
; PURPOSE:
;	Returns a the environment name of the specified table.
;
;
; CATEGORY:
;	NV/SYS/STATE
;
;
; CALLING SEQUENCE:
;	table = nv_env_name(/<type>)
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
;	translator:	If set, the translator environment name is returned.
;
;	transform:	If set, the transform environment name is returned.
;
;	io:		If set, the io environment name is returned.
;
;	filetype:	If set, the filetype environment name is returned.
;
;	detector:	If set, the detector environment name is returned.
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
function nv_env_name, translator=translator, transform=transform, $
               io=io, filetype=filetype, instrument=instrument, detector=detector

 if(keyword_set(translator)) then return, 'OMINAS_TRANSLATOR_TABLE'
 if(keyword_set(transform)) then return, 'OMINAS_TRANSFORM_TABLE'
 if(keyword_set(io)) then return, 'OMINAS_IO_TABLE'
 if(keyword_set(detector)) then return, 'OMINAS_DETECTORS'

end
;===========================================================================

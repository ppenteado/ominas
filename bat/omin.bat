;=============================================================================
;+
; NAME:
;	omin.bat
;
;
; PURPOSE:
;	Access to OMIN from the unix command line.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE (from the csh prompt):
;	ominas omin.bat -args files <keyvals>
;
;
; ARGUMENTS:
;  INPUT:
;	files:		One or more file specification strings following 
;			the standard csh rules.
;
;	keyvals:	Keyword-value pairs to be passed to OMIN.  
;
;
; RESTRICTIONS:
;	See ominas_description.txt
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	grim.bat brim.bat rim.bat
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale; 2/2020
;	
;-
;=============================================================================
!quiet = 1

___argv = bat_parse_argv(___keys, ___val_ps, $
                           list=___list, path=___path, samp=___samp, sel=___sel)
___filespecs = bat_expand(___argv, ___list, ___path, ___samp, ___sel)
if(keyword_set(___filespecs)) then ___files = findfiles(___filespecs, /tolerant)

call_procedure, 'omin', _extra=pp_build_extra(___keys,___val_ps), /bat

exit
;=============================================================================

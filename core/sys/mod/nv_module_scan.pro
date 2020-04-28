;==============================================================================
;+
; NAME:
;	nv_module_scan
;
;
; PURPOSE:
;	Scans for all OMINAS modules and builds the module tree.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_scan
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:  NONE
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		1/2020
;	
;-
;==============================================================================
pro nv_module_scan

 ominas_dir = getenv('OMINAS_DIR')

 tree = nv_module_add('OMINAS', ominas_dir)

end
;=============================================================================

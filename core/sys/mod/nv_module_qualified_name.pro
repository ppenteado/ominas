;==============================================================================
;+
; NAME:
;	nv_module_qualified_name
;
;
; PURPOSE:
;	Constructs a fully qualified module name.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	qname = nv_module_qualified_name(qname0, name)
;
;
; ARGUMENTS:
;  INPUT:
;	qname0:		Fully qualified name of parent.
;
;	name:		Module name.
;	
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:  Fully qualified module name.
;
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
function nv_module_qualified_name, qname0, name

 qname = ''
 if(NOT keyword_set(qname0)) then qname = name $
 else qname = qname0 + '.' + name

 return, strlowcase(qname)
end
;=============================================================================

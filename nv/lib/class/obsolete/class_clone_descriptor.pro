;=============================================================================
;+
; NAME:
;	class_clone_descriptor
;
;
; PURPOSE:
;	Calls the 'clone' method for objects of unspecified class.
;
;
; CATEGORY:
;	NV/LIB/CLASS
;
;
; CALLING SEQUENCE:
;	xd1 = class_clone_descriptor(xd)
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	 Descriptor to clone.
;
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
; RETURN: Newly allocated descriptor, identical to xd.
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
function class_clone_descriptor, xd
nv_message, /con, name='class_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'

 abbrev = cor_abbrev(xd[0])
 fn = abbrev + '_CLONE_DESCRIPTOR'

 return, call_function(fn, xd)
end
;===========================================================================




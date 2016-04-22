;=============================================================================
;+
; NAME:
;	class_copy_descriptor
;
;
; PURPOSE:
;	Calls the 'copy' method for objects of unspecified class.
;
;
; CATEGORY:
;	NV/LIB/CLASS
;
;
; CALLING SEQUENCE:
;	class_copy_descriptor, dst, src
;
;
; ARGUMENTS:
;  INPUT:
;	dst:	 Descriptor to copy to.
;
;	src:	 Descriptor to copy from.
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
; RETURN: NONE
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
pro class_copy_descriptor, dst, src
return, nv_copy, dst, src, noevent=noevent

 abbrev = cor_abbrev(dst[0])
 fn = abbrev + '_COPY_DESCRIPTOR'

 call_procedure, fn, dst, src
end
;===========================================================================




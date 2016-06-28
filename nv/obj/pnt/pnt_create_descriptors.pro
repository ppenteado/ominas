;=============================================================================
;+
; NAME:
;	pnt_create_descriptors
;
;
; PURPOSE:
;	Creates and initializes a POINT object.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ps = pnt_create_descriptors()
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
;	name:		Data set name.
;
;	desc:		Data set description.
;
;	input:		Description of input data used to produce these points.
;
;	points:		Image points.
;
;	vectors:	Inertial vectors.
;
;	flags:		Point-by-point flag array.
;
;	data:		Point-by-point data array.
;
;	tags:		Tags for point-by-point data.
;
;	assoc_xd:	Associated descriptor.
;
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Newly created and initialized POINT object.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function pnt_create_descriptors, n, crd=crd0, ptd=ptd0, $
@point__keywords.include
end_keywords
 if(NOT keyword_set(n)) then n = 1

 ptd = objarr(n)
 for i=0, n-1 do $
  begin

   ptd[i] = ominas_point(i, crd=crd0, ptd=ptd0, $
@point__keywords.include
end_keywords)

  end

 return, ptd
end
;===========================================================================




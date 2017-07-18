;=============================================================================
;+
; NAME:
;	cor_set_gd
;
;
; PURPOSE:
;	Sets the generic descriptor in a CORE object.
;
;
; CATEGORY:
;	NV/OBJ/COR
;
;
; CALLING SEQUENCE:
;	cor_set_gd, crd, gd
;
;
; ARGUMENTS:
;  INPUT:
;	crd:		CORE object.  The fields from any existing generic 
;			descriptor in this object are retained in the new one.
;			Only one object allowed.
;
;	gd:		New gd.  
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<x>d:		Input keyword for each descriptor type.
;
;	xds:		Array of objects to put in generic descriptor.  Generic
;			descriptors in these objects are considered as well.
;
;	noevent:	If set, no event is generated.
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
; SEE ALSO:
;	cor_gd
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2017
;	
;-
;=============================================================================
pro cor_set_gd, crd0, gd, xds=xds, noevent=noevent, direct=direct, _ref_extra=keys
@core.include

 _crd0 = cor_dereference(crd0)
 n = n_elements(_crd0)

 if(keyword_set(gd)) then xds = append_array(xds, cor_cat_gd(gd))	;;;
 gd0 = _cor_gd(_crd0)

 new_gd = cor_create_gd(xds, gd=gd0, _extra=keys)

 if(keyword_set(new_gd)) then _cor_set_gd, _crd0, new_gd

 cor_rereference, crd0, _crd0
 nv_notify, crd0, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================

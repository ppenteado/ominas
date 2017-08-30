;=============================================================================
; ominas_array::init
;
;=============================================================================
function ominas_array::init, ii, crd=crd0, ard=ard0, $
@arr__keywords_tree.include
end_keywords
@core.include
 
 if(keyword_set(ard0)) then struct_assign, ard0, self
 void = self->ominas_core::init(ii, crd=crd0, $
@cor__keywords.include
end_keywords)

 self.abbrev = 'ARR'
 self.tag = 'ARD'

 if(keyword__set(surface_pts)) then $
           self.surface_pts_p = nv_ptr_new(decrapify(surface_pts[*,*,ii]))


 return, 1
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	ominas_array__define
;
;
; PURPOSE:
;	Class structure for the ARRAY class.
;
;
; CATEGORY:
;	NV/LIB/arr
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	bd:	BODY class descriptor.  
;
;		Methods: arr_body, arr_set_body
;
;
;	surface_pts:	Vector giving the surface coordinates of the 
;			array points on the primary.  
;
;			Methods: arr_surface_pts, arr_set_surface_pts
;
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2012
; 	Adapted by:	Spitale, 5/2016
;-
;=============================================================================
pro ominas_array__define

 struct = $
    { ominas_array, inherits ominas_core, $
	surface_pts_p:	 ptr_new() $		; Surface coords of location.
    }

end
;===========================================================================




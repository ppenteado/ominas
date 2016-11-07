;=============================================================================
; ominas_station::init
;
;=============================================================================
function ominas_station::init, ii, crd=crd0, bd=bd0, std=std0, $
@stn__keywords.include
end_keywords
@core.include
 
 void = self->ominas_body::init(ii, crd=crd0, bd=bd0,  $
@bod__keywords.include
end_keywords)
 if(keyword_set(bd0)) then struct_assign, bd0, self

 self.abbrev = 'STN'

 if(keyword__set(primary)) then self.__PROTECT__primary = decrapify(primary[ii])
 if(keyword__set(surface_pt)) then self.surface_pt = decrapify(surface_pts[*,*,ii])


 return, 1
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	ominas_station__define
;
;
; PURPOSE:
;	Class structure for the STATION class.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	bd:	BODY class descriptor.  
;
;		Methods: stn_body, stn_set_body
;
;
;	primary:	Primary body descriptor.
;
;			Methods: stn_primary, stn_set_primary
;
;	surface_pt:	Vector giving the surface coordinates of the 
;			stations location on the primary.  This 
;			is redundant with the location of bd, but it 
;			allows one to compute map coordinates without
;			a body descriptor present.
;
;			Methods: stn_surface_pt, stn_set_surface_pt
;
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro ominas_station__define

 struct = $
    { ominas_station, inherits ominas_body, $
	surface_pt:	 dblarr(1,3), $		; Surface coords of location.
        __PROTECT__primary:     obj_new() $	; primary pd
    }

end
;===========================================================================




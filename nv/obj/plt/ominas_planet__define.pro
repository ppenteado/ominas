;=============================================================================
; ominas_planet::init
;
;=============================================================================
function ominas_planet::init, ii, crd=crd0, bd=bd0, sld=sld0, gbd=gbd0, pd=pd0, $
@plt__keywords.include
end_keywords
@core.include
 
 void = self->ominas_globe::init(ii, crd=crd0, bd=bd0, sld=sld0, gbd=gbd0, $
@glb__keywords.include
end_keywords)
 if(keyword_set(pd0)) then struct_assign, pd0, self

 self.abbrev = 'PLT'

 return, 1
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	ominas_planet__define
;
;
; PURPOSE:
;	Class structure for the PLANET class.
;
;
; CATEGORY:
;	NV/LIB/PLT
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	gbd:	GLOBE class descriptor.  
;
;		Methods: str_globe, str_set_globe
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
pro ominas_planet__define

 struct = $
    { ominas_planet, inherits ominas_globe $
    }

end
;===========================================================================




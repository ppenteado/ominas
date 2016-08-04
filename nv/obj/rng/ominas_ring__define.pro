;=============================================================================
; ominas_ring::init
;
;=============================================================================
function ominas_ring::init, ii, crd=crd0, bd=bd0, sld=sld0, dkd=dkd0, rd=rd0, $
@ring__keywords.include
end_keywords
@core.include
 
 void = self->ominas_disk::init(ii, crd=crd0, bd=bd0, sld=sld0, dkd=dkd0, $
@disk__keywords.include
end_keywords)
 if(keyword_set(rd0)) then struct_assign, rd0, self

 self.abbrev = 'RNG'

 if(keyword__set(primary)) then self.__PROTECT__primary = decrapify(primary[ii])
 if(keyword__set(desc)) then self.desc = decrapify(desc[ii])

 return, 1
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	ominas_ring__define
;
;
; PURPOSE:
;	Class structure for the RING class.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	dkd:	DISK class descriptor.  
;
;		Methods: rng_disk, rng_set_disk
;
;
;	primary:	Primary body descriptor.
;
;			Methods: rng_primary, rng_set_primary
;
;	desc:	String giving the description of the ring.  Valid values
;		are 'EDGE', 'PEAK', 'TROUGH'.
;
;		Methods: rng_desc, rng_set_desc
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
pro ominas_ring__define

 struct = $
    { ominas_ring, inherits ominas_disk, $
	desc:			'', $		; 'EDGE', 'PEAK', 'TROUGH'
        __PROTECT__primary:     obj_new() $	; primary pd
    }

end
;===========================================================================




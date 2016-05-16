;=============================================================================
;+
; NAME:
;       dlon_to_daz
;
;
; PURPOSE:
;	Computes azimuths relative to a given observer descriptor.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = dlon_to_daz(dlon, dkx, od)
;
;
; ARGUMENTS:
;  INPUT:
;	dlon:	Longitude.
;
;	dkx:	Disk descriptor.
;
;	od:	Object descriptor (subclass of BODY) describing the observer.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT: NONE
;
;   OUTPUT: NONE
;
;
; RETURN:
;       An array of azimuths.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function dlon_to_daz, dlon, dkx, od

 n = n_elements(dlon)

 vref_inertial = get_disk_ref(dkx, od)
 vref_disk = dsk_body_to_disk(dkx, $
               bod_inertial_to_body(dkx, vref_inertial))

 dlon_ref = vref_disk[*,1]

 daz = dlon - make_array(n, val=dlon_ref[0])

 return, daz
end
;===========================================================================

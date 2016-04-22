;=============================================================================
;+
; NAME:
;       plt_globe
;
;
; PURPOSE:
;       Returns a globe descriptor for each given planet descriptor.
;
;
; CATEGORY:
;       NV/LIB/PLT
;
;
; CALLING SEQUENCE:
;       gbd = plt_globe(pd)
;
;
; ARGUMENTS:
;  INPUT:
;       pd:    Array (nt) of planet descriptors
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;         NONE
;
; RETURN:
;       An array (nt) of globe descriptors.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale; 1/1998
;
;-
;=============================================================================
function plt_globe, pxp, noevent=noevent
@nv_lib.include
 pdp = class_extract(pxp, 'PLANET')
 nv_notify, pdp, type = 1, noevent=noevent
 pd = nv_dereference(pdp)
 return, pd.gbd
end
;===========================================================================




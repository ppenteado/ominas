;=============================================================================
;+
; NAME:
;       naif_pckobj
;
;
; PURPOSE:
;       Like cspice_spkobj and cspice_ckobj, but for pcks.  Intended to be
;	replaced whenever NAIF adds this functionality to the toolkit.
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       ids = naif_pckobj(pck)
;
;
; ARGUMENTS:
;  INPUT:
;	pck:		Name of a NAIF pck file.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: Body ids
;
;
; STATUS:
;       Complete
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale      2/2020
;-
;=============================================================================
function naif_pckobj, pck

 ;----------------------------------------------------
 ; get all BODY variables in the file
 ;----------------------------------------------------
 vals = naif_kernel_value(pck, 'BODY*', keys=keys)

 ;----------------------------------------------------
 ; extract unique body ids
 ;----------------------------------------------------
 ss = str_nnsplit(keys, '_')
 ids = unique(strmid(ss, 4, 128))

 return, ids
end
;=============================================================================

; pck = '/home/spitale/ominas_data/trs/cas/kernels/pck/cpck_rock_01Oct2007.tpc'
; ids = naif_pckobj(pck)


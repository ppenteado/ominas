;=============================================================================
;++
; NAME:
;	orient_to_cmat
;
;
; PURPOSE:
;	xx
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; PROCEDURE:
;	The appropriate conversion routine is called based on the instrument
;	field in the data desciptor.
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	cmat_to_orient
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002
;	
;-
;=============================================================================
function orient_to_cmat, dd, orient

 cam_name = dat_instrument(dd)

 case strmid(cam_name, 0, 3) of $
  'CAS' : return, cas_orient_to_cmat(orient)
;  'GLL' : return, gll_orient_to_cmat(orient)
;  'VGR' : return, vgr_orient_to_cmat(orient)
   default : nv_message, name='orient_to_cmat', $
                               'Instrument  ' + cam_name + ' not supported.'
 endcase

end
;=============================================================================

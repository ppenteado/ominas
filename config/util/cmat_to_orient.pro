;=============================================================================
;++
; NAME:
;	cmat_to_orient
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
; STATUS:
;	xx
;
;
; SEE ALSO:
;	orient_to_cmat
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002
;	
;-
;=============================================================================
function cmat_to_orient, dd, cmat

 cam_name = dat_instrument(dd)

 case strmid(cam_name, 0, 3) of $
  'CAS' : return, cas_cmat_to_orient(cmat)
;  'GLL' : return, gll_cmat_to_orient(cmat)
;  'VGR' : return, vgr_cmat_to_orient(cmat)
   default : nv_message, name='cmat_to_orient', $
                               'Instrument  ' + cam_name + ' not supported.'
 endcase


end
;=============================================================================

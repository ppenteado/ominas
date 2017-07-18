;=============================================================================
;+
; NAME:
;       stereo_split
;
;
; PURPOSE:
;       Splits a given camera descriptor into a stereo pair.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       cds = stereo_split(cd, sep=sep)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;  OUTPUT: NONE
;
;
; KEYOWRDS:
;  INPUT: 
;       sep:	Separation distance of output descriptors.
;
;  OUTPUT: NONE
;
; RETURN: 
;	Array (2) giving the left and right camera descriptors.
;	Each descriptor is cloned from the input descripor, and has
;	been translated +/- sep/2 in the camara body 0-axis direction.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function stereo_split, cd, sep=sep

 sep2 = sep[0]/2.

 cds = [nv_clone(cd), nv_clone(cd)]
 xx = (bod_orient(cd))[0,*,*]

 bod_set_pos, cds[0], bod_pos(cd) - xx*sep2
 bod_set_pos, cds[1], bod_pos(cd) + xx*sep2

 return, cds
end
;=============================================================================

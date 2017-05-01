;=============================================================================
;+
; NAME:
;	bod_inertial
;
;
; PURPOSE:
;	Returns body descriptors defining te inertial coordinate system.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bd = bod_inertial()
;
;
; ARGUMENTS:
;  INPUT: 
;	nt : number of desriptors to return.
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
; RETURN:
;	Body descriptor defining the inertial frame.  Note this descriptor is
;	not allocated on the heap, so it should not be freed by the caller.
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
function bod_inertial, nt
common bod_inertial_block, bd
@core.include

 if(NOT keyword_set(nt)) then nt = 1

 if(NOT keyword__set(bd)) then $
  begin 
   orient = dblarr(3,3)
   orient[0,*] = [1,0,0]
   orient[1,*] = [0,1,0]
   orient[2,*] = [0,0,1]

   bd = bod_create_descriptors(1, name='INERTIAL FRAME', orient=orient)
  end


 return, make_array(nt, val=bd)
end
;===========================================================================

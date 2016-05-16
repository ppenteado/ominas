;=============================================================================
;+
; NAME:
;	pg_repoint
;
;
; PURPOSE:
;	Modifies the camera orientation matrix based on the given image
;	coordinate translation and rotation.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_repoint, cd=cd, dxy, dtheta, axis_ptd=axis_ptd
;	pg_repoint, gd=gd, dxy, dtheta, axis_ptd=axis_ptd
;
;
; ARGUMENTS:
;  INPUT:
;	dxy:		Array (2,1,nt) or (2,1) specifying the
;			translation as [dx,dy] in pixels.
;
;	dtheta:		Array (nt) specfying the rotation angle in radians.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	 Array (nt) of camera descriptors.
;
;	gd:	 Generic descriptor.  If given, the cd input is taken from the
;		 cd field of this structure instead of from that keyword.
;
;	axis_ptd: POINT containing a single image point
;		 to be used as the axis of rotation.  Default is the camera
;		 optic axis.
;
;	bore_cd:  Array (nt) of camera descriptors from which to copy the 
;		  new orientation instead of using dxy, dtheta, and axis_ptd.
;
;	bore_rot: If given, the orientation from bore_cd will be rotated
;		  using this rotation matrix (3,3) before being copied.
;
;	bore_dxy: Boresight offset in pixels.
;
;	absolute: If set, the dxy argument represents and abosolute image
;		  position rather than an offset.
;
;  OUTPUT:
;	cd:	 If given, the camera descriptor is modified with a new
;		 orientation matrix.
;
;	gd:	 If given in this way, the camera descriptor contained in the
;		 generic descriptor is modified with a new orientation matrix.
;
;
; RETURN: NONE
;
;
; SIDE EFFECTS:
;	pg_repoint adds its name to the task list of each given camera
;	descriptor.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_fit, pg_drag
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
pro pg_repoint, cd=cd, gd=gd, _dxy, _dtheta, axis_ptd=axis_ptd, $
                bore_cd=bore_cd, bore_rot=bore_rot, bore_dxy=bore_dxy, $
		absolute=absolute


 dxy = 0
 if(keyword_set(_dxy)) then dxy = _dxy

 dtheta = 0
 if(keyword_set(_dtheta)) then dtheta = _dtheta


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(keyword__set(gd)) then if(NOT keyword__set(cd)) then $
  begin
   cd=gd.cd
;   use_gd=1
  end

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(cd)


 ;---------------------------------------
 ; check for boresight cd
 ;---------------------------------------
 if(keyword__set(bore_cd)) then $
  begin
   bore_orient = bod_orient(bore_cd)
   if(NOT keyword_set(bore_rot)) then orient = bore_orient $
   else orient = v_mxm(bore_rot[linegen3z(3,3, nt)], bore_orient)
   bod_set_orient, cd, orient

   if(keyword_set(bore_dxy)) then $
     dxy = dxy + bore_dxy*cam_scale(bore_cd)/cam_scale(cd)
  end 
 
 if(keyword_set(dxy)) then $
  begin
   ;-----------------------------------
   ; check number of parameters
   ;-----------------------------------
   if(n_elements(dtheta) EQ 1) then dtheta = replicate(dtheta[0], nt) 
   if(n_elements(dxy) EQ 2) then dxy = dxy[linegen3z(2,1,nt)]


   ;------------------------------------------------
   ; modify camera pointing for all times
   ;------------------------------------------------
   if(keyword__set(axis_ptd)) then axis = pnt_points(axis_ptd) $
   else axis = cam_oaxis(cd)
   cam_reorient, cd, axis, dxy[*,0,*], dtheta[*], absolute=absolute
  end


 cor_add_task, cd, 'pg_repoint'



end
;=============================================================================

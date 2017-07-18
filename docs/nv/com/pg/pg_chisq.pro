;=============================================================================
;+
; NAME:
;	pg_chisq
;
;
; PURPOSE:
;	Computes chi-squared value for given curve- or point-fit parameters.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	chisq = pg_chisq(dxy, dtheta, scan_ptd, axis_ptd=axis_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	dxy:		2-element vector giving the translation as [dx,dy].
;
;	dtheta:		Rotation in radians.
;
;	scan_ptd:	Array (n_curves) of POINT objects output from
;			pg_cvscan or pg_ptscan containing scan data.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	axis_ptd:	POINT object containing a single image point
;			to be used as the axis of rotation.
;
;	fix:		Array specifying which parameters to fix as
;			[dx,dy,dtheta].
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Normalized chi-square value.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_cvscan, pg_cvscan_coeff, pg_cvchisq, pg_ptscan, pg_ptscan_coeff,
;	pg_ptchisq, pg_fit, pg_threshold
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2002
;	
;-
;=============================================================================
function pg_chisq, dxy, dtheta, scan_ptd, axis_ptd=axis_ptd, fix=fix
                 
 n_objects = n_elements(scan_ptd)
 chisq = 0d
 n = 0

 nfix = n_elements(fix)

 axis = dblarr(2)
 if(keyword__set(axis_ptd)) then axis = pnt_points(axis_ptd)


 ;===============================================
 ; compute chi-squared for each object
 ;===============================================
 for i=0, n_objects-1 do $
  begin
   ;-------------------
   ; get scan data
   ;-------------------
   pnt_query, scan_ptd[i], data=scan_data, desc=desc, points=scan_pts, /visible

   if(keyword__set(scan_data)) then $
    begin
     n = n + n_elements(scan_pts)/2

     ;----------------------
     ; curve scan data
     ;----------------------
     if(desc EQ 'cvscan') then $
      begin
       cos_alpha = scan_data[0,*]
       sin_alpha = scan_data[1,*]
       scan_offsets = scan_data[2,*]

       chisq = chisq + icv_chisq(dxy, dtheta, fix, $
                        cos_alpha, sin_alpha, scan_offsets, scan_pts, axis)
      end $
     ;----------------------
     ; point scan data
     ;----------------------
     else if(desc EQ 'ptscan') then $
      begin
       dx = scan_data[0]
       dy = scan_data[1]

       chisq = chisq + ipt_chisq(dxy, dtheta, fix, dx, dy, scan_pts, axis)
      end $
     else nv_message, 'Invalid data set.'

    end
  end


 ;--------------------------
 ; normalize
 ;--------------------------
 chisq = chisq / (n - nfix)


 return, chisq
end
;===========================================================================

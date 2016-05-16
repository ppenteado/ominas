;=============================================================================
;+
; NAME:
;	pg_ptchisq
;
;
; PURPOSE:
;	Computes chi-squared value for given point fit parameters.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	chisq = pg_ptchisq(dxy, dtheta, scan_ptd, axis_ptd=axis_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	dxy:		2-element vector giving the translation as [dx,dy].
;
;	dtheta:		Rotation in radians.
;
;	scan_ptd:	Array (n_points) of POINT output from
;			pg_ptscan containing scanned image points as well as
;			other necessary scan data.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	axis_ptd:	POINT containing a single image  point
;			to be used as the axis of rotation.
;
;	fix:		Array specifying which parameters to fix as
;			[dx,dy,dtheta].
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Single chi-square values for totality of points.
;
;
; RESTRICTIONS:
;	The caller is responsible for ensuring that the input parameters are
;	consistent with those used with other programs like pg_fit.
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
; 	Written by:	Haemmerle, 12/1998
;	
;-
;=============================================================================
function pg_ptchisq, dxy, dtheta, scan_ptd, axis_ptd=axis_ptd, fix=fix
                 

 n_points=n_elements(scan_ptd)
 pts_dx = dblarr(n_points)
 pts_dy = dblarr(n_points)
 pts = dblarr(2,n_points)
 valid = intarr(n_points)

 for i=0, n_points-1 do $
  begin
   ;-------------------
   ; get scan data
   ;-------------------
   pnt_get, scan_ptd[i], data=pts_data, points=pts_pts, /visible

   if(NOT keyword__set(pts_data)) then valid[i] = 0 $
   else $
    begin

     valid[i] = 1
     pts_dx[i] = pts_data[0]
     pts_dy[i] = pts_data[1]
     pts[*,i] = pts_pts[*]

    end
  end

  axis=dblarr(2)
  if(keyword__set(axis_ptd)) then axis = pnt_points(axis_ptd)

  ;----------------------
  ; compute chi-squared
  ;----------------------
  subs = where(valid EQ 1)
  pts_dx = pts_dx[subs]
  pts_dy = pts_dy[subs]
  pts = pts[0:1,subs]
  chisq = ipt_chisq(dxy, dtheta, fix, pts_dx, pts_dy, pts, axis)

 return, chisq
end
;===========================================================================

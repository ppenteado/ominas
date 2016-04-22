;=============================================================================
;+
; NAME:
;	pg_cvscan_coeff
;
;
; PURPOSE:
;	Computes linear least-squares coefficients for a fit to the image
;	coordinate translation and rotation that matches a computed curve to
;	a scanned curve in an image.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	scan_cf = pg_cvscan_coeff(scan_ps, axis_ps=axis_ps)
;
;
; ARGUMENTS:
;  INPUT:
;	scan_ps:	Array (n_curves) of points_struct output from
;			pg_cvscan containing scanned image points as well as
;			other necessary scan data.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	axis_ps:	points_struct containing a single image  point
;			to be used as the axis of rotation in the fit for
;			every curve.
;
;	fix:		Array specifying which parameters to fix in the
;			fit as [dx,dy,dtheta].
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n_curves) of pg_fit_coeff_struct containing coefficients for 
;	the least-square fit to be input to pg_fit.
;
;
; RESTRICTIONS:
;	Currently does not work for multiple time steps.
;
;
; PROCEDURE:
;	pg_cvscan_coeff extracts the scan data from the given
;	scan_ps structure and uses icv_coeff to compute the coefficients.  
;	See the documentation for that routine for details.
;
;
; EXAMPLE:
;	The following command uses scan data from pg_cvscan to compute
;	least square coefficients for a fit such that only dx and dtheta
;	will be allowed to vary: 
;
;	cvscan_cf = pg_cvscan_coeff(scan_ps, axis=center_ps, fix=[1])
;
;	In this call, scan_ps is a points_struct containing the scan data
;	from pg_cvscan and center_ps is a points_struct giving the center
;	of the planet as computed by pg_center.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_cvscan, pg_cvchisq, pg_ptscan, pg_ptscan_coeff, pg_ptchisq, 
;	pg_fit, pg_threshold
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function pg_cvscan_coeff, scan_ps, axis_ps=_axis_ps, fix=fix
       
 if(keyword_set(_axis_ps)) then $
  begin     
   if(size(_axis_ps, /type) NE 10) then axis_ps = ps_init(points=_axis_ps) $ 
   else axis_ps = _axis_ps
  end

 n_objects=n_elements(scan_ps)
 scan_cf=replicate({pg_fit_coeff_struct}, n_objects)

 n_scans=0

 ;===============================================
 ; compute coefficients for each object
 ;===============================================
 for i=0, n_objects-1 do $
  begin
   ps_get, scan_ps[i], data=scan_data, points=scan_pts, /visible

   ;---------------------------------------------------------------
   ; if scan data exists, compute the least-squares coefficients
   ;---------------------------------------------------------------
   if(keyword_set(scan_data)) then $
    begin
     n_scans=n_scans+1
     cos_alpha = scan_data[0,*]
     sin_alpha = scan_data[1,*]
     scan_offsets = scan_data[2,*]
     scan_sigma = scan_data[4,*]

     axis = dblarr(2)
     if(keyword_set(axis_ps)) then axis = ps_points(axis_ps)
     icv_coeff, cos_alpha, sin_alpha, scan_offsets, scan_pts, axis, $
               sigma=scan_sigma, M=M, b=b

     ;--------------------------------------
     ; fix the specified rows and columns
     ;--------------------------------------
     if(keyword__set(fix)) then $
      begin
       nfix = n_elements(fix)

       for j=0, nfix-1 do $
        begin
         w = where([0,1,2] NE fix[j])
         M[fix[j],w] = 0. & M[w,fix[j]] = 0.
         M[fix[j],fix[j]] = 1.
        end

       b[fix] = 0.
      end
    end $
   ;---------------------------------------------------------------
   ; otherwise, set all coefficients to zero so that they do not
   ; contribute to a simultaneous fit
   ;---------------------------------------------------------------
   else $
    begin
     M = dblarr(3,3)
     b = dblarr(1,3)
    end

   ;--------------------
   ; save the scan data
   ;--------------------
   scan_cf[i].M=M
   scan_cf[i].b=b
  end



 ;---------------------------
 ; error if no scans exist
 ;---------------------------
 if(n_scans EQ 0) then nv_message, name='pg_cvscan_coeff', $
                                      'No scan data available - use pg_cvcsan.'



 return, scan_cf
end
;===========================================================================

;=============================================================================
;+
; NAME:
;	pg_residuals
;
;
; PURPOSE:
;	Computes residuals value for given curve- or point-fit parameters.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	chisq = pg_residuals(scan_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	scan_ptd:	Array (n_curves) of POINT output from
;			pg_cvscan or pg_ptscan containing scan data.
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
;	Array (2,n_curves) of residuals.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function pg_residuals, scan_ptd
                 

 n_objects = n_elements(scan_ptd)
 resx = 0d
 resy = 0d

 ;===============================================
 ; compute chi-squared for each object
 ;===============================================
 for i=0, n_objects-1 do $
  begin
   ;-------------------
   ; get scan data
   ;-------------------
   pnt_get, scan_ptd[i], data=scan_data, desc=desc, points=scan_pts, /visible

   if(keyword__set(scan_data)) then $
    begin
     ;----------------------
     ; curve scan data
     ;----------------------
     if(desc EQ 'cvscan') then $
      begin
       model_pts = scan_data[5:6,*]
       _resx = tr(model_pts[0,*] - scan_pts[0,*])
       _resy = tr(model_pts[1,*] - scan_pts[1,*])
       resx = [resx, _resx]
       resy = [resy, _resy]
      end $
     ;----------------------
     ; point scan data
     ;----------------------
     else if(desc EQ 'ptscan') then $
      begin
       dx = scan_data[0]
       dy = scan_data[1]

       resx = [resx, dx]
       resy = [resy, dy]
      end $
     else nv_message, 'Invalid data set.'

    end
  end


 res = [tr(resx[1:*]), tr(resy[1:*])]


 return, res
end
;===========================================================================

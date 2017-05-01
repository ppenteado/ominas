;=============================================================================
;+
; NAME:
;	pg_ptfarscan
;
;
; PURPOSE:
;	Attempts to find all occurrences of a model in an image.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_ptfarscan(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;       model:          Point spread model to be used in correlation.  If
;                       not given a default gaussian is used.
;
;	wmod:		x, ysize of default gaussian model.
;
;	wpsf:		Half width of default gaussian psf model.
;
;       edge:           Distance from edge from which to ignore points.  If
;                       not given, an edge distance of 0 is used.
;
;       gdmax:		If given, the maximum gradiant of correlation coefficient 
;			to accept. 
;
;       ccmin:          Minimum correlation to consider in search.  Default
;			is 0.8.
;
;       gdmax:          If given, points where the gradient of the
;                       correlation function is higher than this value
;			are not considered in the search.
;
;	sky:		If set, it is assumed that the image contains only
;			point sources and sky.  Any object more than nsig
;			standard deviations above the image mean are
;			selected as candidates. 
;
;	nsig:		For use with the /sky option, standard deviation 
;			threshold for detecting point sources.
;
;	nmax:		Max. number of point sources to return.  If more
;			are found, nsig is raised until thiws is satisified.
;
;	smooth:		If given, the input image is smoothed using
;			this width before any further processing.
;
;	median:		If given, the input image is filtered using
;			a median filter of this width before any further
;			processing.
;
;	mask:		If set, an attempt is made to mask out extended
;			objects before performing the scan
;
;	extend:		If nonzero, star masks are extended by this
;			many pixels in all directions.
;
;	name:		Name to use for the returned POINT objects.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	An array of type POINT giving the detected position for
;       each object.  The correlation coeff value for each detection is
;       saved in the data portion of POINT with tag 'scan_cc'.
;
;
; SEE ALSO:
;	pg_ptscan
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale 2/2004 
;	
;-
;=============================================================================
function pg_ptfarscan, dd, name=name, $
                    model=model, $
                    edge=edge, ccmin=ccmin, gdmax=gdmax, $
                    smooth=smooth, wmod=wmod, wpsf=wpsf, $
                    sky=sky, nsig=nsig, median=median, $
                    mask=mask, extend=extend, nmax=nmax, chifit=chifit
@pnt_include.pro

 if(NOT keyword__set(ccmin)) then ccmin = 0.8
 if(NOT keyword__set(nsig)) then nsig = 3d
 if(NOT keyword__set(wmod)) then wmod = 15
 if(NOT keyword__set(wpsf)) then wpsf = 1.3
 
 image = dat_data(dd)
 
 if(keyword__set(smooth)) then image = smooth(_image, smooth)
 if(keyword__set(median)) then _image = median(_image, median)

 s=size(_image)

 ;-----------------------------------
 ; default edge offset is 0 pixels
 ;-----------------------------------
 if(NOT keyword__set(edge)) then edge = 0

 if(keyword__set(sky)) then $
  begin
   sm = size(model)
   points = sky_points(image, nsig, wmod, extend=extend, mask=mask, nmax=nmax)
  end $
 else $
  begin
   ;----------------------------------
   ; use default model if none given
   ;----------------------------------
   if(NOT keyword__set(model)) then model = gauss_2d(0, 0, wpsf, wmod, wmod)
   sm = size(model)

   ;----------------------------------
   ; scan for candidates
   ;----------------------------------
   points = modloc(image, model, edge=edge, ccmin=ccmin, gdmax=gdmax)
  end


 if(keyword_set(chifit)) then $
  begin
  end

 if(NOT keyword__set(points)) then return, 0


 ;----------------------------------------
 ; remove points too close to the edge
 ;----------------------------------------
 if(keyword_set(edge)) then $
  begin
   s = size(image)
   w = where((points[0,*] LT s[1]-edge) AND $
             (points[0,*] GT edge) AND $
             (points[1,*] LT s[2]-edge) AND $
             (points[1,*] GT edge))
   if(w[0] EQ -1) then return, 0
   points = points[*,w]
  end


 n = n_elements(points)/2
 pts_ptd = objarr(n)

 for i=0, n-1 do $
  begin
   pnt_assign, pts_ptd[i], points = points[*,i], name = name, desc = 'ptfarscan'
  end


 return, pts_ptd
end
;===========================================================================

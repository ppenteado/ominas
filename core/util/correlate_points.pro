;=============================================================================
;+
; NAME:
;	correlate_points
;
;
; PURPOSE:
;	Searches for offset dxy that translates a set of model points so as 
;	to obtain the maximum correlation with a set of base points.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = correlate_points(base_pts, model_pts)
;
;
; ARGUMENTS:
;  INPUT:
;	base_pts:	Array (2,nbase) of points to remain stationary. 
;
;	model_pts:	Array (2,nmodel) of points to be offset.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	bin:		Initial point density bin size.  Default is 100.  See
;			procedure below.
;
;	nsamples:	Number of samples in each direction in the grid search. 
;			See image_correlate.
;
;	show:		If set, the grid search is displayed.  See
;			image_correlate.
;
;	xsize,ysize:	Dimensions of image from which points were extracted.
;
;	max_density:	Maximum model point density.  Default = 5.
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	2-element array giving the offset [dx,dy] that shifts the model points
;	so as to obtain the maxmimum correlation between the two sets of points.
;
;
; PROCEDURE:
;	The points are fit by using image_correlate to align point-density maps
;	of the two arrays of points using a successively smaller bin size,
;	starting with that given by the 'bin' keyword.  The search grid is
;	narrowed as the bin size is reduced.  The procedure is repeated until
;	the bin size falls below one pixel.
;
;
; STATUS:
;	Complete, but simulated annealing might be a better approach in some
;	cases.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 4/2002
;	
;-
;=============================================================================
function correlate_points, base_pts, _model_pts, nsamples=nsamples, show=show, $
                   xsize=xsize, ysize=ysize, bin=bin, max_density=max_density, $
                   region=region, sigma_x=sigma_x, sigma_y=sigma_y, cc=cc, $
                   mcc=mcc, bias=bias, nosearch=nosearch

 if(NOT keyword__set(nsamples)) then nsamples = [4,4]

 nbase = n_elements(base_pts)/2
 nmodel = n_elements(_model_pts)/2

 if(NOT keyword__set(bin)) then bin = 100
 bin = long(bin)

 if(NOT keyword__set(max_density)) then max_density = 5
 if(NOT keyword__set(bias)) then bias = 0d

 ;-------------------------------------------------------------------
 ; find offset that maximizes correlation of point density functions
 ;-------------------------------------------------------------------
 model_pts = dblarr(2,nmodel)
 dmodel_pts = dblarr(2,nmodel)
 dxy = dblarr(2)
 break = 0

 if(keyword__set(nosearch)) then $
  begin
   break = 1
   bin = 1
  end

 repeat $
  begin
   model_pts[0,*] = _model_pts[0,*] + dxy[0]
   model_pts[1,*] = _model_pts[1,*] + dxy[1]
   ;-------------------------------------------------
   ; compute point densities
   ;-------------------------------------------------
   base_density = hist_2d(base_pts[0,*], base_pts[1,*], $
			bin1 = bin, bin2 = bin, $
			min1 = 0, max1 = xsize-1, min2 = 0, max2 = ysize-1)
   model_density = hist_2d(model_pts[0,*], model_pts[1,*], $
			bin1 = bin, bin2 = bin, $
			min1 = -bin, max1 = xsize-1+bin, $
                        min2 = -bin, max2 = ysize-1+bin)
   s = size(model_density)
   model_density = model_density[1:s[1]-2, 1:s[2]-2] < max_density
   base_density = base_density < max_density

   ;------------------------------------------------------
   ; obtain an offset by correlating density maps
   ;------------------------------------------------------
   no_width = 0
   if(bin GT 1) then no_width = 1 $
   else nsamples = [5,5]

   if(bin LE 5) then bias = 0
   offset = image_correlate(base_density, model_density, cc, bias=bias/bin, $
                       wx=sigma_x, wy=sigma_y, no_width=no_width, $
                       region=region, nsamples=nsamples, show=show, data=data, $
                       nosearch=nosearch)
   dxy = dxy + offset * bin

   bin = bin/2
   region=[10d,10d]
;   region=[5d,5d]


  endrep until((bin LT 1) OR break)

 ;-----------------------------------------------------
 ; compute correlation at only model points
 ;-----------------------------------------------------
 w = where(model_density EQ 0) 
 base_density[w] = 0
 mcc = cr_correlation(base_density, model_density, [0,0], /norm)


 return, dxy[*,0]
end
;=============================================================================

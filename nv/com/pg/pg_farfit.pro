;=============================================================================
;+
; NAME:
;	pg_farfit
;
;
; PURPOSE:
;	Searches for the offset (dx,dy) that gives the best agreement between
;	two uncorrelated sets of image points.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	dxy = pg_farfit(dd, base_ps, model_ps)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	base_ps:	points_struct giving a set of points to fit to.
;			This input may be produced by pg_edges, for example. 
;
;	model_ps:	Array of points_struct giving model points (computed
;			limb points for example).
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	show:		If specified, the search is displayed in the current 
;			graphics window.  This value can be specified as a
;			2-element array giving the size of the displayed image.
;
;	bin:		Initial bin size for point densities.  Default is 50
;			pixels.
;
;	max_density:	Maximum model point density.  Default = 5.
;
;	nsamples:	Number of samples in each direction in the grid search. 
;			See image_correlate.
;
;	region:		Size of region to scan, centered at offset [0,0].  If not
;			specified, the entire image is scanned.
;
;	sigma:		2-element array giving the width of the correlation
;			peak in each direction.
;
;	cc:		Cross correlation of final result.
;
;	mcc:		Corss correlation at the model points.
;
;	bias:		If given, solutions are biased toward the initial
;			guess using a weighting function of the form:
;
;				exp(-r^2/2*bias),
;
;			where r is the distance between from the initial 
;			guess.
;
;	nosearch:	If set, no search is performed.  An offset of [0,0]
;			is returned.	
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	2-element array giving the fit offset as [dx,dy].
;
;
; PROCEDURE:
;	pg_farfit is a wrapper for the routine correlate_points.  See the
;	documentation for that routine for details on the fitting procedure 
;
;
; STATUS:
;	Complete.
;
;
; SEE ALSO:
;	pg_edges correlate_points
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 4/2002
;	
;-
;=============================================================================
function pg_farfit, dd, base_ps, model_ps, nsamples=nsamples, show=show, $
                          bin=bin, max_density=max_density, region=region, $
                          sigma=sigma, cc=cc, mcc=mcc, bias=bias, $
                          nosearch=nosearch


 ;------------------------------------------------------------
 ; dereference points structs
 ;------------------------------------------------------------
 base_pts = pg_points(base_ps)
 model_pts = pg_points(model_ps)
 if(NOT keyword__set(model_pts)) then nv_message, name='pg_farfit', $
                                                   'No visible model points.'

 nbase = n_elements(base_pts)/2
 nmodel = n_elements(model_pts)/2

 im = nv_data(dd)
 s = size(im)
 im = 0

 ;------------------------------------------------------------
 ; find optimum offset by correlating point densities
 ;------------------------------------------------------------
 dxy = correlate_points(base_pts, model_pts, bin=bin, max_density=max_density, $
                        nsamples=nsamples, show=show, xsize=s[1], ysize=s[2], $
                        region=region, sigma_x=sigma_x, sigma_y=sigma_y, $
                        cc=cc, mcc=mcc, bias=bias, nosearch=nosearch)
 if(keyword__set(sigma_x)) then sigma = [sigma_x, sigma_y]

 return, dxy
end
;=============================================================================

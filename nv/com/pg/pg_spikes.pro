;=============================================================================
;+
; NAME:
;	pg_spikes
;
;
; PURPOSE:
;	Locates spurious features like cosmic-ray hits.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_spikes(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor containing the image to be despiked.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	nsig:		Number of standard deviations above the local
;			mean data value to flag for removal.  Default is 2.
;
;	grad:		Minimum data value gradient to use when searching
;			for clusters of hot pixels.  Default is 5.
;
;	umask:		Byte image of the same size as the input image
;			in which nonzero pixel values indicate locations
;			where spikes should not be flagged.
;
;	extend:		Number of pixels away from masked pixels before
;			locations may be flagged as spikes.
;
;	scale:		Typical size of objects to be flagged.  Default is 10.
;
;	edge:		Regions closer than this to the edge of the image
;			will be ignored.  Default is 10.
;
;	local:		Multiplier that determines the width of the region 
;			over which the local mean and standard deviation are
;			taken.  That width is local * scale.  Default is 5.
;
;	allpix:		If set, all pixels in the spike region are returned
;			instead of of the centroids.
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	POINT containing the detected spike points.
;
;
; PROCEDURE:
;
;	Clusters of hot pixels of size 'scale' are identified by looking 
;	for regions bounded by large gradients.  Each cluster is then
;	examined for pixels whose values are larger than nsig standard
;	deviations above the local mean.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_despike, pg_mask
;
;
; EXAMPLE:
;	dd = dat_read(filename)
;	spike_ptd = pg_spikes(dd)
;	dd1 = pg_despike(dd, spike_ptd)
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 4/2005
;	
;-
;=============================================================================
function pg_spikes, dd, nsig=nsig, grad=grad, mask=mask, umask=umask, extend=extend, $
            scale=scale, edge=edge, local=local, nohot=nohot, allpix=allpix

 if(NOT keyword_set(local)) then local = 5
 if(NOT keyword_set(grad)) then grad = 5
 if(NOT keyword_set(nsig)) then nsig = 2
 if(NOT keyword_set(scale)) then scale = 10
 if(NOT keyword_set(edge)) then edge = 10


 ;---------------------------------------
 ; dereference the data descriptor
 ;---------------------------------------
 im = dat_data(dd)


 ;---------------------------------------
 ; find clusters of bright points
 ;---------------------------------------
; pp = sky_points(im, grad, scale, mask=mask, extend=extend, edge=edge)
 pp = sky_points(im, nsig, scale, mask=mask, umask=umask, extend=extend, $
             edge=edge, all=allpix)


 ;----------------------------------------------
 ; examine each cluster for local hot pixels
 ;----------------------------------------------
 p = pp
 n = n_elements(pp)/2
 if(NOT keyword_set(nohot)) then $
  for i=0, n-1 do $
   begin
    q = local_spikes(im, pp[*,i], nsig, scale, f=local)
    if(keyword__set(q)) then $
     begin
      if(keyword_set(p)) then p = tr([tr(p), tr(q)]) $
      else p = q
     end
   end


 ;---------------------------------------
 ; set up the POINT object
 ;---------------------------------------
  ptd = pnt_create_descriptors(points = p, desc = 'spikes')

 return, ptd
end
;=============================================================================





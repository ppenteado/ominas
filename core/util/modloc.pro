;=============================================================================
;+
; NAME:
;       modloc
;
;
; PURPOSE:
;       Finds points in the image at which the correlation with the
;       given model is high.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = modloc(image, model, edge=edge, ccmin=ccmin, gdmax=gdmax)
;
;
; ARGUMENTS:
;  INPUT:
;       image:  Input image.
;
;       model:  2-D array giving a model of the reseau image.
;
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;        edge:  Distance from edge within which points are ignored.
;
;       ccmin:  Minimum correlation coefficient to accept.  Default is 0.8. 
;
;       gdmax:  If given, the maximum gradiant of correlation coefficient 
;		to accept. 
;
;	dmax:	Maximum number of resultant points allowed within any region
;		of the image of size dbin * (size of the model).  Default is 2.
;
;	dbin:	Binning factor size for computing point density, default is 2.
;
;      double:  If set, image is converted to double in the function,
;               otherwise it is converted to float.
;
;
;  OUTPUT:
;       NONE 
;
;
; RETURN:
;       The points (x,y) in the image that best fits the model.  Returns 0
;       if no points are found.
;
; PROCEDURE:
;	Modloc first computes computes maps of the correlation coefficient
;	between the model and the image with the model centered at each point
;	as well as the gradient of the correlation coefficient at each point. 
;	Points with high correlation and low gradient are selected as
;	candidates.  To select the final points, the point density is computed
;	using a bin size of twice the size of the model and points within
;	regions containing more than dmax candidates are deselected.
;	
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function modloc, _image, model, $
                 edge=edge, ccmin=ccmin, gdmax=gdmax, $
                 dmax=dmax, dbin=dbin, double=double

 s=size(_image)
 if(NOT keyword__set(edge)) then edge=0
 if(NOT keyword__set(ccmin)) then ccmin=0.8
 if(NOT keyword__set(dmax)) then dmax=2
 if(NOT keyword__set(dbin)) then dbin=2

 ;---------------------------------------
 ; trim edges from image
 ;---------------------------------------
 if(NOT keyword__set(double)) then image=float(_image)
 image = double(_image)

 ;---------------------------------------
 ; correlation coefficients
 ;---------------------------------------
 cc = c_correlate_2d(image, model, sigma=sigma, mean=mean)

 if(edge NE 0) then cc = cc[edge:s[1]-edge-1, edge:s[2]-edge-1]
 si = size(cc)
 sm = size(model)


 ;--------------------------------------------------------------------
 ; if desired, remove points of high cc gradient and low correlation
 ;--------------------------------------------------------------------
 if(keyword__set(gdmax)) then $
  begin
   gcc = image_gradient(cc)
   w = where((cc GT ccmin) AND (gcc LT gdmax))
  end $

 ;----------------------------------------------------
 ; otherwise, threshold based correlation alone
 ;----------------------------------------------------
 else w = where((cc GT ccmin))
 if(w[0] EQ -1) then return, 0


 ;----------------------------------------------------------------
 ; filter out long-wavelength objects
 ;----------------------------------------------------------------
 im = dblarr(s[1], s[2])
 im[*] = 0
 im[w] = 1

 imm = im - smooth(im, 2*sm[1])
 immm = (imm > 0.9) - 0.9		; this should be an input parameter

 ;----------------------------------------------------------------
 ; select cluster centers
 ;----------------------------------------------------------------
 points = image_clusters(immm, 2*sm[1])


 return, points
end
;===========================================================================

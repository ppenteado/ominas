;=============================================================================
;+
; NAME:
;       locmod
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
;       ccmin:  Minimum correlation coefficient to accept.  Default is 0.8 . 
;
;       gdmax:  Maximum gradiant of correlation coefficient to accept. 
;		Default is 0.25
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
;       coeff:	Correlation coefficients of returned points. 
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
function locmod, _image, model, coeff=coeff, $
                 edge=edge, ccmin=ccmin, gdmax=gdmax, $
                 dmax=dmax, dbin=dbin, double=double

 s=size(_image)
 if(NOT keyword__set(edge)) then edge=0
 if(NOT keyword__set(ccmin)) then ccmin=0.8
 if(NOT keyword__set(gdmax)) then gdmax=0.25
 if(NOT keyword__set(dmax)) then dmax=2
 if(NOT keyword__set(dbin)) then dbin=2

 ;---------------------------------------
 ; trim edges from image
 ;---------------------------------------
 if(NOT keyword__set(double)) then image=float(_image)
 image=double(_image)

 ;---------------------------------------
 ; correlation coefficients
 ;---------------------------------------
 cc = cross_correlate_2d(image, model, sigma=sigma, mean=mean)

 if(edge NE 0) then cc = cc[edge:s[1]-edge-1, edge:s[2]-edge-1]
 si = size(cc)
 sm = size(model)

 ;------------------------------------------------
 ; compute gradient of correlation coefficients
 ;------------------------------------------------
 gcc = image_gradient(cc)

 ;----------------------------------------------------------------
 ; select points with high correlation coeffs and low gradients
 ;----------------------------------------------------------------
 w = where(cc GT ccmin AND gcc LT gdmax)
 if(w[0] EQ -1) then return, 0
 n_points = n_elements(w)
 coeff = cc[w]

 ;----------------------------------------------------------------
 ; extract sub image centered at each candidate point
 ;----------------------------------------------------------------
 box_subs = (indgen(sm[1])-sm[1]/2)#make_array(sm[2],val=1) + $
                      ((indgen(sm[2])-sm[2]/2)*si[1])##make_array(sm[1],val=1)
 subs = dblarr(sm[1],sm[2],n_points, /nozero)
 for i=0, n_points-1 do subs[*,*,i]=box_subs+w[i]
 sub_ccs = cc[subs]

 ;-------------------------------------------------------------------
 ; choose point of greatest cc in each sub image 
 ;-------------------------------------------------------------------
 points = intarr(2,n_points)
 ww = intarr(n_points)

 for i=0, n_points-1 do $
  begin
   sub_cc = sub_ccs[*,*,i]
   ww[i] = (where(sub_cc EQ max(sub_cc)))[0]
  end

 points[0,*] = (ww mod sm[1]) + (w mod si[1]) - sm[1]/2 + edge
 points[1,*] = fix(ww/sm[1]) + fix(w/si[1]) - sm[2]/2 + edge

 ;----------------------------
 ; discard non-unique points
 ;----------------------------
 indices = points[0,*] + s[1]*points[1,*]
 uniq_indices = uniq(indices)

 points = points[*,uniq_indices]
 n_points = n_elements(uniq_indices)
 coeff = coeff[uniq_indices]


 ;----------------------------------------------------------------
 ; remove points in areas too densely populated by hits to 
 ; really distinguish the model
 ;----------------------------------------------------------------
 density = hist__2d(points[0,*], points[1,*], rev = ri, $
                    bin1=dbin*sm[1], bin2=dbin*sm[2], $
                    min1=0, min2=0, max1=s[1], max2=s[2])

 www = where(density GT dmax)
 nwww = n_elements(www)

 if(nwww GT 1) then $
; if(www[0] NE -1) then $
  begin
   rm_sub = lonarr(n_points)
   n_rm_sub = 0
   for i=0, nwww-2 do $
    begin
     ii = ri[ ri[www[i]] : ri[ www[i]+1 ]-1 ]
     nii = n_elements(ii)
     rm_sub[n_rm_sub:n_rm_sub+nii-1] = ii
     n_rm_sub = n_rm_sub + nii
    end
   rm_sub = rm_sub[0:n_rm_sub-1]   
   good_sub = complement(coeff, rm_sub)

   points = points[*,good_sub]
   coeff = coeff[good_sub]
  end


 return, points
end
;===========================================================================

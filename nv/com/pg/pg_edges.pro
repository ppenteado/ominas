;=============================================================================
;+
; NAME:
;	pg_edges
;
;
; PURPOSE:
;	Scans an image for candidate edge points.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	edge_ptd = pg_edges(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	threshold:	Minimum activity to accept as an edge point.
;
;	edge:		Distance from the edge of the image within which 
;			curve points will not be scanned.  Default is 0.
;
;	npoints:	Maximum number of points to return.
;
;	lowpass:	If given, the image is smoothed with a kernel of
;			this size.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	POINT giving the resulting edge points.
;
;
; PROCEDURE:
;	At each pixel in the image, an activity is computed (see activity.pro).
;	Points with activity greater than the threshold value are accepted.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_cvscan_coeff, pg_cvchisq, pg_ptscan, pg_ptscan_coeff, pg_ptchisq, 
;	pg_fit, pg_threshold
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 4/2002
;	
;-
;=============================================================================
function pg_edges, dd, threshold=threshold, edge=edge, npoints=npoints, $
                      gate=gate, lowpass=lowpass
 @pnt_include.pro
   

 ;-------------------------------------
 ; scale image to byte range
 ;-------------------------------------
 image = bytscl(dat_data(dd))
 s = size(image)
 xsize = s[1] & ysize = s[2]


 ;---------------------------------
 ; gate out fine features 
 ;---------------------------------
 if(keyword__set(gate)) then $
  begin
   h = histogram(image)
   h[0] = 0
   h[255] = 0
   h = smooth(h,15)

   xmax = (where(h EQ max(h)))[0]		; remove background peak
   top = 4*xmax
   if(top LE 255) then $
    begin
     h[0:top] = 0
     h = smooth(h, 50)
     hmax = max(h)

     xmax = min(where(h GE hmax/4d))
;     xmax = (where(h EQ max(h)))[0]

     if(xmax GT 50) then image = image < xmax
    end
  end



 ;---------------------------------
 ; compute activity 
 ;---------------------------------
 act = activity(image)


 ;----------------------------------
 ; set default threshold
 ;----------------------------------
 if(NOT keyword__set(threshold)) then threshold = 30
 if(keyword__set(npoints)) then $
  begin
   hist = histogram(act) # make_array(256, val=1)
   xx = indgen(256) # make_array(256,val=1)
   yy = indgen(256) ## make_array(256,val=1)
   w = where(yy GT xx)
   hist[w] = 0
   nnp = total(hist, 1)

   threshold = min(where((npoints GE nnp)))
  end

 ;-------------------------
 ; select points
 ;-------------------------
 w = where(act GT threshold)
 if(w[0] EQ -1) then return, 0

 ;----------------------------------
 ; low-pass filter
 ;----------------------------------
 if(keyword__set(lowpass)) then $
  begin
   if(lowpass EQ 1) then nn = 3 $
   else nn = lowpass

   im = bytarr(xsize,ysize)
   im[w] = 1
   im = smooth(im,nn)

   ww = where(im GT 0)
   if(ww[0] EQ -1) then return, 0
   w = ww
  end

 ;----------------------------------
 ; convert to image coordinates
 ;----------------------------------
 npoints = n_elements(w)
 points = dblarr(2,npoints)
 points[0,*] = w mod xsize
 points[1,*] = fix(w/xsize)

 ;----------------------------------
 ; clip if desired
 ;----------------------------------
 if(keyword__set(edge)) then $
  begin
   w = where((points[0,*] GE edge) AND $
             (points[0,*] LE xsize - edge) AND $
             (points[1,*] GE edge) AND $
             (points[1,*] LE ysize - edge))
   if(w[0] EQ -1) then return, 0
   points = points[*,w]
  end

 ;-----------------------------
 ; save the selected points
 ;-----------------------------
 edge_ptd = pnt_create_descriptors(points=points, desc='edges', input=pgs_desc_suffix(dd))


 return, edge_ptd
end
;===========================================================================

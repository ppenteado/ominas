;=============================================================================
;+
; NAME:
;	pg_ptscan
;
;
; PURPOSE:
;	Attempts to find points of highest correlation with a given model
;	centered near given features in an image.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_ptscan(dd, object_ps)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor
;
;	object_ps: 	Array (n_pts) of points_struct giving the points.
;			Only the image coordinates of the points need to be
;			specified.
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
;	wpsf:		Half-width of default gaussian psf model.
;
;       width:          Width to search around expected point location.  If
;                       not given, a default width of 20 pixels is used.
;
;	radius:		Width outside of which to exclude detections whose
;			offset varies too far from the most frequent offset.
;			Detections with offsets outside this radius receive
;			correlation coefficients of zero.
;
;       edge:           Distance from edge from which to ignore points.  If
;                       not given, an edge distance of 0 is used.
;
;       ccmin:          If given, points are discarded if the correlation
;                       is below this value.
;
;	chisqmax:	Max chisq between the model and the image.
;
;       gdmax:          If given, points are discarded if the gradiant of
;                       the correlation function is higher than this value.
;
;	smooth:		If given, the input image is smoothed using
;			this width before any further processing.
;
;	median:		If given, the input image is filtered using
;			a median filter of this width before any further
;			processing.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	An array of type points_struct giving the detected position for
;       each object.  The correlation coeff value for each detection is
;       saved in the data portion of points_struct with tag 'scan_cc'.
;       The x and y offset from the given position is also saved.
;
;
; RESTRICTIONS:
;	Currently does not work for multiple time steps, only considers
;	one point per given points_struct.
;
;
; PROCEDURE:
;	For each visible object, a section of the image of size width +
;       the size of the model is extracted and sent to routine ptloc to
;       find the pixel offset with the highest correlation with the given
;       model.
;
;
; EXAMPLE:
;	To find stellar positions with a correlation higher than 0.6...
;
;       star_ps=pg_center(bx=sd, gd=gd) & pg_hide, star_ps, gd=gd, /rm, /globe
;       ptscan_ps=pg_ptscan(dd, star_ps, edge=30, width=40, ccmin=0.6)
;
; SEE ALSO:
;	pg_ptfarscan
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Haemmerle, 5/1998
;	Modified:	Spitale 9/2002 -- added twice model width to search
;			width.
;	
;-
;=============================================================================
function pg_ptscan, dd, object_ps, $
                    model=model, radius=radius, $
                    width=_width, edge=edge, ccmin=ccmin, gdmax=gdmax, $
                    smooth=smooth, show=show, wmod=wmod, wpsf=wpsf, $
                    median=median, chisqmax=chisqmax, cc_out=cc_out, $
                    round=round, spike=spike
@ps_include.pro

 if(NOT keyword__set(ccmin)) then ccmin=0.01
; if(NOT keyword__set(gdmax)) then gdmax=0.25
 
 _image=nv_data(dd)
 
 if(keyword__set(smooth)) then _image = smooth(_image, smooth)
 if(keyword__set(median)) then _image = median(_image, median)

 n_objects = n_elements(object_ps)
 s = size(_image)

 ;-----------------------------
 ; default width is 20 pixels
 ;-----------------------------
 if(NOT keyword__set(_width)) then _width = make_array(n_objects,val=20) $
 else if(n_elements(_width) EQ 1) then $
                           _width = make_array(n_objects,val=_width[0])

 ;-----------------------------------
 ; default edge offset is 0 pixels
 ;-----------------------------------
 if(NOT keyword__set(edge)) then edge = 0

 ;----------------------------------
 ; use default model if none given
 ;----------------------------------
 if(NOT keyword__set(wmod)) then wmod = 15
 if(NOT keyword__set(wpsf)) then wpsf = 1.8
 if(NOT keyword__set(model)) then model = gauss_2d(0, 0, wpsf, wmod, wmod)
 sm = size(model)

 width = _width + 2*sm[1]


 ;=========================
 ; scan for each object
 ;=========================
 dxy = dblarr(2, n_objects)
 all_pts = dblarr(2,n_objects)
 all_cc = dblarr(n_objects)
 dxy = dblarr(2,n_objects)
 all_flags = bytarr(n_objects)
 pts_ps = ptrarr(n_objects)
 for i=0, n_objects-1 do $
  begin
   ;-----------------------------------
   ; get object point
   ;-----------------------------------
   ps_get, object_ps[i], points=pts, flags=flags, name=name, /visible

   ;------------------------------------------------------
   ; trim point if invisible or too close to edge
   ;------------------------------------------------------
   x0=edge & y0=edge
   x1=s[1]-1-edge & y1=s[2]-1-edge
   im_pts = trim_external_points(pts, sub=sub, x0, x1, y0, y1)

   ;------------------------------
   ; Setup for invalid point
   ;------------------------------
   delta=[0d,0d]
   ccp = 0
   scan_pts = pts
   sim = size(im_pts)
   flags = make_array(1, /byte, val=PS_MASK_INVISIBLE)

   start = intarr(2)
   start[0] = fix(pts[0]-width[i]/2) < (s[1]-width[i]-1) > 0.
   start[1] = fix(pts[1]-width[i]/2) < (s[2]-width[i]-1) > 0.

   if(sim[0] NE 0 AND start[0] GE 0 AND start[1] GE 0 AND  $
      (start[0]+width[i]) LT s[1] AND $
      (start[1]+width[i]) LT s[2] ) then $
    begin
     if(keyword__set(show)) then $
      begin
       xx1 = start[0] & xx2 = start[0] + width[i]
       yy1 = start[1] & yy2 = start[1] + width[i]
       plots, [xx1,xx2,xx2,xx1,xx1], [yy1,yy1,yy2,yy2,yy1], col=ctred(), psym=-3
      end

     ;--------------------------------
     ; send ptloc a subimage
     ;--------------------------------
     subimage = _image(start[0]:start[0]+width[i], $
                       start[1]:start[1]+width[i])
     point = ptloc(subimage, model, _width[i], ccp=ccp, $
                        sigma=sigma, chisq=chisq, round=round, spike=spike)

     OK=1
     if(NOT keyword_set(point)) then OK = 0
     if(NOT(keyword_set(ccmin))) then OK=(ccp[0] GE 0d)
     if(keyword_set(ccmin)) then OK=(ccp[0] GE ccmin)
     if(keyword_set(chisqmax)) then if(chisq GT chisqmax) then OK = 0

     if(OK) then $ 
      begin
       scan_pts = point+double(start)
       delta = scan_pts-pts
       flags = make_array(1, /byte, val=0)
      end 
     
    end

   ;--------------------
   ; save the scan data
   ;--------------------
   dxy[*,i] = delta

   scan_data=dblarr(5)
   tags=strarr(5)
   scan_data[0]=delta[0]	 & tags[0]='point_dx' 	 	; dx
   scan_data[1]=delta[1]	 & tags[1]='point_dy' 		; dy
   scan_data[2]=0                & tags[2]='Not_applicable'     ; 
   scan_data[3]=ccp		 & tags[3]='scan_cc'            ; correlation


   pts_ps[i] = ps_init(points = scan_pts, $
                       name = name, $
                       desc = 'ptscan', $
                       data = scan_data, $
                       flags = flags, $
                       tags = tags)
   all_pts[*,i] = scan_pts
   all_cc[i] = ccp
   all_flags[i] = flags
  end


 ;---------------------------------------------
 ; get rid of duplicate detections
 ;---------------------------------------------
 mag2_dxy = total(dxy^2, 1)
 discard = bytarr(n_objects)
 for i=0, n_objects-1 do $
  begin
   w = where((all_pts[0,*] EQ all_pts[0,i]) AND (all_pts[1,*] EQ all_pts[1,i]))
   if(n_elements(w) GT 1) then $
    begin
     ff = all_flags[w]
     ww = where((ff AND PS_MASK_INVISIBLE) EQ 0)
     if(n_elements(ww) GT 1) then $
      begin
       d2 = mag2_dxy[w[ww]]
       www = where(d2 eq max(d2))
       ii = w[ww[www[0]]]
       flags = ps_flags(pts_ps[ii])
       flags = flags OR PS_MASK_INVISIBLE
       ps_set_flags, pts_ps[ii], flags
       discard[ii] = 1
      end
    end
  end

 cc_out = all_cc
 ww = where((all_flags AND PS_MASK_INVISIBLE) EQ 0)
 if(ww[0] NE -1) then cc_out = cc_out[ww] 


 ;---------------------------------------------
 ; exclude outlying offsets
 ;---------------------------------------------
 if(keyword__set(radius)) then $
  begin
   ww = where((all_flags AND PS_MASK_INVISIBLE) EQ 0)
   if(ww[0] NE -1) then $
    begin
     w = correlate_pairs(dxy[*,ww], radius, /complement)
     if(w[0] NE -1) then $
      begin
       w = ww[w]
       nw = n_elements(w)
       for i=0, nw-1 do $
        begin
         scan_data = ps_data(pts_ps[w[i]])
         scan_data[3] = 0d
         ps_set_data, pts_ps[w[i]], scan_data
        end
      end
    end
  end


 return, pts_ps
end
;===========================================================================

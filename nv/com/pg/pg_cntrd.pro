;=============================================================================
;+
; NAME:
;	pg_cntrd
;
;
; PURPOSE:
;	Calculates the centroids centered near given features in
;	an image.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_cntrd(dd, object_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor
;
;	object_ptd: 	Array (n_pts) of POINT objects giving the points.
;			Only the image coordinates of the points need to be
;			specified.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;
;       fwhm:           Full-Width Half-maximum to use around expected point
;                       location.  If not given, a default fwhm of 2 pixels
;                       is used.
;
;       edge:           Distance from edge from which to ignore points.  If
;                       not given, an edge distance of 0 is used.
;
;     sigmin:           If given, points are discarded if the sigma above 
;                       the mean for the centroid pixel is below this value.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	An array of type POINT objects giving the detected position for
;       each object.  The max values for each detection is
;       saved in the data portion of object with tag 'scan_cc'.
;       The x and y offset from the given position is also saved.
;
;
; RESTRICTIONS:
;	Currently does not work for multiple time steps.
;
;
; PROCEDURE:
;	For each visible object, a centroid is calcualted using the
;	astronlib cntrd routine.
;
;
; SEE ALSO:
;	ptscan, pg_ptscan, pg_ptcntrd
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Haemmerle, 2/1999
;	
;-
;=============================================================================
function pg_cntrd, dd, object_ptd, $
                    fwhm=fwhm, edge=edge, sigmin=sigmin
@pnt_include.pro
 _image=dat_data(dd)

 n_objects=n_elements(object_ptd)
 s=size(_image)

 ;-----------------------------
 ; default fwhm is 2 pixels
 ;-----------------------------
 if(NOT keyword__set(fwhm)) then fwhm=2d

 ;-----------------------------------
 ; default edge offset is 0 pixels
 ;-----------------------------------
 if(NOT keyword__set(edge)) then edge=0

 ;=========================
 ; scan for each object
 ;=========================
 pts_ptd=objarr(n_objects)
 for i=0, n_objects-1 do $
  begin
   ;-----------------------------------
   ; get object point
   ;-----------------------------------
   pnt_query, object_ptd[i], points=pts, flags=flags, /visible

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
   ccp=0
   scan_pts=pts
   sim=size(im_pts)
   flags = make_array(1, /byte, val=PTD_MASK_INVISIBLE)

   if(sim[0] NE 0 AND pts[0] GE x0 AND pts[1] GE y0 AND  $
      pts[0] LE x1 AND pts[1] LE y1 ) then $
    begin

     ;--------------------------------
     ; Find centroid
     ;--------------------------------
     cntrd, _image, pts[0], pts[1], xcent, ycent, fwhm, /silent
;     print, 'start point ',pts[0], pts[1]
     print, 'centroid   ',xcent, ycent
     point = dblarr(2)
     point[0] = xcent
     point[1] = ycent

     OK=1
     if(xcent EQ -1) then OK=0
     if(ycent EQ -1) then OK=0
     if(OK AND keyword__set(sigmin)) then $
      begin
       ;------------------------------------------
       ; Find sigma and mean of surrounding pixels
       ;------------------------------------------
       subimage = double(_image(xcent-5*fwhm:xcent+5*fwhm, $
                                ycent-5*fwhm:ycent+5*fwhm))
       subimage(3*fwhm:7*fwhm,3*fwhm:7*fwhm) = -1
       subs = where(subimage NE -1)
       pixs = subimage[subs] 
       sigma = stdev(pixs,mean)
       print, 'sigma, mean = ',sigma, mean
       OK=(_image(xcent,ycent) GE mean+sigmin*sigma)
       print, 'center pixel, criteria =',_image(xcent,ycent), mean+sigmin*sigma
      end

     if(OK) then $ 
      begin
       scan_pts=point
       delta=scan_pts-pts
       flags=make_array(1, /byte, val=0)
      end 
     
    end

;print, 'point= ', i
;if(flags[0] EQ 0) then $
; begin
;  print, 'point= ', i
;  print,' scan_pts = ',scan_pts
;  print,' dx, dy = ',delta
;  print,' corr = ',ccp
;  print,' gd = ',gccp
; end

   ;--------------------
   ; save the scan data
   ;--------------------
   scan_data=dblarr(4)
   tags=strarr(4)
   scan_data[0]=delta[0]	 & tags[0]='point_dx'  	; dx
   scan_data[1]=delta[1]	 & tags[1]='point_dy' 		; dy
   scan_data[2]=0                & tags[2]='Not_applicable'    ; offsets
   scan_data[3]=ccp		 & tags[3]='scan_cc'           ; correlation


   pnt_assign, pts_ptd[i], $
              points = scan_pts, $
              data = scan_data, $
              flags = flags, $
              tags = tags

  end



 return, pts_ptd
end
;===========================================================================

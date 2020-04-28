;=============================================================================
;+
; NAME:
;	pg_ptcntrd
;
;
; PURPOSE:
;	Attempts to find points of highest correlation with a given model
;	centered near given features in an image, then returns the centroid.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_ptcntrd(dd, object_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor
;
;	object_ptd: 	Array (n_pts) of POINT giving the points.
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
;       width:          Width to search around expected point location.  If
;                       not given, a default width of 20 pixels is used.
;
;       edge:           Distance from edge from which to ignore points.  If
;                       not given, an edge distance of 0 is used.
;
;       ccmin:          If given, points are discarded if the correlation
;                       is below this value.
;
;       gdmax:          If given, points are discarded if the gradiant of
;                       the correlation function is higher than this value.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	An array of type POINT giving the detected position for
;       each object.  The correlation coeff values for each detection is
;       saved in the data portion of POINT with tag 'scan_cc'.
;       The x and y offset from the given position is also saved.
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	Currently does not work for multiple time steps.
;
;
; PROCEDURE:
;	For each visible object, a section of the image of size width +
;       the size of the model is extracted and sent to routine ptloc to
;       find the pixel offset with the highest correlation with the given
;       model. Then call astrolib routine cntrd to return centroid.
;
;
; EXAMPLE:
;	To find stellar positions with a correlation higher than 0.6...
;
;       star_ptd=pg_center(bx=sd, gd=gd) & pg_hide, star_ptd, gd=gd, /rm
;       ptscan_ptd=pg_ptscan(dd, star_ptd, edge=30, width=40, ccmin=0.6)
;
; SEE ALSO:
;	ptscan, pg_ptscan
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Haemmerle, 5/1998
;	
;-
;=============================================================================
function pg_ptcntrd, dd, object_ptd, $
                    model=model, $
                    width=width, edge=edge, ccmin=ccmin, gdmax=gdmax
                 
@pnt_include.pro
 _image=dat_data(dd)

 n_objects=n_elements(object_ptd)
 s=size(_image)

 ;-----------------------------
 ; default width is 20 pixels
 ;-----------------------------
 if(NOT keyword__set(width)) then width=make_array(n_objects,val=20) $
 else if(n_elements(width) EQ 1) then width=make_array(n_objects,val=width[0])

 ;-----------------------------------
 ; default edge offset is 0 pixels
 ;-----------------------------------
 if(NOT keyword__set(edge)) then edge=0

 ;----------------------------------
 ; use default model if none given
 ;----------------------------------
 if(NOT keyword__set(model)) then model=gauss_2d(0, 0, 1.8, 15, 15)
 sm=size(model)

 ;----------------------------------------
 ; Find Full-width half-maximum from model
 ;----------------------------------------
 if(NOT keyword__set(model)) then fwhm = 4.2 $
   else $
    begin
     Result = gauss2dfit(model, A)
     sigma = max([A[2],A[3]])
     fwhm = 2.35*sigma
    end
; print,'fwhm = ',fwhm
  

 ;=========================
 ; scan for each object
 ;=========================
 pts_ptd = objarr(n_objects)
 for i=0, n_objects-1 do $
  begin
   ;-----------------------------------
   ; get object point
   ;-----------------------------------
   pnt_query, object_ptd[i], points=pts, flags=flags, /visible

   ;------------------------------------------------------
   ; trim point if invisible or too close to edge
   ;------------------------------------------------------
   x0=edge-width[i]/2-sm[1]/2 & y0=edge-width[i]/2-sm[2]/2
   x1=s[1]-1-edge+width[i]/2+sm[1]/2 & y1=s[2]-1-edge+width[i]/2+sm[2]/2
   im_pts = trim_external_points(pts, sub=sub, x0, x1, y0, y1)

   ;------------------------------
   ; Setup for invalid point
   ;------------------------------
   delta=[0d,0d]
   ccp=0
   scan_pts=pts
   sim=size(im_pts)
   flags = make_array(1, /byte, val=PTD_MASK_INVISIBLE)

   start=intarr(2)
   start[0]=fix(pts[0]-width[i]/2-sm[1]/2)
   start[1]=fix(pts[1]-width[i]/2-sm[2]/2)
   if(pts[0] GT x0 AND start[0] LT edge) then start[0] = edge
   if(pts[1] GT y0 AND start[1] LT edge) then start[1] = edge
   if(pts[0] LT x1 AND start[0]+width[i]+sm[1] GT s[1]) then $
    start[0] = s[1]-width[i]-sm[1]-1
   if(pts[1] LT y1 AND start[1]+width[i]+sm[2] GT s[2]) then $
    start[1] = s[2]-width[i]-sm[2]-1

   if(sim[0] NE 0 AND start[0] GE 0 AND start[1] GE 0 AND  $
      (start[0]+width[i]+sm[1]) LE s[1] AND                $
      (start[1]+width[i]+sm[2]) LE s[2] ) then $
    begin
;     print, 'start= ',start
;     print, 'end = ',start[0]+width[i]+sm[1],start[1]+width[i]+sm[2]

     ;--------------------------------
     ; send ptloc a subimage
     ;--------------------------------
     subimage=_image(start[0]:start[0]+width[i]+sm[1], $
                     start[1]:start[1]+width[i]+sm[2])
     point=ptloc(subimage, model, width[i], ccp=ccp, gccp=gccp)

     OK=1
     if(NOT(keyword__set(ccmin))) then OK=(ccp[0] GE 0d)
     if(keyword__set(ccmin)) then OK=(ccp[0] GE ccmin)
     if(OK AND keyword__set(gdmax)) then OK=(gccp[0] LE gdmax)

     ;--------------------------------
     ; Find centroid
     ;--------------------------------
     cntrd, subimage, point[0], point[1], xcent, ycent, fwhm
;     print, 'scan point ',point[0], point[1]
;     print, 'centroid   ',xcent, ycent
     point[0] = xcent
     point[1] = ycent
     if(xcent EQ -1) then OK=0
     if(ycent EQ -1) then OK=0

     if(OK) then $ 
      begin
       scan_pts=point+start
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


   pnt_assign, pts_ptd[i], points = scan_pts, $
                      data = scan_data, $
                      flags = flags, $
                      tags = tags

  end



 return, pts_ptd
end
;===========================================================================

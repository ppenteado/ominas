;=============================================================================
;+
; NAME:
;	pg_select_points
;
;
; PURPOSE:
;	Allows the user to select points in an image using the mouse.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	region = pg_select_points(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor containing the image.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	noverbose: 	If set, turns off the notification that cursor
;			movement is required.
;
;	psym: 		Plotting symbol to use for the points.
;
;	one:		If set, the routine will exit after selecting one point.
;
;	number:		If set, each point will be labeled with a number.
;
;	color:		Color to use for graphics overlays.
;
;	ptd_output:	If set, a POINT object is returned instead
;			of a points array.
;
;	p0:		Initial point, instead of user selection.
;
;  OUTPUT: 
;	cancelled:	Set if routine is caused to return by the cancel button.
;
;
; RETURN:
;	Array of image points (2,n).
;
;
; EXAMPLE:
;
;  To print the coordinates of each point as the user selects them, use:
;
;   can=0 & while(NOT can) do print, pg_select_points(dd, /one, /nov, can=can)
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2001
;	
;-
;=============================================================================
function pg_select_points, dd, psym=psym, noverbose=noverbose, color=color, $
                 p0=p0, one=one, number=number, cancelled=cancelled, ptd_output=ptd_output

 if(NOT keyword_set(psym)) then psym=1
 cancel = 0

 ;------------------------------------------
 ; user defines points in device coords
 ;------------------------------------------
 tvcursor, /set
 if(NOT keyword_set(noverbose)) then $
   begin
    nv_message, 'Use cursor and mouse buttons to select points -', $
                 name='pg_select_points', /continue
    nv_message, 'LEFT: Select point, MIDDLE: Erase point, RIGHT: End', $
                 name='pg_select_points', /continue
   end

 vv=tvpath(psym=psym, /copy, p0=p0, one=one, number=number, $
                                  cancelled=cancelled, color=color, /points)
 tvcursor, /restore

 if(cancelled) then return, ''

 xv=transpose(vv[0,*])
 yv=transpose(vv[1,*])

 ;------------------------------------------
 ; transform to data coords
 ;------------------------------------------
 points=convert_coord(double(xv), double(yv), /device, /to_data)




 if(keyword_set(ptd_output)) then $
  begin
   ptd = pnt_create_descriptors(points=points[0:1,*])
   return, ptd
  end

 return, points[0:1,*]
end
;=============================================================================

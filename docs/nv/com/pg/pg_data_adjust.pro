;=============================================================================
;+
; NAME:
;	pg_data_adjust
;
; PURPOSE:
;	Allows the user to adjust data values using the mouse.  A rectangle 
;	is selected height (positve or negative) gives the data value adjustment.
;	Works for 1-D or 2_d data sets.
;
; CATEGORY:
;       NV/PG
;
; CALLING SEQUENCE:
;     pg_data_adjust, dd
;
;
; ARGUMENTS:
;  INPUT:
;      dd:	Data descriptor.
;
;  OUTPUT:
;	NONE
;
;
;
; KEYWORDS:
;  INPUT: 
;         NONE
;
;
;
;  OUTPUT:
;         NONE
;
;
; RETURN: 
;      NONE
;
;
; ORIGINAL AUTHOR : J. Spitale ; 2/2014
;
;-
;=============================================================================
pro pg_data_adjust, dd

 device, cursor_standard=30
 data = dat_data(dd, abscissa=abscissa)	; requesting the entire data array is not ideal
 dim = dat_dim(dd)

 ndim = n_elements(dim)

 ;----------------------------------------------------
 ; adjust values until right button pressed
 ;----------------------------------------------------
 oldbutton = 0
 repeat $
  begin
   cursor, px, py, /device, /change
   button = !mouse.button
   
   release = 0
   if(button NE oldbutton) then $
    begin
     release = oldbutton
     oldbutton = button
    end

   ;- - - - - - - - - - - - - -
   ; left button
   ;- - - - - - - - - - - - - -
   if(button EQ 1) then $
    begin
     ;- - - - - - - - - - - - - - - - -
     ; get box coordinates
     ;- - - - - - - - - - - - - - - - -
     box = tvrec(p0=[px,py], color=ctred(), /vline)

     xx = box[0,0] & yy = box[1,0]
     pp = (convert_coord(/device, /to_data, double(xx), double(yy)))[0:1,*]

     xx = box[0,0] & yy = box[1,1]
     qq = (convert_coord(/device, /to_data, double(xx), double(yy)))[0:1,*]

     plots, qq, psym=1, col=ctred()

     ;- - - - - - - - - - - - - - - - -
     ; 1-D array
     ;- - - - - - - - - - - - - - - - -
     if(ndim EQ 1) then $
      begin
       ii = round(pp[0])
       data[ii] = qq[1]
      end

     ;- - - - - - - - - - - - - - - - -
     ; 2-D array
     ;- - - - - - - - - - - - - - - - -
     if(ndim EQ 2) then $
      begin
       ii = xy_to_w(data, round(pp))
       delta = qq[1] - pp[1]			;;; needs to be more sophisticated
       data[ii] = data[ii] + delta
      end
    end


   ;- - - - - - - - - - - - - -
   ; right button
   ;- - - - - - - - - - - - - -
   if(button EQ 4) then $
    begin
     ;- - - - - - - - - - - - - - - - -
     ; get curve coordinates
     ;- - - - - - - - - - - - - - - - -
     path = tvpath(p0=[px,py], color=ctred(), select=4, end=2)

     xx = path[0,*] & yy = path[1,*]
     pp = (convert_coord(/device, /to_data, double(xx), double(yy)))[0:1,*]
     xx = transpose(pp[0,*]) & yy = transpose(pp[1,*])

     ;- - - - - - - - - - - - - - - - -
     ; interpolate onto abscissa grid
     ;- - - - - - - - - - - - - - - - -
; need to look at actual dd abscissa...
     xxmin = ceil(min(xx))
     xxmax = floor(max(xx))
     x = dindgen(xxmax-xxmin+1) + xxmin

     y = interpol(yy, xx, x)

     plots, x, y, psym=-3, col=ctred()

     ;- - - - - - - - - - - - - - - - -
     ; 1-D array
     ;- - - - - - - - - - - - - - - - -
     if(ndim EQ 1) then data[x] = y

    end
  endrep until(release EQ 4)

 ;-------------------------------------------------
 ; update data descriptor with modified data array
 ;-------------------------------------------------
 dat_set_data, dd, data

end
;=====================================================================



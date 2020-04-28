;=============================================================================
;+
; NAME:
;	zfill
;
;
; PURPOSE:
;	Replace tagged (default=0) values in array with mean of box
;	around pixel.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	zfill, image, fill, nsw, nlw
;
;
; ARGUMENTS:
;  INPUT:
;	image:	image to be operated on
;
;	fill:	DN value to fill and not be included in mean calculation
;
;	nsw:	size of sample window in mean calculation (default = 1)
;
;	nlw:	size of line window in mean calculation (default = 3)
;
;  OUTPUT:
;	mask:	Mask of changed pixels (changed = 1)
;
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; COMMON BLOCKS:
;	xx:	xx
;
;	xx:	xx
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	
;
;
; PROCEDURE:
;	xx
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	V. Haemmerle 8/26/99
;	
;-
;=============================================================================
pro zfill, image, fill, nsw, nlw, mask

 si = size(image)
 ns = si[1]
 nl = si[2]
 if(NOT keyword__set(nsw)) then nsw=1
 if(NOT keyword__set(nlw)) then nlw=3
 if(NOT keyword__set(fill)) then fill=0
 if(NOT keyword__set(mask)) then mask = BYTARR(ns,nl)

 nimage = image

 for j=0,nl-1 do $
   begin
     index = where(image[*,j] EQ fill, count)
     if count NE 0 then $
       begin
;       print, 'line number ',j,'  zcount=', count
       j0 = max([0,j-(nlw-1)/2])
       j1 = min([j+(nlw-1)/2,nl-1])
       for k=0,count-1 do $
         begin 
           i0 = max([0,index[k]-(nsw-1)/2])
           i1 = min([index[k]+(nsw-1)/2,ns-1])
           box=image(i0:i1,j0:j1)
           sb = size(box)
           dummy = where(box EQ fill, nf)
           if nf NE sb[1]*sb[2] then $
             begin
               mean = (total(box) - nf*fill)/(sb[1]*sb[2] - nf)
               nimage(index[k],j) = mean
               mask(index[k],j) = 1
             end
         end
       end
     end
   image = nimage
   print,long(total(mask)),' pixels filled'
end

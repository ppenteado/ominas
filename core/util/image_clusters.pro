;===============================================================================
; image_clusters
;
;
;===============================================================================
function image_clusters, image, scale, thresholds=thresholds, all=all

 if(NOT keyword_set(thresholds)) then thresholds = [0.1,0.75]


 ;-----------------------------------------------------------------
 ; determine which points lie on extended clusters near the 
 ; specified scale
 ;-----------------------------------------------------------------
 max = max(image)
 smim = smooth(image, scale)
 threshim = smim > thresholds[0]*max < thresholds[1]*max
 threshim = threshim - thresholds[0]*max


 ;-----------------------------------------------------------------
 ; determine coords of all cluster points
 ;-----------------------------------------------------------------
 if(keyword_set(all)) then $
  begin
   w = where(threshim GT 0)
   xy = w_to_xy(threshim, w)
  end $
 ;-----------------------------------------------------------------
 ; determine coords of cluster centroids
 ;-----------------------------------------------------------------
 else $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; get approximate coordinates of cluster centroids
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   dim = size(image, /dim)
   cim = congrid(threshim, dim[0]/scale, dim[1]/scale, /interp)
   w = where(cim GT 0) 
   nw = n_elements(w)
   if(w[0] EQ -1) then return, 0
   xy = w_to_xy(cim, w) * scale

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; find centroid of each cluster
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   for i=0, nw-1 do $
    begin
     p0 = xy[*,i] - 2*[scale,scale]
     p1 = xy[*,i] + 2*[scale,scale]

     im = threshim[p0[0]>0:p1[0]<dim[0]-1, p0[1]>0:p1[1]<dim[1]-1]
     cxy = image_centroid(im)
     xy[*,i] = cxy + p0
    end

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; there may still be some duplicates where clusters spanned more
   ; than one bin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   xy = combine_duplicate_points(xy, epsilon=scale/2)
  end
 
  
 return, xy
end
;===============================================================================




;===============================================================================
; image_clusters
;
;
;===============================================================================
function ___image_clusters, _image, scale, cutoff=cutoff, mincluster

 if(NOT keyword_set(cutoff)) then cutoff = 0
 if(NOT keyword_set(mincluster)) then mincluster = 1

 image = _image


 ;-----------------------------------------------------------------
 ; get coordinates of all points greater than the cutoff value
 ;-----------------------------------------------------------------
 s = size(image)
 xs = s[1] & ys = s[2]

 w = where(image GT cutoff)
 if(w[0] EQ -1) then return, 0
 nw = n_elements(w)

 xarr = w mod xs
 yarr = w / xs


 ;-----------------------------------------------------------------
 ; bin coordinates according to scale
 ;-----------------------------------------------------------------
 hh = hist__2d(xarr, yarr, rev=ri, bin1=scale, bin2=scale, $
                     min1=0, min2=0, max1=s[1], max2=s[2]) 
 www = where(hh GE mincluster)


 ;-----------------------------------------------------------------
 ; select average position of each cluster
 ;-----------------------------------------------------------------
 if(www[0] NE -1) then $
  begin
   nwww = n_elements(www)
   p = dblarr(2,nwww)
   for i=0, nwww-2 do $
    begin
     ii = ri[ ri[www[i]] : ri[ www[i]+1 ]-1 ]
     nii = double(n_elements(ii))
     x = total(xarr[ii])/nii
     y = total(yarr[ii])/nii
     p[*,i] = [x,y]
    end
  end


 ;-----------------------------------------------------------------
 ; there may still be some duplicates where clusters spanned more
 ; than one bin
 ;-----------------------------------------------------------------
 p = combine_duplicate_points(p, epsilon=scale/2)

 
 return, p
end
;===============================================================================

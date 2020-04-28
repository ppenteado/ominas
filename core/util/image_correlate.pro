;=============================================================================
;+
; image_correlate
;
; PURPOSE :
;
;  Search for the vector offset, t, at which image2 best correlates with
; image1 (without searching the entire array).
;
;
;  The algorithm works as follows:
;
; 1) begin with a grid of size nsamples covering the entire image1,
;    for example, for nsample=[4,4], the grid might look like :
;                     
;            -------------------------
;           |   .     .     .     .   |
;           |                         |<-----image array
;           |                         |
;           |   .     .     .     .   |
;           |                         |
;           |                         |
;           |   .     .     .     .<--|---sample each of these offsets
;           |                         |
;           |                         |
;           |   .     .     .     .   |
;            -------------------------
;
; 2) evaluate the cross correlation function of image1 and image2
;     at each point on the grid and determine which point gave the
;     best result.  Store this point and its correlation in
;     best_arr.
;
; 3) center a new grid of the same configuration at that point
;     but make it smaller by grid_ratio : 
;                     
;            -------------------------
;        ---|---.   .   .   .     .   |
;         | |                         |<-----image array
;    new  | |   .   .   .   .         |
;    grid | |         +<----------.---|----best point from last scan
;         | |   .   .   .   .         |
;         | |                         |
;        ---|---.   .   .   .     .   |
;           |                         |
;           |                         |
;           |   .     .     .     .   |
;            -------------------------
;
; 4) continue until the entire grid becomes smaller than 1 pixel across.
;
; 5) return the point in best_arr which gave the best correlation.
;
; Accuracy:
;  The offset vector returned by this routine should usually
;   lie within one pixel of the actual maximum correlation.  The
;   result can only be guaranteed, though, if nsamples is set to the
;   size of the array, but this is almost never practical.
;
; Speed:
;  If you use nsamples of [2,2], the default, then each search cycle
;   will be as fast as possible, but it will take many cycles to converge 
;   on the maximum.  If you use a very fine grid, then it may take only
;   a few cycles, but the cycles will take very long.  Of course, 
;   generally one would expect it to be much faster to use a coarse grid
;   as opposed to one of the same size as the array, otherwise, there 
;   would have been no reason to write this program.  The total time
;   should scale as:
;
;         t = nsamples(0)*nsamples(1)  *  ncycles
;
;   where ncycles is the number of search cycles necessary to converge.
;   The exact value depends on the two images and their initial 
;   offsets.
;
;
; NOTE: Unless /nohome is set, the first point in best_arr always corresponds
;       to t=[0,0], i.e; no shift at all.  Thus, if the
;       images never needed to be shifted, then the result
;       the result will always be zero offset.
;
;
;
; CALLING SEQUENCE :
;
;   t=image_correlate(im1, im2, correlation)
;
;
; ARGUMENTS
;  INPUT : im1 - reference image
;
;          im2 - image to be shifted
;
;  OUTPUT : correlation - cross correlation value after im2 has been
;                         shifted by t.
;
;
;
; KEYWORDS 
;  INPUT : show - Show the search.
;
;          nsamples - 2D vector giving the dimensions of the search grid,
;                     default is [2,2].
;
;          nohome - Do not check the offset [0,0] for best correlation.
;
;          function_min, function_max - Name of a function to either
;                                       minimize or maximize.  The
;                                       function should be declared as
;                                       follows:
;
;                                         function [name], f, g, t
;
;                                       and should return a number which
;                                       indicates the degree of correlation
;                                       between f ang g, with g shifted by t.
;
;          indices - This keyword will only work properly if both images
;                    are of the same dimensions.  It allows the caller
;                    to specify a region over which the correlation
;                    will be optomized by giving an array of the 1D subscripts
;                    which lie within that region.
;
;          kill_char - Key which can be used to abort the search and return
;                      an offset of [0,0], with the corresponding correlation.
;                      This slows down the loop a bit, but not significantly
;                      for large images, in which it may be more important
;                      for the user to be able to abort.
;
;	   region - Size of region to scan, centered at offset [0,0].  If not
;		    specified, the entire image is scanned.
;
;  OUTPUT : NONE
;
;
;
; RETURN : t, the vector offset by which im2 had to be shifted for 
;          maximum correlation with im1.
;
;
;
;
; KNOWN BUGS : see 'Accuracy' above.
;
;
;
; ORIGINAL AUTHOR : J. Spitale ; 8/94
;
; UPDATE HISTORY : Spitale, 4/2002 -- added 'region' keyword
;
;-
;=============================================================================
function image_correlate, im1, im2, correlation, $
   show=show, nsamples=_nsamples, nohome=nohome, $
   function_min=function_min, function_max=function_max, $
   corners=corners, kill_char=kill_char, region=region, data=data, $
   wx=wx, wy=wy, no_width=no_width, bias=bias, nosearch=nosearch


 if(NOT keyword_set(function_min) AND NOT keyword_set(function_max)) then $
   function_max='cr_correlation'

 if(keyword_set(function_min)) then $
  begin
   fn=function_min
   minmax='MIN'
  end

 if(keyword_set(function_max)) then $
  begin
   fn=function_max
   minmax='MAX'
  end


;-----------paste images on backgrounds of same size---------

 s1=size(im1)
 s2=size(im2)

 if(s1(1) NE s2(1) OR s1(2) NE s2(2)) then $
  begin
   black=dblarr(s1(1)>s2(1), s1(2)>s2(2))
   black(*)=min(im1)<min(im2)
   image1=black
   image2=black

   image1(0:s1(1)-1, 0:s1(2)-1) = im1
   image2(0:s2(1)-1, 0:s2(2)-1) = im2
  end $
 else $
  begin
   image1=im1
   image2=im2
  end



;-----------perform correlation search---------


 t = grid_correlate(image1, image2, correlation, $
	show=show, nsamples=_nsamples, nohome=nohome, $
	function_min=function_min, function_max=function_max, $
	corners=corners, kill_char=kill_char, region=region, data=data, $
	wx=wx, wy=wy, no_width=no_width, bias=bias, nosearch=nosearch)



 return, t
end
;============================================================


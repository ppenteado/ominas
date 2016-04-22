;=============================================================================
;+
; NAME:
;	class_homogenize
;
;
; PURPOSE:
;	Produces a set of descriptors of the highest common object class.
;
;
; CATEGORY:
;	NV/LIB/CLASS
;
;
; CALLING SEQUENCE:
;	odh = class_homogenize(od)
;
;
; ARGUMENTS:
;  INPUT:
;	od:	 Array of descriptors of any class.
;
;  OUTPUT: 
;	class:	 String giving the name of the resulting class.
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	String array giving the names of all classes in od, in descending order.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function class_homogenize, odp, class, noevent=noevent
 nv_notify, odp, type = 1, noevent=noevent

 if(NOT keyword_set(odp)) then return, 0
 n = n_elements(odp)

 trees = strarr(10,n)

 ;------------------------------
 ; get trees
 ;------------------------------
 nnmax = 0
 for i=0, n-1 do $
  begin
   tree = class_get_tree(odp[i])
   nn = n_elements(tree)
   if(nn GT nnmax) then nnmax = nn
   trees[0:nn-1,i] = rotate(tree,2)    
  end

 ;------------------------------
 ; find highest common class
 ;------------------------------
 i = nnmax
 done = 0
 while(NOT done) do $
  begin
   i = i - 1
   if(i EQ -1) then done = 1 $
   else $
    begin
     w = where(trees[i,*] NE trees[i,0])
     if(w[0] EQ -1) then done = 1
    end
  end
 if(i EQ -1) then return, 0
 class = trees[i,0]

 ;------------------------------
 ; concatentate descriptors
 ;------------------------------
 return, class_extract(odp, class)
end
;===========================================================================

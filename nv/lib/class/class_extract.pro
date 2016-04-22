;=============================================================================
;+
; NAME:
;	class_extract
;
;
; PURPOSE:
;	Extracts the object descriptor of the specified class.
;
;
; CATEGORY:
;	NV/LIB/CLASS
;
;
; CALLING SEQUENCE:
;	odc = class_extract(od)
;
;
; ARGUMENTS:
;  INPUT:
;	od:	 Descriptor of any class.  Arrays may be inhomogeneous.
;
;	class:	 String giving the name of the class to extract.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	rm:	If set, the identified descriptors are removed from the 
;	        input array.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Descriptors of the desired class.
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
function class_extract, odp, class, indices=indices, rm=rm, noevent=noevent
 nv_notify, odp, type = 1, noevent=noevent

 if(NOT keyword_set(odp)) then return, 0

 indices = 0
 n = n_elements(odp)
 for i=0, n-1 do if(ptr_valid(odp[i])) then $
  begin
   od = nv_dereference(odp[i])

   ii = [i]

   case class_search(od, class) of $
	0 : xxdp = odp[i]
	1 : xxdp = od.(0)
	2 : xxdp = (nv_dereference(od.(0))).(0)
	3 : xxdp = (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0)
	4 : xxdp = (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0))).(0)
	5 : xxdp = (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0))).(0))).(0)
	6 : xxdp = (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0))).(0))).(0))).(0)
	7 : xxdp = (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0))).(0))).(0))).(0))).(0)
	else : begin
	        xxdp = nv_ptr_new()
	        ii = -1
	       end
   endcase

   xdp = append_array(xdp, xxdp)  
   indices = append_array(indices, ii) 
  end

 if(keyword_set(rm)) then odp = rm_list_item(odp, indices, only=0)

 return, xdp
end
;===========================================================================



;===========================================================================
; class_extract
;
;
;===========================================================================
function _class_extract, odp, class, noevent=noevent
 nv_notify, odp, type = 1, noevent=noevent
 od = nv_dereference(odp)

 case class_search(od, class) of $
	0 : return, odp
	1 : return, od.(0)
	2 : return, (nv_dereference(od.(0))).(0)
	3 : return, (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0)
	4 : return, (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0))).(0)
	5 : return, (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0))).(0))).(0)
	6 : return, (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0))).(0))).(0))).(0)
	7 : return, (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference( $
		    (nv_dereference(od.(0))).(0))).(0))).(0))).(0))).(0))).(0)
	else : return, 0
 endcase

end
;===========================================================================




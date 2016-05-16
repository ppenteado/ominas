;=============================================================================
;+
; NAME:
;	struct_sub
;
;
; PURPOSE:
;	Creates a new structure whise fields are the same as those in the 
;	given structure except for the specified substitutions.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = struct_sub(struct, sub_tags, sub_val_ps)
;
;
; ARGUMENTS:
;  INPUT:
;	struct:		Input structure.
;
;	sub_tags:	Tags to substitute
;
;	sub_val_s:	Pointers to values for the substituted tags.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	NONE
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	A new structure is created that is the same as the input structure
;	except for the specified field substitutions.
;
;
; RESTRICTIONS:
;	Currently only works for output structures with 10 or fewer fields.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2002
;
;-
;=============================================================================
function struct_sub, s, _sub_tags, sub_val_ps

;sub_tags=_sub_tags
 sub_tags = strupcase(_sub_tags)
 tags = tag_names(s)
 n = n_elements(tags)
 nsub = n_elements(sub_tags)

 new_val_ps = objarr(n+nsub)
 new_tags = strarr(n+nsub)

 ;--------------------------------
 ; replace existing fields 
 ;--------------------------------
 nn = 0
 for i=0, n-1 do $
  begin
   w = where(sub_tags EQ tags[i])
   if(w[0] EQ -1) then $
    begin
     new_val_ps[i] = nv_ptr_new(s.(i))
     new_tags[i] = tags[i]
    end $
   else $
    begin
     new_val_ps[i] = sub_val_ps[w[0]]
     new_tags[i] = sub_tags[w[0]]
    end 
   nn = nn + 1
  end
 nnn = nn

 ;--------------------------------
 ; append new fields 
 ;--------------------------------
 for i=0, nsub-1 do $
  begin
   w = where(tags EQ sub_tags[i])
   if(w[0] EQ -1) then $
    begin
     new_val_ps[i+nnn] = sub_val_ps[i] 
     new_tags[i+nnn] = sub_tags[i]
     nn = nn + 1
    end
  end

 new_tags = new_tags[0:nn-1]


 ;--------------------------------
 ; create new struct 
 ;--------------------------------
 case nn of
   1 : 	ss = create_struct(new_tags, *new_val_ps[0])
   2 : 	ss = create_struct(new_tags, *new_val_ps[0], $
	                             *new_val_ps[1])
   3 : 	ss = create_struct(new_tags, *new_val_ps[0], $
	                             *new_val_ps[1], $
	                             *new_val_ps[2])
   4 : 	ss = create_struct(new_tags, *new_val_ps[0], $
	                             *new_val_ps[1], $
	                             *new_val_ps[2], $
	                             *new_val_ps[3])
   5 : 	ss = create_struct(new_tags, *new_val_ps[0], $
	                             *new_val_ps[1], $
	                             *new_val_ps[2], $
	                             *new_val_ps[3], $
	                             *new_val_ps[4])
   6 : 	ss = create_struct(new_tags, *new_val_ps[0], $
	                             *new_val_ps[1], $
	                             *new_val_ps[2], $
	                             *new_val_ps[3], $
	                             *new_val_ps[4], $
	                             *new_val_ps[5])
   7 : 	ss = create_struct(new_tags, *new_val_ps[0], $
	                             *new_val_ps[1], $
	                             *new_val_ps[2], $
	                             *new_val_ps[3], $
	                             *new_val_ps[4], $
	                             *new_val_ps[5], $
	                             *new_val_ps[6])
   8 : 	ss = create_struct(new_tags, *new_val_ps[0], $
	                             *new_val_ps[1], $
	                             *new_val_ps[2], $
	                             *new_val_ps[3], $
	                             *new_val_ps[4], $
	                             *new_val_ps[5], $
	                             *new_val_ps[6], $
	                             *new_val_ps[7])
   9 : 	ss = create_struct(new_tags, *new_val_ps[0], $
	                             *new_val_ps[1], $
	                             *new_val_ps[2], $
	                             *new_val_ps[3], $
	                             *new_val_ps[4], $
	                             *new_val_ps[5], $
	                             *new_val_ps[6], $
	                             *new_val_ps[7], $
	                             *new_val_ps[8])
  10 : 	ss = create_struct(new_tags, *new_val_ps[0], $
	                             *new_val_ps[1], $
	                             *new_val_ps[2], $
	                             *new_val_ps[3], $
	                             *new_val_ps[4], $
	                             *new_val_ps[5], $
	                             *new_val_ps[6], $
	                             *new_val_ps[7], $
	                             *new_val_ps[8], $
	                             *new_val_ps[9])
 endcase


 nv_ptr_free, new_val_ps

 return, ss
end
;=============================================================================

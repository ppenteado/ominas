;=============================================================================
; ominas_core::rereference
;
;=============================================================================
pro ominas_core::rereference, struct
@core.include
 struct_assign, struct, self
end
;=============================================================================



;=============================================================================
; ominas_core::dereference
;
;=============================================================================
function ominas_core::dereference, struct
@core.include

 if(NOT keyword_set(struct)) then struct = create_struct(obj_class(self))

 struct_assign, self, struct
 return, struct
end
;=============================================================================



;=============================================================================
; ominas_core::init
;
;=============================================================================
function ominas_core::init, ii, crd=crd0, $
@cor__keywords.include
end_keywords
@core.include
 
 if(keyword_set(crd0)) then struct_assign, crd0, self


 if(keyword_set(tasks)) then self.tasks_p = nv_ptr_new(tasks[*,ii]) $
 else self.tasks_p=nv_ptr_new([''])

 self.abbrev = 'COR'
 self.tag = 'CRD'
 if(keyword_set(name)) then self.name = decrapify(name[ii])

 if(keyword_set(udata)) then cor_set_udata, self, uname, udata	;;;;

; self.__protect__gdp = nv_ptr_new(0)
; if(keyword_set(gd)) then *self.__protect__gdp = cor_create_gd(gd[ii], /explicit)

 self.gdp = nv_ptr_new(0)
 if(keyword_set(gd)) then $
              *self.gdp = {__PROTECT__:0, gd:cor_create_gd(gd[ii], /explicit)}

 return, 1
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	ominas_core__define
;
;
; PURPOSE:
;	Class structure for the CORE class.
;
;
; CATEGORY:
;	NV/OBJ/COR
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	name:	Name of the object.
;
;		Methods: cor_name, cor_set_name
;
;
;	user:	Username.
;
;		Methods: cor_user
;
;
;	tasks_p:
;		Pointer to tasks list.
;
;		Methods: cor_tasks, cor_add_task
;
;
;	udata_tlp:	
;		Tag list containing user data.
;
;		Methods: cor_set_udata, cor_test_udata, cor_udata
;
;	abbrev:	Abbreviation for this descriptor class, e.g., COR.
;
;	tag:	Tag for this descriptor class, e.g., CRD.
;
;	gdp:	Pointer to generic descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro ominas_core__define

 struct = $
    { ominas_core, inherits IDL_Object, $
	tasks_p:	 nv_ptr_new(), $	; Pointer to task list 
	name:		 '', $			; Name of object
	udata_tlp:	 nv_ptr_new(), $	; Pointer to user data
	abbrev:		 '', $			; Abbreviation of descriptor class
	tag:		 '', $			; Standard tag for this descriptor type
	user:		 '', $			; Name of user
	gdp: 		nv_ptr_new() $		; Generic descriptor
;	__PROTECT__gdp: 	nv_ptr_new() $	; Generic descriptor
    }

end
;===========================================================================




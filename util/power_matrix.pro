;=============================================================================
;+
; NAME:
;       power_matrix
;
;
; PURPOSE:
;       Constructs an array of n x n matrices such that the (i,j)th element
;       of the kth matrix is:
;                                  i    j
;                   M(i,j,k) = p(k) q(k)
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = power_matrix(p, q, n)
;
;
; ARGUMENTS:
;  INPUT:
;       p:      An input array of k elements
;
;       q:      An input array of k elements
;
;       n:      Dimension of 2d matrix
;
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;       NONE
;
;
; RETURN:
;       The power_matrix as described above.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function power_matrix, _p, _q, n

 p = double(_p)
 q = double(_q)

 np=n_elements(p)
 PP=p[gen3z(n,n,np)]
 QQ=q[gen3z(n,n,np)]

 Ppow=gen3x(n,n,np)
 Qpow=gen3y(n,n,np)

 return, (PP^Ppow)*(QQ^Qpow)
end
;===========================================================================

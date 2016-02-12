###############################################################################
# sun-4_sunos.make
#
#
###############################################################################
GCC=		gcc
LDSO=		ld
SO_CC_OPTIONS=	-shared
SO_LD_OPTIONS=	
ANSI=		
COPY=		cp
ARCHIVE=	$(PFDIR)/ar.sunos
DEARCHIVE=	ar -x
SOCKET_LIBS=	
DL_LIBS=	
MATH_LIBS=	
C_LIBS=		-lc $(SOCKET_LIBS) $(DL_LIBS) $(MATH_LIBS)


###############################################################################

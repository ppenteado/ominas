###############################################################################
# alpha_osf.make
#
#
###############################################################################
GCC=		cc -O0
LDSO=		ld
SO_CC_OPTIONS=	-shared
SO_LD_OPTIONS=	-shared
ANSI=		-std1
COPY=		cp
ARCHIVE=	ar rcv
#DEARCHIVE=	ar -x
DEARCHIVE=	$(PFDIR)/arx.osf
SOCKET_LIBS=	#-lsocket -lnsl
DL_LIBS=	
MATH_LIBS=	-lm
C_LIBS=		-lc $(SOCKET_LIBS) $(DL_LIBS) $(MATH_LIBS)


###############################################################################

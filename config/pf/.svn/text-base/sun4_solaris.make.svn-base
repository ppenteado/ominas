###############################################################################
# sun4_solaris.make
#
#
###############################################################################
GCC=		cc
LDSO=		ld
SO_CC_OPTIONS=	 -xarch=v7
SO_LD_OPTIONS=	-G
COPY=		cp
ARCHIVE=	ar rcv
DEARCHIVE=	ar -x
SOCKET_LIBS=	-lsocket -lnsl
DL_LIBS=	-ldl
MATH_LIBS=	-lm
C_LIBS=		-lc $(SOCKET_LIBS) $(DL_LIBS) $(MATH_LIBS)


###############################################################################

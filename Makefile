DEST	      = .

#EXTHDRS	      = /usr/include/sys/times.h \
#		/usr/include/sys/types.h

HDRS	      = timing.h \
		type.h
MIS           = Makefile makefile.sun makefile.alliant makefile.titan

# For SUN-3
#FLOAT_OPTIONS = -f68881
#CFLOAT_OPTIONS = -f68881 -fsingle

# For NEWS
#CFLOAT_OPTIONS = -f
#CFLAGS        = -DMINI -DUNIX -DBSD $(CFLOAT_OPTIONS) -O -DSHORTREAL
#FFLAGS        = -DMINI -DUNIX -DBSD  -u $(FLOAT_OPTIONS) -O -DSHORTREAL
#LDFLAGS	      =  
# For MIPS
CFLOAT_OPTIONS = 
CFLAGS        =  -DUNIX -DBSD $(CFLOAT_OPTIONS) -O2
FFLAGS        =  -DUNIX -DBSD  -u $(FLOAT_OPTIONS) -O2 -v
LDFLAGS	      =  -v -Bstatic

LIBS	      =

LINKER	      = f77

MAKEFILE      = Makefile

OBJS	      = second.o \
		csubs.o \
		timing.o

PRINT	      = pr

PROGRAM	      = timing

SRCS	      = second.c \
		csubs.c \
		timing.F

all:		$(PROGRAM)

$(PROGRAM):     $(OBJS) $(LIBS)
		@echo -n "Loading $(PROGRAM) ... "
		@$(LINKER) $(LDFLAGS) $(OBJS) $(LIBS) -o $(PROGRAM)
		@echo "done"

clean:;		@rm -f $(OBJS) $(PROGRAM)

depend:;	@mkmf -f $(MAKEFILE) PROGRAM=$(PROGRAM) DEST=$(DEST)

index:;		@ctags -wx $(HDRS) $(SRCS)

install:	$(PROGRAM)
		@echo Installing $(PROGRAM) in $(DEST)
		@install -s $(PROGRAM) $(DEST)

print:;		@$(PRINT) $(HDRS) $(SRCS)

program:        $(PROGRAM)

tags:           $(HDRS) $(SRCS); @ctags $(HDRS) $(SRCS)

update:		$(DEST)/$(PROGRAM)

###

fd  : timing.MSP timing.CRY Makefile $(HDRS) $(SRCS)
	csh /usr/local/mssave timing.MSP timing.CRY Makefile $(HDRS) $(SRCS)
msp : timing.MSP
	ls -l timing.MSP
timing.MSP : $(HDRS) $(SRCS)
	f77 -F -DMSP -DBIG timing.F 
	dd conv=ucase <timing.f| sed -e '/^#/d' >timing.MSP
	rm timing.f
timing.VOS : $(HDRS) $(SRCS)
	f77 -F -DVOS3 -DBIG timing.F 
	dd conv=ucase <timing.f| sed -e '/^#/d' >timing.MSP
	rm timing.f
cray : timing.CRY
	ls -l timing.CRY
timing.CRY : $(HDRS) $(SRCS)
	f77 -F -DCRAY -DBIG timing.F 
	dd conv=ucase <timing.f| sed -e '/^#/d'  >timing.CRY
	rm timing.f
cyber : timing.CYB
	ls -l timing.CYB
	jvncput timing.CYB timing
timing.CYB : $(HDRS) $(SRCS)
	f77 -F -DCYBER -DBIG timing.F 
	dd conv=ucase <timing.f| sed -e '/^#/d'  >timing.CYB
	rm timing.f

shar : timing.shar
	ls -l timing.shar
timing.shar : $(HDRS) $(SRCS) $(MIS)
	bundle $(HDRS) $(SRCS) $(MIS) > timing.shar
###

second.o: second.c
timing.o: type.h timing.h timing.F
	gfortran $(FFLAGS) -c timing.F

#Makefile for 2D MPI/OpenMP PIC codes

# Makefile gfortran compiler with MacOS X

#OpenMPI
#MPIFC = mpif90 -fopenmp
#MPICC = mpicc -fopenmp

#FC90 = gfortran -fopenmp
#CC = gcc

#OPTS90 = -O3
#OPTS90 = -O3 -fdefault-real-8 -fdefault-double-8
#OPTS90 = -O3 -fcheck=bounds -fdefault-real-8 -fdefault-double-8 -Wall -std=f95

#CCOPTS = -O3 -std=c99
#CCOPTS = -O3 -Wall -std=c99

#LOPTS = -lgomp
#LEGACY =

# Makefile Intel compiler with Mac OS X

# OpenMPI
#MPIFC = mpif90 -qopenmp
#MPICC = mpicc -fopenmp

#FC90 = ifort -qopenmp
#CC = gcc

#OPTS90 = -O3
#OPTS90 = -O3 -r8
#OPTS90 = -O3 -CB -r8 -warn all -std90

#CCOPTS = -O3 -std=c99
#CCOPTS = -O3 -Wall -std=c99

#LEGACY = -nofor_main

# Makefile Intel compiler with Linux

# MPI
#MPIFC = mpiifort -qopenmp
#MPICC = mpiicc -qopenmp

#FC90 = ifort -qopenmp
#CC = icc

#OPTS90 = -O3
#OPTS90 = -O3 -r8
#OPTS90 = -O3 -CB -r8 -warn all -std90

#CCOPTS = -O3 -std=c99
#CCOPTS = -O3 -no-vec -Wall -std=c99

#LGOPTS = -lYgl -L/usr/X11R6/lib -lX11
#LEGACY = -nofor_main

# Makefile gfortran compiler with Linux

# OpenMPI
MPIFC = mpif90 -fopenmp
MPICC = mpicc -fopenmp

FC90 = gfortran -fopenmp
CC = gcc

OPTS90 = -O3
#OPTS90 = -O3 -fdefault-real-8 -fdefault-double-8
#OPTS90 = -O3 -fbounds-check -fdefault-real-8 -fdefault-double-8 -Wall -std=f95

CCOPTS = -O3 -std=c99
#CCOPTS = -O3 -Wall -std=c99

LOPTS = -lgomp
#LGOPTS = -lYgl -L/usr/X11R6/lib -lX11
LEGACY =

# Makefile PGI compiler with Linux

# OpenMPI
#MPIFC = mpipgf90
#MPICC = mpicc -fopenmp

#FC90 = pgf90
#CC = gcc

#OPTS90 = -O3
#OPTS90 = -O3 -r8
#OPTS90 = -O3 -Mbounds -r8 -Mstandard

#CCOPTS = -O3 -std=c99
#CCOPTS = -O3 -Wall -std=c99

#LEGACY = -Mnomain

# Makefile Cray compiler with Linux

# MPI
#MPIFC = ftn -h omp
#MPICC = cc -h omp

#FC90 = ftn -h omp
#CC = cc

#OPTS90 = -O 3
#OPTS90 = -O 3 -s real64
#OPTS90 = -O 3 -R b -s real64 -en

#CCOPTS = -O 3 -h c99 -h conform

#LEGACY =

#

ESOBJS = libmpinit2.o libmppush2.o libmpsort2.o libmpgard2.o libmpfft2.o \
libmpfield2.o

EMOBJS = libmpbpush2.o libmpcurd2.o

EDOBJS = libmpdpush2.o

ESHOBJS = libmpinit2_h.o libmppush2_h.o libmpsort2_h.o libmpgard2_h.o \
libmpfft2_h.o libmpfield2_h.o

EMHOBJS = libmpbpush2_h.o libmpcurd2_h.o

EDHOBJS = libmpdpush2_h.o

ESMODS = input2mod.o modmpinit2.o modmppush2.o modmpsort2.o modmpgard2.o \
modmpfft2.o modmpfield2.o modmpdiag2.o

EMMODS = modmpbpush2.o modmpcurd2.o

EDMODS = modmpdpush2.o

# Fortran Graphics

#Tektronix
#GOBJS = libt1.o plot10.o libplt10.o libgks1.o libgks2.o plibgks2.o \
#modpgraf2.o
# X11 graphics needs Ygl from http://www.thp.uni-duisburg.de/Ygl/
#GOBJS = libygl.o libgks1.o libgks2.o plibgks2.o modpgraf2.o
#NGOBJS = libygl.o libgks1.o libgks2.o nplibgks2.o nmodpgraf2.o
#No graphics
GOBJS = nullgks1.o nullgks2.o nullpgks2.o modpgraf2.o
NGOBJS = nullgks1.o nullgks2.o nullpgks2.o nmodpgraf2.o

# Linkage rules

all : mpbeps2 mpbbeps2 mpdbeps2

nompi : mbeps2 mbbeps2 mdbeps2

mpbeps2 : mpbeps2.o $(ESOBJS) $(GOBJS) dtimer.o
	$(MPIFC) $(OPTS90) $(LOPTS) $(LGOPTS) -o mpbeps2 \
    mpbeps2.o $(ESOBJS) $(ESMODS) mpplib2.o mppmod2.o omplib.o ompplib2.o \
    $(ESHOBJS) $(GOBJS) dtimer.o

mpbbeps2 : mpbbeps2.o $(ESOBJS) $(EMOBJS) $(GOBJS) dtimer.o
	$(MPIFC) $(OPTS90) $(LOPTS) $(LGOPTS) -o mpbbeps2 \
    mpbbeps2.o $(ESOBJS) $(EMOBJS) $(ESMODS) $(EMMODS) mpplib2.o \
    mppmod2.o omplib.o ompplib2.o $(ESHOBJS) $(EMHOBJS) $(GOBJS) dtimer.o

mpdbeps2 : mpdbeps2.o $(ESOBJS) $(EMOBJS) $(EDOBJS) $(GOBJS) dtimer.o
	$(MPIFC) $(OPTS90) $(LOPTS) $(LGOPTS) -o mpdbeps2 \
    mpdbeps2.o $(ESOBJS) $(EMOBJS) $(EDOBJS) $(ESMODS) $(EMMODS) $(EDMODS) \
    mpplib2.o mppmod2.o omplib.o ompplib2.o $(ESHOBJS) $(EMHOBJS) $(EDHOBJS) \
    $(GOBJS) dtimer.o

#noMPI
mbeps2 : mbeps2.o $(ESOBJS) noMPI.o $(NGOBJS) dtimer.o
	$(FC90) $(OPTS90) $(LOPTS) $(LGOPTS) -o mbeps2 \
    mbeps2.o $(ESOBJS) $(ESMODS) nmpplib2.o nmppmod2.o omplib.o nompplib2.o \
    $(ESHOBJS) noMPI.o $(NGOBJS) dtimer.o

mbbeps2 : mbbeps2.o $(ESOBJS) $(EMOBJS) noMPI.o $(NGOBJS) dtimer.o
	$(FC90) $(OPTS90) $(LOPTS) $(LGOPTS) -o mbbeps2 \
    mbbeps2.o $(ESOBJS) $(EMOBJS) $(ESMODS) $(EMMODS) nmpplib2.o \
    nmppmod2.o omplib.o nompplib2.o $(ESHOBJS) $(EMHOBJS) noMPI.o $(NGOBJS) dtimer.o

mdbeps2 : mdbeps2.o $(ESOBJS) $(EMOBJS) $(EDOBJS) noMPI.o $(NGOBJS) dtimer.o
	$(FC90) $(OPTS90) $(LOPTS) $(LGOPTS) -o mdbeps2 \
    mdbeps2.o $(ESOBJS) $(EMOBJS) $(EDOBJS) $(ESMODS) $(EMMODS) $(EDMODS) \
    nmpplib2.o nmppmod2.o omplib.o nompplib2.o $(ESHOBJS) $(EMHOBJS) \
    $(EDHOBJS) noMPI.o $(NGOBJS) dtimer.o

# Compilation rules

dtimer.o : dtimer.c
	$(CC) $(CCOPTS) -c dtimer.c

#noMPI
noMPImod.o : noMPI.f90
	$(FC90) $(OPTS90) -o noMPImod.o -c noMPI.f90

noMPI.o : noMPI.f
	$(FC90) $(OPTS90) -o noMPI.o -c noMPI.f

nmpplib2.o : mpplib2.f90 noMPImod.o
	$(FC90) $(OPTS90) -o nmpplib2.o -c mpplib2.f90

nmppmod2.o : mppmod2.f90 nmpplib2.o
	$(FC90) $(OPTS90) -o nmppmod2.o -c mppmod2.f90

nompplib2.o : ompplib2.f90 modmpsort2.o modmpfft2.o modmpgard2.o nmppmod2.o
	$(FC90) $(OPTS90) -o nompplib2.o -c ompplib2.f90

#OPENMP
omplib.o : omplib.f90
	$(FC90) $(OPTS90) -o omplib.o -c omplib.f90

mpplib2.o : mpplib2.f90
	$(MPIFC) $(OPTS90) -o mpplib2.o -c mpplib2.f90

mppmod2.o : mppmod2.f90 mpplib2.o
	$(FC90) $(OPTS90) -o mppmod2.o -c mppmod2.f90

libmpinit2.o : libmpinit2.f
	$(FC90) $(OPTS90) -o libmpinit2.o -c libmpinit2.f

libmppush2.o : libmppush2.f
	$(FC90) $(OPTS90) -o libmppush2.o -c libmppush2.f

libmpbpush2.o : libmpbpush2.f
	$(FC90) $(OPTS90) -o libmpbpush2.o -c libmpbpush2.f

libmpcurd2.o : libmpcurd2.f
	$(FC90) $(OPTS90) -o libmpcurd2.o -c libmpcurd2.f

libmpdpush2.o : libmpdpush2.f
	$(FC90) $(OPTS90) -o libmpdpush2.o -c libmpdpush2.f

libmpsort2.o : libmpsort2.f
	$(FC90) $(OPTS90) -o libmpsort2.o -c libmpsort2.f

libmpgard2.o : libmpgard2.f
	$(FC90) $(OPTS90) -o libmpgard2.o -c libmpgard2.f

libmpfft2.o : libmpfft2.f
	$(FC90) $(OPTS90) -o libmpfft2.o -c libmpfft2.f

libmpfield2.o : libmpfield2.f
	$(FC90) $(OPTS90) -o libmpfield2.o -c libmpfield2.f

libmpinit2_h.o : libmpinit2_h.f90
	$(FC90) $(OPTS90) -o libmpinit2_h.o -c libmpinit2_h.f90

libmppush2_h.o : libmppush2_h.f90
	$(FC90) $(OPTS90) -o libmppush2_h.o -c libmppush2_h.f90

libmpbpush2_h.o : libmpbpush2_h.f90
	$(FC90) $(OPTS90) -o libmpbpush2_h.o -c libmpbpush2_h.f90

libmpcurd2_h.o : libmpcurd2_h.f90
	$(FC90) $(OPTS90) -o libmpcurd2_h.o -c libmpcurd2_h.f90

libmpdpush2_h.o : libmpdpush2_h.f90
	$(FC90) $(OPTS90) -o libmpdpush2_h.o -c libmpdpush2_h.f90

libmpsort2_h.o : libmpsort2_h.f90
	$(FC90) $(OPTS90) -o libmpsort2_h.o -c libmpsort2_h.f90

libmpgard2_h.o : libmpgard2_h.f90
	$(FC90) $(OPTS90) -o libmpgard2_h.o -c libmpgard2_h.f90

libmpfft2_h.o : libmpfft2_h.f90
	$(FC90) $(OPTS90) -o libmpfft2_h.o -c libmpfft2_h.f90

libmpfield2_h.o : libmpfield2_h.f90
	$(FC90) $(OPTS90) -o libmpfield2_h.o -c libmpfield2_h.f90

input2mod.o : input2mod.f90
	$(FC90) $(OPTS90) -o input2mod.o -c input2mod.f90

modmpinit2.o : modmpinit2.f90 libmpinit2_h.o
	$(FC90) $(OPTS90) -o modmpinit2.o -c modmpinit2.f90

modmppush2.o : modmppush2.f90 libmppush2_h.o
	$(FC90) $(OPTS90) -o modmppush2.o -c modmppush2.f90

modmpbpush2.o : modmpbpush2.f90 libmpbpush2_h.o
	$(FC90) $(OPTS90) -o modmpbpush2.o -c modmpbpush2.f90

modmpcurd2.o : modmpcurd2.f90 libmpcurd2_h.o
	$(FC90) $(OPTS90) -o modmpcurd2.o -c modmpcurd2.f90

modmpdpush2.o : modmpdpush2.f90 libmpdpush2_h.o
	$(FC90) $(OPTS90) -o modmpdpush2.o -c modmpdpush2.f90

modmpsort2.o : modmpsort2.f90 libmpsort2_h.o
	$(FC90) $(OPTS90) -o modmpsort2.o -c modmpsort2.f90

modmpgard2.o : modmpgard2.f90 libmpgard2_h.o
	$(FC90) $(OPTS90) -o modmpgard2.o -c modmpgard2.f90

modmpfft2.o : modmpfft2.f90 libmpfft2_h.o
	$(FC90) $(OPTS90) -o modmpfft2.o -c modmpfft2.f90

modmpfield2.o : modmpfield2.f90 libmpfield2_h.o
	$(FC90) $(OPTS90) -o modmpfield2.o -c modmpfield2.f90

modmpdiag2.o : modmpdiag2.f90
	$(FC90) $(OPTS90) -o modmpdiag2.o -c modmpdiag2.f90

ompplib2.o : ompplib2.f90 modmpsort2.o modmpfft2.o modmpgard2.o mppmod2.o
	$(FC90) $(OPTS90) -o ompplib2.o -c ompplib2.f90

mpbeps2.o : mpbeps2.f90 $(ESMODS) mppmod2.o omplib.o ompplib2.o modpgraf2.o
	$(FC90) $(OPTS90) -o mpbeps2.o -c mpbeps2.f90

mpbbeps2.o : mpbbeps2.f90 $(ESMODS) $(EMMODS) mppmod2.o omplib.o ompplib2.o \
             modpgraf2.o
	$(FC90) $(OPTS90) -o mpbbeps2.o -c mpbbeps2.f90

mpdbeps2.o : mpdbeps2.f90 $(ESMODS) $(EMMODS) $(EDMODS) mppmod2.o omplib.o \
             ompplib2.o modpgraf2.o
	$(FC90) $(OPTS90) -o mpdbeps2.o -c mpdbeps2.f90

#noMPI
mbeps2.o : mpbeps2.f90 $(ESMODS) nmppmod2.o omplib.o nompplib2.o nmodpgraf2.o
	$(FC90) $(OPTS90) -o mbeps2.o -c mpbeps2.f90

mbbeps2.o : mpbbeps2.f90 $(ESMODS) $(EMMODS) nmppmod2.o omplib.o nompplib2.o \
            nmodpgraf2.o
	$(FC90) $(OPTS90) -o mbbeps2.o -c mpbbeps2.f90

mdbeps2.o : mpdbeps2.f90 $(ESMODS) $(EMMODS) $(EDMODS) nmppmod2.o omplib.o \
            nompplib2.o nmodpgraf2.o
	$(FC90) $(OPTS90) -o mdbeps2.o -c mpdbeps2.f90

# Fortran Graphics

libt1.o : gks2/libt1.f90
	$(FC90) $(OPTS90) -o libt1.o -c gks2/libt1.f90

plot10.o : gks2/plot10.f
	$(FC90) $(OPTS90) -o plot10.o -c gks2/plot10.f

libplt10.o : gks2/libplt10.f
	$(FC90) $(OPTS90) -o libplt10.o -c gks2/libplt10.f
	
libygl.o : gks2/libygl.f
	$(FC90) $(OPTS90) -o libygl.o -c gks2/libygl.f

libgks1.o : gks2/libgks1.f
	$(FC90) $(OPTS90) -o libgks1.o -c gks2/libgks1.f

nullgks1.o : gks2/nullgks1.f
	$(FC90) $(OPTS90) -o nullgks1.o -c gks2/nullgks1.f

libgks2.o : gks2/libgks2.f
	$(FC90) $(OPTS90) -o libgks2.o -c gks2/libgks2.f

nullgks2.o : gks2/nullgks2.f
	$(FC90) $(OPTS90) -o nullgks2.o -c gks2/nullgks2.f

plibgks2.o : gks2/plibgks2.f90 mpplib2.o
	$(FC90) $(OPTS90) -o plibgks2.o -c gks2/plibgks2.f90

nullpgks2.o : gks2/nullpgks2.f90
	$(FC90) $(OPTS90) -o nullpgks2.o -c gks2/nullpgks2.f90

modpgraf2.o : gks2/modpgraf2.f90 plibgks2.o
	$(FC90) $(OPTS90) -o modpgraf2.o -c gks2/modpgraf2.f90

#noMPI
nplibgks2.o : gks2/plibgks2.f90 nmpplib2.o
	$(FC90) $(OPTS90) -o nplibgks2.o -c gks2/plibgks2.f90

nmodpgraf2.o : gks2/modpgraf2.f90 nplibgks2.o
	$(FC90) $(OPTS90) -o nmodpgraf2.o -c gks2/modpgraf2.f90

cpexecs : cpmpbeps2 cpmpbbeps2 cpmpdbeps2

cpmpbeps2 :
	cp mpbeps2 ../

cpmpbbeps2 :
	cp mpbbeps2 ../

cpmpdbeps2 :
	cp mpdbeps2 ../

#noMPI
cpmexecs : cpmbeps2 cpmbbeps2 cpmdbeps2

cpmbeps2 :
	cp mbeps2 ../

cpmbbeps2 :
	cp mbbeps2 ../

cpmdbeps2 :
	cp mdbeps2 ../

clean :
	rm -f *.o *.mod

clobber: clean
	rm -f mpbeps2 mpbbeps2 mpdbeps2 mbeps2 mbbeps2 mdbeps2

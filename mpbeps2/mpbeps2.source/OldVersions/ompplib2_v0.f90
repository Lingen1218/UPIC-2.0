!-----------------------------------------------------------------------
!
      module ompplib2
!
! ompmove2 reorder particles by tile with OpenMP and MPI
!          calls mporderf2a or mporder2a, and mpmove2, mporder2b
! wmpfft2r performs 2d real/complex FFT for scalar data,
!          moving data between uniform and non-uniform partitions
!          calls mpfmove2 and mpfft2r
! wmpfft2rn performs 2d real/complex FFT for n component vector data,
!           moving data between uniform and non-uniform partitions
!           calls mpfnmove2 and mpfft2rn
! wmpcguard2 copy scalar guard cells to local and remote partitions
! wmpncguard2 copy vector guard cells to local and remote partitions
!             calls mpncguard2, mpcguard2x
! wmpaguard2 add scalar guard cells from local and remote partitions
!            calls mpaguard2x, mpnaguard2
! wmpnacguard2 add vector guard cells from local and remote partitions
!              calls mpacguard2x, mpnacguard2
! written by viktor k. decyk, ucla
! copyright 2016, regents of the university of california
! update: february 20, 2016
!
      use modmpsort2
      use modmpfft2
      use modmpgard2
      use mppmod2, only: mpmove2, mpfmove2, mpfnmove2, mpcguard2,       &
     &mpncguard2, mpnaguard2, mpnacguard2
      implicit none
!
! ppbuff = buffer array for reordering tiled particle array
      real, dimension(:,:,:), allocatable :: ppbuff
      integer :: szpbuf = 0
! sbufl/sbufr = particle buffers sent to nearby processors
! rbufl/rbufr = particle buffers received from nearby processors
      real, dimension(:,:), allocatable :: sbufl, sbufr, rbufl, rbufr
      integer :: szbufs = 0
! ncll/nclr/mcll/mclr = number offsets send/received from processors
      integer, dimension(:,:), allocatable :: ncll, nclr, mcll, mclr
      integer :: sznbufs = 0
      save
!
      private :: ppbuff, szpbuf
      private :: sbufl, sbufr, rbufl, rbufr, szbufs
      private :: ncll, nclr, mcll, mclr, sznbufs
!
      contains
!
!-----------------------------------------------------------------------
      subroutine ompmove2(ppart,kpic,ncl,ihole,noff,nyp,tsort,tmov,kstrt&
     &,nvp,nx,ny,mx,my,npbmx,nbmax,mx1,plist,irc2)
! reorder particles by tile with OpenMP and MPI
! list = (true,false) = list of particles leaving tiles found in push
      implicit none
      integer, intent(in) :: kstrt, nvp, nx, ny, mx, my, npbmx, nbmax
      integer, intent(in) :: mx1
      integer, intent(in) :: noff, nyp
      real, intent(inout) :: tsort, tmov
      logical, intent(in) :: plist
      real, dimension(:,:,:), intent(inout) :: ppart
      integer, dimension(:), intent(inout) :: kpic
      integer, dimension(:,:), intent(inout) :: ncl
      integer, dimension(:,:,:), intent(inout) :: ihole
      integer, dimension(2), intent(inout) :: irc2
! local data
      integer :: idimp, nppmx, mxyp1, ntmax
! extract dimensions
      idimp = size(ppart,1); nppmx = size(ppart,2)
      mxyp1 = size(ppart,3)
      ntmax = size(ihole,2) - 1
! check if required size of buffer has increased
      if (szpbuf < idimp*npbmx*mxyp1) then
         if (szpbuf /= 0) deallocate(ppbuff)
! allocate new buffer
         allocate(ppbuff(idimp,npbmx,mxyp1))
         szpbuf = idimp*npbmx*mxyp1
      endif
! check if required size of buffers has increased
      if (szbufs < idimp*nbmax) then
         if (szbufs /= 0) deallocate(sbufl,sbufr,rbufl,rbufr)
! allocate new buffers
         allocate(sbufl(idimp,nbmax),sbufr(idimp,nbmax))
         allocate(rbufl(idimp,nbmax),rbufr(idimp,nbmax))
         szbufs = idimp*nbmax
      endif
! check if required size of buffers has increased
      if (sznbufs < 3*mx1) then
         if (sznbufs /= 0) deallocate(ncll,nclr,mcll,mclr)
! allocate new buffers
         allocate(ncll(3,mx1),nclr(3,mx1),mcll(3,mx1),mclr(3,mx1))
         sznbufs = 3*mx1
      endif
!
! first part of particle reorder on x and y cell with mx, my tiles:
! list of particles leaving tile already calculated by push
      if (plist) then
! updates: ppart, ppbuff, sbufl, sbufr, ncl, ncll, nclr, irc
         call mporderf2a(ppart,ppbuff,sbufl,sbufr,ncl,ihole,ncll,nclr,  &
     &tsort,irc2)
         if (irc2(1) /= 0) then
            write (*,*) kstrt,'mporderf2a error: irc1=', irc2
         endif
! calculate list of particles leaving tile
      else
! updates ppart, ppbuff, sbufl, sbufr, ncl, ihole, ncll, nclr, irc
         call mporder2a(ppart,ppbuff,sbufl,sbufr,kpic,ncl,ihole,ncll,   &
     &nclr,noff,nyp,tsort,nx,ny,mx,my,irc2)
         if (irc2(1) /= 0) then
            write (*,*) kstrt,'mporder2a error: irc2=', irc2
         endif
      endif
      if (irc2(1) /= 0) then
         call PPABORT()
         stop
      endif
!
! move particles into appropriate spatial regions with MPI:
! updates rbufr, rbufl, mcll, mclr
      call mpmove2(sbufr,sbufl,rbufr,rbufl,ncll,nclr,mcll,mclr,tmov,    &
     &kstrt,nvp)
!
! second part of particle reorder on x and y cell with mx, my tiles:
! updates ppart, kpic
      call mporder2b(ppart,ppbuff,rbufl,rbufr,kpic,ncl,ihole,mcll,mclr, &
     &tsort,nx,ny,irc2)
      if (irc2(1) /= 0) then
         write (*,*) kstrt,'mporder2b error: irc2=', irc2
         call PPABORT()
         stop
      endif
      end subroutine
!
!-----------------------------------------------------------------------
      subroutine wmpfft2r(f,g,noff,nyp,isign,mixup,sct,tfft,tfmov,indx,&
     &indy,kstrt,nvp,kyp,ny,mter,ierr)
! performs 2d real/complex FFT for scalar data
! data in real space has a non-uniform partition,
! data in fourier space has a uniform partition
      implicit none
      integer, intent(in) :: isign, indx, indy, kstrt, nvp, kyp, ny
      integer, intent(in) :: noff, nyp
      integer, intent(inout) :: mter, ierr
      real, intent(inout) :: tfmov
      real, dimension(:,:), intent(inout) :: f
      complex, dimension(:,:), intent(inout) :: g
      integer, dimension(:), intent(in) :: mixup
      complex, dimension(:), intent(in) :: sct
      real, dimension(2), intent(inout) :: tfft
! inverse fourier transform: from real to complex
      if (isign < 0) then
! moves scalar grids from non-uniform to uniform partition
         call mpfmove2(f,noff,nyp,isign,tfmov,kyp,ny,kstrt,nvp,mter,ierr&
     &)
! wrapper function for scalar 2d real/complex FFT
         call mpfft2r(f,g,isign,mixup,sct,tfft,indx,indy,kstrt,nvp,kyp)
! forward fourier transform: from complex to real
      else if (isign > 0) then
! wrapper function for scalar 2d real/complex FFT
         call mpfft2r(f,g,isign,mixup,sct,tfft,indx,indy,kstrt,nvp,kyp)
! moves scalar grids from uniform to non-uniform partition
         call mpfmove2(f,noff,nyp,isign,tfmov,kyp,ny,kstrt,nvp,mter,ierr&
     &)
      endif
      end subroutine
!
!-----------------------------------------------------------------------
      subroutine wmpfft2rn(f,g,noff,nyp,isign,mixup,sct,tfft,tfmov,indx,&
     &indy,kstrt,nvp,kyp,ny,mter,ierr)
! performs 2d real/complex FFT for n component vector data
! data in real space has a non-uniform partition,
! data in fourier space has a uniform partition
      implicit none
      integer, intent(in) :: isign, indx, indy, kstrt, nvp, kyp, ny
      integer, intent(in) :: noff, nyp
      integer, intent(inout) :: mter, ierr
      real, intent(inout) :: tfmov
      real, dimension(:,:,:), intent(inout) :: f
      complex, dimension(:,:,:), intent(inout) :: g
      integer, dimension(:), intent(in) :: mixup
      complex, dimension(:), intent(in) :: sct
      real, dimension(2), intent(inout) :: tfft
! inverse fourier transform
      if (isign < 0) then
! moves vector grids from non-uniform to uniform partition
         call mpfnmove2(f,noff,nyp,isign,tfmov,kyp,ny,kstrt,nvp,mter,   &
     &ierr)
! wrapper function for n component vector 2d real/complex FFT
         call mpfft2rn(f,g,isign,mixup,sct,tfft,indx,indy,kstrt,nvp,kyp)
! forward fourier transform
      else if (isign > 0) then
! wrapper function for n component vector 2d real/complex FFT
         call mpfft2rn(f,g,isign,mixup,sct,tfft,indx,indy,kstrt,nvp,kyp)
! moves vector grids from uniform to non-uniform partition
         call mpfnmove2(f,noff,nyp,isign,tfmov,kyp,ny,kstrt,nvp,mter,   &
     &ierr)
      endif
      end subroutine
!
!-----------------------------------------------------------------------
      subroutine wmpcguard2(f,nyp,tguard,nx,kstrt,nvp)
! copy scalar guard cells to local and remote partitions
      implicit none
      integer, intent(in) :: nyp, nx, kstrt, nvp
      real, intent(inout) :: tguard
      real, dimension(:,:), intent(inout) :: f
! copies data to guard cells in non-uniform partitions
      call mpcguard2(f,nyp,tguard,kstrt,nvp)
! replicates local periodic scalar field
      call mpdguard2x(f,nyp,tguard,nx)
      end subroutine
!
!-----------------------------------------------------------------------
      subroutine wmpncguard2(f,nyp,tguard,nx,kstrt,nvp)
! copy vector guard cells to local and remote partitions
      implicit none
      integer, intent(in) :: nyp, nx, kstrt, nvp
      real, intent(inout) :: tguard
      real, dimension(:,:,:), intent(inout) :: f
! copies data to guard cells in non-uniform partitions
      call mpncguard2(f,nyp,tguard,kstrt,nvp)
! replicates local periodic vector field
      call mpcguard2x(f,nyp,tguard,nx)
      end subroutine
!
!-----------------------------------------------------------------------
      subroutine wmpaguard2(f,nyp,tguard,nx,kstrt,nvp)
! add scalar guard cells from local and remote partitions
      implicit none
      integer, intent(in) :: nyp, nx, kstrt, nvp
      real, intent(inout) :: tguard
      real, dimension(:,:), intent(inout) :: f
! accumulates local periodic scalar field
      call mpaguard2x(f,nyp,tguard,nx)
! adds scalar data from guard cells in non-uniform partitions
      call mpnaguard2(f,nyp,tguard,nx,kstrt,nvp)
      end subroutine
!
!-----------------------------------------------------------------------
      subroutine wmpnacguard2(f,nyp,tguard,nx,kstrt,nvp)
! add vector guard cells from local and remote partitions
      implicit none
      integer, intent(in) :: nyp, nx, kstrt, nvp
      real, intent(inout) :: tguard
      real, dimension(:,:,:), intent(inout) :: f
! accumulates local periodic vector field
      call mpacguard2x(f,nyp,tguard,nx)
! adds vector data from guard cells in non-uniform partitions
      call mpnacguard2(f,nyp,tguard,nx,kstrt,nvp)
      end subroutine
!
      end module

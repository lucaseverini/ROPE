module FLAGS

  ! A place to store stuff for anybody to look at them

  implicit NONE
  public

  character, parameter :: Pierce_A_Encoding = 'A' ! IBM A-chain %)#&@
  character, parameter :: Pierce_H_Encoding = 'H' ! IBM H-chain ()=+'
  character, parameter :: SIMH_Encoding = 'S'
  character:: Encoding = SIMH_Encoding

  ! Mutable encodings:       A   H   S
  character :: At = '@'   !  @   '   @
  character :: Dev = '%'  !  %   (   %
  character :: GM = '"'   !  }   }   "
  character :: Hash = '#' !  #   =   #
  character :: Plus = '&' !  &   +   $
  character(len=5) :: Encodings
  equivalence ( encodings(1:1),at ), ( encodings(2:2),dev), &
    &         ( encodings(3:3),gm ), ( encodings(4:4),hash ), &
    &         ( encodings(5:5),plus )

  character(len=6) :: Traces ! Trace triggers

end module FLAGS

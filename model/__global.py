C_AXI_WORLD_ID          : int = None
C_AXI_WORLD_ID_WIDTH    : int = 2
C_AXI_USER_ID           : int = 3
C_AXI_USER_ID_WIDTH     : int = 3

nb_id_system            : int = 2
vector_perm_width       : int = 8

C_S_AXI_AWUSER_WIDTH    : int = 0   # Width of optional user defined signal in write address channel
C_S_AXI_ARUSER_WIDTH    : int = 0   # Width of optional user defined signal in read address channel
C_S_AXI_WUSER_WIDTH     : int = 0   # Width of optional user defined signal in write data channel
C_S_AXI_RUSER_WIDTH     : int = 0   # Width of optional user defined signal in read data channel
C_S_AXI_BUSER_WIDTH     : int = 0   # Width of optional user defined signal in write response channel

# For ASCON
C_S00_AXI_AWUSER_WIDTH  : int = 0
C_S00_AXI_ARUSER_WIDTH  : int = 0
C_S00_AXI_WUSER_WIDTH   : int = 0
C_S00_AXI_RUSER_WIDTH   : int = 0
C_S00_AXI_BUSER_WIDTH   : int = 0

range_of_indice_w       : int = 25000
range_of_indice_r       : int = 25000

#NBITS                   : int = 736 # the full operand size
#WID                     : int = 32  # the size of the input word

NUMBER_OF_BITS_FOR_DATA_IN  : int   = 32
NUMBER_OF_BITS_FOR_DATA_OUT : int   = 32

NUMBER_OF_BITS_FOR_ctr_i : int = 23

# configure_enable : ??????

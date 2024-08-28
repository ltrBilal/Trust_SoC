from typing import List
from a_signal import Signal
from port import Port
from generic import Generic
from exception import My_Exception
from colors import colors
from functions import generic_signals_list, port_signals_list
from __global import *
from component import Component
from ascon_AXI import Ascon_axi

C_S00_AXI_ID_WIDTH = 1
C_S00_AXI_DATA_WIDTH = 32
C_S00_AXI_ADDR_WIDTH = 6

class Ascon(Component):

    NAME = "ASCON"

    def __init__(self, components_list : List[Component]) -> None:
        self.name = self.NAME
        self.path = f"model/generated_VHDL_files/{self.name}.vhd"

        signals_list_for_generic_part : List[Signal] = generic_signals_list(
                                                                        [
                                                                            "C_AXI_WORLD_ID",
                                                                            "C_AXI_WORLD_ID_WIDTH",
                                                                            "C_AXI_USER_ID",
                                                                            "C_AXI_USER_ID_WIDTH",
                                                                            "nb_id_system",
                                                                            "vector_perm_width",
                                                                            "C_S00_AXI_ID_WIDTH",
                                                                            "C_S00_AXI_DATA_WIDTH",
                                                                            "C_S00_AXI_ADDR_WIDTH",
                                                                            "C_S00_AXI_AWUSER_WIDTH",
                                                                            "C_S00_AXI_ARUSER_WIDTH",
                                                                            "C_S00_AXI_WUSER_WIDTH",
                                                                            "C_S00_AXI_RUSER_WIDTH",
                                                                            "C_S00_AXI_BUSER_WIDTH"
                                                                        ],
                                                                        ["integer"],
                                                                        [C_AXI_WORLD_ID, C_AXI_WORLD_ID_WIDTH, C_AXI_USER_ID, C_AXI_USER_ID_WIDTH, 
                                                                         nb_id_system, vector_perm_width, C_S00_AXI_ID_WIDTH, C_S00_AXI_DATA_WIDTH, 
                                                                         C_S00_AXI_ADDR_WIDTH, C_S00_AXI_AWUSER_WIDTH, C_S00_AXI_ARUSER_WIDTH, 
                                                                         C_S00_AXI_WUSER_WIDTH, C_S00_AXI_RUSER_WIDTH, C_S00_AXI_BUSER_WIDTH]
                                                                    )

        signals_list_for_port_part : List[Signal] = port_signals_list(
                                                                    [
                                                                        # inputs (35)
                                                                        "configure_enable",
                                                                        "configure_vector_permissions",
                                                                        "s00_axi_aclk",
                                                                        "s00_axi_aresetn",
                                                                        "s00_axi_awid",
                                                                        "s00_axi_awaddr",
                                                                        "s00_axi_awlen",
                                                                        "s00_axi_awsize",
                                                                        "s00_axi_awburst",
                                                                        "s00_axi_awlock",
                                                                        "s00_axi_awcache",
                                                                        "s00_axi_awprot",
                                                                        "s00_axi_awqos",
                                                                        "s00_axi_awregion",
                                                                        "s00_axi_awuser",
                                                                        "s00_axi_awvalid",
                                                                        "s00_axi_wdata",
                                                                        "s00_axi_wstrb",
                                                                        "s00_axi_wlast",
                                                                        "s00_axi_wuser",
                                                                        "s00_axi_wvalid",
                                                                        "s00_axi_bready",
                                                                        "s00_axi_arid",
                                                                        "s00_axi_araddr",
                                                                        "s00_axi_arlen",
                                                                        "s00_axi_arsize",
                                                                        "s00_axi_arburst",
                                                                        "s00_axi_arlock",
                                                                        "s00_axi_arcache",
                                                                        "s00_axi_arprot",
                                                                        "s00_axi_arqos",
                                                                        "s00_axi_arregion",
                                                                        "s00_axi_aruser",
                                                                        "s00_axi_arvalid",
                                                                        "s00_axi_rready",
                                                                        # outputs (13)
                                                                        "s00_axi_awready",
                                                                        "s00_axi_wready",
                                                                        "s00_axi_bid",
                                                                        "s00_axi_bresp",
                                                                        "s00_axi_buser",
                                                                        "s00_axi_bvalid",
                                                                        "s00_axi_arready",
                                                                        "s00_axi_rid",
                                                                        "s00_axi_rdata",
                                                                        "s00_axi_rresp",
                                                                        "s00_axi_rlast",
                                                                        "s00_axi_ruser",
                                                                        "s00_axi_rvalid"
                                                                    ],
                                                                    35, 13,
                                                                    [
                                                                        # type for inputs
                                                                        1, "vector_perm_width",
                                                                        1, 1, "C_S00_AXI_ID_WIDTH", "C_S00_AXI_ADDR_WIDTH", 8, 3, 2, 1, 4, 3, 4, 4,
                                                                        "C_S00_AXI_AWUSER_WIDTH", 1, "C_S00_AXI_DATA_WIDTH", "(C_S00_AXI_DATA_WIDTH/8)",
                                                                        1, "C_S00_AXI_WUSER_WIDTH", 1, 1, "C_S00_AXI_ID_WIDTH", "C_S00_AXI_ADDR_WIDTH", 8,
                                                                        3, 2, 1, 4, 3, 4, 4, "C_S00_AXI_ARUSER_WIDTH", 1, 1,
                                                                        # type of outputs
                                                                        1, 1, "C_S00_AXI_ID_WIDTH", 2, "C_S00_AXI_BUSER_WIDTH", 1, 1, "C_S00_AXI_ID_WIDTH",
                                                                        "C_S00_AXI_DATA_WIDTH", 2, 1,  "C_S00_AXI_RUSER_WIDTH", 1
                                                                    ]
                                                                )

        # generic session 
        self.generic = Generic(signals_list_for_generic_part)

        # port session
        self.ports = Port(signals_list_for_port_part)

    # -------------------------------------------------------------------

                
        # add libraries
        lib = """library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
"""

        # entity
        entity = f"\nentity {self.name} is\n"
        # generic session
        if self.generic != None:
            entity += self.generic.generic_to_vhdl()
        # ports session
        if self.ports != None:
            entity += self.ports.port_to_vhdl()
        entity += f"end {self.name};\n\n"

        # architecture
        arch = f"architecture {self.name}_arch of {self.name} is\n"

        # ASCON_AXI Component
        ascon_axi = Ascon_axi(components_list)
        arch += ascon_axi.component_code()
                    
        # the beginnings of architecture 
        arch += "begin\n"

        # component instance
        arch += ascon_axi.component_instance("ASCON_inst", self)
        
        # the end of architecture
        arch += f"end {self.name}_arch;\n" 

        code = lib
        code += entity
        code += arch

        if My_Exception.warnings_list.__len__() > 0:
            My_Exception.display_warnings()  # display all warnings    

        if My_Exception.exceptions_list == []:
            file = open(f"{self.path}", 'w')
            file.write(code)
            print(f"{colors.GREEN}*** UPDATE {self.path} *** {colors.END}")
        else:
            My_Exception.display_exceptions()
            print(f"{colors.BLUE} *** VHDL files have not been modified or created{colors.END}")
        
    
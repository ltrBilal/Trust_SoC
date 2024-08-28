from __global import *
from a_signal import Signal
from generic import Generic
from port import Port
from colors import colors
from component import Component
from functions import generic_signals_list, port_signals_list
from process import Process

from typing import List
import csv


class Ascon_axi(Component):

    NAME = "ASCON_AXI"

    def __init__(self, components_list : List[Component]):

        C_S_AXI_ID_WIDTH = 1
        C_S_AXI_DATA_WIDTH = 32
        C_S_AXI_ADDR_WIDTH = 6

        generic_part_signals : List[Signal] = generic_signals_list(
                                                                    [
                                                                        "C_AXI_WORLD_ID",
                                                                        "C_AXI_WORLD_ID_WIDTH",
                                                                        "C_AXI_USER_ID",
                                                                        "C_AXI_USER_ID_WIDTH",
                                                                        "nb_id_system",
                                                                        "vector_perm_width",
                                                                        "C_S_AXI_ID_WIDTH",
                                                                        "C_S_AXI_DATA_WIDTH",
                                                                        "C_S_AXI_ADDR_WIDTH",
                                                                        "C_S_AXI_AWUSER_WIDTH",
                                                                        "C_S_AXI_ARUSER_WIDTH",
                                                                        "C_S_AXI_WUSER_WIDTH",
                                                                        "C_S_AXI_RUSER_WIDTH",
                                                                        "C_S_AXI_BUSER_WIDTH"
                                                                    ], ["integer"],
                                                                    [   
                                                                        C_AXI_WORLD_ID,
                                                                        C_AXI_WORLD_ID_WIDTH,
                                                                        C_AXI_USER_ID,
                                                                        C_AXI_USER_ID_WIDTH,
                                                                        nb_id_system,
                                                                        vector_perm_width,
                                                                        C_S_AXI_ID_WIDTH,
                                                                        C_S_AXI_DATA_WIDTH,
                                                                        C_S_AXI_ADDR_WIDTH,
                                                                        C_S_AXI_AWUSER_WIDTH,
                                                                        C_S_AXI_ARUSER_WIDTH,
                                                                        C_S_AXI_WUSER_WIDTH,
                                                                        C_S_AXI_RUSER_WIDTH,
                                                                        C_S_AXI_BUSER_WIDTH
                                                                    ]
                                                                )
        port_part_signals : List[Signal] = port_signals_list(
                                                                [
                                                                    # inputs (35)
                                                                    "configure_enable",
                                                                    "configure_vector_permissions",
                                                                    "S_AXI_ACLK",
                                                                    "S_AXI_ARESETN",
                                                                    "S_AXI_AWID",
                                                                    "S_AXI_AWADDR",
                                                                    "S_AXI_AWLEN",
                                                                    "S_AXI_AWSIZE",
                                                                    "S_AXI_AWBURST",
                                                                    "S_AXI_AWLOCK",
                                                                    "S_AXI_AWCACHE",
                                                                    "S_AXI_AWPROT",
                                                                    "S_AXI_AWQOS",
                                                                    "S_AXI_AWREGION",
                                                                    "S_AXI_AWUSER",
                                                                    "S_AXI_AWVALID",
                                                                    "S_AXI_WDATA",
                                                                    "S_AXI_WSTRB",
                                                                    "S_AXI_WLAST",
                                                                    "S_AXI_WUSER",
                                                                    "S_AXI_WVALID",
                                                                    "S_AXI_BREADY",
                                                                    "S_AXI_ARID",
                                                                    "S_AXI_ARADDR",
                                                                    "S_AXI_ARLEN",
                                                                    "S_AXI_ARSIZE",
                                                                    "S_AXI_ARBURST",
                                                                    "S_AXI_ARLOCK",
                                                                    "S_AXI_ARCACHE",
                                                                    "S_AXI_ARPROT",
                                                                    "S_AXI_ARQOS",
                                                                    "S_AXI_ARREGION",
                                                                    "S_AXI_ARUSER",
                                                                    "S_AXI_ARVALID",
                                                                    "S_AXI_RREADY",
                                                                    # outputs (13)
                                                                    "S_AXI_AWREADY",
                                                                    "S_AXI_WREADY",
                                                                    "S_AXI_BID",
                                                                    "S_AXI_BRESP",
                                                                    "S_AXI_BUSER",
                                                                    "S_AXI_BVALID",
                                                                    "S_AXI_ARREADY",
                                                                    "S_AXI_RID",
                                                                    "S_AXI_RDATA",
                                                                    "S_AXI_RRESP",
                                                                    "S_AXI_RLAST",
                                                                    "S_AXI_RUSER",
                                                                    "S_AXI_RVALID"
                                                                ], 35, 13,
                                                                [
                                                                    # type for inputs (35)
                                                                    1, "vector_perm_width",
                                                                    1, 1, "C_S_AXI_ID_WIDTH", "C_S_AXI_ADDR_WIDTH", 8, 3, 2, 1, 4, 3, 4, 4,
                                                                    "C_S_AXI_AWUSER_WIDTH", 1, "C_S_AXI_DATA_WIDTH", "(C_S_AXI_DATA_WIDTH/8)",
                                                                    1, "C_S_AXI_WUSER_WIDTH", 1, 1, "C_S_AXI_ID_WIDTH", "C_S_AXI_ADDR_WIDTH", 8,
                                                                    3, 2, 1, 4, 3, 4, 4, "C_S_AXI_ARUSER_WIDTH", 1, 1,
                                                                    # type of outputs (13)
                                                                    1, 1, "C_S_AXI_ID_WIDTH", 2, "C_S_AXI_BUSER_WIDTH", 1, 1, "C_S_AXI_ID_WIDTH",
                                                                    "C_S_AXI_DATA_WIDTH", 2, 1,  "C_S_AXI_RUSER_WIDTH", 1 
                                                                ]
                                                            )
        self.generic : Generic = Generic(generic_part_signals)
        self.ports : Port = Port(port_part_signals)
        self.name = self.NAME
        self.path = f"model/generated_VHDL_files/{self.name}.vhd"

        """
        ******************************************************************************************
                                    VHDL FILE GENERATOR FOR ASCON_AXI
        ******************************************************************************************
        """
        # library
        lib = """library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
"""
        
        # entity
        entity = f"\nentity {self.name} is\n"
        if self.generic != None:
            self.signals_list = self.signals_list.union(set(self.generic.signals_list))
            entity += self.generic.generic_to_vhdl()

        if self.ports != None:
            self.signals_list = self.signals_list.union(set(self.ports.signals_list))
            entity += self.ports.port_to_vhdl()
        entity += f"end {self.name};\n\n"

        # architecture
        arch = f"architecture {self.name}_arch of {self.name} is\n"

        # attribute
        arch += f"\tattribute dont_touch : string;\n"
        arch += f"\tattribute dont_touch of {self.name}_arch : architecture is \"yes\";\n"
        
        # core_interface component
        # /////////////////////////////////////////////////////////////////
        ##################### THIS PART CAN BE VARIED ##################### 

        for i in components_list:
            arch += i.component_code()

        s0 = Signal("data_in", NUMBER_OF_BITS_FOR_DATA_IN, None, None)
        s1 = Signal("data_out", NUMBER_OF_BITS_FOR_DATA_OUT, None, None)
        s2 = Signal("ctr_i", NUMBER_OF_BITS_FOR_ctr_i, None, None)
        # display and add to signals list the three signals
        for i in (s0, s1, s2):
            arch += "\t"+i.signal_to_vhdl()
            self.signals_list.add(i)
                   
        # /////////////////////////////////////////////////////////////////

        with open("model/txt_files/Signals.csv", mode='r') as file:
            csv_reader = csv.DictReader(file, quoting=csv.QUOTE_NONE)
            for row in csv_reader:
                key : str = row['key'] if row['key'] else None
                name : str = row['name'] if row['name'] else None
                type : str  = row['type'] if row['type'] else None
                value  = row['value'] if row['value'] else None
            
                s = Signal(name, type, None, value, key) # build the signal
                arch += "\t"+s.signal_to_vhdl()+"\n" # display the signal
                self.signals_list.add(s) # add the signal to signals list

        # /////////////////////////////////////////////////////////////////
        ##################### THIS PART CAN BE VARIED #####################                                   
        arch += f"""    constant width_part : integer := nb_id_system *2;
    signal indice_w       : integer range 0 to {range_of_indice_w}:= 0;
    signal indice_r       : integer range 0 to {range_of_indice_r}:= 0;
    {Signal("r_w_r", 1, None).signal_to_vhdl()}    
    {Signal("w_r_w", 1, None).signal_to_vhdl()}
    constant configure_vector_permissions_i : std_logic_vector(vector_perm_width-1 downto 0):=X"01";
"""       
        # /////////////////////////////////////////////////////////////////
        
        # the beginnings of architecture 
        arch += "begin\n"

        # /////////////////////////////////////////////////////////////////

        f = open("model/txt_files/assignments.txt")
        arch += f.read()

        vhdl_code_p1 = """if rising_edge(S_AXI_ACLK) then 
	       if (configure_enable = '1') then
	           configure_vector_permissions_i <= configure_vector_permissions;  
	       else 
	           configure_vector_permissions_i <= configure_vector_permissions_i;
	       end if;
	    end if;"""     
        reconfiguration_tabl : Process = Process("perm_table_config", vhdl_code_p1, ["S_AXI_ACLK"], self.signals_list)
        arch += reconfiguration_tabl.process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        vhdl_code_p2 = "indice_w <= width_part * to_integer(unsigned(S_AXI_AWUSER(C_AXI_WORLD_ID_WIDTH - 1 DOWNTO 0))) +2*(to_integer(unsigned(S_AXI_AWUSER((C_AXI_USER_ID_WIDTH + C_AXI_WORLD_ID_WIDTH - 1) DOWNTO C_AXI_WORLD_ID_WIDTH)))-1);"
        decodage_addresses_write : Process = Process(None, vhdl_code_p2, ["S_AXI_AWADDR", "configure_enable", "configure_vector_permissions", "S_AXI_AWUSER"], self.signals_list)
        arch += decodage_addresses_write.process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        arch += "\n\tw_r_w <= configure_vector_permissions_i(indice_w) when (indice_w >=0) else '0';\n"

        # /////////////////////////////////////////////////////////////////

        vhdl_code_p3 = "indice_r <= width_part * to_integer(unsigned(S_AXI_ARUSER(C_AXI_WORLD_ID_WIDTH - 1 DOWNTO 0)))+2*(to_integer(unsigned(S_AXI_ARUSER((C_AXI_USER_ID_WIDTH + C_AXI_WORLD_ID_WIDTH - 1) DOWNTO C_AXI_WORLD_ID_WIDTH)))-1)+1;"
        decodage_addresses_read : Process = Process(None, vhdl_code_p3, ["S_AXI_ARADDR", "configure_enable", "configure_vector_permissions", "S_AXI_ARUSER"], self.signals_list)
        arch += decodage_addresses_read.process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        arch += "\n\tr_w_r <= configure_vector_permissions_i(indice_r) when (indice_r >=0) else '0';\n"

        # /////////////////////////////////////////////////////////////////

        vhdl_code_p4 = """if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	      axi_awv_awr_flag <= '0';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and axi_awv_awr_flag = '0' and axi_arv_arr_flag = '0') then
	        -- slave is ready to accept an address and
	        -- associated control signals
	        axi_awv_awr_flag  <= '1'; -- used for generation of bresp() and bvalid
	        axi_awready <= '1';
	      elsif (S_AXI_WLAST = '1' and axi_wready = '1') then 
	      -- preparing to accept next address after current write burst tx completion
	        axi_awv_awr_flag  <= '0';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;  """
        generate_axi_awready : Process = Process(None, vhdl_code_p4, ["S_AXI_ACLK"], self.signals_list)
        arch += generate_axi_awready.process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        f = open('model/txt_files/p5.txt', 'r')
        vhdl_code_p5 = f.read()
        axi_awaddr : Process = Process(None, vhdl_code_p5, ["S_AXI_ACLK"], self.signals_list)
        arch += axi_awaddr.process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        vhdl_code_p6 = """ if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and axi_awv_awr_flag = '1') then
	        axi_wready <= '1';
	        -- elsif (axi_awv_awr_flag = '0') then
	      elsif (S_AXI_WLAST = '1' and axi_wready = '1') then 

	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;"""
        axi_wready : Process = Process(None, vhdl_code_p6, ["S_AXI_ACLK"], self.signals_list)
        arch += axi_wready.process_to_vhdl()
        # /////////////////////////////////////////////////////////////////

        arch += "\n\tslv_reg_wren <= axi_wready and S_AXI_WVALID ;\n"

        # /////////////////////////////////////////////////////////////////

        vhdl_code_p7 = open("model/txt_files/p7.txt").read()
        s : Signal = Signal("loc_addr", "OPT_MEM_ADDR_BITS",None, None, "variable")
        self.signals_list.add(s)
        arch += Process(None, vhdl_code_p7, ["S_AXI_ACLK"], self.signals_list, [s]).process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        vhdl_code_p8 = """if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp  <= "00"; --need to work more on the responses
	    else
	      if (axi_awv_awr_flag = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0' and S_AXI_WLAST = '1' ) then
	        axi_bvalid <= '1';
	        if (w_r_w = '1') then
	           axi_bresp  <= "00"; 
	        else 
	           axi_bresp <= "10";
	        end if;
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then  
	      --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                      
	      end if;
	    end if;
	  end if;"""
        arch += Process(None, vhdl_code_p8, ["S_AXI_ACLK"], self.signals_list).process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        vhdl_code_p9 = """if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_arv_arr_flag <= '0';
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1' and axi_awv_awr_flag = '0' and axi_arv_arr_flag = '0') then
	        axi_arready <= '1';
	        axi_arv_arr_flag <= '1';
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1' and (axi_arlen_cntr = axi_arlen)) then 
	      -- preparing to accept next address after current read completion
	        axi_arv_arr_flag <= '0';
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;"""
        
        arch += Process(None, vhdl_code_p9, ["S_AXI_ACLK"], self.signals_list).process_to_vhdl()
        
        # /////////////////////////////////////////////////////////////////

        vhdl_code_p10 = """if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_araddr <= (others => '0');
	      axi_arburst <= (others => '0');
	      axi_arlen <= (others => '0'); 
	      axi_arlen_cntr <= (others => '0');
	      axi_rlast <= '0';
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1' and axi_arv_arr_flag = '0') then
	        -- address latching 
	        axi_araddr <= S_AXI_ARADDR(C_S_AXI_ADDR_WIDTH - 1 downto 0); ---- start address of transfer
	        axi_arlen_cntr <= (others => '0');
	        axi_rlast <= '0';
	        axi_arburst <= S_AXI_ARBURST;
	        axi_arlen <= S_AXI_ARLEN;
	      elsif((axi_arlen_cntr <= axi_arlen) and axi_rvalid = '1' and S_AXI_RREADY = '1') then     
	        axi_arlen_cntr <= std_logic_vector (unsigned(axi_arlen_cntr) + 1);
	        axi_rlast <= '0';      
	     
	        case (axi_arburst) is
	          when "00" =>  -- fixed burst
	            -- The read address for all the beats in the transaction are fixed
	            axi_araddr     <= axi_araddr;      ----for arsize = 4 bytes (010)
	          when "01" =>  --incremental burst
	            -- The read address for all the beats in the transaction are increments by awsize
	            axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB)) + 1); --araddr aligned to 4 byte boundary
	            axi_araddr(ADDR_LSB-1 downto 0)  <= (others => '0');  ----for awsize = 4 bytes (010)
	          when "10" =>  --Wrapping burst
	            -- The read address wraps when the address reaches wrap boundary 
	            if (ar_wrap_en = '1') then   
	              axi_araddr <= std_logic_vector (unsigned(axi_araddr) - (to_unsigned(ar_wrap_size,C_S_AXI_ADDR_WIDTH)));
	            else 
	              axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB)) + 1); --araddr aligned to 4 byte boundary
	              axi_araddr(ADDR_LSB-1 downto 0)  <= (others => '0');  ----for awsize = 4 bytes (010)
	            end if;
	          when others => --reserved (incremental burst for example)
	            axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_araddr(C_S_AXI_ADDR_WIDTH - 1 downto ADDR_LSB)) + 1);--for arsize = 4 bytes (010)
			  axi_araddr(ADDR_LSB-1 downto 0)  <= (others => '0');
	        end case;         
	      elsif((axi_arlen_cntr = axi_arlen) and axi_rlast = '0' and axi_arv_arr_flag = '1') then  
	        axi_rlast <= '1';
	      elsif (S_AXI_RREADY = '1') then  
	        axi_rlast <= '0';
	      end if;
	    end if;
	  end if;"""
        
        arch += Process(None, vhdl_code_p10, ["S_AXI_ACLK"], self.signals_list).process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        vhdl_code_p11 = """if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arv_arr_flag = '1' and axi_rvalid = '0') then
	        axi_rvalid <= '1';
	        if (r_w_r = '1') then
	           axi_rresp  <= "00"; -- 'OKAY' response
	        else 
	           axi_rresp <= "10"; -- "SLVERR" error
	        end if;
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        axi_rvalid <= '0';
	      end  if;      
	    end if;
	  end if;"""
        
        arch += Process(None, vhdl_code_p11, ["S_AXI_ACLK"], self.signals_list).process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        arch += "\n\tslv_reg_rden <= axi_rvalid and S_AXI_RREADY;"

        # /////////////////////////////////////////////////////////////////

        code_vhdl_p12 = """-- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"0000" =>
	        reg_data_out <= slv_reg0;
	      when b"0001" =>
	        reg_data_out <= slv_reg1;
	      when b"0010" =>
	        reg_data_out <= slv_reg2;
	      when b"0011" =>
	        reg_data_out <= slv_reg3;
	      when b"0100" =>
	        reg_data_out <= slv_reg4;
	      when b"0101" =>
	        reg_data_out <= slv_reg5;
	      when b"0110" =>
	           reg_data_out <= slv_reg6;
	      when b"0111" =>
	           reg_data_out <= slv_reg7;
	      when b"1000" =>
	        reg_data_out <= data_out;
	      when b"1001" =>
	        reg_data_out <= slv_reg9;
	      when b"1010" =>
	        reg_data_out <= slv_reg10;
	      when b"1011" =>
	        reg_data_out <= slv_reg11;
	      when b"1100" =>
	        reg_data_out <= slv_reg12;
	      when b"1101" =>
              reg_data_out <= slv_reg13;
	      when b"1110" =>
	        reg_data_out <= slv_reg14;
	      when b"1111" =>
	        reg_data_out <= slv_reg15;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;"""
        
        s : Signal = Signal("loc_reg0", "OPT_MEM_ADDR_BITS+1", None, None, "variable")
        arch += Process(None, vhdl_code_p11, ["slv_reg0","slv_reg1","slv_reg2","slv_reg3","slv_reg4","slv_reg5","slv_reg6","slv_reg7","slv_reg8","slv_reg9","slv_reg10","slv_reg11","slv_reg12","slv_reg13","slv_reg14","slv_reg15", "data_out", "axi_araddr", "S_AXI_ARESETN", "slv_reg_rden"], self.signals_list, [s]).process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        code_vhdl_p13 = """if (rising_edge (S_AXI_ACLK)) then
			if (S_AXI_ARESETN = '0') then
				axi_rdata <= (others => '0');
			else
				if (slv_reg_rden = '1' or (axi_arv_arr_flag = '1' and axi_rvalid = '0')) then
					-- When there is a valid read address (S_AXI_ARVALID) with 
					-- acceptance of read address by the slave (axi_arready), 
					-- output the read dada 
					-- Read address mux
					if (r_w_r = '1')then
			           axi_rdata <= reg_data_out; -- register read data
					else
					   axi_rdata <= (OTHERS => '0');
					end if;
				end if;
			end if;
		end if;"""
        
        arch += Process(None, code_vhdl_p13, ["S_AXI_ACLK"], self.signals_list).process_to_vhdl()

        # /////////////////////////////////////////////////////////////////

        arch += "\n\tdata_in <= slv_reg0;\n"
        arch += "\n\tctr_i   <= slv_reg1(22 downto 0);\n"

        # /////////////////////////////////////////////////////////////////

       # arch += core_interface.component_instance("inst", self, self, [NBITS, WID, "S_AXI_ACLK", "S_AXI_ARESETN", "ctr_i", "data_in", "data_out"])

        # /////////////////////////////////////////////////////////////////

        # the end of architecture
        arch += f"end {self.name}_arch;\n" 

        code = lib
        code += entity
        code += arch

        file = open(f"{self.path}", 'w')
        file.write(code)
        print(f"{colors.GREEN}*** UPDATE {self.path} *** {colors.END}")        
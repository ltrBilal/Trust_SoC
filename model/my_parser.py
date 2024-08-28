import re
import glob

from typing import List
from generic import Generic
from port import Port
from a_signal import Signal
from component import Component

####################################################################################################################

def port_direction(direction : str) -> str:
    """
    Converts a Verilog port direction to a VHDL port direction.

    Parameters
    ----------
    direction : str
        The port direction in Verilog ("input", "output", "inout").

    Returns
    -------
    str
        The corresponding port direction in VHDL ("in", "out", "inout").
    """
    if direction == "input":
        return "in"
    elif direction == "output":
        return "out"
    else:
        return "inout"

####################################################################################################################

def parser(file_name : str) -> Component:
    """
    Parses a Verilog file to extract the module name, generics, and ports, then creates a Component object.

    Parameters
    ----------
    file_name : str
        The name of the Verilog file to parse.

    Returns
    -------
    Component
        A Component object representing the parsed Verilog module, or None in case of an error.

    Raises
    ------
    Exception
        If an error occurs during parsing, it prints an error message and returns None.

    Notes
    -----
    The function performs the following steps:
        1. Initializes variables to store different parts of the module.
        2. Reads the Verilog file line by line, ignoring comments and empty lines.
        3. Detects the start of the module to capture the generic part.
        4. Captures I/O ports and their names for later use.
        5. Uses regular expressions to extract the module name, generics, and ports.
        6. Constructs `Signal`, `Generic`, and `Port` objects from the parsed data.
        7. Creates and returns a `Component` object representing the module.
    """

    try:
        # Initialize variables to store different parts of the module
        module_parag = None
        generic_parag = None
        io_parag = None
        ports_parag = None

        # Temporary variables to store the content of the sections as they are read
        current_module_parag = ""
        current_generic_parag = ""
        current_io_parag = ""
        current_ports_parag = ""

        # Flag to indicate if ports are being retrieved
        get_ports = False
        io_names = []

        # Read the Verilog file line by line
        with open(file_name, 'r') as file:
            for line in file:
                # Ignore comment lines and empty lines
                line = line.split('//')[0].strip()
                if not line:
                    continue

                # If retrieving ports and they are still in io_names, add them to current_ports_parag
                if get_ports and len(io_names) > 0:
                    for i in io_names:
                        if i in line and len(io_names) > 0:
                            io_names.remove(i)
                            current_ports_parag = current_ports_parag + "\n" + line

                # Detect the start of the module to capture the generic part
                if generic_parag == None and line.split()[0].strip().lower() == "module":
                    generic_parag = current_generic_parag
                
                # Detect the end of the port declaration
                if io_parag == None and line.endswith(');'):
                    current_io_parag = current_io_parag + " " + line
                    io_parag = current_io_parag

                    # Extract I/O names between parentheses
                    io_name_pattern = r'\((.*?)\);'
                    match = re.search(io_name_pattern, io_parag)
                    if match:
                        io_names = match.group(1).split(',')
                        io_names = [var.strip() for var in io_names]
                        get_ports = True

                # Construct the paragraphs
                if generic_parag == None:
                    current_generic_parag = current_generic_parag + "\n" + line
                elif module_parag == None:
                    current_module_parag = current_module_parag + "\n" + line
                    module_parag = current_module_parag
                    current_io_parag = module_parag
                elif io_parag == None:
                    current_io_parag = current_io_parag + " " + line
                else:
                    if len(io_names) == 0:
                        ports_parag = current_ports_parag
                        break

        # Regular expressions to capture different parts of the module
        module_name_pattern = r'module\s+(\w+)'
        generic_pattern = r'\(\*\s*(\w+)\s*=\s*\"(.*?)\"\s*\*\)'
        port_pattern = r'(input|output|inout)\s+(?:\[(\d+):\d+\])?\s*(\w+)\s*;'
        
        # Extract the module name
        module_name_match = re.search(module_name_pattern, module_parag)
        module_name = module_name_match.group(1) if module_name_match else 'Module name not found'

        # Construct the generic part
        generic_matches = re.findall(generic_pattern, generic_parag)
        signals_of_generic_part : List[Signal] = []
        for name, value in generic_matches:
            try:
                t = int(value)
            except:
                continue
            s : Signal = Signal(name, "integer", None, value)
            signals_of_generic_part.append(s)
        generic_part : Generic = Generic(signals_of_generic_part)
        
        # Construct the ports part
        ports_matches = re.findall(port_pattern, ports_parag)
        signals_of_port_part : List[Signal] = []
        for direction, nb_bits, port_name in ports_matches:
            if not nb_bits:
                nb_bits = "0"
            s : Signal = Signal(port_name, int(nb_bits)+1, port_direction(direction))
            signals_of_port_part.append(s)
        port_part : Port = Port(signals_of_port_part)

        # Print statements for verification (can be removed in production)
        print(f"module ******* : {module_name}")
        print(f"generic ****** : {generic_part.generic_to_vhdl()}")
        print(f"ports ******** : {port_part.port_to_vhdl()}")

        # Create and return the component
        component : Component = Component(module_name, generic_part, port_part)

        return component
    
    except Exception as e:
        print(f"Error parsing file {file_name}: {e}")
        return None
    
####################################################################################################################

def extract_components(folder : str) -> List[Component]:
    """
    Extracts components from all Verilog files in a specified folder.

    Parameters
    ----------
    folder : str
        The path to the folder containing Verilog files.

    Returns
    -------
    List[Component]
        A list of Component objects extracted from the Verilog files.
    
    Notes
    -----
    The function performs the following steps:
        1. Uses `glob` to find all Verilog files in the specified folder.
        2. Iterates through the list of file paths, parsing each file to extract components.
        3. Adds successfully parsed components to the return list.
    """
    components_file_list : List[str] = glob.glob(f"{folder}/*.v")

    components_list : List[Component] = []

    for i in components_file_list:
        if parser(i) != None:
            components_list.append(parser(i))

    return components_list

from a_signal import Signal, Clock
from typing import List
from functions import find_signal

class Process:
    """
    Represents a VHDL process.

    Attributes
    ----------
    label : str
        The label name of the process.
    sensibilities : List[Signal]
        A list of Signal objects that are sensitive to the process.
    code : str
        The VHDL code to be included within the process.
    variable_list : List[Signal]
        A list of Signal objects representing variables within the process.
    """

    def __init__(self, label_name: str, vhdl_code: str, sensibilities: List[str] = None, 
                 component_signals_list: List[Signal] = None, variables_list: List[Signal] = None) -> None:
        """
        Initializes the Process class with the provided parameters.

        Parameters
        ----------
        label_name : str
            The label name of the process.
        vhdl_code : str
            The VHDL code to be included within the process.
        sensibilities : List[str], optional
            A list of signal names that are sensitive to the process.
        component_signals_list : List[Signal], optional
            A list of Signal objects in the component.
        variables_list : List[Signal], optional
            A list of Signal objects representing variables within the process.
        """
        self.label: str = label_name
        self.sensibilities: List[Signal] = []
        for i in sensibilities:
            self.sensibilities.append(find_signal(component_signals_list, i))
        
        self.code: str = vhdl_code
        self.variable_list = variables_list

    def process_to_vhdl(self) -> str:
        """
        Generates the VHDL code for the process.

        Returns
        -------
        str
            A string containing the VHDL code for the process.

        Notes
        -----
        The method performs the following steps:
            1. Initializes a string `seq` with the process label as a comment.
            2. Checks if sensibilities are provided to determine the process sensitivity list.
            3. Adds the sensitivity list or a simple process declaration if no sensibilities are provided.
            4. Adds any declared variables to the process.
            5. Adds the provided VHDL code within the process.
            6. Closes the process declaration and returns the final VHDL code as a string.
        """
        seq = f"\n    -- {self.label} process\n" if self.label else "\n\t -- process"
        if self.sensibilities is None:
            seq += f"\t{self.label} : process\n" if self.label else "\n\t process\n"
        else:
            seq += f"\t{self.label} : process (" if self.label else "\n\tprocess("
            for i in self.sensibilities:
                if self.sensibilities[-1] == i:
                    seq += f"{i.name})\n"
                else:
                    seq += f"{i.name},"
        if self.variable_list is not None:
            for i in self.variable_list:
                seq += "\t\t" + i.signal_to_vhdl() + "\n"
        seq += "\tbegin\n"
        seq += f"       {self.code}\n"
        seq += f"\tend process;\n"
        return seq


class Clock_Process(Process):
    """
    Represents a clock process for VHDL code generation.

    Attributes
    ----------
    label : str
        The label name of the clock process.
    clock : Clock
        A Clock object containing the clock name, period, and unit.
    """

    def __init__(self, label: str, clock: Clock) -> None:
        """
        Initializes the Clock_Process class with the provided label and clock.

        Parameters
        ----------
        label : str
            The label name of the clock process.
        clock : Clock
            A Clock object containing the clock name, period, and unit.
        """
        self.label = label
        self.clock = clock
        self.sensibilities = None

    def process_to_vhdl(self) -> str:
        """
        Generates the VHDL code for the clock process.

        Returns
        -------
        str
            A string containing the VHDL code for the clock process.

        Notes
        -----
        The method performs the following steps:
            1. Initializes a string `code` with a comment indicating clock simulation.
            2. Adds the process label and begin statement.
            3. Generates the clock toggling VHDL code with wait statements based on the clock period and unit.
            4. Closes the process declaration and returns the final VHDL code as a string.
        """
        self.code = "   -- clock simulation\n"
        self.code += f"   {self.label} : process\n"
        self.code += "   begin\n"
        self.code += f"      {self.clock.name} <= '0';\n"
        self.code += f"      wait for {self.clock.period} {self.clock.unit};\n"
        self.code += f"      {self.clock.name} <= '1';\n"
        self.code += f"      wait for {self.clock.period} {self.clock.unit};\n"
        self.code += f"   end process;\n"
        return self.code

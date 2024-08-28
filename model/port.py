from a_signal import Signal
from typing import List

class Port:
    """
    Represents the port part of a VHDL component.

    Attributes
    ----------
    signals_list : List[Signal]
        A list of Signal objects representing the ports of a component.
    """

    def __init__(self, signals_list: List[Signal]) -> None:
        """
        Initializes the Port class with a list of Signal objects.

        Parameters
        ----------
        signals_list : List[Signal]
            A list of Signal objects representing the ports of a component.
        """
        self.signals_list = signals_list

    def port_to_vhdl(self) -> str:
        """
        Generates the VHDL code for the port part of a component.

        Returns
        -------
        str
            A string containing the VHDL code for the ports.

        Notes
        -----
        The method performs the following steps:
            1. Initializes a string 'port' with the beginning of the port declaration.
            2. Creates a copy of the signals list to avoid modifying the original list.
            3. Iterates through each Signal object in the copied list:
                - Sets the 'key' attribute of the Signal to None, as it is not needed for ports.
                - If the current Signal is the last in the list, it appends its VHDL representation without the trailing comma.
                - Otherwise, it appends its VHDL representation with a trailing comma.
            4. Closes the port declaration and returns the final VHDL code as a string.
        """
        port = "\tport(\n"
        signals_list_copy = [i.copy() for i in self.signals_list]
        for i in signals_list_copy:
            i.key = None
            if signals_list_copy[-1] == i:
                tmp = i.signal_to_vhdl()
                port += f"\t\t\t{tmp[:tmp.__len__()-1]}\n"
            else:
                port += f"\t\t\t{i.signal_to_vhdl()}\n"
        port += "\t\t);\n"
        return port

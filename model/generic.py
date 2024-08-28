from a_signal import Signal
from typing import List

class Generic:
    """
    Represents the generic part of a VHDL component.

    Attributes
    ----------
    signals_list : List[Signal]
        A list of Signal objects representing the generics of a component.
    """

    def __init__(self, signals_list: List[Signal]) -> None:
        """
        Initializes the Generic class with a list of Signal objects.

        Parameters
        ----------
        signals_list : List[Signal]
            A list of Signal objects representing the generics of a component.
        """
        self.signals_list = signals_list

    def generic_to_vhdl(self) -> str:
        """
        Generates the VHDL code for the generic part of a component.

        The VHDL code starts with the `generic` keyword and includes each signal's name and type.
        The code handles multiple signals and ensures proper formatting.

        Returns
        -------
        str
            A string containing the VHDL code for the generic part.

        Notes
        -----
        The method performs the following steps:
            1. Creates a copy of the signals list to avoid modifying the original list.
            2. Initializes a string 'generic' with the beginning of the generic declaration.
            3. Iterates through each Signal object in the copied list:
                - Sets the 'direction' and 'key' attributes of the Signal to None, as they are not needed for generics.
                - Appends each Signal's VHDL representation to the 'generic' string, ensuring proper formatting with commas.
            4. Closes the generic declaration and returns the final VHDL code as a string.
        """
        signals_copy = [signal.copy() for signal in self.signals_list]
        generic_code = "\tgeneric(\n"

        for i, signal in enumerate(signals_copy):
            signal.direction = None
            signal.key = None
            signal_vhdl = signal.signal_to_vhdl().rstrip(';')
            if i < len(signals_copy) - 1:
                generic_code += f"\t\t\t{signal_vhdl},\n"
            else:
                generic_code += f"\t\t\t{signal_vhdl}\n"

        generic_code += "\t\t);\n"
        return generic_code

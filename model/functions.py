from typing import List
from a_signal import Signal
from exception import My_Exception
import re

def generic_signals_list(signal_names: List[str], types: List[str | int], values: List[str | int]) -> List[Signal]:
    """
    Generates a list of generic signals for a VHDL component.

    Each signal in the list is assigned a type and value based on the provided lists.

    Parameters
    ----------
    signal_names : List[str]
        List of signal names.
    types : List[str | int]
        List of signal types or bit sizes. If all signals share the same type, it should be provided once.
    values : List[str | int]
        List of signal values. Use 'None' if a signal has no value.

    Returns
    -------
    List[Signal]
        A list of Signal objects for the generic part of the VHDL component.

    Raises
    ------
    TabError
        If the sizes of signal_names, types, and values do not match.
    """
    try:
        if len(signal_names) != len(values):
            raise TabError("ERROR: Length of signal_names and values must be the same")

        signals_list: List[Signal] = []

        if len(types) == 1:
            # All signals have the same type
            for i in range(len(signal_names)):
                signals_list.append(Signal(signal_names[i], types[0], None, values[i]))
        elif len(signal_names) == len(types):
            # Each signal has its own type
            for i in range(len(signal_names)):
                signals_list.append(Signal(signal_names[i], types[i], None, values[i]))
        else:
            raise TabError("ERROR: The length of types list does not match the length of signal_names list")
    except TabError as t:
        My_Exception.add_exception(t)

    return signals_list

# -------------------------------------------------------------------

def port_signals_list(signal_names: List[str], number_of_inputs: int, number_of_outputs: int, types_or_number_of_bits: List[str | int]) -> List[Signal]:
    """
    Generates a list of port signals for a VHDL component.

    The list includes signals for both inputs and outputs, with specified types or bit sizes.

    Parameters
    ----------
    signal_names : List[str]
        List of signal names.
    number_of_inputs : int
        The number of input signals.
    number_of_outputs : int
        The number of output signals.
    types_or_number_of_bits : List[str | int]
        List of signal types or bit sizes. The length should match the total number of signals.

    Returns
    -------
    List[Signal]
        A list of Signal objects for the ports of the VHDL component.

    Raises
    ------
    TabError
        If the sizes of signal_names and types_or_number_of_bits do not match the total number of signals.
    """
    signals_list: List[Signal] = []

    try:
        if len(signal_names) != (number_of_inputs + number_of_outputs):
            raise TabError("ERROR: The sum of number_of_inputs and number_of_outputs must match the length of signal_names")

        if len(signal_names) != len(types_or_number_of_bits):
            raise TabError("ERROR: Length of signal_names and types_or_number_of_bits must be the same")

        for i in range(len(signal_names)):
            direction = "in" if i < number_of_inputs else "out"
            signals_list.append(Signal(signal_names[i], types_or_number_of_bits[i], direction, None))

    except TabError as e:
        My_Exception.add_exception(e)

    return signals_list

# -------------------------------------------------------------------

def find_signal(signals_list: List[Signal], name: str) -> Signal:
    """
    Searches for a signal by name in a list of signals.

    Parameters
    ----------
    signals_list : List[Signal]
        List of Signal objects.
    name : str
        The name of the signal to find.

    Returns
    -------
    Signal
        The Signal object if found.

    Raises
    ------
    ValueError
        If no signal with the given name is found.
    """
    for signal in signals_list:
        if signal.name == name:
            return signal

    try:
        raise ValueError(f"ERROR: Signal '{name}' not found")
    except ValueError as e:
        My_Exception.add_exception(e)
    
    return Signal("", "", None)  # Return a default Signal object if not found

from exception import My_Exception
from typing import List

class Signal:
    """
    Signal class to represent a digital signal.

    Attributes
    ----------
    name : str
        The name of the signal.
    type : str
        The type of the signal (e.g., "integer", "std_logic", "std_logic_vector").
    direction : str
        The direction of the signal, can be 'in', 'out', or None.
    value : str
        The value of the signal.
    key : str
        The key for the signal, can be 'variable', 'signal', 'constant', or None.
    """

    possible_types: List[str] = ["integer", "std_logic"]
    nb_bits = None

    def __init__(self, name: str, type_or_number_of_bits: str | int, direction: str, value: str | int = None, key: str = None) -> None:
        """
        Constructor for the Signal class.

        Parameters
        ----------
        name : str
            The name of the signal.
        type_or_number_of_bits : str or int
            The type or number of bits for the signal.
        direction : str
            The direction of the signal, can be 'in', 'out', or None.
        value : str or int, optional
            The initial value of the signal, by default None.
        key : str, optional
            The key for the signal, can be 'variable', 'signal', 'constant', or None, by default None.

        Returns
        -------
        None
        """
        self.key: str = key if key is not None else "signal"
        self.name: str = name
        self.value: str = value
        self.type: str = None

        # Validate the direction
        try:
            if direction not in ("in", "out", None):
                raise ValueError("ERROR: Direction must be 'in', 'out', or None")
        except ValueError as e:
            My_Exception.add_exception(e)
        self.direction: str = direction

        try:
            number_of_bits = int(type_or_number_of_bits)
        except ValueError:
            if type_or_number_of_bits.strip() in self.possible_types:
                self.type = type_or_number_of_bits  # Recognized type
            else:
                self.type = f"std_logic_vector({type_or_number_of_bits}-1 downto 0)"  # Unrecognized type
                # If the type is not in the possible types, add it
                if self.type not in self.possible_types:
                    self.possible_types.append(self.type)
        else:
            try:
                if number_of_bits == 1:
                    self.type = "std_logic"
                    self.nb_bits = number_of_bits
                elif number_of_bits > 1:
                    self.type = f"std_logic_vector({number_of_bits - 1} downto 0)"
                    self.nb_bits = number_of_bits
                    # Add the type to possible types if not already present
                    if self.type not in self.possible_types:
                        self.possible_types.append(self.type)
                else:
                    raise ValueError("ERROR: Number of bits cannot be negative")
            except ValueError as e:
                My_Exception.add_exception(e)

    def signal_to_vhdl(self) -> str:
        """
        Generates the VHDL code line for the signal.

        Returns
        -------
        str
            A string representing the VHDL code line.
        """
        s = f"{self.key} " if self.key is not None else ""
        s += f"{self.name}\t\t: {self.direction + ' ' if self.direction is not None else ''}{self.type}"
        if self.value is not None:
            s += f" := {self.value}"
        s += ";"
        return s

    def copy(self):
        """
        Creates a copy of the signal.

        Returns
        -------
        Signal
            A new Signal object with the same attributes.
        """
        return Signal(self.name, self.type, self.direction, self.value)

#-------------------------------------------------------------

class Clock(Signal):
    """
    Clock class to represent a clock signal.

    Attributes
    ----------
    type : str, constant
        The type of the clock signal, always "std_logic".
    direction : str, constant
        The direction of the clock signal, always "in".
    name : str
        The name of the clock signal.
    period : int
        The period of the clock, used for simulations.
    unit : str
        The time unit of the clock period, e.g., 'ns', 'us', 'ms', 's'.
    """
    type = "std_logic"
    direction = "in"

    def __init__(self, name: str, period: int, unit: str) -> None:
        """
        Constructor for the Clock class.

        Parameters
        ----------
        name : str
            The name of the clock signal.
        period : int
            The period of the clock.
        unit : str
            The unit of time for the clock period.

        Returns
        -------
        None
        """
        self.name = name
        self.period = period
        self.unit = unit

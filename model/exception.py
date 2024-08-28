from typing import List
from colors import colors

class My_Exception:
    """
    A class for handling exceptions and warnings.

    Attributes
    ----------
    exceptions_list : List[Exception]
        A static list to store exceptions.
    warnings_list : List[Warning]
        A static list to store warnings.
    """
    exceptions_list: List[Exception] = []
    warnings_list: List[Warning] = []

    @classmethod
    def add_exception(cls, e: Exception) -> None:
        """
        Adds an exception to the static exceptions list.

        Parameters
        ----------
        e : Exception
            The exception to add.

        Returns
        -------
        None
        """
        cls.exceptions_list.append(e)

    @classmethod
    def add_warning(cls, w: Warning) -> None:
        """
        Adds a warning to the static warnings list.

        Parameters
        ----------
        w : Warning
            The warning to add.

        Returns
        -------
        None
        """
        cls.warnings_list.append(w)
    
    @classmethod
    def display_exceptions(cls) -> None:
        """
        Displays all stored exceptions with appropriate color coding.

        Returns
        -------
        None
        """
        for e in cls.exceptions_list:
            print(f"{colors.RED} {e} {colors.END}")

    @classmethod
    def display_warnings(cls) -> None:
        """
        Displays all stored warnings with appropriate color coding.

        Returns
        -------
        None
        """
        for w in cls.warnings_list:
            print(f"{colors.YELLOW} {w} {colors.END}")

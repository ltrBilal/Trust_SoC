from generic import Generic
from port import Port
from typing import List
from process import Process
from a_signal import Signal
from functions import find_signal

class Component:
    """
    Represents a hardware component in VHDL.

    Attributes
    ----------
    name : str
        The name of the component, a constant defined for each component inheriting this class.
    generic : Generic
        The generic part of the component, represented as a Generic object.
    ports : Port
        The port part of the component, represented as a Port object.
    process_list : List[Process]
        A list containing all processes within the component.
    signals_list : set[Signal]
        A set containing all signals associated with the component.
    """
    name: str = None
    generic: Generic = None
    ports: Port = None
    process_list: List[Process] = []
    signals_list: set[Signal] = set()

    def __init__(self, name: str, generic: Generic, ports: Port) -> None:
        """
        Initializes a Component instance.

        Parameters
        ----------
        name : str
            The name of the component.
        generic : Generic
            The generic part of the component.
        ports : Port
            The ports of the component.

        Returns
        -------
        None
        """
        self.name = name
        self.generic = generic
        self.ports = ports

    def component_code(self) -> str:
        """
        Generates the VHDL code for the component declaration.

        Returns
        -------
        str
            The VHDL code for the component.
        """
        code: str = f"\tcomponent {self.name} is\n"
        if self.generic is not None:
            code += "\t" + self.generic.generic_to_vhdl()
        if self.ports is not None:
            code += "\t" + self.ports.port_to_vhdl()
        code += "\tend component;\n"
        return code

    def component_instance(self, instance_name: str, component: 'Component', component_parent: 'Component' = None, signals_name_list: List[Signal] = None) -> str:
        """
        Generates the VHDL code for an instance of the component.

        Parameters
        ----------
        instance_name : str
            The name of the instance.
        component : Component
            The component to instantiate.
        component_parent : Component, optional
            The parent component, used to determine connections if signals_name_list is None, by default None.
        signals_name_list : List[Signal], optional
            A list of signals to connect to this component's ports. If None, connections use the parent component's ports, by default None.

        Returns
        -------
        str
            The VHDL code for the component instance.
        """
        code: str = f"\t{instance_name} : {self.name}\n"
        if self.generic is not None:
            code += f"\t\tgeneric map (\n"
            size = len(self.generic.signals_list)
            indice = 0
            for i in range(size):
                if signals_name_list is None:
                    code += f"\t\t\t{self.generic.signals_list[i].name} => {component.generic.signals_list[i].name},\n"
                else:
                    code += f"\t\t\t{self.generic.signals_list[i].name} => {signals_name_list[indice].name},\n"
                    indice += 1
            code = code.rstrip(',\n')  # Remove trailing comma and newline
            code += "\n\t\t)\n"
        
        if self.ports is not None:
            code += f"\t\tport map (\n"
            size = len(self.ports.signals_list)
            for i in range(size):
                if signals_name_list is None:
                    code += f"\t\t\t{self.ports.signals_list[i].name} => {component.ports.signals_list[i].name},\n"
                else:
                    s: Signal = find_signal(component_parent.signals_list, signals_name_list[indice])
                    code += f"\t\t\t{self.ports.signals_list[i].name} => {s.name},\n"
                    indice += 1
            code = code.rstrip(',\n')  # Remove trailing comma and newline
            code += "\n\t\t);\n"
                    
        return code

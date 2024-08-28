from component import Component
from typing import List
from ascon import Ascon
from __global import *
from my_parser import extract_components

import time


def main(folder : str):
    start_time = time.time()

    # Récupérer tous les composants externes
    components_list: List[Component] = extract_components(folder)

    print(f"l'extraction de composant a fait : {time.time() - start_time}")
    Ascon(components_list)

# ---------------------------------------------------------------------------------------------------------

if __name__ == "__main__":
    folder : str = "./components"
    main(folder)

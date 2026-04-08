#Abstract Method

from abc import ABC, abstractmethod

class Appliance(ABC): #Abstract base class (Class - Blueprint)
    def __init__(self, brand: str, version_no: int) -> None:
        self.brand = brand
        self.version_no = version_no
        self.is_turned_on: bool = False

    @abstractmethod
    def turn_on(self) -> None:
        ...
    @abstractmethod
    def turn_off(self) -> None:
        ...

class Lamp(Appliance):
    def __init__(self, brand: str, version_no: int) -> None:
        super().__init__(brand, version_no)

    def turn_on(self) -> None:
        if self.is_turned_on:
            print(f"{self.brand} is turned on!")
        else:
            self.is_turned_on = True
            print(f"{self.brand} is already turned on!")

    def turn_off(self) -> None:
        if self.is_turned_on:
            self.is_turned_on = False
            print(f"{self.brand} is turned off!")
        else:
            print(f"{self.brand} is already turned off!")

class Oven(Appliance):
    def __init__(self, brand: str, version_no: int) -> None:
        super().__init__(brand, version_no)

    def turn_on(self) -> None:
        raise NotImplementedError("Need to add functionality")

    def turn_off(self) -> None:
        raise NotImplementedError("Need to add functionality")

def main() -> None:
    lamp: Lamp = Lamp("Z-Lite", 1)
    lamp.turn_on()
    lamp.turn_on()
    lamp.turn_off()
    lamp.turn_off()
    lamp.turn_on()
    lamp.turn_off()


if __name__ == "__main__":
    main()
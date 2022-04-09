module {

    public type Animal = {
        species : Text;
        energy : Nat;
    };

    // Challenge 3
    public func animal_sleep(animal : Animal) : Animal {
        var r_animal : Animal = {
            species = animal.species;
            energy = animal.energy - 10;
        };

        return r_animal;
    };
}
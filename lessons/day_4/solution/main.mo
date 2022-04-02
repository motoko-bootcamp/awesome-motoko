import Person "person";
import Attitude "custom";
import Animal "animal";
import Array "mo:base/Array";
import List "mo:base/List";

actor {
    public type Person = Person.Person;
    public type Attitude = Attitude.Attitude;
    public type Animal = Animal.Animal;
    public type List<T> = ?(T, List<T>);

    // Challenge 1
    let isaac : Person = {
        name = "isaac";
        age = 31;
    };

    let default_attitude : Attitude = {
        person = isaac;
        mood = "excited";
        expression = "smiling";
        good = true;
    };

    public func fun() : async Attitude {
        return default_attitude;
    };

    // Challenge 2
    let cheeta : Animal = {
        species = "felis catus";
        energy = 100;
    };

    // Challenge 4
    public func create_animal_then_takes_a_break(species : Text, energy : Nat) : async Animal {
       var animal : Animal = {
            species = species;
            energy = energy;
        };

        animal := Animal.animal_sleep(animal);

        return animal;
    };

    // Challenge 5
    var animal_list : List<Animal> = null;

    // Challenge 6
    public func push_animal(animal : Animal) {
        animal_list := List.push<Animal>(animal, animal_list);
    };

    public func get_animals() : async [Animal] {
        return List.toArray<Animal>(animal_list);
    }


}
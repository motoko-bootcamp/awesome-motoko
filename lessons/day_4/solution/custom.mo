import Person "person";

module {
    public type Person = Person.Person;

    public type Attitude = {
        person : Person;
        mood : Text;
        expression : Text;
        good : Bool;
    };
}
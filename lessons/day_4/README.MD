# Daily guide : day 4 🐓

Welcome into the **day 4** of the Motoko Bootcamp ! <br/>
Today we will cover the following topics : **Custom type** and **Linked list**.

# Prerequisites ✅

- Make sure you have dfx installed on your machine.

  ```
  dfx --version
  ```

- Start a new project called **day_4** and turn on your local replica.

  ```
  dfx new day_4
  cd day_4
  dfx start
  ```

# Custom type 🔧

During the previous days we have manipulated different types (Nat, Text, Bool, Array); today we are creating to create our **own** type !
Create a new file called person.mo in the day_4 folder (next to main.mo) and copy and paste the following declaration.

```
module {

}
```

This is a **module** declaration, contrary to all previous .mo files that were **actor** declarations. <br/>
A module is (just the like the base library modules we've been using) a piece of code that we can import and reuse.

This is how we can create a custom type. If you want your type to be accessible from the outside of the module you need to make it **public**.

```
public type Person = {
  name : Text;
  age : Nat;
};
```

The type Person is also called an **object** with different **fields** (name, age).

Now that we have declared our type we can create our first variable of type Person.

```
let tom : Person = {
  name = "Tom Cruise";
  age = 59;
};
```

You can access any **field** using the **dot** notation.

```
let tom_name = tom.name;
let tom_age = tom.age;
```

In your main.mo file you can **import** the type Person and use it as if it was part of Motoko native types.

```
import Person "person";
actor {
  public type Person = Person.Person;
  let penelope : Person = {
    name = "Penelope Cruz";
    age = 47;
  };

};

```

💡 **Person.Person** simply means : grab the type Person from the Person module.

# Challenge 🎮

Take a break and try completing challenge 1 to 3.

# Linked list 🔗

A linked list is a datastructure, that contrary to array has a **dynamic** size.
It consists of many **nodes** each node contains :

- A value of type T.
- A pointer to the next node or to **_null_**.

<p align="center"> <img src="img/linked-list.svg" width="400"/> </p>
<p align="center"> <i> <strong> A linked list of Nat</i> </strong> </p>

The first element of this linked list is a node where :

- Value of type **Nat** equals to 12.
- A pointer to next node.

💡 A pointer is just a memory location indicating where a data is stored. You can think of it as an **arrow** indicating where to find the next node.

Here's how one would define a **linked list** in Motoko.

```
public type List<T> = ?(T, List<T>);
```

This means that a List of type T is either :

- **_null_**
- A **couple** of two elements.
  - 1st element is a value of type T.
  - 2nd element is a List of type T.

💡 To acces an element in a **linked list** you need to start from the first node and follow all the nodes until you came accross the value you are looking for. </n> <br/>
This is more complex than with **arrays** where we could just use array[i], but linked lists have other advantages that we will see.

# Challenge 🎮

Take a break and try completing challenge 4 to 6. <br/>

# Switch / Case

We have already seen the switch/case expression in previous lessons, but let's make a quick review.
We can use the switch/case on **optional expression**.
An element of type **List** can be of value **_null_**. We can check it that way.

```
public type List<T> = ?(T, List<T>);
public func is_list_null(list : List<Nat>) : async Text {
        switch(list){
            case(null) {
                return "The list is null... 😢"
            };
            case(?list){
                return "This list is not null 🥳"
            };
        }
    };
```

The switch/case can also be used for testing different **values**.

```
public func month_to_season (month : Text) : async Text {
  switch(month){
    case("January") return "Winter";
    case("February") return "Winter";
    case("March") return "Spring";
    case("April") return "Spring";
    case("May") return "Spring";
    case("June") return "Summer";
    case("July") return "Summer";
    case("August") return "Summer";
    case("September") return "Autumn";
    case("October") return "Autumn";
    case("November") return "Autumn";
    case("December") return "Winter";
    case(_) return "This is not a month";
  }
};
```

The last case statement is used to indicate a default value, in case the value in the switch (in our case the **month**) do not find in any of the previous cases. It will default to the case with the **\_** indicator :

```
case(_) return "This is not a month";
```

You can actually try this function by deploying it in the Motoko Playground and check what value you get back with "April" and then with "Hello".

# Challenge 🎮

Take a break and try completing challenge 7 to 10. <br/>

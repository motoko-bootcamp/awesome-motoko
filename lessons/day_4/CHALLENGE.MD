# Challenge : day 4 🐓

TODO

# Prerequisites ✅

- Make sure you've read all the instructions on how to complete the challenges.

- Follow along with the daily guide.

# Coding 🧑‍💻

For the daily challenges of today, you need to create multiples files. Instead of creating a file day_4.mo, start by creating a folder day_4 and inside create the different files you'll be asked for through the challenges.

- Challenge 1 : Create two files called custom.mo and main.mo, create your own type inside custom.mo and import it in your main.mo file. In main, create a public function<strong> <i> fun </i> </strong> that takes no argument but return a value of your custom type. <br/>
  Note : Be creative 🌈

- Challenge 2 : Create a new file called animal.mo with at least 2 property (specie of type Text, energy of type Nat), import this type in your main.mo and create a variable that will store an animal.

- Challenge 3 : In animal.mo create a public function called animal_sleep that takes an **Animal** and returns the same Animal where the field energy has been increased by 10.
  Note : As this is a public function of a **module**, you don't need to make the return type Async !

- Challenge 4 : In main.mo create a public function called<strong> <i> create_animal_then_takes_a_break <T> </i> </strong> that takes two parameter : a specie of type Text, an number of energy point of type Nat and returns an animal. This function will create a new animal based on the parameters passed and then put this animal to sleep before returning it ! 💤

- Challenge 5 : In main.mo, import the type List from the base Library and create a list that stores animal.

- Challenge 6 : In main.mo : create a function called <strong> <i> push_animal </i> </strong> that takes an animal as parameter and returns nothing this function should add this animal to your list created in challenge 5. Then create a second functionc called <strong> <i> get_animals </i> </strong> that takes no parameter but returns an **Array** that contains all animals stored in the list.

For challenges 7 to 10 : You need to start from a fresh file (call it list.mo) you **cannot** use the List module of the base library, the goal is to reimplement some functionnality of arrays.

- Challenge 7 : Write a function <strong> <i> is_null<T> </i> </strong> that takes <strong> l </strong> of type <strong>List\<T> </strong> and returns a boolean indicating if the list is <strong> <i> null </i> </strong>.
  Tips : Try using a switch/case.

- Challenge 8 : Write a function <strong> <i> last </i> </strong> that takes <strong> l </strong> of type <strong>List\<T> </strong> and returns the optional last element of this list.

- Challenge 9 : Write a function <strong> <i> size </i> </strong> that takes <strong> l </strong> of type <strong>List\<T> </strong> and returns a <strong> Nat </strong> indicating the size of this list. <br/>
  Note : If l is <strong> <i> null </i> </strong>, this function will return 0.

- Challenge 10 : Write a function <strong> <i> get </i> </strong> that takes two arguments : <strong> l </strong> of type <strong>List\<T> </strong> </strong> and <strong> n </strong> of type <strong> Nat</strong> this function should return the optional value at rank n in the list.

In case you are done with everything. 👇

- Challenge 11 : Write a function <strong> <i> reverse </i> </strong> that takes <strong> l </strong> of type **List** and returns the reversed list.

<br/>
<strong> <i> Good luck 🎉 </strong> </i>

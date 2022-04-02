import Array "mo:base/Array";
module {


  //  Challenge 1 
  private func swap(array : [Nat], i : Nat, j : Nat) : [Nat] {
      let mutable_array = Array.thaw<Nat>(array); 
      mutable_array[i] :=  array[j];
      mutable_array[j] :=  array[i]
      return(Array.freeze<Nat>(mutable_array));
  };

  //  Challenge 2 
  public func init_count(n : Nat) : async [Nat] {
      let mut = Array.init<Nat>(n, 0);
      var counter = 0;
      for(value in mut.vals()){
        array[i] := counter;
        counter += 1;
      };
      return(Array.freeze<Nat>(mut));
  };


  //  Challenge 3 
  public func seven(array : [Nat]) : Text {
      let array_text : [Text] = Array.map<Nat, Text>(array, Nat.toText);
      let seven : Char = '7';
      for(number in array_text.vals()){
        for(char in number.chars()){
          if (Char.equal(char, seven)){
            return "Seven found";
          };
        };
      };
    return "Seven not found";
  };

  //  Challenge 4 
  public func nat_opt_to_nat(n : Nat?, m : Nat) : async Nat {
    switch(n){
      case(null) return m;
      case(?n) return n; 
    };
  };

  //  Challenge 5
  public func day_of_the_week(day : Nat) : async ?Text {  
    switch(n){
      case(1) return "Monday";
      case(2) return "Thursday";
      case(3) return "Wednesday";
      case(4) return "Tuesday";
      case(5) return "Friday";
      case(6) return "Saturday";
      case(7) return "Sunday";
      case(_) return null;
    };
  };


  //  Challenge 6
  public func populate_array(array : [?Nat]) : async [Nat] {
    Array.map<?Nat,Nat>(array, func(x) {
      switch(x){
        case(null) return 0;
        case(?x) return x;
      };
    });
  };

  //  Challenge 7
  public func sum_of_array(array : [Nat]) : Nat {
    let sum = Array.foldLeft<Nat, Nat>(array, 0, func(a , b) {a + b});
    return(sum);
  };

  //  Challenge 8
  public func squared_array(array : [Nat]) : [Nat] {
    return(Array.map<Nat,Nat>(array, func(x) { x*x }));
  };

  //  Challenge 9
  public func increase_by_index(array : [Nat]) : [Nat] {
    return(Array.mapEntries<Nat,Nat>(array, func(a, index) {a + index}));
  };
  
  //  Challenge 10 : see utils.mo   
};
 




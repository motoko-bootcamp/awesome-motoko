import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Char "mo:base/Char";

actor {

  //  Challenge 1 
  public func add(x : Nat, y : Nat) : async Nat {
    return(x + y);
  };

  //  Challenge 2
  public func square(n : Nat) : async Nat {
    return(n * n);
  };

  //  Challenge 3
  public func days_to_second(n : Nat) : async Nat {
    return(n * 24 * 60 * 60); // Each day has 24 hours; each hour has 60 minutes; each minute has 60 seconds.
  };

  //  Challenge 4
  var counter = 0;

  public func increment_counter(n : Nat) : async Nat {
    counter += n;
    return counter;
  };

  public func clear_counter() : async Nat {
    counter := 0;
    return counter;
  };

  //  Challenge 5 
  public func divise(x : Nat, y: Nat) : async Bool {
    if(x % y == 0){
      return true 
    } else {
      return false;
    };
  };

  //  Challenge 5 : short version.
  public func divise2(x : Nat, y: Nat) : async Bool {
    return(x % y == 0)
  }; 

  //  Challenge 6
  public func is_even (n : Nat) : async Bool {
    (n % 2 == 0);
  };

  //  Challenge 7
  public func sum_of_array(array : [Nat]) : async Nat {
    var sum = 0;
    for(val in array.vals()){
      sum += val;
    };
    return(sum)
  };

  //  Challenge 8
  public func maximum(array : [Nat]) : async Nat {
    if(array.size() == 0) return 0;
    var maximum = array[0];
    for (val in array.vals()){
      if (val >= maximum) {
        maximum := val;
      };
    };
    return(maximum)
  };


  //  Challenge 9
  public func remove_from_array(array : [Nat], n : Nat) : async [Nat] {
    var new_array : [Nat] = [];
    for (vals in array.vals()){
      if(vals != n){
        new_array := Array.append<Nat>(new_array, [vals]);
      };
    };
    return(new_array);
  };

  // Challenge 10 : Selection sort

  private func _swap(array : [Nat], i : Nat, j : Nat) : [Nat] {
    // Transform our immutable array into a mutable one so we can modify values.
    let array_mutable = Array.thaw<Nat>(array);
    let tmp = array[i];
    array[i] := array[j];
    array[j] := tmp;
    // Transform our mutable array into an immutable array.
    return(Array.freeze<Nat>(array));
  };

  public func selection_sort(array : [Nat]) : async [Nat] {
    var sorted = array;
    let size = array.size();
    // First loop
    for(i in Iter.range(0, size - 1)){
      var index_minimum = i;
      // Second loop to determine the minimum in the sub array
      for(j in Iter.range(i, size - 1)){
        if(sorted[j] < sorted[index_minimum]){
          index_minimum := j;
        };
      };
    sorted := _swap(sorted, index_minimum, i);
    };  
    return(sorted);
  };

  // Note : This _swap function that swap index i and j of a mutable array is not something I would recommend. If you are defining an array as immutable you shouldn't touch the values inside after the declaration.
  // Also Motoko has a sort function in the Array library. Challenge 10 was mostly for educational purposes around sorting algorithm.

};

 



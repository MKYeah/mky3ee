import Int "mo:base/Int";
import Nat32 "mo:base/Nat32" ;
import Trie "mo:base/Trie";
import Option "mo:base/Option";
import List "mo:base/List";
import Result "mo:base/Result";
import Debug "mo:base/Debug";


actor {
  stable var lastGreeted: Text = "";
  stable var lastGreetedAge: Text ="" ;
  stable var greetCount: Nat = 0;
  private stable var next : personId = 1;
  public type personId = Nat32 ; 

  public type person = {
    name : Text;
    age : Text;
    //agam: List.List<Text>;
  };
  
  private stable  var persons : Trie.Trie< personId , person> = Trie.empty();
  
  public func getperson (id: personId) : async ?person{
    let result = Trie.find(
      persons,
      key(id),
      Nat32.equal
    );
    return result;
  };

  public func greet(person : Text): async Text{
  lastGreeted := person;
  greetCount += 1;
  return "Hello," # person # "!";
  };

  public func createperson (newperson : person) : async person {
    let id = next ;
    next += 1 ; 

    persons := Trie.replace(
      persons,
      key(id),
      Nat32.equal,
      ?newperson
    )
    .0;
    return newperson;
  };  


  public func giveage(age: Text): async Text{
    lastGreetedAge := age;
    return  "" # age # ".";
  };
  
  public func getLastGreetedAge() : async Text {
  return lastGreetedAge;
  };


  public func getLastGreetedPerson() : async Text {
  return lastGreeted;
  };

  public func getGreetCount() : async Int {
  return greetCount;
  };

  public func reset() : async Nat {
  greetCount := 0 ;

  return greetCount;
  };


  private func key(x : personId): Trie.Key<personId> {
    { hash = x ; key = x };

  };

};

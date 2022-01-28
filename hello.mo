import Text "mo:base/Text";
import Debug "mo:base/Debug";

actor Echo {
  public query func say(phrase : Text) : async Text {
    Debug.print(phrase);
    return phrase
  }
}

/*
import Debug "mo:base/Debug"

actor HelloWorld {
  public func main() {
    Debug.print("Hello World!")
  }
}
*/
import Text "mo:base/Text";
import Soundex "../src/Soundex";

actor {
  public func useSoundex(t: Text): async Text {
    let soundex = Soundex.initMapping();
    switch(Soundex.toSoundexCode(soundex, t)) {
      case (#err(error)) { "error: " # error };
      case (#ok(result)) { "result: " # result};
    }
  }
}
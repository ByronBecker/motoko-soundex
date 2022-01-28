import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Prim "mo:⛔"

/// Generate the SoundexMapping (or your own custom soundex mapping), as well as a string,
/// and apply the American Soundex algorithm to it
/// https://en.wikipedia.org/wiki/Soundex#American_Soundex
///
/// Note: The algorithm returns a result type, and will return an error if passed an empty string
///
/// Example usage:
///
/// ```motoko
/// import Soundex "mo:soundex/Soundex"
/// let soundex = Soundex.Soundex();
/// let codeTymcazk = Soundex.toSoundexCode(soundex, "Tymczak");  // yields ("T520")
/// let codeRupert = Soundex.toSoundexCode(soundex, "Rupert");  // yields ("R163")
///  ```

module {
  public func initMapping(): HashMap.HashMap<Text, Text> {
    let characterScoreTupleMapping: [([Text], Text)] = [
      (["a", "e", "i", "o", "u", "y", "h", "w"], ""),  //vowelOrHW
      (["b", "f", "p", "v"], "1"), //charScore1
      (["c", "g", "j", "k", "q", "s", "x", "z"], "2"), //charScore2
      (["d", "t"], "3"), //charScore3
      (["l"], "4"), //charScore4
      (["m", "n"], "5"), //charScore5
      (["r"], "6")  //charScore6
    ];
    let map = HashMap.HashMap<Text, Text>(
      26, //size of alphabet
      Text.equal,
      Text.hash
    );

    for ((charList, digitValue) in characterScoreTupleMapping.vals()) {
      for (c in charList.vals()) {
        map.put(c, digitValue);
      };
    };

    return map;
  };

  /// Generate the SoundexMapping (or your own custom soundex mapping), as well as a string,
  /// and apply the American Soundex algorithm to it
  /// https://en.wikipedia.org/wiki/Soundex#American_Soundex
  ///
  /// Note: The algorithm returns a result type, and will return an error if passed an empty string
  ///
  /// Example usage:
  ///
  /// let soundex = Soundex.Soundex();
  /// let codeTymcazk = Soundex.toSoundexCode(soundex, "Tymczak");  // yields ("T520")
  /// let codeRupert = Soundex.toSoundexCode(soundex, "Rupert");  // yields ("R163")
  public func toSoundexCode(soundexTextToDigitMap: HashMap.HashMap<Text, Text>, t: Text): Result.Result<Text, Text> {
    let chars = t.chars();
    let firstLetter = chars.next();
    let soundexCodeSize = 4;
    switch(firstLetter) {
      case null {
          return #err("Empty String")
      };
      case (?first) {
        var code = "";
        var prevLetter = "";
        code #= Text.fromChar(Prim.charToUpper(first));

        for (c in chars) {
          if (code.size() == soundexCodeSize) return #ok(code);

          switch(soundexTextToDigitMap.get(Text.fromChar(c))) {
            case null  { /* character not in alphabet */ };
            // case (?"") { /* vowel or HW is not added */ };
            case (?digit) { 
              if (digit != prevLetter) {
                prevLetter := digit;
                code #= digit;
              }
            };
          }
        };

        var codeSize = code.size();
        while(codeSize < soundexCodeSize) {
          code #= "0";
          codeSize += 1;
        };
        
        return #ok(code);
      }
    }
  }
}

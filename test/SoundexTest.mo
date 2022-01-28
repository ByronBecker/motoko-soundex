import Array "mo:base/Array";
import Debug "mo:base/Debug";
import M "mo:matchers/Matchers";
import T "mo:matchers/Testable";
import Suite "mo:matchers/Suite";
import Soundex "../src/Soundex";

let {run;test;suite} = Suite;
let soundexMapping = Soundex.initMapping();

Debug.print("running tests!");

run(suite("toSoundexCode rules", 
  [
    test(
      "empty string throws an error",
      Soundex.toSoundexCode(soundexMapping, ""),
      M.equals(T.result<Text, Text>(
        T.textTestable,
        T.textTestable,
        #err("Empty String")
      ))
    ),
    test(
      "vowels omitted",
      Soundex.toSoundexCode(soundexMapping, "baeiouy"),
      M.equals(T.result<Text, Text>(
        T.textTestable,
        T.textTestable,
        #ok("B000")
      ))
    ),
    test(
      "w and h omitted",
      Soundex.toSoundexCode(soundexMapping, "twhwhwhwh"),
      M.equals(T.result<Text, Text>(
        T.textTestable,
        T.textTestable,
        #ok("T000")
      ))
    ),
    test(
      "if code is not length 4, fills remaining code digits with zeroes",
      Soundex.toSoundexCode(soundexMapping, "x"),
      M.equals(T.result<Text, Text>(
        T.textTestable,
        T.textTestable,
        #ok("X000")
      ))
    ),
    test(
      "uppercases first letter",
      Soundex.toSoundexCode(soundexMapping, "santa"),
      M.equals(T.result<Text, Text>(
        T.textTestable,
        T.textTestable,
        #ok("S530")
      ))
    ),
    test(
      "codes a consonant multiple times if separated by a vowel",
      Soundex.toSoundexCode(soundexMapping, "xbabab"),
      M.equals(T.result<Text, Text>(
        T.textTestable,
        T.textTestable,
        #ok("X111")
      ))
    ),
    test(
      "codes a consonant only once if immediately coming after a consonant with the same score",
      Soundex.toSoundexCode(soundexMapping, "sacks"),
      M.equals(T.result<Text, Text>(
        T.textTestable,
        T.textTestable,
        #ok("S200")
      ))
    ),
    test(
      "retains only the first 3 numbers if there are more than enough consonants",
      Soundex.toSoundexCode(soundexMapping, "Tyranosaurus"),
      M.equals(T.result<Text, Text>(
        T.textTestable,
        T.textTestable,
        #ok("T652")
      ))
    )
  ]
));

func characterTest(expectedDigit: Text): (Text) -> Suite.Suite {
  func f(t: Text): Suite.Suite {
    let digit = if (expectedDigit == "") {"0"} else {expectedDigit};
    return test(
      t # " maps to the digit " # expectedDigit,
      Soundex.toSoundexCode(soundexMapping, "x" # t),
      M.equals(T.result<Text, Text>(
        T.textTestable,
        T.textTestable,
        #ok("X" # digit # "00")
      ))
    )
  };
  return f;
};

run(suite("toSoundexCode character to digit codes",
  Array.flatten<Suite.Suite>([
    Array.map<Text, Suite.Suite>(
      ["a", "e", "i", "o", "u", "y", "h", "w"],
      characterTest("")
    ),
    Array.map<Text, Suite.Suite>(
      ["b", "f", "p", "v"],
      characterTest("1")
    ),
    Array.map<Text, Suite.Suite>(
      ["c", "g", "j", "k", "q", "s", "x", "z"],
      characterTest("2")
    ),
    Array.map<Text, Suite.Suite>(
      ["d", "t"],
      characterTest("3")
    ),
    Array.map<Text, Suite.Suite>(
      ["l"],
      characterTest("4")
    ),
    Array.map<Text, Suite.Suite>(
      ["m","n"],
      characterTest("5")
    ),
    Array.map<Text, Suite.Suite>(
      ["r"],
      characterTest("6")
    )
  ])
));
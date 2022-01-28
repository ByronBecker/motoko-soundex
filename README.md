# motoko-soundex

An implementation of the American Soundex algorithm in Motoko


## Usage

Generate the SoundexMapping (or your own custom soundex mapping), as well as a string,
and apply the American Soundex algorithm to it
https://en.wikipedia.org/wiki/Soundex#American_Soundex

Note: The algorithm returns a result type, and will return an error if passed an empty string

Example usage:

```motoko
import Soundex "mo:soundex/Soundex"
let soundex = Soundex.Soundex();
let codeTymcazk = Soundex.toSoundexCode(soundex, "Tymczak");  // yields ("T520")
let codeRupert = Soundex.toSoundexCode(soundex, "Rupert");  // yields ("R163")
 ```
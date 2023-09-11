# This is a full monkey lang tokenizer (minus extensions; so no string or comments).
# No perf tests have been done on it.

src←"let five = 5;
let ten = 10;

let add = fn(x, y) {
  x + y;
};

let result = add(five, ten);
!-/*5;
5 < 10 > 5;

if (5 < 10) {
    return true;
} else {
    return false;
}

10 == 10;
10 != 9;
let nottrue = false;
"

# Get all the letters, their first index, and the length of chains
az←('_'⊸=∨('a'⊸≤∧≤⟜'z')∨('A'⊸≤∧≤⟜'Z')) src
faz←(»<⊢)az
laz←faz×(+×0⊸≠)`⌾⌽ az

# Do the same thing to get all of the numbers
num←('0'⊸≤∧≤⟜'9') src
fnum←(»<⊢)num
lnum←fnum×(+×0⊸≠)`⌾⌽ num

# Match all of the keywords
kws←"fn"‿"let"‿"true"‿"false"‿"if"‿"else"‿"return"
pi←{/laz=≠𝕩}¨kws
kwi←pi/˜¨ kws {kw←𝕨⋄{kw≡(≠kw)↑𝕩↓src}¨𝕩}¨ pi

# Extract keyword types into full array.
kwm←1+↕≠kwi
c←↕≠src
kwt←+´kwm(⊣×c⊸∊)¨kwi

# Merge all length data into one general data array.
# Also includes the keyword type.
d←kwt+laz×kwt=0
d lnum⊸+↩

# Only match the first `!=` or `==` in a chain.
# Repeats will be invalid syntax anyway.
# So it is fine to parse `====` as `==` `=` `=`.
n‿e←⋈˝"!="=⌜src
fne←e(⊢∧«∘∧⟜»)n
n (¬fne)⊸∧↩
e (¬»fne)⊸∧↩
fee←(«∧⊢>»)e
e ((¬»∨⊢)fee)⊸∧↩

# All other symbols are just single characters.
tc←"+-/*<>;,(){}"
fc←n∨e∨tc∊˜src

# Get all illegal tokens
fi←¬az∨num∨fc∨src∊@+9‿10‿13‿32

fkw←kwt≠0

# Final format
# First array is i: ident, k: keyword, 0: number, e: equals, n: not equals, x: illegal, other tokens: themselves
# Second array is the index in the original src (This will be used to extract identifiers later).
# It also could be used for nice error messages.
# The last array is miscellaneous data.
# For keywords, it is the keyword type: 1: fn, 2: let, 3: true, 4: false, 5: if, 6: else, 7: return
# For identifiers and numbers, it is the length of the indentifier.

fm←faz∨fnum∨fkw∨fne∨fee∨fc∨fi
f←/fm

tt←fm/src
tt 'i'¨⌾((fm/faz)⊸/)↩
tt '0'¨⌾((fm/fnum)⊸/)↩
tt 'k'¨⌾((fm/fkw)⊸/)↩ # Note Keyword types are in data array. They could be merged here.
tt 'n'¨⌾((fm/fne)⊸/)↩
tt 'e'¨⌾((fm/fee)⊸/)↩
tt 'x'¨⌾((fm/fi)⊸/)↩

d fm⊸/↩

•Show ⍉>tt‿f‿d

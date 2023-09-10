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

•Show >kws‿kwi

# Only match the first `!=` or `==` in a chain.
# Repeats will be invalid syntax anyway.
# So it is fine to parse `====` as `==` `=` `=`.
n‿e←⋈˝"!="=⌜src
ne←e(⊢∧«∘∧⟜»)n
n (¬ne)⊸∧↩
e (¬»ne)⊸∧↩
ee←(«∧⊢>»)e
e ((¬»∨⊢)ee)⊸∧↩

# All other symbols are just single characters.
tc←"+-/*<>;,"
fc←n∧e∧tc∊˜src

•Show ⍉>src‿faz‿laz‿fnum‿lnum‿ne‿ee‿fc

# This should now be a full monkey lang tokenizer (minus extensions).
# Of course would have to get more fancy to deal with strings and comments.

# Probably should also double check for no invalid characters instead of skipping them.
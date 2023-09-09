# Just some testing for the == and != tokens.
# They naturally have a linear dependency
# ...though you technically could ignore those cause they always will fail to parse.
# Just make any chain of more than 2 equals a lex failure
# Could do the same for anything !== and beyond.
# Kinda like generating the parse error early
# ...I may do that in the final code for simplicity and perf
# Could also technically delay all of this to the parser but that changes token types.
src←"a!===!b====!====!c"
e←'='=src
n←'!'=src
# This filters out all of the `!=`s
ne←e(⊢∧«∘∧⟜»)n
o1←e (¬»ne)⊸∧↩
# Each stage here filters out the leftmost `==` in a group
# Would be done with a repeat instead of manually (repeat based on the max)
o2←c←(+×0⊸≠)`⌾⌽ e
m←⌈´c
o3←c↩(c×⊢¬∘∨»)m=c
m↩⌈´c
o4←c↩(c×⊢¬∘∨»)m=c
# What is left here is the indivial `=`s
m↩⌈´c
o5←c↩(c×⊢¬∘∨»)m=c
•Show >src‿((⊢∨»)ne)‿o1‿o2‿o3‿o4‿o5

src↩"true 27 < if if123 let>nolet;"

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

# All other symbols are just single characters.
# Note: need to use the special info from above for = and !.
tc←"=+-!/*<>;,"
fc←tc∊˜src

•Show >src‿faz‿laz‿fnum‿lnum‿fc
# This is all of the pieces needed for a monkey lang tokenizer.
# Probably should also double check for no invalid characters instead of skipping them.
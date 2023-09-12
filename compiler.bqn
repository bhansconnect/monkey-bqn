⟨
  Lex
⟩⇐

# This is a full monkey lang tokenizer based on chapter 1 of the book (so no string or comments).
Lex←{
    src←𝕩
    # Get all the letters, their first index, and the length of chains
    az←('_'⊸=∨('a'⊸≤∧≤⟜'z')∨('A'⊸≤∧≤⟜'Z')) src
    faz←»⊸<⊢az
    laz←-˜˝˘∘‿2⥊/0(∾≠∾˜)az

    # Do the same thing to get all of the numbers
    num←('0'⊸≤∧≤⟜'9') src
    fnum←»⊸<num
    lnum←-˜˝˘∘‿2⥊/0(∾≠∾˜)num

    # Match all of the keywords
    kws←"fn"‿"let"‿"true"‿"false"‿"if"‿"else"‿"return"
    iaz←/faz
    kwi←{
      l←≠kw←𝕩
      pi←iaz/˜l=laz
      {kw≡l↑𝕩↓src}¨⊸/pi
    }¨kws

    # Extract keyword types into full array.
    kwm←1+↕≠kwi
    kwt←+´kwm×(≠src)⊸↑∘(/⁼)¨kwi

    # Only match the first `!=` or `==` in a chain.
    # Repeats will be invalid syntax anyway.
    # So it is fine to parse `====` as `==` `=` `=`.
    n‿e←⋈˝"!="=⌜src
    on‿oe←n‿e
    fne←e(⊢∧«∘∧⟜»)n
    n ∧↩ ¬fne
    e ∧↩ ¬»fne
    fee←(«∧⊢>»)e
    e ∧↩ (¬»∨⊢)fee

    # All other symbols are just single characters.
    tc←"+-/*<>;,(){}"
    fc←n∨e∨tc∊˜src

    # Get all illegal tokens
    fx←¬az∨num∨fc∨on∨oe∨src∊@+9‿10‿13‿32

    fkw←kwt≠0

    # Final format
    # First array is i: ident, k: keyword, 0: number, e: equals, n: not equals, x: illegal, other tokens: themselves
    # Second array is the index in the original src (This will be used to extract identifiers later).
    # It also could be used for nice error messages.
    # The last array is miscellaneous data.
    # For keywords, it is the keyword type: 1: fn, 2: let, 3: true, 4: false, 5: if, 6: else, 7: return
    # For identifiers and numbers, it is the length of the indentifier.

    fm←faz∨fnum∨fkw∨fne∨fee∨fc∨fx
    f←/fm

    # fc does not update tt becuase characters stay as their oringal value.
    tt←"ki0nex "⊏˜+´∧`¬fkw‿faz‿fnum‿fne‿fee‿fx
    tt↩fm/src⊣⌾((' '=tt)⊸/)tt

    ffaz←fm/faz
    ffnum←fm/fnum
    ffkw←fm/fkw
    d←0¨tt
    d laz⌾(ffaz⊸/)↩
    d lnum⌾(ffnum⊸/)↩
    d (fkw/kwt)⌾(ffkw⊸/)↩

    tt‿f‿d
}

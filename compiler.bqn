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

    # Final format
    # First array is i: ident, k: keyword, 0: number, e: equals, n: not equals, x: illegal, other tokens: themselves
    # Second array is the index in the original src (This will be used to extract identifiers later).
    # It also could be used for nice error messages.
    # The last array is miscellaneous data.
    # For keywords, it is the keyword type: 1: fn, 2: let, 3: true, 4: false, 5: if, 6: else, 7: return
    # For identifiers and numbers, it is the length of the indentifier.

    # Construct token type array.
    # fc does not update tt becuase characters stay as their orignal value.
    fm←faz∨fnum∨fne∨fee∨fc∨fx
    tt←"i0nex "⊏˜fm/+´∧`¬faz‿fnum‿fne‿fee‿fx
    tt (fc/src)⌾((' '=tt)⊸/)↩

    # Construct index array.
    f←/fm

    # Construct data array.
    ffaz←fm/faz
    ffnum←fm/fnum
    d←0¨tt
    d laz⌾((/ffaz)⊸⊏)↩
    d lnum⌾((/ffnum)⊸⊏)↩

    # We skipped keywords above. Add them now.
    # Convert identifiers to keywords if they match.
    # This really feels like it could be done better.
    # ~50% of execution time is spent after this line.
    # Originally, I calculated kwt when first extracting identifiers.
    # That also had promise, but was a bit slower than this is.
    kws←"fn"‿"let"‿"true"‿"false"‿"if"‿"else"‿"return"
    kwm←kws(faz⊸∧≠∘⊢↑⍷)⌜<src # keyword matches across the source that start at the correct index
    kwi←/∨´kwm               # Indices of keywords
    kwd←kwi⊸⊏+´kwm×¨≠¨kws    # Length of each keyword
    kwt←kwi⊸⊏+´kwm×¨1+↕≠kws  # Type of each keyword
    mi←f⊐kwi                 # Matching token indices for keywords (only first index match)
    md←(kwd=mi⊏d)            # If the keyword fully matches (length included)
    mi md⊸/↩                 # Fully matching token indices for keywords
    tt 'k'¨⌾(mi⊸⊏)↩          # Update token type to 'k'
    d (md/kwt)⌾(mi⊸⊏)↩       # Update data to keyword type

    tt‿f‿d
}

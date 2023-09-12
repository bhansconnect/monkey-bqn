⟨Lex⟩←•Import "compiler.bqn"

src←•Fchars⊑•args
i←•Parsefloat 1⊑⎊"1"•args
•Show {𝕩+≠⊑Lex src}⍟i 0

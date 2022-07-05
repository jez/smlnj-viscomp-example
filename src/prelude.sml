(*
 * This structure is for things which I could conceivably want to 'open' in
 * every SML project I ever make.
 *
 * See also: src/util.sml
 *)
structure Prelude =
struct
  fun println str = print (str ^ "\n")

  fun eprint str =
    (TextIO.output (TextIO.stdErr, str);
     TextIO.flushOut TextIO.stdErr)

  fun eprintln str = eprint (str ^ "\n")

  infixr 0 $
  fun f $ x = f x

  exception Undefined
end

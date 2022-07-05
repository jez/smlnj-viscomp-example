structure Main : MAIN =
struct
  fun main (arg0, argv) =
    let
      (**
       * The SOURCE_MAP signature does not expose a function like
       *
       *     val fromSourceloc : sourceloc -> option charpos
       *
       * which makes it tricky to work with line/col pairings from the user.
       * We could build our own in a number of ways. One way might be to just
       * read the file ourselves.
       *
       * Another way might be to binary search for the charpos with the matching
       * sourceloc. Start at the midpoint of [0, SourceMap.lastLinePos m) and
       * call SourceMap.filepos on each valid charpos until you find one
       * that matches the line/col provided by the user.
       *)
      val {filename, charpos} = Options.parseArgs argv
      val (source, dec, statenv) = ViscompExample.parseAndElab filename
    in
      OS.Process.success
    end
end

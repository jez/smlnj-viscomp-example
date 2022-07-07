structure Main : MAIN =
struct
  fun ppFirstResult (staticEnv, source) ppstrm (first, depth) =
    ( Query.Result.ppResult (staticEnv, source) ppstrm (first, depth)
    ; PrettyPrint.newline ppstrm
    )

  fun ppQueryResults (staticEnv, source) results =
    let
      val depth = !Control.Print.printDepth

      fun printRest ppstrm result =
        ( PrettyPrint.newline
        ; Query.Result.ppResult (staticEnv, source) ppstrm (result, depth)
        ; PrettyPrint.newline ppstrm
        )

      fun printAll ppstrm =
        case results
          of first::rest =>
               ( ppFirstResult (staticEnv, source) ppstrm (first, depth)
               ; List.app (printRest ppstrm) rest
               )
           | [] => ()
    in
      PrettyPrint.with_default_pp printAll
    end

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
      val {fileName, charPos} = Options.parseArgs argv
      val (source, dec, statenv) = ViscompExample.parseAndElab fileName
      val results = Query.atPos dec charPos

      (* First result is the most specific, remaining results get further up
       * into the surrounding context. *)
      val first =
        case results
          of result::_ => result
           | [] => raise Fail "Failed to find any results at charpos"

      val depth = !Control.Print.printDepth

      val _ =
        PrettyPrint.with_default_pp
          (fn ppstrm =>
            ( PrettyPrint.string ppstrm "First query result:"
            ; PrettyPrint.newline ppstrm
            ; ppFirstResult (statenv, SOME source) ppstrm (first, depth)
            ; PrettyPrint.newline ppstrm
            ; PrettyPrint.string ppstrm "Type:"
            ; PrettyPrint.newline ppstrm
            ; Query.Result.ppResultType (statenv, source) ppstrm (first, depth)
            ; PrettyPrint.newline ppstrm
            )
          )
    in
      OS.Process.success
    end
end

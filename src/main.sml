structure Main : MAIN =
struct
  fun main (arg0, argv) =
    let
      val {filename, line, col} = Options.parseArgs argv
      val (source, dec, statenv) = ViscompExample.parseAndElab filename
    in
      OS.Process.success
    end
end

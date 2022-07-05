structure Options =
struct
  local
    open Prelude
  in

  fun description () =
    "Shows the type of the expression variable at the location"

  fun usage () = String.concatWith "\n"
    [ "Usage:"
    , "  "^(CommandLine.name ())^" [options] <filename> <line> <col>"
    , ""
    , "Arguments:"
    , "  <filename>      The single SML file to run on."
    , "  <line>          The line number the variable is on."
    , "  <col>           Any column number the variable spans on that line."
    , ""
    , "Options:"
    , "  -h, --help      Show this usage message."
    , ""
    , "Example:"
    , "  "^(CommandLine.name ())^" foo.sml 12 6"
    ]

  fun help () =
    ( println (description ())
    ; println (usage ())
    ; OS.Process.exit OS.Process.success)


  fun failWithUsage msg =
    ( eprintln msg
    ; eprintln ""
    ; eprintln (usage ())
    ; OS.Process.exit OS.Process.failure
    )

  type options =
    { filename: string
    , line: int
    , col: int
    }

  fun parseInt argName arg =
    case Int.fromString arg
      of SOME x => x
       | _ => failWithUsage ("Failed to convert "^argName^" to int. Got: "^arg)

  fun parseArgs argv : options =
    case argv
      of [] => failWithUsage "Missing required <filename> argument."
       | "-h"::_ => help ()
       | "--help"::_ => help ()
       | [filename] => failWithUsage "Missing required <line> argument."
       | [filename, line] => failWithUsage "Missing required <col> argument."
       | [filename, line, col] =>
           { filename=filename
           , line=parseInt "line" line
           , col=parseInt "col" col
           }
       | arg0::_ => failWithUsage "Too many arguments"

  end
end

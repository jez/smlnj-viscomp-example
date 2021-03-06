structure ViscompExample =
struct
  local
    open Prelude
  in

  fun parseAndElab fileName =
    let
      val fileStr = TextIO.openIn fileName
      val source = Source.newSource
        (fileName, fileStr, false, ErrorMsg.defaultConsumer ())
      val cinfo =
        CompInfo.mkCompInfo
          { mkStampGenerator = Stamps.newGenerator
          , source = source
          , transform = fn x => x
          }

      val ast = SmlFile.parse source

      (**
       * This is wrong, as it doesn't even have the pervasives like print in
       * scope. I'm not sure how to get that working.
       *)
      val {get=getLocEnv, set=_} = (EnvRef.loc ())
      val {get=getBaseEnv, set=_} = (EnvRef.base ())

      val {static=statenv, dynamic=NOTUSED, symbolic=symenv} =
        Environment.layerEnv (getLocEnv (), getBaseEnv ())

      val (absyn, newStatenv) = ElabTop.elabTop (ast, statenv, cinfo)
    in
      if CompInfo.anyErrors cinfo
      then (source, Absyn.SEQdec nil, StaticEnv.empty)
      else (source, absyn, newStatenv)
    end

  fun ppdec (source, dec, staticEnv) =
    let
      val depth = 1000
    in
      PrettyPrint.with_default_pp
        (fn ppstrm =>
          PPAbsyn.ppDec (staticEnv, SOME source) ppstrm (dec, depth)
        )
    end

  fun pptype (typ, staticEnv) =
    let
      val depth = 1000
    in
      PrettyPrint.with_default_pp
        (fn ppstrm =>
          (PPType.ppType staticEnv ppstrm typ;
           PrettyPrint.newline ppstrm)
        )
    end

  fun fileRegionForDec (source : Source.inputSource) dec =
    case dec
      of Absyn.MARKdec (_, region) =>
           SourceMap.fileregion (#sourceMap source) region
       | _ => raise Fail "the dec you passed isn't wrapped in a MARKdec"

  end
end

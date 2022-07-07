structure Query =
struct
  local
    structure V = VarCon
    structure A = Absyn

    (* https://smlnj-gforge.cs.uchicago.edu/scm/viewvc.php/sml/releases/release-110.99.2/base/compiler/ElabData/syntax/absyn.sig?view=markup&root=smlnj *)

    (* TODO(jez) Rename to queryAtCharpos* *)
    (* TODO(jez) Make helpers that pass `[]` for acc *)

  in
    structure Result =
    struct
      datatype t
        = Exp of Absyn.exp
        | Pat of Absyn.pat
        | Dec of Absyn.dec
        | Strexp of Absyn.strexp
        | Fctexp of Absyn.fctexp

      fun ppResult (staticEnv, source) ppstrm (result, depth) =
        case result
          of Exp e =>
               PPAbsyn.ppExp (staticEnv, source) ppstrm (e, depth)
           | Pat p =>
               PPAbsyn.ppPat staticEnv ppstrm (p, depth)
           | Dec d =>
               PPAbsyn.ppDec (staticEnv, source) ppstrm (d, depth)
           | Strexp sexp =>
               PPAbsyn.ppStrexp (staticEnv, source) ppstrm (sexp, depth)
           | Fctexp fexp =>
               (* PPAbsyn.ppFctexp is not exposed by PPABSYN for some reason *)
               PrettyPrint.string ppstrm "<fctexp unimplemented>"
               (* PPAbsyn.ppFctexp (staticEnv, source) ppstrm (fexp, depth) *)

      fun ppVarType staticEnv ppstrm var =
        case var
          of VarCon.VALvar {typ, ...} => PPType.ppType staticEnv ppstrm (!typ)
           | VarCon.OVLDvar _ => raise Fail "unimplemented"
           | VarCon.ERRORvar => raise Fail "unimplemented"

      (* TODO(jez) Might not actually need all these args *)
      fun ppExpResultType (staticEnv, source) ppstrm (e, depth) =
        case e
          of A.VARexp (ref var, _) => ppVarType staticEnv ppstrm var
           | A.CONexp _ => raise Fail "unimplemented"
           | A.NUMexp _ => raise Fail "unimplemented"
           | A.REALexp _ => raise Fail "unimplemented"
           | A.STRINGexp _ => raise Fail "unimplemented"
           | A.CHARexp _ => raise Fail "unimplemented"
           | A.RECORDexp fields => raise Fail "unimplemented"
           | A.SELECTexp (idx, e') => raise Fail "unimplemented"
           | A.VECTORexp (elems, ty) => raise Fail "unimplemented"
           | A.APPexp (f, x) => raise Fail "unimplemented"
           | A.HANDLEexp (e', (rules, ty)) => raise Fail "unimplemented"
           | A.RAISEexp (e', ty) => raise Fail "unimplemented"
           | A.CASEexp (e', rules, _) => raise Fail "unimplemented"
           | A.IFexp {test, thenCase, elseCase} => raise Fail "unimplemented"
           | A.ANDALSOexp (left, right) => raise Fail "unimplemented"
           | A.ORELSEexp (left, right) => raise Fail "unimplemented"
           | A.WHILEexp {test, expr} => raise Fail "unimplemented"
           | A.FNexp (rules, ty) => raise Fail "unimplemented"
           | A.LETexp (dec, e') => raise Fail "unimplemented"
           | A.SEQexp exps => raise Fail "unimplemented"
           | A.CONSTRAINTexp (e', ty) => raise Fail "unimplemented"
           | A.MARKexp (e', region) => raise Fail "unimplemented"

      (* TODO(jez) Might not actually need all these args *)
      and ppPatResultType (staticEnv, source) ppstrm (p, depth) =
        case p
          of A.WILDpat => raise Fail "unimplemented"
           | A.VARpat var => ppVarType staticEnv ppstrm var
           | A.NUMpat _ => raise Fail "unimplemented"
           | A.STRINGpat _ => raise Fail "unimplemented"
           | A.CHARpat _ => raise Fail "unimplemented"
           | A.CONpat _ => raise Fail "unimplemented"
           | A.RECORDpat {fields, flex, typ} => raise Fail "unimplemented"
           | A.APPpat (_, _, p') => raise Fail "unimplemented"
           | A.CONSTRAINTpat (p', _) => raise Fail "unimplemented"
           | A.LAYEREDpat (v, p') => raise Fail "unimplemented"
           | A.ORpat (l, r) => raise Fail "unimplemented"
           | A.VECTORpat (ps, _) => raise Fail "unimplemented"
           | A.NOpat => raise Fail "unimplemented"
           | A.MARKpat (p', region) => raise Fail "unimplemented"

      (* TODO(jez) Might not actually need all these args *)
      and ppDecResultType (staticEnv, source) ppstrm (d, depth) =
        case d
          of A.VALdec [A.VB {pat, exp, ...}] =>
               (* Presumably, the exp would have been marked, so we can assume
                * that we only need to print the type of the pat here. *)
               ppPatResultType (staticEnv, source) ppstrm (pat, depth)
           | A.VALdec [] => raise Fail "unexpected empty Absyn.VALdec"
           | A.VALdec _ => raise Fail "unimplemented Absyn.VALdec with len > 1"
           | A.VALRECdec rvbs => raise Fail "unimplemented"
           | A.DOdec e => raise Fail "unimplemented"
           | A.TYPEdec _ => raise Fail "unimplemented"
           | A.DATATYPEdec _ => raise Fail "unimplemented"
           | A.ABSTYPEdec{body, ...} => raise Fail "unimplemented"
           | A.EXCEPTIONdec ebs => raise Fail "unimplemented"
           | A.STRdec strbs => raise Fail "unimplemented"
           | A.FCTdec fctbs => raise Fail "unimplemented"
           | A.SIGdec _ => raise Fail "unimplemented"
           | A.FSIGdec _ => raise Fail "unimplemented"
           | A.OPENdec _ => raise Fail "unimplemented"
           | A.LOCALdec(d1, d2) => raise Fail "unimplemented"
           | A.SEQdec ds => raise Fail "unimplemented"
           | A.OVLDdec _ => raise Fail "unimplemented"
           | A.FIXdec _ => raise Fail "unimplemented"
           | A.MARKdec (d', region) => raise Fail "unimplemented"

      fun ppResultType (staticEnv, source) ppstrm (result, depth) =
        case result
          of Exp e => ppExpResultType (staticEnv, source) ppstrm (e, depth)
           | Pat p => ppPatResultType (staticEnv, source) ppstrm (p, depth)
           | Dec d => ppDecResultType (staticEnv, source) ppstrm (d, depth)
           | Strexp sexp => raise Fail "unimplemented"
           | Fctexp fexp => raise Fail "unimplemented"
    end

    fun charPosInRegion charPos (lo, hi) =
      lo <= charPos andalso charPos < hi

    fun maybeAddResult constructor charPos enclosingRegion current acc =
      case enclosingRegion
        of NONE => acc
         | SOME region =>
             if charPosInRegion charPos region
             then (constructor current)::acc
             else acc

    fun queryExp charPos enclosingRegion (e, acc) =
      let
        val acc = maybeAddResult Result.Exp charPos enclosingRegion e acc
        val recurse = queryExp charPos NONE
      in
        case e
          of A.MARKexp (e', region) => queryExp charPos (SOME region) (e', acc)
           | A.VARexp _ => acc
           | A.CONexp _ => acc
           | A.NUMexp _ => acc
           | A.REALexp _ => acc
           | A.STRINGexp _ => acc
           | A.CHARexp _ => acc
           | A.RECORDexp fields => List.foldl recurse acc (List.map #2 fields)
           | A.SELECTexp (idx, e') => recurse (e', acc)
           | A.VECTORexp (elems, ty) => List.foldl recurse acc elems
           | A.APPexp (f, x) => recurse (x, recurse (f, acc))
           | A.HANDLEexp (e', (rules, ty)) =>
               let
                 val acc = recurse (e', acc)
               in
                 List.foldl (queryRule charPos) acc rules
               end
           | A.RAISEexp (e', ty) => recurse (e', acc)
           | A.CASEexp (e', rules, _) =>
               let
                 val acc = recurse (e', acc)
               in
                 List.foldl (queryRule charPos) acc rules
               end
           | A.IFexp {test, thenCase, elseCase} =>
               let
                 val acc = recurse (test, acc)
                 val acc = recurse (thenCase, acc)
               in
                 recurse (elseCase, acc)
               end
           | A.ANDALSOexp (left, right) =>
               let
                 val acc = recurse (left, acc)
               in
                 recurse (right, acc)
               end
           | A.ORELSEexp (left, right) =>
               let
                 val acc = recurse (left, acc)
               in
                 recurse (right, acc)
               end
           | A.WHILEexp {test, expr} =>
               let
                 val acc = recurse (test, acc)
               in
                 recurse (expr, acc)
               end
           | A.FNexp (rules, ty) =>
               List.foldl (queryRule charPos) acc rules
           | A.LETexp (dec, e') =>
               let
                 val acc = queryDec charPos NONE (dec, acc)
               in
                 recurse (e', acc)
               end
           | A.SEQexp exps => List.foldl recurse acc exps
           | A.CONSTRAINTexp (e', ty) => recurse (e', acc)
      end

    and queryRule charPos (A.RULE (p, e), acc) =
      let
        val acc = queryPat charPos NONE (p, acc)
      in
        queryExp charPos NONE (e, acc)
      end

    and queryPat charPos enclosingRegion (p, acc) =
      let
        val acc = maybeAddResult Result.Pat charPos enclosingRegion p acc
        val recurse = queryPat charPos NONE
      in
        case p
          of A.MARKpat (p', region) => queryPat charPos (SOME region) (p', acc)
           | A.WILDpat => acc
           | A.VARpat _ => acc
           | A.NUMpat _ => acc
           | A.STRINGpat _ => acc
           | A.CHARpat _ => acc
           | A.CONpat _ => acc
           | A.RECORDpat {fields, flex, typ} =>
               List.foldl recurse acc (List.map #2 fields)
           | A.APPpat (_, _, p') => recurse (p', acc)
           | A.CONSTRAINTpat (p', _) => recurse (p', acc)
           | A.LAYEREDpat (v, p') => recurse (p', recurse (v, acc))
           | A.ORpat (l, r) => recurse (r, recurse (l, acc))
           | A.VECTORpat (ps, _) => List.foldl recurse acc ps
           | A.NOpat => acc
      end

    and queryDec charPos enclosingRegion (d, acc) =
      let
        val acc = maybeAddResult Result.Dec charPos enclosingRegion d acc
        val recurse = queryDec charPos NONE
      in
        case d
          of A.MARKdec (d', region) => queryDec charPos (SOME region) (d', acc)
           | A.VALdec vbs => List.foldl (queryVb charPos) acc vbs
           | A.VALRECdec rvbs => List.foldl (queryRvb charPos) acc rvbs
           | A.DOdec e => queryExp charPos NONE (e, acc)
           | A.TYPEdec _ => acc
           | A.DATATYPEdec _ => acc
           | A.ABSTYPEdec{body, ...} => recurse (body, acc)
           | A.EXCEPTIONdec ebs => List.foldl (queryEb charPos) acc ebs
           | A.STRdec strbs => List.foldl (queryStrb charPos) acc strbs
           | A.FCTdec fctbs => List.foldl (queryFctb charPos) acc fctbs
           | A.SIGdec _ => acc
           | A.FSIGdec _ => acc
           | A.OPENdec _ => acc
           | A.LOCALdec(d1, d2) => recurse (d2, recurse (d1, acc))
           | A.SEQdec ds => List.foldl recurse acc ds
           | A.OVLDdec _ => acc
           | A.FIXdec _ => acc
      end

    and queryStrExp charPos enclosingRegion (sexp, acc) =
      let
        val acc = maybeAddResult Result.Strexp charPos enclosingRegion sexp acc
        val recurse = queryStrExp charPos NONE
      in
        case sexp
          of A.MARKstr (sexp', region) =>
               queryStrExp charPos (SOME region) (sexp', acc)
           | A.VARstr _ => acc
           | A.STRstr _ => acc
           | A.APPstr _ => acc
           | A.LETstr (dec, sexp') =>
               let
                 val acc = queryDec charPos NONE (dec, acc)
               in
                 recurse (sexp', acc)
               end
      end

    and queryFctExp charPos enclosingRegion (fexp, acc) =
      let
        val acc = maybeAddResult Result.Fctexp charPos enclosingRegion fexp acc
        val recurse = queryFctExp charPos NONE
      in
        case fexp
          of A.MARKfct(fexp', region) =>
               queryFctExp charPos (SOME region) (fexp', acc)
           | A.VARfct _ => acc
           | A.FCTfct{def, ...} => queryStrExp charPos NONE (def, acc)
           | A.LETfct(dec, fexp') =>
               let
                 val acc = queryDec charPos NONE (dec, acc)
               in
                 recurse (fexp', acc)
               end
      end

    and queryVb charPos (A.VB {pat, exp, ...}, acc) =
      let
        val acc = queryPat charPos NONE (pat, acc)
      in
        queryExp charPos NONE (exp, acc)
      end

    and queryRvb charPos (A.RVB {exp, ...}, acc) =
      queryExp charPos NONE (exp, acc)

    and queryEb charPos (eb, acc) =
      case eb
        of A.EBgen {ident, ...} => queryExp charPos NONE (ident, acc)
         | A.EBdef _ => acc

    and queryStrb charPos (A.STRB {def, ...}, acc) =
      queryStrExp charPos NONE (def, acc)

    and queryFctb charPos (A.FCTB {def, ...}, acc) =
      queryFctExp charPos NONE (def, acc)

    fun atPos dec charPos =
      queryDec charPos NONE (dec, [])

  end
end

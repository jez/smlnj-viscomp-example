structure VarAtPos =
struct
  local
    structure V = VarCon
    structure A = Absyn

    (* https://smlnj-gforge.cs.uchicago.edu/scm/viewvc.php/sml/releases/release-110.99.2/base/compiler/ElabData/syntax/absyn.sig?view=markup&root=smlnj *)

  in
    fun chkExp e acc =
      case e
        of A.VARexp _ => acc
         | A.CONexp _ => acc
         | A.NUMexp _ => acc
         | A.REALexp _ => acc
         | A.STRINGexp _ => acc
         | A.CHARexp _ => acc
         | A.RECORDexp _ => acc
         | A.SELECTexp _ => acc
         | A.VECTORexp _ => acc
         | A.APPexp _ => acc
         | A.HANDLEexp _ => acc
         | A.RAISEexp _ => acc
         | A.CASEexp _ => acc
         | A.IFexp _ => acc
         | A.ANDALSOexp _ => acc
         | A.ORELSEexp _ => acc
         | A.WHILEexp{test, expr} => acc
         | A.FNexp _ => acc
         | A.LETexp _ => acc
         | A.SEQexp es => acc
         | A.CONSTRAINTexp _ => acc
         | A.MARKexp _ => acc

    and chkPat top =
      let
        fun chk (region, p, acc) =
          case p
            of A.WILDpat => acc
             | A.VARpat x => acc
             | A.NUMpat _ => acc
             | A.STRINGpat x => acc
             | A.CHARpat x => acc
             | A.CONpat x => acc
             | A.RECORDpat{fields, ...} => acc
             | A.APPpat(_, _, p) => acc
             | A.CONSTRAINTpat(p, _) => acc
             | A.LAYEREDpat(p1, p2) => acc
             | A.ORpat(p, _) => acc
             | A.VECTORpat(ps, _) => acc
             | A.MARKpat(p, region) => acc
             | A.NOpat => acc
      in
        chk
      end

    and chkDec (region, top, d, acc) =
      case d
        of A.VALdec vbs => acc
         | A.VALRECdec rvbs => acc
         | A.DOdec e => acc
         | A.TYPEdec _ => acc
         | A.DATATYPEdec _ => acc
         | A.ABSTYPEdec{body, ...} => acc
         | A.EXCEPTIONdec _ => acc
         | A.STRdec strbs => acc
         | A.FCTdec fctbs => acc
         | A.SIGdec _ => acc
         | A.FSIGdec _ => acc
         | A.OPENdec _ => acc
         | A.LOCALdec(d1, d2) => acc
         | A.SEQdec ds => acc
         | A.OVLDdec _ => acc
         | A.FIXdec _ => acc
         | A.MARKdec(d, region) => acc

    and chkStrExp (region, sexp, acc) =
      case sexp
        of A.VARstr _ => acc
         | A.STRstr _ => acc
         | A.APPstr _ => acc
         | A.LETstr(dec, sexp) => acc
         | A.MARKstr(sexp, region) => acc

    and chkFctExp (region, fexp, acc) =
      case fexp
        of A.VARfct _ => acc
         | A.FCTfct{def, ...} => acc
         | A.LETfct(dec, fexp) => acc
         | A.MARKfct(fexp, region) => acc

  end
end

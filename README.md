# smlnj-viscomp-example

An example of how to use [SML/NJ]'s woefully under-documented [Visible Compiler]
to build something that could possibly be used to build a language server.

It's not finished and I have no plans to do so. Instead, it's meant to hint at
an implementation or architecture that might interest you, as well as showcase
APIs that (as of SML/NJ v110.99.2) were known to compile. As in: it mostly just
serves to jog my memory of what *can* be done, not be an example of how best to
use these APIs.

## Demo

If you have SML/NJ v110.99.2 installed, you can run this to build the project,
(using my [symbol] build tool, which is just a shell script + Makefile that's
checked into the repo):

```
❯ ./symbol make
[ .. ] Analyzing CM dependencies...
[ .. ] Building heap image with SML/NJ...
[ .. ] Building 'smlnj-viscomp-example' into '.symbol-work/bin'...
[ OK ] .symbol-work/bin/smlnj-viscomp-example
```

Once that's done, here are some ways you can interact with it from the command
line:

```
❯ .symbol-work/bin/smlnj-viscomp-example --help
Shows the type of the expression variable at the location
Usage:
  .symbol-work/bin/smlnj-viscomp-example [options] <filename> <charpos>

Arguments:
  <filename>      The single SML file to run on.
  <charpos>       The 1-based character offset in the file to query.

Options:
  -h, --help      Show this usage message.

Example:
  .symbol-work/bin/smlnj-viscomp-example foo.sml 12
```

```
❯ cat example.sml
fun fakePrint msg = ()
val greeting = "Hello, world!"
val _ = fakePrint greeting

❯ .symbol-work/bin/smlnj-viscomp-example example.sml 30
First query result:
val greeting = "Hello, world!"

Type:
?.string

❯ .symbol-work/bin/smlnj-viscomp-example example.sml 66
First query result:
fakePrint

Type:
'a -> ?.unit
```

## Explanation

The SML/NJ wraps certain AST nodes in `MARK...` nodes, like `MARKdec`,
`MARKexp`, etc. These nodes contain the nested AST node and also a `region`,
which is a begin and end offset corresponding to locations in the source buffer.

Given a character offset, we can walk the AST that SML/NJ produces and
accumulate a list of matching AST nodes where the cursor position lies within
the containing region. If we combine this with a pre-order traversal of the
tree and push results onto the front of a list as we go, the resulting list will
be ordered from most specific results to least specific results, so we can take
the head of the list and find the type of it.

The traversal is implemented (`Query.atPos`) but getting the type of an
arbitrary result is mostly not, except for the case of a variable in a `val`
binding, as a proof of concept.

The idea would be that these two APIs (location-based queries and query results
wrapping typed AST nodes) could be used to power IDE features like "show me the
type" or "go to definition"

## Gotchas / future work

- This only works for a single file. To do multiple files, it would require
  figuring out the APIs to use the Compilation Manager (CM) structures to load
  and type check a file in the context of a number of files and libraries.

- It currently prints out `?.` in front of all the types...

  Honestly, I think this has to do with the next gotcha, which is:

- It doesn't even typecheck a file in the context of the pervasive/basis
  library. Again, it's likely that integrating with CM would fix this?

The APIs **should** all be there, it's just not documented. When I was looking
into this last, I basically grepped for `elabTop` in the SML/NJ sources, found
one result in `base/compiler/TopLevel/main/compile.sml`, and was in the process
of working my way out from there to see how it sets up the environment that gets
fed into `elabTop`. Presumably all we have to do is mimic enough of that code
that it would work (or maybe there's an even higher level API we could call that
both takes care of setting up the right environment and gives us back an `Absyn`
typed AST).

## Understanding the Visible Compiler APIs

The online docs for the SML/NJ Visible Compiler APIs are terrible.

You're going to have much better luck searching through and reading the SML/NJ
source. It's important that you look at the source for the right version,
because these APIs tend to break in minor ways from version to version.

Some ways to get the sources for the version relevant to you:

-   If you know how to use SVN (or want to learn):

    ```
    svn checkout --username anonsvn --password anonsvn https://smlnj-gforge.cs.uchicago.edu/svn/smlnj/
    ```

    and then figure out how to checkout the version you're using

-   Otherwise, use the "install from source" instructions on the release page for
    your version of SML/NJ, for example:

    <https://www.smlnj.org/dist/working/110.99.2/index.html>

    And be sure to follow the suggestion to edit `config/targets` so that you
    uncomment whatever is required to get the compiler source code downloaded
    too. For 110.99.2, this amounted to ensuring that this directive was
    uncommented in the `config/targets` file:

    ```
    # unpack the source code for everything (including for the SML/NJ compiler
    # itself); this is not required,  unless you are doing compiler hacking,
    # but it may be interesting to look at.
    #
    request src-smlnj
    ```

-   If you're really lazy, you can probably get by with using the SVN web viewer

    <https://smlnj-gforge.cs.uchicago.edu/scm/viewvc.php/?root=smlnj>

    but it takes some getting used to, and you're very quickly want to be able
    to start grepping, so you probably only want to use this in a pinch.

Once you've got the sources, the `base/compiler` folder is the one where all the
good stuff is. If you chose an SVN option above (instead of downloading just the
sources for the given version), you'll have to make sure that you're in the
right `base/compiler` folder. For 110.99.2, that folder is
`/sml/releases/release-110.99.2/base/compiler`.

Once you have the SML/NJ sources, you should be able to work from the
dependencies in this example project's CM file to the relevant files in your
SML/NJ checkout to begin browsing what APIs are available to you.


[SML/NJ]: <https://www.smlnj.org/>
[Visible Compiler]: <https://www.smlnj.org/doc/Compiler/pages/compiler.html>
[symbol]: https://github.com/jez/symbol

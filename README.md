# smlnj-viscomp-example

An example of how to use [SML/NJ]'s woefully under-documented [Visible Compiler]
to build something that could possibly be used to build a language server.

- TODO(jez) Document how to build and run
  - TODO(jez) Make note in the docs that you're using v110.99.2 and that things
    do break when upgrading.

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

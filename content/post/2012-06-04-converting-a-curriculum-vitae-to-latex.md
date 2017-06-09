---
title: Converting a Curriculum Vitae to LaTeX
author: Matthew Sigal
date: '2012-06-04'
slug: converting-a-curriculum-vitae-to-latex
categories:
  - Productivity
tags:
  - LaTeX
  - BibDesk
---

A friend of mine recently goaded me a bit about knowing LaTeX but having my curriculum vitae in Word. This got me thinking: how hard would it be to convert? What would be the benefits? This post goes into some detail about the advantages of switching to LaTeX and some practical advice about a few useful commands and packages to make use of when doing so.

First of all, having your CV in LaTeX demonstrates knowledge of a language that others might not have. I believe that TeX typesetting can be fairly easily differentiated from other programs, and showing this knowledge - especially if the CV is being distributed as part of a job search - can definitely make you a more appealing candidate.

Secondly, it is pretty nice not have to worry about references anymore. Just like how we can add references from our database to any paper we are working on, once a paper or conference lecture or any other type of event that you want to add to your CV is in your bibliography file, you can simply cite it anywhere afterward - including your new CV.

In any case, I decided to make the switch and I'm glad I did. See [this page](http://www.matthewsigal.com/SigalCV_2017.pdf) for an example of what you are going to be working toward. The transition took me a few hours, but mainly that was due to a few bumps in the road, which I'll document below to save you the trouble!

1) Choosing a style. Every document produced in TeX uses some sort of style template - whether it is fairly generic (e.g. `\documentclass[]{article}`) or tailored to particular needs (like `\documentclass[doc]{apa6}`, which formats your document to match the APA style guidelines). A quick search on Google will reveal that there are quite a few pre-made selections for producing a curriculum vitae (such as here), however not all of them will be fully integrated with your referencing system.

For my CV, I ended up using a generic document class, but supplementing it with the currvita package, which defines some nice spacing and list rules tailored for producing CVs. The benefit of doing this is that it is fully integrated with natbib, which I will use here to obtain my BibTeX references*. Plus, currvita is included in a basic installation of LaTeX, so you don't even have to worry about installing it manually.

2) Defining the preamble. My preamble looks a bit intense, but I'll comment about the inclusions I've made.

```
\documentclass[10pt]{article}
\usepackage[NoDate,LabelsAligned]{currvita}
\usepackage[american]{babel}
\usepackage{csquotes, natbib, bibentry, anysize, titlesec}
\usepackage[hmargin=1in,vmargin=1in]{geometry}
\titlespacing*{\subsubsection}{10pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}
```

I redefine the spacing of subsubsections because I wanted them to be indented on the CV. I was happy with the formatting of the other section styles.

```
\pagestyle{headings}
\setcounter{page}{1}
```

I wanted page numbers to start at 1 and appear in the upper right corner. 

```
\newcommand{\bibverse}[1]{\begin{verse} \bibentry{#1}. \end{verse}}
```

This is where it gets a little less vanilla. Above, I define a new command `\bibverse`, which creates full in-text citations. This is the primary tool used in referencing anything from your BibTeX library.

```
\newcommand{\squishlist}{
      \begin{list}{$\bullet$}{
           \setlength{\itemsep}{0pt}
           \setlength{\parsep}{3pt}
           \setlength{\topsep}{3pt}
           \setlength{\partopsep}{0pt}
           \setlength{\leftmargin}{1.5em}
           \setlength{\labelwidth}{1em}
           \setlength{\labelsep}{0.5em}}}
\newcommand{\squishend}{
     \end{list}}
```

The above code defines two new functions that define a "squished list" environment, and is used because the regular itemize environment kept breaking the margins of the page. The first function, `\squishlist`, begins a squished list. The second command, `\squishend`, finishes it.

```
\newcommand{\sectionline}{
     \nointerlineskip \vspace{\baselineskip}
     \hspace{\fill}\rule{0.8\linewidth}{.7pt}\hspace{\fill}
     \par\nointerlineskip \vspace{\baselineskip}}
```

This final command defines the horizontal lines that I've placed on the front page of the CV.

3) Body Template. A simple template would be as follows:

```
\begin{document}
  \nobibliography*
```

The \nobibliography command is invoked because we want all the references to appear in full in-text, not printed in the end as per usual conventions.

```
\begin{cv}{}

\begin{cvlist}{Test List}
     \item[2010-present] Test test test\\
\end{cvlist}

\end{cv}

\bibliographystyle{apalike}
\nobibliography{ReferenceDesk}
\end{document}
```

The `\bibliographystyle` command defines how the references will look in the document. The \nobibliography command tells LaTeX where to find your .bib file.

__Further Troubleshooting__. If you have gotten this far, your CV will look almost complete. I was perfectly happy with mine, until I noticed one small detail: publications and presentations from the same year were getting letters placed behind them in an extremely unattractive manner. For instance, I have two conference presentations this summer. The apalike package wanted to format the dates as being (2012, Junea) and (2012, Julyb). While in most publications this is how you would approach multiple citations from a particular year from the same author, for the purposes of a CV it makes less sense (especially for citing presentations where the month is usually indicated). After lots of googling to try and solve the problem, I ended up making a post on the extremely helpful TeX StackExchange last night. By this morning, a contributor already had a beautiful and elegant answer for me.

So, for posterity (and with thanks to Mico) here is how to remove the automatic lettering from `apalike`:

1. Navigate to `/usr/local/texlive/2011/texmf-dist/bibtex/bst/base/` (Note: You will need to turn on "Show Invisible Files" to find this folder! (Either use 
defaults `write com.apple.Finder AppleShowAllFiles YES` in the Terminal, or install TotalFinder for a handy keyboard shortcut).
2. Copy `apalike.bst` to your Desktop.
3. Rename the file to `apalikecv.bst` or something similar.
4. Open the file (e.g. with TextWrangler or TexShop).
5. Find the line that says:` " (" year * extra.label * ")" *` (on mine it was on line 124).
6. Replace that line with: `" (" year * ")" *` (we are getting rid of that pesky `"extra.label"`).
7. Save the file and copy it back to the `/usr/local/texlive/2011/texmf-dist/bibtex/bst/base/` directory (this will require you to supply your administrator account password).
8. In the Terminal, run `sudo texhash` so LaTeX can find your new file.
9. In your CV, replace the `\bibliographystyle{apalike}` line with `\bibliographystyle{apalikecv}` or whatever you named the modified file as.

And there you have it! A complete template/guide for creating a CV in LaTeX. I hope you find it useful!

* Careful readers will note that I'm not using `apacite` here, as I did in my last post. The reason is that `apacite` is not fully integrated with currvita. It is simply easier for my workflow to use `apacite` for all my other documents, as described in my previous post, and `natbib` for my CV.
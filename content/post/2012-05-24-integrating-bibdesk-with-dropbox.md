---
title: Integrating BibDesk with Dropbox.
author: Matthew Sigal
date: '2012-05-24'
slug: integrating-bibdesk-with-dropbox
categories:
  - Productivity
tags:
  - APA style
  - BibDesk
  - Dropbox
  - LaTeX
  - OS X
---

I've implemented a powerful workflow for generating reports in APA style.  It allows for a) all references that I come across to be stored in a central location and easily accessed; b) for this file to be synced and editable across multiple computers;  and, c) auto-applies the stylistic requirements of APA style (proper formatting of headings, references, et cetera).  This is optimized for OS X.  This workflow involves three main components: a reference management system (basically an application that maintains a .bib LaTeX bibliography file), a LaTeX editor with a few packages pertaining to APA style installed, and a synchronization application.  For the last component, a more sophisticated approach might be to use Git, however for simplicity, I will be using Dropbox.  I will assume you already have Dropbox installed (and, as such, the folder `~\Dropbox` exists).

__Reference Management__: I have used a few different applications to deal with references (e.g. Mendeley, Papers, JabRef, and so on).  Each of these applications have their strengths and weaknesses, however I have found that I've fallen in love with one in particular: BibDesk.  I believe BibDesk balances aesthetics with functionality better than the aforementioned applications.  It is easy to use, customizable using scripts (a useful selection of which I will document in a future post), and extremely stable.

The first step is to install BibDesk.  Once installed, create a new .bib file that you will use to store all of your bibliography entries.  The important point is to not save it in your Documents folder, but somewhere in your Dropbox.  For instance, I called mine "ReferenceDesk.bib" and placed it in `~\Dropbox`.  In the settings for BibDesk, I set the application to load ReferenceDesk.bib upon launch (under General), and changed the Cite Key Format to the present `"First Author + : + Year + Sufficient Unique Letters)`.  If you want BibDesk to file your PDFs (e.g. to keep them all in a particular folder, in kind of an iTunes-esque fashion), you can specify how the application does so via the "AutoFile" settings. Once you have created your bibliography database and changed any settings you deem appropriate, you can start adding references to the database.  Add at least a couple before moving to the next step.

__BibDesk and LaTeX Integration__: So, we have a bibliographic database.  However, unless we create a LaTeX file in the same directory as our database, calling it will be difficult.  A much better solution is to have our `ReferenceDesk.bib` always available to all of our LaTeX documents, no matter where they live on your computer.  To do so, we will create a symbolic link between the folder where our ReferenceDesk.bib exists and the bibtex folder that gets loaded upon launch.

To create this link, open the Terminal and type in:

```
cd /usr/local/texlive/texmf-local/bibtex/bib
sudo ln -s /Users/TumblesPro/Dropbox/RefenceDesk.bib ReferenceDesk.bib
sudo texhash
```

Note: you will have to update the second line to point to where your ReferenceDesk.bib file lives.  Now, your master bibliography file is accessible from LaTeX.

__APA Style__: LaTeX is a fantastic type-setting application that is especially useful for mathematics and other scientific based documents. For working on any TeX file, I currently prefer the LaTeXian editor, although there are many others that could suffice.  It is relatively cheap, has a powerful live preview feature, decent code completion, among other features.  If you wish to write in APA style, it is highly recommended to install the following packages: apa6, and apacite, which pertain to general document style, and reference/bibliography style, respectively. Note: you can check that these are installed either using the TeX Live Utility, or via command line (e.g., in the Terminal type: `kpsewhich apa6.cls` and make sure it returns something similar to `/usr/local/texlive/2011/texmf-dist/tex/latex/apa6/apa6.cls`)

__Working and Citing in APA Style__: So, now all the pieces are in place. The next step is to simply create a new document using your preferred LaTeX editor.  In the preamble you should specify the necessary packages, as well as the information for the title page:

```
\documentclass[man]{apa6}        % Available classes: journal [jou], manuscript [man], or document [doc]
\usepackage[american]{babel}     
\usepackage{csquotes}            % Required for quotation formatting
\usepackage{apacite}             % Required for bibliography formatting
\title{Title Placeholder}
\shorttitle{Running Head Placeholder}
\author{Matthew J. Sigal}
\affiliation{York University}
\abstract{This demonstration paper uses the \textsf{apa6} \LaTeX\ class to format the document in compliance with the $6^{th}$ edition of the American Psychological Association's \textit{Publication Manual.} The references are managed using \textsf{apacite}.  Sections and subsection commands are also demonstrated.}
\keywords{APA style, references}  
```

In the body:

```
\begin{document}
\maketitle
\section{Top Level (Section)}
\subsection{Second Level (Subsection)}
\subsubsection{Third Level (Subsubsection)}
\paragraph{Fourth Level (Paragraph)}
\subparagraph{Fifth Level (Subparagraph)}
\bibliographystyle{apacite}         % This is important if you want the references formatted correctly.
\bibliography{ReferenceDesk}        % Make sure you replace the filename with the one you chose earlier.
\end{document}
```

So there you have it!  For citing in-text, here is a handy chart taken from the apacite manual:

* `\cite<e.g.,>[p.~11]{Jone01,Ross87}` (e.g., Jones, 2001; Ross, 1987, p. 11)
* `\citeA<e.g.,>[p.~11]{Jone01,Ross87}` e.g., Jones (2001); Ross (1987, p. 11)
* `\citeauthor<e.g.,>[p.~11]{Jone01,Ross87}` e.g., Jones; Ross, p. 11
* `\citeyear<e.g.,>[p.~11]{Jone01,Ross87}` (e.g., 2001; 1987, p. 11)
* `\citeyearNP<e.g.,>[p.~11]{Jone01,Ross87}` e.g., 2001; 1987, p. 11
* `\citeNP<e.g.,>[p.~11]{Jone01,Ross87}` e.g., Jones, 2001; Ross, 1987, p. 11
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{problem-set}
\LoadClass{article}

\RequirePackage{amsmath}
\RequirePackage{mathrsfs}
\RequirePackage{amsthm}
\RequirePackage{enumerate}
\RequirePackage{color}
\RequirePackage{graphicx}
\RequirePackage{ifthen}
\RequirePackage{wrapfig}

\newcommand\truefalsepoints{2}

% Multiple choice question
\newcommand{\mcqb}{{\Large$\Circle$\ \ }}
\newcommand{\mcqs}{\solution{\mcqb}{{\Large$\CIRCLE$\ \ }}}

% Multiple option question.
\newcommand{\moqb}{{\Large$\Square$\ \ }}
\newcommand{\moqs}{\solution{\moqb}{{\Large$\blacksquare$\ \ }}}

% space-less multiple option question.
\newcommand{\mosb}{{\Large$\Square$}}
\newcommand{\moss}{\solution{\mosb}{{\Large$\blacksquare$}}}

\newcommand{\hugeMosb}{{\Huge$\square$}}
\newcommand{\hugeMoss}{\solution{\hugeMosb}{{\Huge$\blacksquare$}}}

\newcommand{\usolution}[2]{\underline{\hspace{5ex}\solution{#1}{#2}\hspace{5ex}}}
\newcommand{\dbk}[1]{\hspace{#1 ex}}
\newcommand{\blank}{\dbk{20}}
\newcommand{\blanks}{\dbk{27}}

\newcommand{\assignmentdue}[1]{\def\@assignmentdue{#1}}
\newcommand{\subtitle}[1]{\def\@subtitle{#1}}
\newcommand{\selfgradedue}[1]{\def\@selfgradedue{#1}}

% Self assessment stuff
\RequirePackage{tcolorbox}
\newcommand{\selfassessment}[1]{
\@ifundefined{showSolutions}{%
    \begin{tcolorbox}[size=small,colback=white,coltitle=black,colbacktitle=white,title=\textbf{Self assessment} \footnotesize{
    If correct, write ``\textbf{correct}'' in the box. Otherwise, \textbf{write and explain} the correct answer. 
    }]
    \vspace{#1}
    \end{tcolorbox}
}{%
}
}

\newcommand{\@DeclareGotDocType}[1]{%
  \@ifundefined{@problemSetDocType}{%
    \newcommand{\@problemSetDocType}{#1}%
  }{%
    \ClassError{problem-set}{processing option: #1: document type already declared as \@problemSetDocType}%
  }%
}

\newcommand{\examInstructions}{
  \begin{itemize}
  \item You have approximately 2 hours and 50 minutes.

  \item The exam is closed book, closed notes except your one-page crib sheet.

  \item Please use non-programmable calculators only.

  \item Mark your answers ON THE EXAM ITSELF.  If you are not sure of
    your answer you may wish to provide a {\em brief} explanation.
    All short answer sections can be successfully answered in a few
    sentences AT MOST.

  \end{itemize}
}

\DeclareOption{section}{%
  \@DeclareGotDocType{section}
  \def\@declareHidePoints{}
  \AtBeginDocument{%
    \@ifundefined{showSolutions}{%
      \@MakeTitle[\@subtitle]{\@title}%
    }{%
      \@MakeTitle[\@subtitle]{\@title~Solutions}%
    }
  }%
}

\DeclareOption{written}{%
  \@DeclareGotDocType{written}
  %\def\@declareHidePoints{}
  \AtBeginDocument{%
  \@ifundefined{showSolutions}{%
    \@MakeTitle[\@subtitle]{\@title}%
      \begin{list}{}{}
      \item \textbf{Due:} \@assignmentdue.
      
      \item \textbf{Policy:} Can be solved in groups (acknowledge collaborators) but must be written up individually
      
      \item \textbf{Submission:} Your submission should be a PDF that matches this template. Each page of the PDF should align with the corresponding page of the template (page 1 has name/collaborators, question 1 begins on page 2, etc.). \textbf{Do not reorder, split, combine, or add extra pages.} The intention is that you print out the template, write on the page in pen/pencil, and then scan or take pictures of the pages to make your submission. You may also fill out this template digitally (e.g.\ using a tablet.)
      
      \end{list}
      \vskip .5em
      {\newcommand{\tprompt}[1]{\raisebox{0pt}[2em][1em]{#1}}
        \begin{center}
          \begin{tabular}{|l|l@{\hspace{3.5in}}|}
            \hline
            \tprompt{First name} & \\
            \hline
            \tprompt{Last name} & \\
            \hline
            \tprompt{SID} & \\
            \hline
            \tprompt{Collaborators} & \\
            \hline
          \end{tabular}%
        \end{center}
      }
      \@MakeGradeBox%
      
      \newpage%
    }{%
      \@MakeTitle[\@subtitle]{\@title~Sol.}%
        Solutions for HW 2 (Written)
    }%
  }%
}

\DeclareOption{exam}{%
  \@DeclareGotDocType{exam}
  \AtBeginDocument{%
%Pieter: I commented this if condition out, this way solutions and
%original exam have the same formatting (rather than saving 2 pages on
%the solutions, which seems not that important with electronic handouts)
%    \@ifundefined{showSolutions}{%
      \@MakeTitle{\@title}%
      \examInstructions%
      \vskip .5em
      {\newcommand{\tprompt}[1]{\raisebox{0pt}[2em][1em]{#1}}
        \begin{center}
          \begin{tabular}{|l|l@{\hspace{3.5in}}|}
            \hline
            \tprompt{First name} & \\
            \hline
            \tprompt{Last name} & \\
            \hline
            \tprompt{SID} & \\
           \hline
        %    \tprompt{edX username} & \\
           %\hline
            %\hline
            %\hline
            %\tprompt{First and last name of student to your left} &\\
           %\hline
            %\tprompt{First and last name of student to your right} &\\
           %\hline
          \end{tabular}%
        \end{center}
     }
      \@MakeGradeBox%

      \newpage%
%    }{%
%      \@MakeTitle[Solutions]{\@title}%
%    }%
  }%
}

\AtEndDocument{
  \@definelabel{NumProblems}{\thesection}
  \@definelabel{TotalPoints}{\arabic{TotalPoints}}
}

\ProcessOptions

\@ifundefined{@problemSetDocType}{%
  \ClassError{problem-set}{document type (section, written, or exam) must be specified}{}%
}


\newcommand{\@singleOrPlural}[3]{\ifthenelse{\equal{#1}{1}}{#1~#2}{#1~#3}}
\newcommand{\@definelabel}[2]{%
\@bsphack
\protected@write\@auxout{}%
       {\string\newlabel{#1}{{#2}{\thepage}}}%
\@esphack%
}

\@ifundefined{@declareHidePoints}{%
  \newcommand{\@showPts}[1]{[\@singleOrPlural{#1}{pt}{pts}]~}%
}{%
  \newcommand{\@showPts}[1]{}%
}%

\newcounter{TotalPoints}
\newcounter{ProblemPoints}[section]
\newcounter{QuestionPoints}[subsection]
\newcounter{SubQuestionPoints}[subsubsection]

\font\dunhd=cmdunh10 scaled \magstep5
\font\dunhc=cmdunh10 scaled \magstep4
\font\dunhb=cmdunh10 scaled \magstep3
\font\dunha=cmdunh10 scaled \magstep2

\newcommand{\@MakeStudentInfo}{%

}

\newcommand{\@MakeGradeBox}{%
  \begin{center}%
    \xdef\graderows{}%
    \@ifundefined{r@NumProblems}{}%
    {%
      \newcounter{qnumber}%
      {\loop%
        \ifnum\theqnumber<\ref{NumProblems}%
        \addtocounter{qnumber}{1}%
        \xdef\graderows{%
          \graderows%
           Q\arabic{qnumber}.&\ref{ProblemName:\theqnumber}&~~~/\ref{ProblemPoints:\theqnumber}\cr %
          \noalign{\hrule}%
        }%
        \repeat}%
    }%
    \vfill
{\bf For staff use only:}\\
    %\begin{large}
      \begin{tabular}{|ll|l|}
        \hline
        \graderows
        & Total &~~~/\ref{TotalPoints}\\
        \hline
      \end{tabular}%
    %\end{large}%
  \end{center}%
}

\newcommand{\@MakeTitle}[2][]{%
  \hrule height6pt \vspace{-0.5em}%
  \noindent%
  \parbox[b]{0.22\textwidth}{
    {\dunhb \coursenumber}\\%
    {\dunhb \coursesemester}}%
  \parbox[b]{0.35\textwidth}{%
    \raggedright
    {\dunhb \coursename}}%
  \hfill%
  \begin{tabular}[b]{l}
    \ifthenelse{\equal{#1}{}}{%
      {\dunhd #2}%
    }{%
      {\dunhb #2}\\%
      {\dunhb #1}%
    }
  \end{tabular}%
  \vskip 0.6em
  \hrule height6pt
  \par
  \vskip .5em
}

\newenvironment{problem}[2][]%
{%
  \addtocounter{section}{1}%
  \ifthenelse{\equal{\arabic{section}}{1}}{}{\newpage}%
  \setcounter{subsection}{0}%
  \setcounter{ProblemPoints}{0}%
  \begin{huge}%
    \noindent Q\arabic{section}.~\@showPts{\ref{ProblemPoints:\thesection}}#2%
  \end{huge}%
  \par
  \@definelabel{ProblemName:\thesection}{#2}%
  \def\@atproblemend {%
    \ifthenelse{\equal{#1}{}}{%
      \@definelabel{ProblemPoints:\thesection}{\theProblemPoints}%
      \addtocounter{TotalPoints}{\theProblemPoints}
    }{%
      \@definelabel{ProblemPoints:\thesection}{#1}%
      \addtocounter{TotalPoints}{#1}
    }%
  }%
}%
{%
  \@atproblemend%
}%

\newenvironment{question}[1][]%
{%
  \addtocounter{subsection}{1}%
  \setcounter{subsubsection}{0}%
  \setcounter{QuestionPoints}{0}%
  \def\@atquestionend {%
    \ifthenelse{\equal{#1}{}}{%
      \@definelabel{QuestionPoints:\thesubsection}{\theQuestionPoints}%
      \addtocounter{ProblemPoints}{\theQuestionPoints}%
    }{%
      \@definelabel{QuestionPoints:\thesubsection}{#1}%
      \addtocounter{ProblemPoints}{#1}%
    }%
  }%
  \begin{list}%
    {{\bf (\alph{subsection})}}%
    {%
      \setlength{\topsep}{0pt}%
      \setlength{\partopsep}{0pt}%
    }%
    \item\ifthenelse{\equal{#1}{}}{}{\@showPts{\ref{QuestionPoints:\thesubsection}}}%
      \ignorespaces%
}%
{%
  \end{list}%
  \@atquestionend%
}%

\newenvironment{subquestion}[1][]%
{%
  \addtocounter{subsubsection}{1}%
  \setcounter{SubQuestionPoints}{0}%
  \def\@atsubquestionend {%
    \ifthenelse{\equal{#1}{}}{%
      \@definelabel{SubQuestionPoints:\thesubsubsection}{\theSubQuestionPoints}%
      \addtocounter{QuestionPoints}{\theSubQuestionPoints}%
    }{%
      \@definelabel{SubQuestionPoints:\thesubsubsection}{#1}%
      \addtocounter{QuestionPoints}{#1}%
    }%
  }%
  \begin{list}%
    {{\bf (\roman{subsubsection})}}%
    {%
      \setlength{\topsep}{0pt}%
      \setlength{\partopsep}{0pt}%
    }%
    \item \@showPts{\ref{SubQuestionPoints:\thesubsubsection}}%
      \ignorespaces%
}%
{%
  \end{list}%
  \@atsubquestionend%
}%


\newcommand{\tfq}[1]{%
 \@showPts{\truefalsepoints} [%
  \ifthenelse{\equal{#1}{true}}{%
    \textit{\solution{true}{\underline{true}}}~or~\textit{false}%
  }{%
    \ifthenelse{\equal{#1}{false}}{%
      \textit{true}~or~\textit{\solution{false}{\underline{false}}}%
    }{%
      \textit{true}~or~\textit{false}%
    }%
  }%
  ]~\ignorespaces
}


\newenvironment{truefalse}[1][]%
{%
  \addtocounter{subsubsection}{1}%
  \setcounter{SubQuestionPoints}{0}%
  \def\@atsubquestionend {%
    \@definelabel{SubQuestionPoints:\thesubsubsection}{1}%
    \addtocounter{QuestionPoints}{\truefalsepoints}%
  }%
  \begin{list}%
    {{\bf (\roman{subsubsection})}}%
    {%
      \setlength{\topsep}{0pt}%
      \setlength{\partopsep}{0pt}%
    }%
    \item \tfq{#1}
}%
{%
  \end{list}%
  \@atsubquestionend%
}%


\newcommand{\pad}{\vspace*{\fill}\par}

\@ifundefined{showSolutions}{
  \newcommand{\solution}[2]{#1} % excludes
  \newcommand{\solval}[2][]{}
  \newcommand{\solutioncircle}[1]{#1} % don't color text but still display it
  \newcommand{\solc}[1]{#1} % don't color text but still display it
  \newcommand{\solutionimage}[2]{#1}  % First argument is nonsolution, second is solution
}{
  \newcommand{\solution}[2]{{\color{red}{#2}}} % includes
  \newcommand{\solval}[2][]{{\color{red}{#2}}}
  \newcommand{\solutioncircle}[1]{\fbox{{\color{red}#1}}}
  \newcommand{\solc}[1]{\fbox{{\color{red}#1}}}
  \newcommand{\solutionimage}[2]{\begin{center}\fcolorbox{red}{white}{#2}\end{center}}
}

\def\indep{\perp\!\!\!\perp}


\textwidth = 7.0 in
\textheight = 9.5 in
\oddsidemargin = -0.30 in
\evensidemargin = -0.30 in
\topmargin = -0.75 in
\headheight = 0.00 in
\headsep = 0.25 in
\parskip = 0.15in
\parindent = 0.0in
\itemsep=-1pt
\floatsep 5pt plus 2pt minus 3pt
\intextsep 5pt plus 2pt minus 3pt
\textfloatsep=5pt plus 2pt minus 3pt
\renewcommand{\baselinestretch}{1.0}
\font\dunhd=cmdunh10 scaled \magstep5
\font\dunhc=cmdunh10 scaled \magstep4
\font\dunhb=cmdunh10 scaled \magstep3
\font\dunha=cmdunh10 scaled \magstep2
\date{}
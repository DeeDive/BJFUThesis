\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bjfuthesis}
[2021/05/09 v1.0.1 Beijing Forestry University Thesis Template]

%\renewcommand{\normalsize}{\fontsize{10pt}{12pt}\selectfont}
%\setlength{\textwidth}{6.5in}
%\setlength{\textheight}{8in}
%\pagenumbering{arabic} % needed even though this class will
%% not show page numbers

\hyphenation{BJFU-Thesis}
\def\bjfuthesis{BJFUThesis}
\def\version{1.0.2}

\newcommand\bjfu@error[1]{%
	\ClassError{bjfuthesis}{#1}{}%
}
\newcommand\bjfu@warning[1]{%
	\ClassWarning{bjfuthesis}{#1}{}%
}

\newcommand\bjfu@name@def[2]{%
	\@namedef{bjfu@name@#1}{#2}
}

% 检查 \LaTeXe{} kernel 版本
\@ifl@t@r\fmtversion{2017/04/15}{}{
	\bjfu@error{%
		TeX Live 2017 or later version is required to compile this document%
	}
}
% 检查编译引擎，要求使用 \XeLaTeX。
\RequirePackage{iftex}
\ifXeTeX\else
	\bjfu@error{XeLaTeX is required to compile this document}
\fi

\LoadClass[a4paper,UTF8,zihao=-4,oneside,AutoFakeBold,scheme=plain]{ctexbook}[2018/04/01]

% 引用的宏包和相应的定义
% bjfusetup
\RequirePackage{kvdefinekeys}
\RequirePackage{kvsetkeys}
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
	family=bjfu,
	prefix=bjfu@,
	setkeys=\kvsetkeys}

\let\bjfu@setup@hook\@empty
\newcommand\bjfusetup[1]{%
	\let\bjfu@setup@hook\@empty
	\kvsetkeys{bjfu}{#1}%
	\bjfu@setup@hook
}
\newcommand\bjfu@define@key[1]{%
	\kvsetkeys{bjfu@key}{#1}%
}
\kv@set@family@handler{bjfu@key}{%
	\@namedef{bjfu@#1@@name}{#1}%
	\def\bjfu@@default{}%
	\def\bjfu@@choices{}%
	\kv@define@key{bjfu@value}{name}{%
		\@namedef{bjfu@#1@@name}{##1}%
	}%
	\@namedef{bjfu@#1@@check}{}%
	\@namedef{bjfu@#1@@code}{}%
	\kv@define@key{bjfu@value}{choices}{%
		\def\bjfu@@choices{##1}%
		\@namedef{bjfu@#1@@reset}{}%
		\@namedef{bjfu@#1@@check}{%
			\@ifundefined{%
				ifbjfu@\@nameuse{bjfu@#1@@name}@\@nameuse{bjfu@\@nameuse{bjfu@#1@@name}}%
			}{%
				\bjfu@error{Invalid value "#1 = \@nameuse{bjfu@\@nameuse{bjfu@#1@@name}}"}%
			}%
			\@nameuse{bjfu@#1@@reset}%
			\@nameuse{bjfu@\@nameuse{bjfu@#1@@name}@\@nameuse{bjfu@\@nameuse{bjfu@#1@@name}}true}%
		}%
	}%
	\kv@define@key{bjfu@value}{default}{%
		\def\bjfu@@default{##1}%
	}%
	\kvsetkeys{bjfu@value}{#2}%
	\@namedef{bjfu@\@nameuse{bjfu@#1@@name}}{}%
	\kv@set@family@handler{bjfu@choice}{%
		\ifx\bjfu@@default\@empty
			\def\bjfu@@default{##1}%
		\fi
		\expandafter\newif\csname ifbjfu@\@nameuse{bjfu@#1@@name}@##1\endcsname
		\expandafter\g@addto@macro\csname bjfu@#1@@reset\endcsname{%
			\@nameuse{bjfu@\@nameuse{bjfu@#1@@name}@##1false}%
		}%
	}%
	\kvsetkeys@expandafter{bjfu@choice}{\bjfu@@choices}%
	\expandafter\let\csname bjfu@\@nameuse{bjfu@#1@@name}\endcsname\bjfu@@default
	\expandafter\ifx\csname bjfu@\@nameuse{bjfu@#1@@name}\endcsname\@empty\else
		\@nameuse{bjfu@#1@@check}%
	\fi
	\kv@define@key{bjfu}{#1}{%
		\@namedef{bjfu@\@nameuse{bjfu@#1@@name}}{##1}%
		\@nameuse{bjfu@#1@@check}%
		\@nameuse{bjfu@#1@@code}%
	}%
}
\newcommand\bjfu@option@hook[2]{%
	\expandafter\g@addto@macro\csname bjfu@#1@@code\endcsname{#2}%
}




\bjfu@define@key{
	name,
	keywords,
	keywords* = {
			name = keywords@en,
		},
}

\newcommand\bjfu@clist@use[2]{%
	\def\bjfu@@tmp{}%
	\def\bjfu@clist@processor##1{%
		\ifx\bjfu@@tmp\@empty
			\def\bjfu@@tmp{#2}%
		\else
			#2%
		\fi
		##1%
	}%
	\expandafter\comma@parse\expandafter{#1}{\bjfu@clist@processor}%
}



% 页面设置
\RequirePackage{geometry}
% 利用 \pkg{fancyhdr} 设置页眉页脚。
\RequirePackage{fancyhdr}
\RequirePackage{titletoc}
% 利用 \pkg{notoccite} 避免目录中引用编号混乱。
\RequirePackage{notoccite}
% \AmSTeX\ 宏包，用来排出更加漂亮的公式。
\RequirePackage{amsmath}
% 图形支持宏包。
\RequirePackage{graphicx}
% 首行缩进
\RequirePackage{indentfirst}
\setlength{\parindent}{2em}
%双语图题，表题
\RequirePackage{bicaption}
% 并排图形。\pkg{subfigure}、\pkg{subfig} 已经不再推荐，用新的 \pkg{subcaption}。
% 浮动图形和表格标题样式。\pkg{caption2} 已经不推荐使用，采用新的 \pkg{caption}。
\RequirePackage[labelformat=simple]{subcaption}
% \pkg{pdfpages} 宏包便于我们插入扫描后的授权说明和声明页 PDF 文档。
\RequirePackage{pdfpages}
\includepdfset{fitpaper=true}

\RequirePackage{xeCJKfntef}
\RequirePackage{soul}
% 更好的列表环境。
\RequirePackage[shortlabels]{enumitem}
\RequirePackage{environ}

%表格控制
\RequirePackage{array}
%三线表:\cs{toprule}，\cs{midrule}，\cs{bottomrule}。
\RequirePackage{tabularx}
\RequirePackage{ragged2e}
\RequirePackage{booktabs}
\RequirePackage{url}

%带圈数字
\RequirePackage{pifont}

%tabluarx居中
%该命令用于控制 p{} 的情况
\newcolumntype{P}[1]{>{\RaggedRight\hspace{0pt}}p{#1}} % 使用过程中，将p{4cm}换成P{4cm}，小写改成大写即可
%该命令用于控制 X 的情况
\newcolumntype{Z}{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}X} % 使用过程中，将Z 换成 X，即可



%论文中出现的所有数字和字母如无特殊要求都用Times New Roman体。
%设置正文非汉字的字体为Times New Roman
\setmainfont{Times New Roman}
% \setCJKmainfont[AutoFakeBold]{STSong}
% \setCJKfallbackfamilyfont{\CJKrmdefault}[AutoFakeBold]{SimSun}


% 行距 1.25
% word 中的行距跟latex中的行距概念不一样。
% word 中，行距 = 单倍行距 x 行距值(1.25)，而单倍行距 = 字体大小 x 固定系数(1.297/1.30)
% 默认字体12pt，所以 word 中行距 = 单倍行距 x 1.25 = 12pt x 1.3 x 1.25 = 19.5 pt
% latex 中，默认字体大小 12pt，可以通过设置其 baselineskip = 19.455 pt 来达到word要求的1.25倍行距的效果
% 又因为latex中默认 baselineskip = fontsize x 1.2，所以默认 baselineskip = 12pt x 1.2 = 14.4 pt
% 所以要求的 baselineskip 是默认的 baselineskip 的 19.455/14.4pt = 1.352 倍：
\linespread{1.352}



% 字体大小
% \fontsize{fontsize}{baselineskip}\selectfont
\newcommand{\chuhao}{\fontsize{42pt}{50.4pt}\selectfont} % 初号字体 42pt
\newcommand{\xiaochu}{\fontsize{36pt}{43.2pt}\selectfont} % 小初字体 36pt
\newcommand{\yihao}{\fontsize{26pt}{31.2pt}\selectfont} % 一号字体 26pt
\newcommand{\xiaoyi}{\fontsize{24pt}{28.8pt}\selectfont} % 小一字体 24pt
\newcommand{\erhao}{\fontsize{22pt}{26.4pt}\selectfont} % 二号字体 22pt
\newcommand{\xiaoer}{\fontsize{18pt}{21.6pt}\selectfont} % 小二字体 18pt
\newcommand{\sanhao}{\fontsize{16pt}{19.2pt}\selectfont} % 三号字体 16pt
\newcommand{\xiaosan}{\fontsize{15pt}{18pt}\selectfont} % 小三字体 15pt
\newcommand{\sihao}{\fontsize{14pt}{16.8pt}\selectfont} % 四号字体 14pt
\newcommand{\xiaosi}{\fontsize{12pt}{14.4pt}\selectfont} % 小四字体 12pt
\newcommand{\wuhao}{\fontsize{10.5pt}{12.6pt}\selectfont} % 五号字体 10.5pt
\newcommand{\xiaowu}{\fontsize{9pt}{10.8pt}\selectfont} % 小五字体 9pt
\newcommand{\liuhao}{\fontsize{7.5pt}{9pt}\selectfont} % 六号字体 7.5pt
\newcommand{\xiaoliu}{\fontsize{6.5pt}{7.8pt}\selectfont} % 小六字体 6.5pt
\newcommand{\qihao}{\fontsize{5.5pt}{6.6pt}\selectfont} % 七号字体 5.5pt
\newcommand{\bahao}{\fontsize{5pt}{6pt}\selectfont} % 八号字体 5pt


% 页面设置
% 根据本科生《撰写与印制规范》
% 
\geometry{
	paper = a4paper,  % 210 * 297mm
	top = 3.0cm,
	bottom=2.5cm,
	left = 3.0cm,
	right = 2.5cm,
	footskip = 1.0cm,
}
%字体
% \setCJKfamilyfont{zhsong}[AutoFakeBold = {2.17}]{SimSun}
% \setCJKfamilyfont{zhsong}[AutoFakeBold = {2.17}]{STSong}

\providecommand\songti{\CJKfamily{zhsong}}
\providecommand\heiti{\CJKfamily{zhhei}}
\providecommand\fangsong{\CJKfamily{zhfs}}
\providecommand\kaishu{\CJKfamily{zhkai}}


%定义页眉和页脚
\pagestyle{fancy}
\renewcommand\headrulewidth{0.75bp}%
\fancypagestyle{plain}{%
	\fancyhf{}%

	\fancyhead[C]{%
		\xiaowu
		\songti
		北京林业大学本科毕业论文
	}
	\fancyfoot[C]{\wuhao\thepage}%
	\headheight  0.5cm
	\headsep  1.1cm
}
\pagestyle{plain}



\bjfu@name@def{abstract@zh}{摘要}
\bjfu@name@def{abstract@en}{Abstract}
\bjfu@name@def{keywords@zh}{关键词：}
\bjfu@name@def{keywords@en}{Keywords:~}
\bjfu@name@def{appendix}{附录}
\bjfu@name@def{contents}{目\hspace{\ccwd}录}
%      listfigure        = {插图索引},
%      listtable         = {表格索引},
%      listalgorithm     = {算法索引},
\bjfu@name@def{figure}{图}
\bjfu@name@def{figure*}{Figure}
\bjfu@name@def{table}{表}
\bjfu@name@def{table*}{Table}
\bjfu@name@def{algorithm}{算法}
\bjfu@name@def{nomenclature}{主要符号对照表}
\bjfu@name@def{summary}{全文总结}
\bjfu@name@def{bib}{参考文献}
\bjfu@name@def{index}{索引}
\bjfu@name@def{acknowledgements}{致谢}
%      publications      = {攻读学位期间发表（或录用）的学术论文}
%      achievements      = {攻读学位期间获得的科研成果},
%      resume            = {个人简历},


\ctexset{
	chapter = {
	  name   = {,}, %{第,章}
	  number = \thechapter,
	 },
}
\ctexset{%
	appendixname   = \bjfu@name@appendix,
	contentsname   = \bjfu@name@contents,
	listfigurename = \bjfu@name@listfigure,
	listtablename  = \bjfu@name@listtable,
	figurename     = \bjfu@name@figure,
	tablename      = \bjfu@name@table,
	bibname        = \bjfu@name@bib,
	indexname      = \bjfu@name@index,
}
% 全文首行缩进 2 字符，标点符号用全角
\ctexset{%
	punct=quanjiao,
	space=auto,
}
% 各级标题格式设置。
\ctexset{%
	autoindent=2,
	chapter = {
	  nameformat   = {},
	  numberformat = {},
	  titleformat  = {},
	  fixskip      = true,
	  aftername    = \quad,
	  afterindent  = true,
	  lofskip      = 0pt,
	  lotskip      = 0pt,
	 },
	section = {
	  aftername    = \quad,
	  afterindent  = true,
	 },
	subsection = {
			aftername    = \quad,
			afterindent  = true,
		},
	subsubsection = {
			aftername    = \quad,
			afterindent  = true,
		},
	paragraph/afterindent = true,
	subparagraph/afterindent = true,
}


\ctexset{%
	chapter = {%
	  format       = \xiaosan\bfseries\songti\centering,
	  nameformat   = {},
	  titleformat  = {},
	  aftername    = \quad,
	  beforeskip   = 0.5\baselineskip,
	  afterskip    = 0.5\baselineskip,
	 },
	section = {%
	  format       = \sihao\bfseries\songti,
	  beforeskip   = 0.5\baselineskip,
	 },
	subsection = {%
			format       = \xiaosi\bfseries\songti,
		},
	subsubsection = {%
			format       = \xiaosi\songti,
		},
}
%中文摘要
\newenvironment{abstract}{%
	\begin{center}
		\songti \sanhao \bfseries
		\bjfu@name@abstract@zh
	\end{center}
	\xiaosi \kaishu
	\par
}{
	\par
	\null\par
	\noindent
	\xiaosi \songti
	\textbf{\bjfu@name@keywords@zh}%
	\bjfu@clist@use{\bjfu@keywords}{，}%
	\clearpage
}
%英文摘要
\newenvironment{abstract*}{%
	\begin{center}
		\centering\sanhao\bfseries
		\bjfu@name@abstract@en
	\end{center}
	\xiaosi
	\ctexset{autoindent=0.8cm}%
	\par

}{
	\par
	\null\par
	\noindent
	\xiaosi
	\textbf{\bjfu@name@keywords@en}%
	\bjfu@clist@use{\bjfu@keywords@en}{,~}%
	\clearpage
}
%目录

\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}

%\renewcommand\tableofcontents{%
%  \section*{\sanhao \songti  \bfseries \centering \centerline{\MakeUppercase{\contentsname}}
%    \@mkboth
%      {\MakeUppercase\contentsname}
%      {\MakeUppercase\contentsname}
%  }%
%  \@starttoc{toc}%
%}
%\RequirePackage{tocloft}
% 该Package会导致页面溢出问题，请谨慎使用

%\renewcommand{\cftchapfont}{\scshape}
%\renewcommand{\cftsecfont}{\bfseries}

% 目录居中
%\renewcommand{\contentsname}{\hfill\sanhao \songti  \bfseries \bjfu@name@contents}
%\renewcommand{\cftaftertoctitle}{\hfill}

\newcommand\bjfu@leaders{\titlerule*[4bp]{.}}
\newcommand\bjfu@set@toc@format{%
	\contentsmargin{\z@}%
	\titlecontents{chapter}
	[\z@]{\wuhao \songti \bfseries }
	{\contentspush{\thecontentslabel\quad}}{}
	{\rmfamily\bjfu@leaders\thecontentspage}%
	\titlecontents{section}
	[1em]{\wuhao \songti}
	{\contentspush{\thecontentslabel\quad}}{}
	{\bjfu@leaders\thecontentspage}%
	\titlecontents{subsection}
	[2em]{\wuhao \songti}
	{\contentspush{\thecontentslabel\quad}}{}
	{\bjfu@leaders\thecontentspage}%
}
\bjfu@set@toc@format


%附录

\g@addto@macro\appendix{%
	\@mainmattertrue
	\songti \wuhao
}

\bjfu@define@key{
	toc-depth = {
			name = toc@depth,
		},
}
\bjfu@option@hook{toc-depth}{%
	\protected@write\@auxout{}{%
		\string\ttl@writefile{toc}{%
			\protect\setcounter{tocdepth}{\bjfu@toc@depth}%
		}%
	}%
	\addtocontents{lof}{\string\let\string\contentsline\string\ttl@gobblecontents}
	\addtocontents{lot}{\string\let\string\contentsline\string\ttl@gobblecontents}
	\addtocontents{loe}{\string\let\string\contentsline\string\ttl@gobblecontents}
}
\g@addto@macro\appendix{%
	\bjfusetup{
		toc-depth =0,
	}%
}
% 致谢环境
\newenvironment{acknowledgements}{%
	\@mainmatterfalse
	\cleardoublepage
	\begin{center}
		\sanhao \songti \bfseries
		\bjfu@name@acknowledgements%
		\vspace{-.5em}
	\end{center}
	\par
	\wuhao
}{%
	\cleardoublepage
}

%页面及计数
\renewcommand\frontmatter{%
	\cleardoublepage
	\@mainmatterfalse
	\pagenumbering{Roman}%
}
\renewcommand\mainmatter{%
	\cleardoublepage
	\@mainmattertrue
	\pagenumbering{arabic}%
}
\renewcommand\backmatter{%
	\if@openright
		\cleardoublepage
	\else
		\clearpage
	\fi
	\@mainmatterfalse
	\bjfusetup{toc-depth = 0}%
}

%图表的格式

\captionsetup[subfigure]{labelformat=parens}
\captionsetup[table]{labelsep=space,font = {footnotesize,bf},labelfont=bf,textfont=bf}
\captionsetup[figure]{labelsep=space,font = {footnotesize,bf},labelfont=bf,textfont=bf}
\captionsetup[figure][bi-second]{name=Figure} %设置图的英文编号前缀
\captionsetup[table][bi-second]{name=Table} %设置表的英文编号前缀

%带圈数字 
\newcommand{\whiteding}[1]{\ding{\numexpr171+#1\relax}}
\newcommand{\blackding}[1]{\ding{\numexpr181+#1\relax}}
\newcommand{\whitedingB}[1]{\ding{\numexpr191+#1\relax}}
\newcommand{\blackdingB}[1]{\ding{\numexpr201+#1\relax}}
% \large\protect\textcircled{\small{}

% 列表编号设置
\renewcommand{\labelenumi}{（\theenumi）} % 一级为(1)
\renewcommand{\theenumii}{\arabic{enumii}} % 二级设置为数字
\renewcommand{\labelenumii}{
	\whitedingB{\theenumii}
} % 二级为圈1


% LongTable Caption间距设置
\setlength{\textfloatsep}{5pt}
\setlength\LTpre{0em} \setlength\LTpost{0em}
%%
%% End of file `bjfuthesis.cls'.
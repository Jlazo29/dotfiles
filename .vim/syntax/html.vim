" Vim syntax file
" Language:	HTML
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" URL:		http://www.fleiner.com/vim/syntax/html.vim
" Last Change:  2001 Jan 15

" Please check :help html.vim for some comments and a description of the options

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case ignore

set sw=2

" mark illegal characters
syn match htmlError "[<>&]"

if !exists("main_syntax")
  let main_syntax = 'html'
endif


" tags
syn region  htmlString   contained start=+"+ end=+"+ keepend contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc
syn region  htmlString   contained start=+'+ end=+'+ keepend contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc
syn match   htmlValue    contained "=[\t ]*[^'" \t>][^ \t>]*"hs=s+1   contains=javaScriptExpression,@htmlPreproc
syn region  htmlEndTag             start=+</+      end=+>+ contains=htmlTagN,htmlTagError
syn region  htmlTag                start=+<[^/%]+   end=+>+ contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster
syn match   htmlTagN     contained +<\s*[-a-zA-Z0-9]\++hs=s+1 contains=htmlTagName,htmlSpecialTagName,@htmlTagNameCluster
syn match   htmlTagN     contained +</\s*[-a-zA-Z0-9]\++hs=s+2 contains=htmlTagName,htmlSpecialTagName,@htmlTagNameCluster
syn match   htmlTagError contained "[^>]<"ms=s+1

syn match   htmlTrailSpaceError "\s\+$"

" tag names
syn keyword htmlTagName contained address applet area a base basefont
syn keyword htmlTagName contained big blockquote br caption center
syn keyword htmlTagName contained cite code dd dfn dir div dl dt font
syn keyword htmlTagName contained form hr html img
syn keyword htmlTagName contained input isindex kbd li link map menu
syn keyword htmlTagName contained meta ol option param pre p samp span
syn keyword htmlTagName contained select small strike sub sup
syn keyword htmlTagName contained table td textarea th tr tt ul var xmp
syn match htmlTagName contained "\<\(b\|i\|u\|h[1-6]\|em\|strong\|head\|body\|title\)\>"

" new html 4.0 tags
syn keyword htmlTagName contained abbr acronym bdo button col label
syn keyword htmlTagName contained colgroup del fieldset iframe ins legend
syn keyword htmlTagName contained object optgroup q s tbody tfoot thead

" legal arg names
if exists("gtmarkup_tag_order")
    syn match htmlArg contained "\_s\@<=\(action\|align\|alink\|alt\|archive\|background\|bgcolor\|border\|bordercolor\|cellpadding\|cellspacing\|checked\|class\|clear\|code\|codebase\|color\|cols\|colspan\|content\|contenteditable\|coords\|enctype\|face\|gutter\|height\|hspace\|id\|link\|lowsrc\|marginheight\|marginwidth\|maxlength\|method\|name\|prompt\|rel\|rev\|rows\|rowspan\|scrolling\|selected\|shape\|size\|src\|start\|target\|text\|type\|url\|usemap\|ismap\|valign\|value\|vlink\|vspace\|width\|wrap\)\>"
else
    syn keyword htmlArg contained action
    syn keyword htmlArg contained align alink alt archive background bgcolor
    syn keyword htmlArg contained border bordercolor cellpadding
    syn keyword htmlArg contained cellspacing checked class clear code codebase color
    syn keyword htmlArg contained cols colspan content contenteditable coords
    syn keyword htmlArg contained enctype face gutter height hspace id
    syn keyword htmlArg contained link lowsrc marginheight
    syn keyword htmlArg contained marginwidth maxlength method name prompt
    syn keyword htmlArg contained rel rev rows rowspan scrolling selected shape
    syn keyword htmlArg contained size src start target text type url
    syn keyword htmlArg contained usemap ismap valign value vlink vspace width wrap
endif
syn match htmlArg contained "\<\(http-equiv\|href\|title\)="me=e-1

" Netscape extensions
syn keyword htmlTagName contained frame noframes frameset nobr blink
syn keyword htmlTagName contained layer ilayer nolayer spacer
if exists("gtmarkup_tag_order")
    syn match htmlArg contained "\_s\@<=\(frameborder\|noresize\|pagex\|pagey\|above\|below\|left\|top\|visibility\|clip\|id\|noshade\)\>"
else
    syn keyword htmlArg     contained frameborder noresize pagex pagey above below
    syn keyword htmlArg     contained left top visibility clip id noshade
endif
syn match   htmlArg     contained "\<z-index\>"

" Microsoft extensions
syn keyword htmlTagName contained marquee

" html 4.0 arg names
syn match htmlArg contained "\<\(accept-charset\|label\)\>"
if exists("gtmarkup_tag_order")
    syn match htmlArg contained "\_s\@<=\(abbr\|accept\|accesskey\|axis\|char\|charoff\|charset\|cite\|classid\|codetype\|compact\|data\|datetime\|declare\|defer\|dir\|disabled\|for\|frame\|headers\|hreflang\|lang\|language\|longdesc\|multiple\|nohref\|nowrap\|object\|profile\|readonly\|rules\|scheme\|scope\|span\|standby\|style\|summary\|tabindex\|valuetype\|version\)\>"
else
    syn keyword htmlArg contained abbr accept accesskey axis char charoff charset
    syn keyword htmlArg contained cite classid codetype compact data datetime
    syn keyword htmlArg contained declare defer dir disabled for frame
    syn keyword htmlArg contained headers hreflang lang language longdesc
    syn keyword htmlArg contained multiple nohref nowrap object profile readonly
    syn keyword htmlArg contained rules scheme scope span standby style
    syn keyword htmlArg contained summary tabindex valuetype version
endif

" special characters
syn match htmlSpecialChar "&[^;]\{1,6};"

" Comments (the real ones or the old netscape ones)
if exists("html_wrong_comments")
  syn region htmlComment                start=+<!--+    end=+--\s*>+
else
  syn region htmlComment                start=+<!+      end=+>+   contains=htmlCommentPart,htmlCommentError
  syn match  htmlCommentError contained "[^><!]"
  syn region htmlCommentPart  contained start=+--+      end=+--\s*+  contains=@htmlPreProc
endif
syn region htmlComment                  start=+<!DOCTYPE+ keepend end=+>+

"syn region htmlComment                  start=+<%\s*--+ end=+--\s*%>+ contains=htmlComment

" server-parsed commands
syn region htmlPreProc start=+<!--#+ end=+-->+ contains=htmlPreStmt,htmlPreError,htmlPreAttr
syn match htmlPreStmt contained "<!--#\(config\|echo\|exec\|fsize\|flastmod\|include\|printenv\|set\|if\|elif\|else\|endif\|geoguide\)\>"
syn match htmlPreError contained "<!--#\S*"ms=s+4
syn match htmlPreAttr contained "\w\+=[^"]\S\+" contains=htmlPreProcAttrError,htmlPreProcAttrName
syn region htmlPreAttr contained start=+\w\+="+ skip=+\\\\\|\\"+ end=+"+ contains=htmlPreProcAttrName keepend
syn match htmlPreProcAttrError contained "\w\+="he=e-1
syn match htmlPreProcAttrName contained "\(expr\|errmsg\|sizefmt\|timefmt\|var\|cgi\|cmd\|file\|virtual\|value\)="he=e-1

if !exists("html_no_rendering")
  " rendering
  syn cluster htmlTop contains=@Spell,htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,@htmlPreproc

  syn region htmlBold start="<b\>" end="</b>"me=e-4 contains=@htmlTop,htmlBoldUnderline,htmlBoldItalic
  syn region htmlBold start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop,htmlBoldUnderline,htmlBoldItalic
  syn region htmlBoldUnderline contained start="<u\>" end="</u>"me=e-4 contains=@htmlTop,htmlBoldUnderlineItalic
  syn region htmlBoldItalic contained start="<i\>" end="</i>"me=e-4 contains=@htmlTop,htmlBoldItalicUnderline
  syn region htmlBoldItalic contained start="<em\>" end="</em>"me=e-5 contains=@htmlTop,htmlBoldItalicUnderline
  syn region htmlBoldUnderlineItalic contained start="<i\>" end="</i>"me=e-4 contains=@htmlTop
  syn region htmlBoldUnderlineItalic contained start="<em\>" end="</em>"me=e-5 contains=@htmlTop
  syn region htmlBoldItalicUnderline contained start="<u\>" end="</u>"me=e-4 contains=@htmlTop,htmlBoldUnderlineItalic

  syn region htmlUnderline start="<u\>" end="</u>"me=e-4 contains=@htmlTop,htmlUnderlineBold,htmlUnderlineItalic
  syn region htmlUnderlineBold contained start="<b\>" end="</b>"me=e-4 contains=@htmlTop,htmlUnderlineBoldItalic
  syn region htmlUnderlineBold contained start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop,htmlUnderlineBoldItalic
  syn region htmlUnderlineItalic contained start="<i\>" end="</i>"me=e-4 contains=@htmlTop,htmUnderlineItalicBold
  syn region htmlUnderlineItalic contained start="<em\>" end="</em>"me=e-5 contains=@htmlTop,htmUnderlineItalicBold
  syn region htmlUnderlineItalicBold contained start="<b\>" end="</b>"me=e-4 contains=@htmlTop
  syn region htmlUnderlineItalicBold contained start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop
  syn region htmlUnderlineBoldItalic contained start="<i\>" end="</i>"me=e-4 contains=@htmlTop
  syn region htmlUnderlineBoldItalic contained start="<em\>" end="</em>"me=e-5 contains=@htmlTop

  syn region htmlItalic start="<i\>" end="</i>"me=e-4 contains=@htmlTop,htmlItalicBold,htmlItalicUnderline
  syn region htmlItalic start="<em\>" end="</em>"me=e-5 contains=@htmlTop
  syn region htmlItalicBold contained start="<b\>" end="</b>"me=e-4 contains=@htmlTop,htmlItalicBoldUnderline
  syn region htmlItalicBold contained start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop,htmlItalicBoldUnderline
  syn region htmlItalicBoldUnderline contained start="<u\>" end="</u>"me=e-4 contains=@htmlTop
  syn region htmlItalicUnderline contained start="<u\>" end="</u>"me=e-4 contains=@htmlTop,htmlItalicUnderlineBold
  syn region htmlItalicUnderlineBold contained start="<b\>" end="</b>"me=e-4 contains=@htmlTop
  syn region htmlItalicUnderlineBold contained start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop

  syn region htmlLink start="<a\>[^>]*href\>" end="</a>"me=e-4 contains=@Spell,htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,javaScript,@htmlPreproc
  syn region htmlH1 start="<h1\>" end="</h1>"me=e-5 contains=@htmlTop
  syn region htmlH2 start="<h2\>" end="</h2>"me=e-5 contains=@htmlTop
  syn region htmlH3 start="<h3\>" end="</h3>"me=e-5 contains=@htmlTop
  syn region htmlH4 start="<h4\>" end="</h4>"me=e-5 contains=@htmlTop
  syn region htmlH5 start="<h5\>" end="</h5>"me=e-5 contains=@htmlTop
  syn region htmlH6 start="<h6\>" end="</h6>"me=e-5 contains=@htmlTop
  syn region htmlHead start="<head\>" end="</head>"me=e-7 end="<body\>"me=e-5 end="<h[1-6]\>"me=e-3 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,htmlTitle,javaScript,cssStyle,@htmlPreproc
  syn region htmlTitle start="<title\>" end="</title>"me=e-8 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,javaScript,@htmlPreproc
endif

syn keyword htmlTagName         contained noscript
syn keyword htmlSpecialTagName  contained script style


if exists("b:current_syntax")
    unlet b:current_syntax
endif
:source <sfile>:p:h/gtmarkup.vim

if main_syntax != 'java' || exists("java_javascript")
  " JAVA SCRIPT
  syn include @htmlJavaScript $VIMRUNTIME/syntax/javascript.vim
  unlet b:current_syntax
  syn region  javaScript start=+<script[^>]*>+ keepend end=+</script>+me=s-1 contains=@htmlJavaScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc
  syn region  htmlScriptTag     contained start=+<script+ end=+>+       contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent
  hi def link htmlScriptTag htmlTag

  " html events (i.e. arguments that include javascript commands)
  if exists("html_extended_events")
    syn region htmlEvent        contained start=+\<on\a\+\s*=[\t ]*'+ end=+'+ contains=htmlEventSQ
    syn region htmlEvent        contained start=+\<on\a\+\s*=[\t ]*"+ end=+"+ contains=htmlEventDQ
  else
    syn region htmlEvent        contained start=+\<on\a\+\s*=[\t ]*'+ end=+'+ keepend contains=htmlEventSQ
    syn region htmlEvent        contained start=+\<on\a\+\s*=[\t ]*"+ end=+"+ keepend contains=htmlEventDQ
  endif
  syn region htmlEventSQ        contained start=+'+ms=s+1 end=+'+me=s-1 contains=@htmlJavaScript
  syn region htmlEventDQ        contained start=+"+ms=s+1 end=+"+me=s-1 contains=@htmlJavaScript
  hi def link htmlEventSQ htmlEvent
  hi def link htmlEventDQ htmlEvent

  " a javascript expression is used as an arg value
  syn region  javaScriptExpression contained start=+&{+ keepend end=+};+ contains=@htmlJavaScript,@htmlPreproc
endif

if main_syntax != 'java' || exists("java_vb")
  " VB SCRIPT
  syn include @htmlVbScript $VIMRUNTIME/syntax/vb.vim
  unlet b:current_syntax
  syn region  javaScript start=+<script [^>]*language *=[^>]*vbscript[^>]*>+ keepend end=+</script>+me=s-1 contains=@htmlVbScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc
endif

syn cluster htmlJavaScript      add=@htmlPreproc

if main_syntax != 'java' || exists("java_css")
  " embedded style sheets
  syn keyword htmlArg           contained media
  syn include @htmlCss $VIMRUNTIME/syntax/css.vim
  unlet b:current_syntax
  syn region cssStyle start=+<style+ keepend end=+</style>+ contains=@htmlCss,htmlTag,htmlEndTag,htmlCssStyleComment,@htmlPreproc
  syn match htmlCssStyleComment contained "\(<!--\|-->\)"
" breaks on load for some reason
"  syn region htmlCssDefinition matchgroup=htmlArg start='style="' keepend matchgroup=htmlString end='"' contains=css.*Attr,css.*Properties,cssComment,cssLength,cssColor,cssURL,cssImportant,cssError,cssString,@htmlPreproc
  hi def link htmlStyleArg htmlString
endif

if main_syntax == "html"
  " synchronizing (does not always work if a comment includes legal
  " html tags, but doing it right would mean to always start
  " at the first line, which is too slow)
  syn sync match htmlHighlight groupthere NONE "<[/a-zA-Z]"
  syn sync match htmlHighlight groupthere javaScript "<script"
  syn sync match htmlHighlightSkip "^.*['\"].*$"
  syn sync minlines=10
endif

" The default highlighting.
hi def link htmlTag                     Function
hi def link htmlEndTag                  Identifier
hi def link htmlArg                     Type
hi def link htmlTagName                 htmlStatement
hi def link htmlSpecialTagName          Exception
hi def link htmlValue                   Value
hi def link htmlSpecialChar             Special

if !exists("html_no_rendering")
  hi def link htmlH1                      Title
  hi def link htmlH2                      htmlH1
  hi def link htmlH3                      htmlH2
  hi def link htmlH4                      htmlH3
  hi def link htmlH5                      htmlH4
  hi def link htmlH6                      htmlH5
  hi def link htmlHead                    PreProc
  hi def link htmlTitle                   Title
  hi def link htmlBoldItalicUnderline     htmlBoldUnderlineItalic
  hi def link htmlUnderlineBold           htmlBoldUnderline
  hi def link htmlUnderlineItalicBold     htmlBoldUnderlineItalic
  hi def link htmlUnderlineBoldItalic     htmlBoldUnderlineItalic
  hi def link htmlItalicUnderline         htmlUnderlineItalic
  hi def link htmlItalicBold              htmlBoldItalic
  hi def link htmlItalicBoldUnderline     htmlBoldUnderlineItalic
  hi def link htmlItalicUnderlineBold     htmlBoldUnderlineItalic
  if !exists("html_my_rendering")
    if &background == "dark"
      hi def htmlLink              term=underline cterm=underline ctermfg=cyan gui=underline guifg=#80a0ff
    else
      hi def htmlLink              term=underline cterm=underline ctermfg=DarkBlue gui=underline guifg=Blue
    endif
    hi def htmlBold                term=bold cterm=bold gui=bold
    hi def htmlBoldUnderline       term=bold,underline cterm=bold,underline gui=bold,underline
    hi def htmlBoldItalic          term=bold,italic cterm=bold,italic gui=bold,italic
    hi def htmlBoldUnderlineItalic term=bold,italic,underline cterm=bold,italic,underline gui=bold,italic,underline
    hi def htmlUnderline           term=underline cterm=underline gui=underline
    hi def htmlUnderlineItalic     term=italic,underline cterm=italic,underline gui=italic,underline
    hi def htmlItalic              term=italic cterm=italic gui=italic
  endif
endif

hi def link htmlPreStmt            PreProc
hi def link htmlPreError           Error
hi def link htmlPreProc            PreProc
hi def link htmlPreAttr            String
hi def link htmlPreProcAttrName    PreProc
hi def link htmlPreProcAttrError   Error
hi def link htmlSpecial            Special
hi def link htmlSpecialChar        Special
hi def link htmlString             String
hi def link htmlStatement          Statement
hi def link htmlComment            Comment
hi def link htmlCommentPart        Comment
hi def link htmlValue              String
hi def link htmlCommentError       htmlError
hi def link htmlTagError           htmlError
hi def link htmlEvent              javaScript
hi def link htmlError              Error
hi def link htmlTrailSpaceError    htmlError

hi def link javaScript             Special
hi def link javaScriptExpression   javaScript
hi def link htmlCssStyleComment    Comment
hi def link htmlCssDefinition      Special

let b:current_syntax = "html"

if main_syntax == 'html'
  unlet main_syntax
endif

" vim: ts=8

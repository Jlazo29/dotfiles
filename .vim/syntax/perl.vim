" Vim syntax file
" Language:	Perl
" Maintainer:	Nick Hibma <n_hibma@webweaving.org>
" Last Change:	2001 June 16
" Location:	http://www.etla.net/~n_hibma/vim/syntax/perl.vim
"
" Please download most recent version first before mailing
" any comments.
" See also the file perl.vim.regression.pl to check whether your
" modifications work in the most odd cases
" http://www.etla.net/~n_hibma/vim/syntax/perl.vim.regression.pl
"
" Original version: Sonia Heimann <niania@netsurf.org>
" Thanks to many people for their contribution. They made it work, not me.

" The following parameters are available for tuning the
" perl syntax highlighting, with defaults given:
"
" unlet perl_include_pod
let perl_include_pod = 1
" unlet perl_want_scope_in_variables
let perl_want_scope_in_variables = 1
" unlet perl_extended_vars
let perl_extended_vars = 1
"unlet perl_string_as_statement
let perl_string_as_statement = 1
" unlet perl_no_sync_on_sub
let perl_no_sync_on_sub = 1
" unlet perl_no_sync_on_global_var
let perl_no_sync_on_global_var = 1
" let perl_sync_dist = 100
let perl_sync_dist = 200

" unlet perl_fold
"let perl_fold = 1

set shiftwidth=4

" Remove any old syntax stuff that was loaded (5.x) or quit when a syntax file
" was already loaded (6.x).
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Unset perl_fold if it set but vim doesn't support it.
if version < 600 && exists("perl_fold")
  unlet perl_fold
endif


" POD starts with ^=<word> and ends with ^=cut

if exists("perl_include_pod")
  " Include a while extra syntax file
  syn include @Pod <sfile>:p:h/pod.vim
  unlet b:current_syntax
  if exists("perl_fold")
    syn region perlPOD start="^=[a-z]" end="^=cut" contains=@Pod,perlTodo keepend fold
  else
    syn region perlPOD start="^=[a-z]" end="^=cut" contains=@Pod,perlTodo keepend
  endif
else
  " Use only the bare minimum of rules
  if exists("perl_fold")
    syn region perlPOD start="^=[a-z]" end="^=cut" fold
  else
    syn region perlPOD start="^=[a-z]" end="^=cut"
  endif
endif


" All keywords
"
syn keyword perlConditional		if elsif unless switch eq ne gt lt ge le cmp not and or xor
syn keyword perlConditional		else nextgroup=perlElseIfError skipwhite skipnl skipempty
syn keyword perlRepeat			while for foreach do until
syn keyword perlOperator		defined undef and or not bless ref
if exists("perl_fold")
  " BUG bug in Vim if BEGIN/END is a keyword the perlBEGINENDFold does not work
  syn match perlControl			"BEGIN" contained
  syn match perlControl			"END" contained
else
  syn keyword perlControl		BEGIN END AUTOLOAD DESTROY
endif

syn match perlStatementStorage		"\(->\s*\)\@<!\<\(my\|local\|our\)\>"
syn match perlStatementControl		"\(->\s*\)\@<!\<\(goto\|return\|last\|next\|continue\|redo\)\>"
syn match perlStatementScalar		"\(->\s*\)\@<!\<\(chomp\|chop\|chr\|crypt\|index\|lc\|lcfirst\|length\|ord\|pack\|reverse\|rindex\|sprintf\|substr\|uc\|ucfirst\)\>"
syn match perlStatementRegexp		"\(->\s*\)\@<!\<\(pos\|quotemeta\|split\|study\)\>"
syn match perlStatementNumeric		"\(->\s*\)\@<!\<\(abs\|atan2\|cos\|exp\|hex\|int\|log\|oct\|rand\|sin\|sqrt\|srand\)\>"
syn match perlStatementList		"\(->\s*\)\@<!\<\(splice\|unshift\|shift\|push\|pop\|split\|join\|reverse\|grep\|map\|sort\|unpack\)\>"
syn match perlStatementHash		"\(->\s*\)\@<!\<\(each\|exists\|keys\|values\|tie\|tied\|untie\)\>"
syn match perlStatementIOfunc		"\(->\s*\)\@<!\<\(carp\|confess\|croak\|dbmclose\|dbmopen\|die\|syscall\)\>"
syn match perlStatementFiledesc		"\(->\s*\)\@<!\<\(binmode\|close\|closedir\|eof\|fileno\|getc\|lstat\|print\|printf\|readdir\|readline\|readpipe\|rewinddir\|select\|stat\|tell\|telldir\|write\)\>" nextgroup=perlFiledescStatementNocomma
syn match perlStatementFiledesc		"\(->\s*\)\@<!\<\(fcntl\|flock\|ioctl\|open\|opendir\|read\|seek\|seekdir\|sysopen\|sysread\|sysseek\|syswrite\|truncate\)\>" nextgroup=perlFiledescStatementComma
syn match perlStatementVector		"\(->\s*\)\@<!\<\(pack\|vec\)\>"
syn match perlStatementFiles		"\(->\s*\)\@<!\<\(chdir\|chmod\|chown\|chroot\|glob\|link\|mkdir\|readlink\|rename\|rmdir\|symlink\|umask\|unlink\|utime\)\>"
syn match perlStatementFiles		"-[rwxoRWXOezsfdlpSbctugkTBMAC]\>" nextgroup=perlFiledescStatementNocomma
syn match perlStatementFlow		"\(->\s*\)\@<!\<\(caller\|die\|dump\|eval\|exit\|wantarray\)\>"
syn match perlStatementInclude		"\(->\s*\)\@<!\<require\>"
syn match perlStatementInclude		"\(use\|no\)\_s\+\(integer\>\|strict\>\|lib\>\|sigtrap\>\|subs\>\|vars\>\|warnings\>\|utf8\>\|byte\>\|constants\=\>\)\="
syn match perlStatementScope		"\(->\s*\)\@<!\<import\>"
syn match perlStatementProc		"\(->\s*\)\@<!\<\(alarm\|exec\|fork\|getpgrp\|getppid\|getpriority\|kill\|pipe\|setpgrp\|setpriority\|sleep\|system\|times\|wait\|waitpid\)\>"
syn match perlStatementSocket		"\(->\s*\)\@<!\<\(accept\|bind\|connect\|getpeername\|getsockname\|getsockopt\|listen\|recv\|send\|setsockopt\|shutdown\|socket\|socketpair\)\>"
syn match perlStatementIPC		"\(->\s*\)\@<!\<\(msgctl\|msgget\|msgrcv\|msgsnd\|semctl\|semget\|semop\|shmctl\|shmget\|shmread\|shmwrite\)\>"
syn match perlStatementNetwork		"\(->\s*\)\@<!\<\(endhostent\|endnetent\|endprotoent\|endservent\|gethostbyaddr\|gethostbyname\|gethostent\|getnetbyaddr\|getnetbyname\|getnetent\|getprotobyname\|getprotobynumber\|getprotoent\|getservbyname\|getservbyport\|getservent\|sethostent\|setnetent\|setprotoent\|setservent\)\>"
syn match perlStatementPword		"\(->\s*\)\@<!\<\(getpwuid\|getpwnam\|getpwent\|setpwent\|endpwent\|getgrent\|getgrgid\|getlogin\|getgrnam\|setgrent\)\>"
syn match perlStatementTime		"\(->\s*\)\@<!\<\(gmtime\|localtime\|time\|times\)\>"

syn match perlStatementMisc		"\(->\s*\)\@<!\<\(warn\|formline\|reset\|scalar\|new\|delete\|prototype\|lock\|END_OF_SUB\|END_OF_FUNC\|END_OF_CODE\)\>"

syn match perlMethodMisc		"\(->\s*\)\@<=new\>"

syn match perlMethodSuper		"\(->\s*\)\@<=\(\w\+\)\(::\w\+\)*::\w\@="

syn match perlMethodGTBase		"\(->\s*\(SUPER::\)\=\)\@<=\(error\|warn\|fatal\|common_param\|reset\|init\)\>"
syn match perlMethodGTSQL		"\(->\s*\(SUPER::\)\=\)\@<=\(table\|select\|select_options\|add\|insert\|modify\|update\|delete\|count\|bool\|not\|query\|query_sth\|fetchrow\(_array\|_arrayref\|_hashref\)\=\|fetchall_\(arrayref\|list\|hashref\)\)\>"
syn match perlMethodGTCGI		"\(->\s*\(SUPER::\)\=\)\@<=\(param\|header\|\(html_\)\=\(un\)\=escape\|cookie\)\>"
syn match perlMethodGTApp		"\(->\s*\(SUPER::\)\=\)\@<=\(\(print\|force\|add\|set\|clear\)_header\|content_type\|no_cache\|response\|out\|request\|in\|user\)\>"
syn match perlMethodGTTemplate		"\(->\s*\(SUPER::\)\=\)\@<=\(parse\|parse_print\|parse_stream\|root\)\>"
syn match perlMethodGTMisc		"\(->\s*\(SUPER::\)\=\)\@<=\(dispatch\)\>"

syn keyword perlTodo			TODO TBD FIXME XXX DEBUG contained

" Perl Identifiers.
"
" Should be cleaned up to better handle identifiers in particular situations
" (in hash keys for example)
"
" Plain identifiers: $foo, @foo, $#foo, %foo, &foo and dereferences $$foo, @$foo, etc.
" We do not process complex things such as @{${"foo"}}. Too complicated, and
" too slow. And what is after the -> is *not* considered as part of the
" variable - there again, too complicated and too slow.

" Special variables first ($^A, ...) and ($|, $', ...)
syn match  perlVarPlain		 "$^[ACDEFHILMOPRSTVWX]\="
syn match  perlVarPlainDQ	 "$^[ACDEFHILMOPRSTVWX]\="
syn match  perlVarPlain		 "$[\\\"\[\]'&`+*.,;=%~!?@$<>(-]"
syn match  perlVarPlainDQ	 "$[\\\"\[\]'&`+*.,;=%~!?@$<>(-]"
syn match  perlVarPlain		 "@[+-]"
syn match  perlVarPlainDQ	 "@[+-]"
" Special hash variables don't get a DQ match
syn match  perlVarPlain		 "%^H"
syn match  perlVarPlain		 "%!"
" Same as above, but avoids confusion in $::foo (equivalent to $main::foo)
" $: is $FORMAT_LINE_BREAK_CHARACTERS
syn match  perlVarPlain		 "$::\@!"
syn match  perlVarPlainDQ	 "$::\@!"
syn match  perlVarPlain          "$\d\+"
syn match  perlVarPlainDQ        "$\d\+"
" These variables are not recognized within matches.
syn match  perlVarNotInMatches   "$[|)]"

"syn match  perlVarPlainRe        +$\(^[ACDEFHILMOPRSTVWX]\|\(\z1\)\@![\\\"\[\]'&`+*.,;=%~!?@$<>(-]\|:\(:\)\@!\)+

" This variable is not recognized within matches delimited by m//.
syn match  perlVarSlash		 "$/"

" And plain identifiers
syn match  perlPackageRef	 "\(\h\w*\)\=::" contained
syn match  perlPackageRef	 "\(\h\w*\)\='\I"me=e-1 contained

" To highlight packages in variables as a scope reference - i.e. in $pack::var,
" pack:: is a scope, just set "perl_want_scope_in_variables"
" If you *want* complex things like @{${"foo"}} to be processed,
" just set the variable "perl_extended_vars"...

" FIXME value between {} should be marked as string. is treated as such by Perl.
" At the moment it is marked as something greyish instead of read. Probably todo
" with transparency. Or maybe we should handle the bare word in that case. or make it into

if exists("perl_want_scope_in_variables")
  syn match  perlVarPlain	"\\\=\([@%$]\|\$#\)\$*\(::\|\(\(::\|'\)\=\I\i*\)\+\)\i\@!" contains=perlPackageRef nextgroup=perlVarMember,perlVarSimpleMember
  syn match  perlVarPlainDQ     "\\\=\([@$]\|\$#\)\$*\(::\|\(\(::\|'\)\=\I\i*\)\+\)\i\@!"  contains=perlPackageRef nextgroup=perlVarMember,perlVarSimpleMember
  syn match  perlFunctionName	"\\\=&\$*\(\I\i*\|::\|'\)\(::\|'\|\I\i*\)*\i\@!" contains=perlPackageRef nextgroup=perlVarMember,perlVarSimpleMember
else
  syn match  perlVarPlain	"\\\=\([@%$]\|\$#\)\$*\(\I\i*\)\=\(\(::\|'\)\I\i*\)*\>" nextgroup=perlVarMember,perlVarSimpleMember
  syn match  perlVarPlainDQ	"\\\=\([@$]\|\$#\)\$*\(\I\i*\)\=\(\(::\|'\)\I\i*\)*\>" nextgroup=perlVarMember,perlVarSimpleMember
  syn match  perlFunctionName	"\\\=&\$*\(\I\i*\)\=\(\(::\|'\)\I\i*\)*\>" nextgroup=perlVarMember,perlVarSimpleMember
endif

if exists("perl_extended_vars")
  syn cluster perlExpr		contains=perlStatementScalar,perlStatementRegexp,perlStatementNumeric,perlStatementList,perlStatementHash,perlStatementFiles,perlStatementTime,perlStatementMisc,perlVarPlain,perlVarNotInMatches,perlVarSlash,perlVarBlock,perlShellCommand,perlFloat,perlNumber,perlStringUnexpanded,perlString,perlQQ,perlQW
  syn region perlVarBlock	matchgroup=perlVarPlain start="\($#\|[@%$]\)\$*{" skip="\\}" end="}" contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember
  syn region perlVarBlock	matchgroup=perlVarPlain start="&\$*{" skip="\\}" end="}" contains=@perlExpr
  syn match  perlVarPlain	"\\\=\(\$#\|[@%&$]\)\$*{\I\i*}" nextgroup=perlVarMember,perlVarSimpleMember
  syn region perlVarMember	matchgroup=perlVarPlain start="\(->\)\={" skip="\\}" end="}" contained contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember
  syn match  perlVarSimpleMember	"\(->\)\={\I\i*}" nextgroup=perlVarMember,perlVarSimpleMember contains=perlVarSimpleMemberName contained
  syn match  perlVarSimpleMemberName	"\I\i*" contained
  syn region perlVarMember	matchgroup=perlVarPlain start="\(->\)\=\[" skip="\\]" end="]" contained contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember
endif

" File Descriptors
syn match  perlFiledescRead	"[<]\h\w\+[>]"

syn match  perlFiledescStatementComma	"\_s*(\=\_s*\h\w*\>\_s*," transparent contained contains=perlFiledescStatement
syn match  perlFiledescStatementNocomma	"\_s*(\=\_s*\(and\|or\|xor\)\@!\h\w*\>\(\_s\+[^,]\|\_s*;\)"me=e-1 transparent contained contains=perlFiledescStatement

syn match  perlFiledescStatement	"\h\w\+" contained

" Special characters in strings and matches
syn match  perlSpecialString	"\\\(\d\+\|[xX]\x\+\|c.\|.\)" contained
syn match  perlSpecialStringU	"\\['\\]" contained
syn match  perlSpecialStringV   "\\\\" contained
syn match  perlSpecialMatch	"{\d\(,\d\)\=}" contained
syn match  perlSpecialMatch	"\[\(\]\|-\)\=[^\[\]]*\(\[\|\-\)\=\]" contained
syn match  perlSpecialMatch	"[+*()?.]" contained
syn match  perlSpecialMatch	"(?[#:=!]" contained
syn match  perlSpecialMatch	"(?[imsx]\+)" contained
" FIXME the line below does not work. It should mark end of line and
" begin of line as perlSpecial.
" syn match perlSpecialBEOM    "^\^\|\$$" contained

" Possible errors
"
" Highlight lines with only whitespace (only in blank delimited here documents) as errors
syn match  perlNotEmptyLine	"^\s\+$" contained
" Highlight '} else if (...) {', it should be '} else { if (...) { ' or
" '} elsif (...) {'.
syn keyword perlElseIfError	if contained
" Highlight foo () as an error - should be foo(), to go with the GT Coding
" Style Guidelines.
syn match   perlFuncSpaceError	"\w\@<=\(\<\(if\|elsif\|unless\|my\|our\|local\|return\|while\|until\|for\(each\)\=\(\s\+\(my\s*\)\=\$\w\+\)\=\|foreach\|x\|and\|x\=or\|not\|[lg][te]\|eq\|ne\|cmp\|\(use\|new\)\s\+[a-zA-Z0-9_:]\+\)\|-[rwxoRWXOezsfdlpSbctugkTBMAC]\)\@<!\s\+(\@="
syn match   perlSpaceTrailError "\s\+$"
syn match   perlDerefSpaceError	"[0-9a-zA-Z_\}\]\)]\@<=\s\+\(->\)\@=\|\(->\)\@<=\s\+[0-9a-zA-Z_\{\[\(]\@="

" Variable interpolation
"
" These items are interpolated inside "" strings and similar constructs.
syn cluster perlInterpDQ	contains=perlSpecialString,perlVarPlainDQ,perlVarNotInMatches,perlVarSlash,perlVarBlock
" These items are interpolated inside '' strings and similar constructs.
syn cluster perlInterpSQ	contains=perlSpecialStringU
syn cluster perlInterpBS        contains=perlSpecialStringV

" These items are interpolated inside m// matches and s/// substitutions.
syn cluster perlInterpSlash	contains=perlSpecialString,perlSpecialMatch,perlVarPlainDQ,perlVarBlock,perlSpecialBEOM

syn cluster perlInterpSquare   contains=perlSpecialString,perlSpecialMatch,perlVarPlainDQ,perlVarBlock,perlSpecialBEOM
syn cluster perlInterpAngle    contains=perlSpecialString,perlSpecialMatch,perlVarPlainDQ,perlVarBlock,perlSpecialBEOM
syn cluster perlInterpSemicolon contains=perlSpecialString,perlSpecialMatch,perlVarPlainDQ,perlVarBlock,perlSpecialBEOM
syn cluster perlInterpBackT     contains=perlSpecialString,perlSpecialMatch,perlVarPlainDQ,perlVarBlock,perlSpecialBEOM

" These items are interpolated inside m## matches and s### substitutions.
syn cluster perlInterpMatch	contains=@perlInterpSlash,perlVarSlash
"syn cluster perlInterpMatch     contains=perlSpecialString,perlSpecialMatch,perlVarPlainRe,perlVarBlock,perlSpecialBEOM

" Shell commands
syn region perlShellCommand	matchgroup=perlStringStartEnd start="`" end="`" contains=@perlInterpDQ

syn region perlShellCommand	matchgroup=perlStringStartEnd start=+\<qx\_s\+\z(\i\)+ skip=+\\\z1+ end=+\z1+ contains=@perlInterpDQ
syn region perlShellCommand	matchgroup=perlStringStartEnd start=+\<qx\_s*\z([^a-zA-Z0-9_[:space:]\[({<']\)+ skip=+\\\z1+ end=+\z1+ contains=@perlInterpDQ
syn region perlShellCommand	matchgroup=perlStringStartEnd start=+\<qx\_s*'+ skip=+\\'+ end=+'+ contains=@perlInterpSQ
syn region perlShellCommand	matchgroup=perlStringStartEnd start=+\<qx\_s*(+ end=+)+ contains=perlBracketsDQ,@perlInterpDQ
syn region perlShellCommand	matchgroup=perlStringStartEnd start=+\<qx\_s*{+ end=+}+ contains=perlCBracketsDQ,@perlInterpDQ
syn region perlShellCommand	matchgroup=perlStringStartEnd start=+\<qx\_s*\[+ end=+\]+ contains=perlSBracketsDQ,@perlInterpDQ
syn region perlShellCommand	matchgroup=perlStringStartEnd start=+\<qx\_s*<+ end=+>+ contains=perlABracketsDQ,@perlInterpDQ

" Constants
"
" Numbers
syn match  perlNumber		"[-+]\=\(\<\d[[:digit:]_]*L\=\>\|0[xX]\x[[:xdigit:]_]*\>\)"
syn match  perlFloat		"[-+]\=\<\d[[:digit:]_]*[eE][\-+]\=\d\+"
syn match  perlFloat		"[-+]\=\<\d[[:digit:]_]*\.[[:digit:]_]*\([eE][\-+]\=\d\+\)\="
syn match  perlFloat		"[-+]\=\<\.[[:digit:]_]\+\([eE][\-+]\=\d\+\)\="
" 'Numbers' like: 5.7.1 or v5.6.0 or 192.168.1.133 - (These actually become binary strings internally)
syn match  perlNumber           "v\=\<\d[[:digit:]_]*\.\d[[:digit:]_]*\(\.\d[[:digit:]_]*\)\+"

" Simple version of searches and matches
" caters for m//, m## and m[] (and the !/ variant)
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<\s*/+ end=+/[cgimosx]*+ contains=@perlInterpSlash
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<\(!\=m\|qr\)\_s\+\z(\_w\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ keepend end=+\z1[cgimosx]*+ contains=@perlInterpMatch
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<\(!\=m\|qr\)\_s*\z([^a-zA-Z0-9_[:space:]\[{(<']\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ keepend end=+\z1[cgimosx]*+ contains=@perlInterpMatch
syn region perlMatch            matchgroup=perlMatchStartEnd start=+\<\(!\=m\|qr\)\_s*'+ skip=+\(\\\)\@<!\(\\\\\)*\\'+ end=+'[cgimosx]*+ contains=@perlInterpSQ
syn region perlMatch            matchgroup=perlMatchStartEnd start=+\<\(!\=m\|qr\)\_s*{+ end=+}[cgimosx]*+ contains=perlCBracketsMatch,@perlInterpMatch
syn region perlMatch            matchgroup=perlMatchStartEnd start=+\<\(!\=m\|qr\)\_s*\[+ end=+\][cgimosx]*+ contains=perlSBracketsMatch,@perlInterpMatch
syn region perlMatch            matchgroup=perlMatchStartEnd start=+\<\(!\=m\|qr\)\_s*(+ end=+)[cgimosx]*+ contains=perlBracketsMatch,@perlInterpMatch
syn region perlMatch            matchgroup=perlMatchStartEnd start=+\<\(!\=m\|qr\)\_s*<+ end=+>[cgimosx]*+ contains=perlABracketsMatch,@perlInterpMatch

" Below some hacks to recognise the // variant. This is virtually impossible to catch in all
" cases as the / is used in so many other ways, but these should be the most obvious ones.
syn region perlMatch		matchgroup=perlMatchStartEnd start=+^split /+lc=5 start=+[^$@%]\<split /+lc=6 start=+^if /+lc=2 start=+[^$@%]if /+lc=3 start=+[!=]\~\_s*/+lc=2 start=+[(~]/+lc=1 start=+\.\./+lc=2 start=+\_s/[^= \t0-9$@%]+lc=1,me=e-1,rs=e-1 start=+^/+ skip=+\(\\\)\@<!\(\\\\\)*\\/+ end=+/[cgimosx]*+ contains=@perlInterpSlash

" Substitutions
" caters for s///, s### and s[][]
" perlMatch is the first part, perlSubstitution* is the substitution part
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<s\_s\+\z(\i\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ keepend end=+\z1+me=e-1 contains=@perlInterpSlash nextgroup=perlSubstitutionDQ
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<s\_s*\z([^a-zA-Z0-9_[:space:]\[{(<']\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ keepend end=+\z1+me=e-1 contains=@perlInterpSlash nextgroup=perlSubstitutionDQ
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<s\_s*'+ skip=+\(\\\)\@<!\(\\\\\)*\\'+ end=+'+ contains=@perlInterpSQ nextgroup=perlSubstitutionSQ
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<s\_s*\[+ end=+\]+ contains=perlSBracketsMatch,@perlInterpSquare nextgroup=perlSubstitutionDQ
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<s\_s*(+ end=+)+ contains=perlBracketsMatch,@perlInterpMatch nextgroup=perlSubstitutionDQ
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<s\_s*{+ end=+}+ contains=perlCBracketsMatch,@perlInterpMatch nextgroup=perlSubstitutionDQ
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<s\_s*<+ end=+>+ contains=perlABracketsMatch,@perlInterpAngle nextgroup=perlSubstitutionDQ

syn region perlSubstitutionDQ	matchgroup=perlMatchStartEnd start=+\_s*\z(\i\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1[egimosx]*+ contained contains=@perlInterpDQ
syn region perlSubstitutionDQ   matchgroup=perlMatchStartEnd start=+\_s*\z([^a-zA-Z0-9_[:space:]\[{(<']\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1[egimosx]*+ contained contains=@perlInterpDQ
syn region perlSubstitutionSQ   matchgroup=perlMatchStartEnd start=+\_s*'+ skip=+\(\\\)\@<!\(\\\\\)*\\'+ end=+'[egimosx]*+ contained contains=@perlInterpSQ
syn region perlSubstitutionDQ	matchgroup=perlMatchStartEnd start=+\_s*\[+ end=+\][egimosx]*+ contained contains=perlSBracketsDQ,@perlInterpDQ
syn region perlSubstitutionDQ	matchgroup=perlMatchStartEnd start=+\_s*(+ end=+)[egimosx]*+ contained contains=perlBracketsDQ,@perlInterpDQ
syn region perlSubstitutionDQ	matchgroup=perlMatchStartEnd start=+\_s*{+ end=+}[egimosx]*+ contained contains=perlCBracketsDQ,@perlInterpDQ
syn region perlSubstitutionDQ	matchgroup=perlMatchStartEnd start=+\_s*<+ end=+>[egimosx]*+ contained contains=perlABracketsDQ,@perlInterpDQ

" Substitutions
" caters for tr///, tr### and tr[][]
" perlMatch is the first part, perlTranslation* is the second, translator part.
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<\(tr\|y\)\_s\+\z(\i\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1+me=e-1 contains=@perlInterpDQ nextgroup=perlTranslation
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<\(tr\|y\)\_s*\z([^a-zA-Z0-9_[:space:]\[{(<']\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1+me=e-1 contains=@perlInterpDQ nextgroup=perlTranslation
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<\(tr\|y\)\_s*\[+ end=+\]+ contains=perlSBracketsSQ,@perlInterpDQ nextgroup=perlTranslation
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<\(tr\|y\)\_s*(+ end=+)+ contains=perlBracketsSQ,@perlInterpDQ nextgroup=perlTranslation
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<\(tr\|y\)\_s*{+ end=+}+ contains=perlCBracketsSQ,@perlInterpDQ nextgroup=perlTranslation
syn region perlMatch		matchgroup=perlMatchStartEnd start=+\<\(tr\|y\)\_s*<+ end=+>+ contains=perlABracketsSQ,@perlInterpDQ nextgroup=perlTranslation

syn region perlTranslation	matchgroup=perlMatchStartEnd start=+\_s*\z(\i\)/+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1[cds]*+ contained contains=@perlInterpDQ
syn region perlTranslation      matchgroup=perlMatchStartEnd start=+\_s*\z([^a-zA-Z0-9_[:space:]\[{(<']\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1[cds]*+ contained contains=@perlInterpDQ
syn region perlTranslation	matchgroup=perlMatchStartEnd start=+'+ end=+'[cds]*+ contained contains=@perlInterpDQ
syn region perlTranslation	matchgroup=perlMatchStartEnd start=+\[+ end=+\][cds]*+ contained contains=perlSBracketsDQ,@perlInterpDQ
syn region perlTranslation	matchgroup=perlMatchStartEnd start=+(+ end=+)[cds]*+ contained contains=perlBracketsDQ,@perlInterpDQ
syn region perlTranslation	matchgroup=perlMatchStartEnd start=+{+ end=+}[cds]*+ contained contains=perlCBracketsDQ,@perlInterpDQ
syn region perlTranslation	matchgroup=perlMatchStartEnd start=+<+ end=+>[cds]*+ contained contains=perlABracketsDQ,@perlInterpDQ


" The => operator forces a bareword to the left of it to be interpreted as
" a string
syn match  perlString "\<\(\I\|-\)\i*\s*=>"me=e-2

" Strings and q, qq, qw and qr expressions

" Brackets in qq(), qx()
syn region perlBracketsDQ	start=+(+ end=+)+   contained transparent contains=perlBracketsDQ,@perlInterpDQ
syn region perlSBracketsDQ      start=+\[+ end=+\]+ contained transparent contains=perlSBracketsDQ,@perlInterpDQ
syn region perlCBracketsDQ      start=+{+ end=+}+   contained transparent contains=perlCBracketsDQ,@perlInterpDQ
syn region perlABracketsDQ      start=+<+ end=+>+   contained transparent contains=perlABracketsDQ,@perlInterpDQ

" m(), s(), qr()

" FIXME - this next one won't work with @perlInterpMatch
syn region perlBracketsMatch	start=+(+ end=+)+   contained transparent contains=perlBracketsMatch,@perlInterpDQ
syn region perlSBracketsMatch   start=+\[+ end=+\]+ contained transparent contains=perlSBracketsMatch,@perlInterpDQ
syn region perlCBracketsMatch   start=+{+ end=+}+   contained transparent contains=perlCBracketsMatch,@perlInterpMatch
syn region perlABracketsMatch   start=+<+ end=+>+   contained transparent contains=perlABracketsMatch,@perlInterpMatch

" q(), qw(), tr/y()()
syn region perlBracketsSQ	start=+(+ end=+)+ contained transparent contains=perlBracketsSQ,@perlInterpSQ
syn region perlSBracketsSQ      start=+\[+ end=+\]+ contained transparent contains=perlSBracketsSQ,@perlInterpSQ
syn region perlCBracketsSQ      start=+{+ end=+}+ contained transparent contains=perlCBracketsSQ,@perlInterpSQ
syn region perlABracketsSQ      start=+<+ end=+>+ contained transparent contains=perlABracketsSQ,@perlInterpSQ

syn region perlStringUnexpanded	matchgroup=perlStringStartEnd start="'" end="'" contains=@perlInterpSQ
syn region perlString		matchgroup=perlStringStartEnd start=+"+  end=+"+ contains=@perlInterpDQ

syn region perlQW		matchgroup=perlStringStartEnd start=+\<qw\=\_s\+\z(\i\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1+ contains=@perlInterpBS
syn region perlQW		matchgroup=perlStringStartEnd start=+\<qw\=\_s*\(=>\)\@!\z([^a-zA-Z0-9_[:space:]\[{(<]\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1+ contains=@perlInterpBS
syn region perlQW               matchgroup=perlStringStartEnd start=+\<qw\=\_s*\[+ end=+\]+ contains=perlSBracketsSQ,@perlInterpSQ
syn region perlQW               matchgroup=perlStringStartEnd start=+\<qw\=\_s*(+ end=+)+ contains=perlBracketsSQ,@perlInterpSQ
syn region perlQW               matchgroup=perlStringStartEnd start=+\<qw\=\_s*{+ end=+}+ contains=perlCBracketsSQ,@perlInterpSQ
syn region perlQW               matchgroup=perlStringStartEnd start=+\<qw\=\_s*<+ end=+>+ contains=perlABracketsSQ,@perlInterpSQ

syn region perlQQ		matchgroup=perlStringStartEnd start=+\<qq\_s\+\z(\i\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1+ contains=@perlInterpDQ
syn region perlQQ		matchgroup=perlStringStartEnd start=+\<qq\_s*\z([^a-zA-Z0-9_[:space:]\[{(<]\)+ skip=+\(\\\)\@<!\(\\\\\)*\\\z1+ end=+\z1+ contains=@perlInterpDQ
syn region perlQQ               matchgroup=perlStringStartEnd start=+\<qq\_s*\[+ end=+\]+ contains=perlSBracketsDQ,@perlInterpDQ
syn region perlQQ               matchgroup=perlStringStartEnd start=+\<qq\_s*(+ end=+)+ contains=perlBracketsDQ,@perlInterpDQ
syn region perlQQ               matchgroup=perlStringStartEnd start=+\<qq\_s*{+ end=+}+ contains=perlCBracketsDQ,@perlInterpDQ
syn region perlQQ               matchgroup=perlStringStartEnd start=+\<qq\_s*<+ end=+>+ contains=perlABracketsDQ,@perlInterpDQ

" Constructs such as print <<EOF [...] EOF, 'heredocs'

" XXX Any statements after the identifier are in perlString colour (i.e.
" 'if $a' in 'print <<EOF if $a').
if exists("perl_fold")
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\z(\(END_OF_\(SUB\|FUNC\|CODE\)\)\@!\I\i*\)+     end=+^\z1$+ contains=@perlInterpDQ fold
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\_s*"\z(\(END_OF_\(SUB\|FUNC\|CODE\)\)\@![^"]\+\)"+ end=+^\z1$+ contains=@perlInterpDQ fold
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\_s*'\z(\(END_OF_\(SUB\|FUNC\|CODE\)\)\@![^']\+\)'+ end=+^\z1$+ contains=@perlInterpSQ fold
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\_s*""+          end=+^$+    contains=@perlInterpDQ,perlNotEmptyLine fold
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\_s*''+          end=+^$+    contains=@perlInterpSQ,perlNotEmptyLine fold

else
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\z(\(END_OF_\(SUB\|FUNC\|CODE\)\)\@!\I\i*\)+ end=+^\z1$+ contains=@perlInterpDQ
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*"\z(\(END_OF_\(SUB\|FUNC\|CODE\)\)\@![^"]\+\)"+ end=+^\z1$+ contains=@perlInterpDQ
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*'\z(\(END_OF_\(SUB\|FUNC\|CODE\)\)\@![^']\+\)'+ end=+^\z1$+ contains=@perlInterpSQ
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*""+          end=+^$+    contains=@perlInterpDQ,perlNotEmptyLine
  syn region perlHereDoc	matchgroup=perlStringStartEnd start=+<<\s*''+          end=+^$+    contains=@perlInterpSQ,perlNotEmptyLine
endif


" Class declarations
"
syn match  perlPackageDecl	"^\s*package\(\s\+\([A-Za-z0-9_]\|::\|'\)\+\)\=" contains=perlStatementPackage
syn keyword perlStatementPackage	package contained

" Functions
"       sub [name] [(prototype)] {
"
syn region perlFunction		start="\(\_^\|\_W\)\@<=\s*sub\>" end="[;{]"he=e-1 contains=perlStatementSub,perlFunctionPrototype,perlFunctionPRef,perlFunctionName,perlComment
syn keyword perlStatementSub	sub contained

syn match  perlFunctionPrototype	"([^)]*)" contained
if exists("perl_want_scope_in_variables")
   syn match  perlFunctionPRef	"\h\w*::" contained
   syn match  perlFunctionName	"\h\w*:\@!" contained
else
   syn match  perlFunctionName	"\h[[:alnum:]_:]*" contained
endif


" All other # are comments, except ^#!
syn match  perlComment		"#.*" contains=perlTodo
syn match  perlSharpBang	"\%^#!.*"

" Formats
syn region perlFormat		matchgroup=perlStatementIOFunc start="^\s*format\s\+\k\+\s*=\s*$"rs=s+6 end="^\s*\.\s*$" contains=perlFormatName,perlFormatField,perlVarPlainDQ
syn match  perlFormatName	"format\s\+\k\+\s*="lc=7,me=e-1 contained
syn match  perlFormatField	"[@^][|<>~]\+\(\.\.\.\)\=" contained
syn match  perlFormatField	"[@^]#[#.]*" contained
syn match  perlFormatField	"@\*" contained
syn match  perlFormatField	"@[^A-Za-z_|<>~#*]"me=e-1 contained
syn match  perlFormatField	"@$" contained

" __END__ and __DATA__ clauses
if exists("perl_fold")
  syntax region perlDATA		start="^__\(DATA\|END\)__$" skip="." end="." contains=perlPOD fold
else
  syntax region perlDATA		start="^__\(DATA\|END\)__$" skip="." end="." contains=perlPOD
endif


"
" Folding

if exists("perl_fold")
  syn region perlPackageFold start="^package \S\+;$" end="^1;$" end="^package"me=s-1 transparent fold keepend
  syn region perlSubFold     start="^\z(\s*\)sub\>.*[^};]$" end="^\z1}\s*$" end="^\z1}\s*\#.*$" transparent fold keepend
  syn region perlBEGINENDFold start="^\z(\s*\)\(BEGIN\|END\)\>.*[^};]$" end="^\z1}\s*$" transparent fold keepend
  syn sync fromstart
  setlocal foldmethod=syntax
endif


if version >= 508 || !exists("did_perl_syn_inits")
  if version < 508
    let did_perl_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default highlighting.
  HiLink perlSharpBang		PreProc
  HiLink perlControl		PreProc
  HiLink perlInclude		Include
  HiLink perlSpecial		Special
  HiLink perlString		String
  HiLink perlCharacter		Character
  HiLink perlNumber		Number
  HiLink perlFloat		Float
  HiLink perlType		Type
  HiLink perlIdentifier		Identifier
  HiLink perlLabel		Label
  HiLink perlStatement		Statement
  HiLink perlConditional	Conditional
  HiLink perlRepeat		Repeat
  HiLink perlOperator		Operator
  HiLink perlFunction		Function
  HiLink perlFunctionPrototype	perlFunction
  HiLink perlComment		Comment
  HiLink perlTodo		Todo
"  if exists("perl_string_as_statement")
  HiLink perlStringStartEnd	perlStatement
"  else
"    HiLink perlStringStartEnd	perlString
"  endif
  HiLink perlList		perlStatement
  HiLink perlMisc		perlStatement
  HiLink perlVarPlain		perlIdentifier
  HiLink perlVarPlainDQ		perlIdentifier
  HiLink perlFiledescRead	perlIdentifier
  HiLink perlFiledescStatement	perlIdentifier
  HiLink perlVarSimpleMember	perlIdentifier
  HiLink perlVarSimpleMemberName perlString
  HiLink perlVarNotInMatches	perlIdentifier
  HiLink perlVarSlash		perlIdentifier
  HiLink perlQQ			perlString
  HiLink perlQW                 perlString
"  if version >= 600
  HiLink perlHereDoc		perlString
"  else
"    HiLink perlHereIdentifier	perlStringStartEnd
"    HiLink perlUntilEOFDQ	perlString
"    HiLink perlUntilEOFSQ	perlString
"    HiLink perlUntilEmptyDQ	perlString
"    HiLink perlUntilEmptySQ	perlString
"    HiLink perlUntilEOF		perlString		
"  endif
  HiLink perlStringUnexpanded	perlString
  HiLink perlSubstitutionSQ	perlString
  HiLink perlSubstitutionDQ	perlString
  HiLink perlSubstitutionSlash	perlString
  HiLink perlSubstitutionHash	perlString
  HiLink perlSubstitutionBracket perlString
  HiLink perlSubstitutionCurly 	perlString
  HiLink perlSubstitutionPling	perlString
  HiLink perlTranslation	perlString
  HiLink perlMatch		perlString
  HiLink perlMatchStartEnd	perlStatement
  HiLink perlFormatName		perlIdentifier
  HiLink perlFormatField	perlString
  HiLink perlPackageDecl	perlType
  HiLink perlStorageClass	perlType
  HiLink perlPackageRef		perlType
  HiLink perlStatementPackage	perlStatement
  HiLink perlStatementSub	perlStatement
  HiLink perlStatementStorage	perlStatement
  HiLink perlStatementControl	perlStatement
  HiLink perlStatementScalar	perlStatement
  HiLink perlStatementRegexp	perlStatement
  HiLink perlStatementNumeric	perlStatement
  HiLink perlStatementList	perlStatement
  HiLink perlStatementHash	perlStatement
  HiLink perlStatementIOfunc	perlStatement
  HiLink perlStatementFiledesc	perlStatement
  HiLink perlStatementVector	perlStatement
  HiLink perlStatementFiles	perlStatement
  HiLink perlStatementFlow	perlStatement
  HiLink perlStatementScope	perlStatement
  HiLink perlStatementInclude	perlStatement
  HiLink perlStatementProc	perlStatement
  HiLink perlStatementSocket	perlStatement
  HiLink perlStatementIPC	perlStatement
  HiLink perlStatementNetwork	perlStatement
  HiLink perlStatementPword	perlStatement
  HiLink perlStatementTime	perlStatement
  HiLink perlStatementMisc	perlStatement
  HiLink perlMethodMisc		perlStatement
  HiLink perlMethodSuper	perlType
  HiLink perlMethodGTBase	perlStatement
  HiLink perlMethodGTSQL	perlStatement
  HiLink perlMethodGTCGI	perlStatement
  HiLink perlMethodGTApp	perlStatement
  HiLink perlMethodGTTemplate	perlStatement
  HiLink perlMethodGTMisc	perlStatement
  HiLink perlFunctionName	perlIdentifier
  HiLink perlFunctionPRef	perlType
  HiLink perlPOD		perlComment
  HiLink perlShellCommand	perlString
  HiLink perlSpecialAscii	perlSpecial
  HiLink perlSpecialDollar	perlSpecial
  HiLink perlSpecialString	perlSpecial
  HiLink perlSpecialStringU	perlSpecial
  HiLink perlSpecialStringV	perlSpecial
  HiLink perlSpecialMatch	perlSpecial
  HiLink perlSpecialBEOM	perlSpecial
  HiLink perlDATA		perlComment
  
  HiLink perlBrackets		Error
  
  " Possible errors
  HiLink perlNotEmptyLine	Error
  HiLink perlElseIfError	Error
  HiLink perlFuncSpaceError	Error
  HiLink perlSpaceTrailError	Error
  HiLink perlDerefSpaceError	Error

  delcommand HiLink
endif

" Syncing to speed up processing
"
if !exists("perl_no_sync_on_sub")
  syn sync match perlSync	grouphere NONE "^\s*package\s"
  syn sync match perlSync	grouphere perlFunction "^\s*sub\s"
  syn sync match perlSync	grouphere NONE "^}"
endif

if !exists("perl_no_sync_on_global_var")
  syn sync match perlSync	grouphere NONE "^$\I[[:alnum:]_:]+\s*=\s*{"
  syn sync match perlSync	grouphere NONE "^[@%]\I[[:alnum:]_:]+\s*=\s*("
endif

if exists("perl_sync_dist")
  execute "syn sync maxlines=" . perl_sync_dist
else
  syn sync maxlines=100
endif

syn sync match perlSyncPOD	grouphere perlPOD "^=pod"
syn sync match perlSyncPOD	grouphere perlPOD "^=head"
syn sync match perlSyncPOD	grouphere perlPOD "^=item"
syn sync match perlSyncPOD	grouphere NONE "^=cut"

let b:current_syntax = "perl"

" vim: ts=8

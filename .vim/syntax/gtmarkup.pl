#!/usr/bin/perl
#
# This generates the gtmarkup.vim output.  Usage:
#
# ./gtmarkup.pl >gtmarkup.vim
#
# Known bugs:
# <%set foo = Function::call()%> doesn't highlight the right-hand-side properly.

use strict;
use warnings;

if (@ARGV) {
    die <<USAGE;

$0 usage:

$0 >gtmarkup.vim

This program creates the output of gtmarkup.vim.  This exists to simplify the
procedure, as vim's syntax format was giving me too many headaches -
specifically, many patterns need to be repeated, but vim doesn't handle this
very well.

USAGE
}

my %re = (
    begin => '<%\_s*',
    end   => '\_s*%>',
    tilde => '\_s*\~\_s*',
    var_first_piece => '\w\+',
    var_piece => '\$\?\w\+',
    function_package => '\w\+::\w\@=',
    function_left => '\((\|,\|=>\)\@<=\_s*',
    not     => '\<not\>',
    logical => '\<\%(or\|and\)\>',
    comparison => '\%(\<i\?\%(eq\|ne\|[gl][et]\|contains\|like\|starts\?\|ends\?\)\>\|[!<=>]=\|[=<>]\|%>\@!\)',
    bareword => '[a-zA-Z0-9_.]\+',
    assignment => '\([-+*/%^.]\|\<x\|||\|&&\)\?=',
    operator => '\(\_sx\_s\|/\d\+\_s\@=\|\<i/\|[+*%~^/-]\|||\|&&\)',
    filters => '\<\%(\%(' . join('\|', qw/escape_html escapeHTML unescape_html unescapeHTML escape_url escapeURL unescape_url unescapeURL escape_js escapeJS nbsp uc lc ucfirst lcfirst/) . '\)\>\_s*\)\+'
);

$re{begin_tilde}     = "$re{begin}\\%($re{tilde}\\)\\?"; # Begin tag with optional tilde
$re{end_tilde}       = "\\%($re{tilde}\\)\\?$re{end}";   # End tag with optional tilde
$re{begin_behind}    = "\\%($re{begin_tilde}\\)\\\@<=";
$re{end_ahead}       = "\\%($re{end_tilde}\\)\\\@=";
$re{string}          = qq/'\\%(\\%($re{end_tilde}\\)\\\@![^\\']\\|\\\\\\%($re{end_tilde}\\)\\\@!.\\)*'\\|\\"\\%(\\%($re{end_tilde}\\)\\\@![^\\\\"]\\|\\\\\\%($re{end_tilde}\\)\\\@!.\\)*\\"/,
$re{'variable_no$'}  = "$re{var_first_piece}\\%(\\.$re{var_piece}\\)*";
$re{'variable_$'}    = "\\\$$re{'variable_no$'}";
$re{variable}        = "\\\$\\?$re{'variable_no$'}";
$re{function_start}  = "\\%($re{function_package}\\)\\+\\w\\+\\>\\_s*(\\\@=",
$re{function_noargs} = "\\%($re{function_package}\\)\\+\\w\\+\\>\\_s*\\%(\\_s*(\\)\\\@!",
$re{function}        = "\\%($re{function_start}(.\\{-})\\|$re{function_noargs}\\)";
$re{rhs}             = "\\%($re{'variable_$'}\\|$re{string}\\|$re{function}\\|$re{bareword}\\)";
$re{op_rhs}          = "\\%($re{filters}\\_s*\\)\\?\\%($re{'variable_$'}\\|$re{string}\\|$re{bareword}\\)";
$re{if_component}    = "\\%($re{not}\\_s*\\)\\?\\%($re{variable}\\|$re{function}\\)\\%(\\_s*$re{comparison}\\_s*$re{rhs}\\)\\?";

# if looks like:
# if (not)? var

my (@tag, @tag_type);

push @tag_type, 'GTMarkupIf';
push @tag, <<IF;

syn match GTMarkupIf "$re{begin_behind}\\%(if\\%(not\\)\\?\\|unless\\|else\\?if\\)\\>\\_s*\\%($re{if_component}\\%(\\_s*$re{logical}\\_s*$re{if_component}\\)*\\)\\@=" nextgroup=GTMarkupIfNotVar,GTMarkupIfVar,GTMarkupIfVarFunc,GTMarkupIfVarCode,GTMarkupIfVarPiece contained
syn match GTMarkupIfOver "" contained nextgroup=GTMarkupIfOperator,GTMarkupIfLogical

syn match GTMarkupIfNotVar "$re{not}\\_s*" contained nextgroup=GTMarkupIfVar,GTMarkupIfVarPiece,GTMarkupIfVarFunc
syn match GTMarkupIfOperator "$re{comparison}\\_s*" contained nextgroup=GTMarkupIfRHSDollarVar,GTMarkupIfRHSString,GTMarkupIfRHSFunc,GTMarkupIfRHSBareword

syn match GTMarkupIfRHSOver "" contained nextgroup=GTMarkupIfLogical

syn match GTMarkupIfLogical "\\_s*$re{logical}\\_s*" contained nextgroup=GTMarkupIfNotVar,GTMarkupIfVar,GTMarkupIfVarPiece,GTMarkupIfVarFunc,GTMarkupIfVarCode

@{[GTMarkupVar('If', 'GTMarkupIfOver', undef, { not => 1 })]}
@{[GTMarkupFunc('IfVar', 'GTMarkupIfOver')]}
@{[GTMarkupValue('IfRHS', 'GTMarkupIfRHSOver')]}
@{[GTMarkupVar('IfRHS', 'GTMarkupIfRHSOver')]}
@{[GTMarkupFunc('IfRHS', 'GTMarkupIfOver')]}

HiLink GTMarkupIf               Operator
HiLink GTMarkupIfNotVar         Operator
HiLink GTMarkupIfOperator       Operator
HiLink GTMarkupIfLogical        Operator

IF

push @tag_type, 'GTMarkupInitVar';
push @tag, <<INITVAR;

syn match GTMarkupInitVar "$re{begin_behind}init\\_s\\+\\%(array\\|hash\\)\\_s\\+" contained nextgroup=GTMarkupVariable

HiLink GTMarkupInitVar Operator

INITVAR


push @tag_type, 'GTMarkupSet';
push @tag, <<SET;

syn match GTMarkupSet "$re{begin_behind}set\\_s\\+" contained nextgroup=GTMarkupSetVar,GTMarkupSetVarPiece
HiLink GTMarkupSet      Operator

@{[GTMarkupVar('Set', 'GTMarkupSetVarOver', { length => 1 })]}
@{[GTMarkupVar('SetRHS', 'GTMarkupSetVarRHSOp')]}
@{[GTMarkupValue('SetRHS', 'GTMarkupSetVarRHSOp')]}

syn match GTMarkupSetVarOver "\\_s*" contained nextgroup=GTMarkupSetAssignment

syn match GTMarkupSetAssignment "$re{assignment}\\_s*" contained nextgroup=GTMarkupSetVarOpVal,GTMarkupSetFilterVar,GTMarkupOperatorX,GTMarkupVariable,GTMarkupString,GTMarkupBareword
syn match GTMarkupSetFilterVar "$re{filters}\\_s*\\%($re{variable}\\)\\@=" contained nextgroup=GTMarkupVariable
syn region GTMarkupSetVarOpVal start="\\%($re{filters}\\_s*\\)\\?\\%(\\%(\\_sx\\_s\\)\\\@!$re{variable}\\|$re{string}\\)\\_s*$re{operator}\\_s*$re{op_rhs}" end="$re{end_ahead}" contained contains=GTMarkupFilter,GTMarkupOperatorX,GTMarkupSetRHSVariable,GTMarkupSetRHSString

syn match GTMarkupSetVarRHSOp "\\_s*$re{operator}\\_s*" contained nextgroup=GTMarkupString,GTMarkupBareword
syn match GTMarkupSetVarRHSOp "\\_s*$re{operator}\\_s*\\%($re{filters}\\)\\\@=" contained nextgroup=GTMarkupSetVarRHSOpFilter
syn match GTMarkupSetVarRHSOpFilter "$re{filters}\\_s*" contained nextgroup=GTMarkupString,GTMarkupBareword

HiLink GTMarkupSetFilterVar Special
HiLink GTMarkupSetAssignment Operator
HiLink GTMarkupSetVarRHSOp Operator
HiLink GTMarkupSetVarRHSOpFilter Special
SET

push @tag_type, 'GTMarkupOperator';
push @tag, <<OPERATOR;

syn match GTMarkupOperator "$re{begin_behind}\\%($re{filters}\\)\\?\\%($re{string}\\|\\%($re{filters}\\_s\\)\\\@!$re{variable}\\)\\_s*$re{operator}\\_s*\\%($re{op_rhs}$re{end_tilde}\\)\\@=" contained contains=GTMarkupOperatorX,GTMarkupString,GTMarkupFilter,GTMarkupOperatorVar nextgroup=GTMarkupOperatorRHS
syn match GTMarkupOperatorX "\\_s\\\@<=x\\_s\\\@=" contained
syn match GTMarkupOperatorVar "\\%($re{begin_tilde}\\%($re{filters}\\)\\?\\)\\\@<=$re{variable}\\_s*" contained contains=GTMarkupNoDollarVar
syn match GTMarkupOperatorRHS "\\%($re{filters}\\_s*\\)\\?\\%($re{'variable_$'}\\|$re{string}\\|$re{bareword}\\)\\\@=" contains=GTMarkupFilter contained nextgroup=GTMarkupDollarVar,GTMarkupString,GTMarkupBareword

HiLink GTMarkupOperator          Operator
HiLink GTMarkupOperatorX         Operator

OPERATOR

push @tag_type, 'GTMarkupKeyword';
push @tag, <<KEYWORD;

syn keyword GTMarkupKeyword contained else endif endunless endifnot endloop nextloop lastloop endparse

HiLink GTMarkupKeyword Keyword

KEYWORD

push @tag_type, 'GTMarkupFunction';
push @tag, <<FUNC;

syn match GTMarkupFunction "$re{begin_behind}$re{function}$re{end_ahead}" contained contains=GTMarkupFunc

FUNC


push @tag_type, 'GTMarkupInclude';
push @tag, <<INCLUDE;

syn region GTMarkupInclude matchgroup=GTMarkupIncludeKeyword start="$re{begin_behind}include\\_s\\+" end="$re{end_ahead}" contained
syn region GTMarkupInclude matchgroup=GTMarkupIncludeKeyword start="$re{begin_behind}include\\_s\\+\\%($re{'variable_$'}$re{end_tilde}\\)\\\@=" end="$re{end_ahead}" contained contains=GTMarkupDollarVar

HiLink GTMarkupIncludeKeyword           Keyword
HiLink GTMarkupInclude                  Constant

INCLUDE

push @tag_type, 'GTMarkupLoop';
push @tag, <<LOOP;

syn region GTMarkupLoop matchgroup=GTMarkupLoopKeyword start="$re{begin_behind}loop\\_s\\+" end="$re{end_ahead}" contained contains=GTMarkupVariable,GTMarkupFunc,GTMarkupCode

HiLink GTMarkupLoopKeyword              Keyword

LOOP

push @tag_type, 'GTMarkupDUMP';
push @tag, <<DUMP;

syn region GTMarkupDUMP matchgroup=GTMarkupDUMPKeyword start="$re{begin_behind}DUMP\\>" end="$re{end_ahead}" contained contains=GTMarkupVariable

HiLink GTMarkupDUMPKeyword      Keyword

DUMP

push @tag_type, 'GTMarkupFilteredVar';
push @tag, <<FILTERS;

syn match GTMarkupFilter "$re{filters}" contained 
syn match GTMarkupFilteredVar "$re{begin_behind}$re{filters}\\%($re{'variable_no$'}$re{end_tilde}\\)\\@=" contained nextgroup=GTMarkupVar,GTMarkupVarPiece

HiLink GTMarkupFilter                   Special
HiLink GTMarkupFilteredVar              Special

FILTERS

push @tag_type, 'GTMarkupJustVariable';
# The following allows a variable to start with a /, which although permitted
# for basic tags (GForum 1 used them), should be considered deprecated and
# aren't highlighted as part of the variable.
push @tag, <<VAR;

syn match GTMarkupJustVariable "$re{begin_behind}\\%(DUMP\\)\\@!/\\?$re{'variable_no$'}$re{end_ahead}" contained contains=GTMarkupNoDollarVar

VAR

# Warn about incorrect attribute ordering (for luna templates and beyond):
my @attr_order = qw(
    type id rel
    \(href\|src\) \(action\|enctype\|method\) name value \(checked\|selected\) \(rows\|cols\) target
    class style
    \(disabled\|readonly\|maxlength\) accesskey tabindex
    title alt on[a-zA-Z]\+
);
my @attr_match;
push @tag, <<TAG_ORDER_IF;
if exists("gtmarkup_tag_order")
TAG_ORDER_IF
for my $i (0 .. $#attr_order-1) {
    my $wrong_preceding = '\(' . join('\|', @attr_order[$i+1 .. $#attr_order]) . '\)';
    push @tag, <<TAG_ORDER;
    syn match GTMarkupBadTagOrder "\\(\\_s$wrong_preceding=[^>]*\\_s\\)\\@<=$attr_order[$i]=\\@=" contained containedin=htmlArg
    syn match GTMarkupBadTagOrder "\\_s\\@<=$wrong_preceding\\(=[^>]*\\_s$attr_order[$i]=\\)\\@=" contained containedin=htmlArg
TAG_ORDER
}
push @tag, <<TAG_ORDER_LINK;
    hi def link GTMarkupBadTagOrder Todo
endif
TAG_ORDER_LINK


print <<VIM;
" Vim syntax file
" Language: GT::Template Markup
"
" WARNING: DO NOT EDIT THIS FILE!  If you want to make changes, change
" gtmarkup.pl, which generates this file.
"

if !exists("main_syntax")
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'gtmarkup'
endif


command -nargs=+ HiLink hi def link <args>


syn match   GTMarkupPreCompressedSpace  "\\_s\\+\\%(\\n\\?$re{begin}$re{tilde}\\)\\\@="
syn match   GTMarkupPostCompressedSpace "\\%($re{tilde}$re{end}\\n\\?\\)\\\@<=\\_s\\+"

hi GTMarkupPreCompressedSpace term=inverse ctermbg=DarkBlue guibg=DarkBlue
hi GTMarkupPostCompressedSpace term=inverse ctermbg=DarkBlue guibg=DarkBlue

@{[GTMarkupVar('', undef)]}

@{[GTMarkupValue('', undef)]}

syn match  GTMarkupStringEscape "\\\\." contained
syn match  GTMarkupSQEscape "\\\\[\\\\']" contained
syn match  GTMarkupStringVar "\\\$\\w\\+" contained
syn match  GTMarkupStringVar "\\\${\\w\\+\\%(\\.\\\$\\?\\w\\+\\)*}" contained contains=GTMarkupNoDollarVar

HiLink GTMarkupStringEscape             SpecialChar
HiLink GTMarkupSQEscape                 SpecialChar
HiLink GTMarkupStringVar                Identifier

@{[GTMarkupFunc('', undef)]}

syn match GTMarkupFuncPkg  "\\(\\w\\+::\\)\\+" contained nextgroup=GTMarkupFuncFunc
syn match GTMarkupFuncFunc "\\w\\+\\_s*" contained
HiLink GTMarkupFuncPkg         Type
HiLink GTMarkupFuncFunc        Function

syn region  GTMarkupTag      matchgroup=GTMarkupDelimiter start="$re{begin_tilde}" end="$re{end_tilde}" keepend containedin=ALLBUT,GTMarkupComment contains=@{[join ',', @tag_type]}

@{[join '', @tag]}

syn region  GTMarkupComment  matchgroup=GTMarkupDelimiter start="$re{begin_tilde}--" end="--$re{end_tilde}" containedin=ALL contains=GTMarkupComment

syn keyword GTMarkupFixme FIXME TODO TBD XXX contained containedin=htmlComment,htmlCommentPart,GTMarkupComment
HiLink GTMarkupFixme                    Todo

HiLink GTMarkupDelimiter                PreProc
HiLink GTMarkupComment                  Comment

HiLink GTMarkupStringDelimiter          Operator
HiLink GTMarkupBareword                 String



delcommand HiLink

syn sync match GTMarkupSync  grouphere NONE "[\\s\\n]*%>"
syn sync match GTMarkupSync  grouphere NONE "<%[\\s\\n]*"
syn sync maxlines=300

let b:current_syntax = "gtmarkup"
if main_syntax == 'gtmarkup'
  unlet main_syntax
endif


VIM

sub GTMarkupFunc {
    my ($prefix, $nextgroup) = @_;
    $prefix ||= '';
    return <<FUNC;
syn match GTMarkup${prefix}Func "$re{function_noargs}" contained contains=GTMarkupFuncPkg@{[$nextgroup ? " nextgroup=$nextgroup" : ""]}

syn region GTMarkup${prefix}Func start="$re{function_start}" end="("he=s-1,me=s-1 contained contains=GTMarkupFuncPkg nextgroup=GTMarkup${prefix}FuncBind
syn match GTMarkup${prefix}Code "\\w\\+\\_s*(\\\@=" contained nextgroup=GTMarkup${prefix}FuncBind
syn region GTMarkup${prefix}FuncBind start="(" end=")\\_s*" contained contains=GTMarkupString,GTMarkupDollarVar,GTMarkupBareword@{[$nextgroup ? " nextgroup=$nextgroup" : ""]}


HiLink GTMarkup${prefix}Code            Function
FUNC
}

sub GTMarkupVar {
    my ($prefix, $nextgroup, $no, $yes) = @_;
    $prefix ||= '';
    return <<IF;
syn match GTMarkup${prefix}Variable "\\\$\\?\\%($re{'variable_no$'}\\)\\\@=" contained nextgroup=GTMarkup${prefix}Var,GTMarkup${prefix}VarPiece
syn match GTMarkup${prefix}DollarVar "\\\$\\%($re{'variable_no$'}\\)\\\@=" contained nextgroup=GTMarkup${prefix}Var,GTMarkup${prefix}VarPiece
syn match GTMarkup${prefix}NoDollarVar "\\%($re{'variable_no$'}\\)\\\@=" contained nextgroup=GTMarkup${prefix}Var,GTMarkup${prefix}VarPiece
syn match GTMarkup${prefix}Var "$re{var_piece}\\%(\\.$re{var_piece}\\)\\\@=" contained nextgroup=GTMarkup${prefix}VarDot
syn match GTMarkup${prefix}VarDot "\\." contained nextgroup=GTMarkup${prefix}Var,GTMarkup${prefix}VarLength,GTMarkup${prefix}VarPiece
@{[$no->{length} ? "" : qq|syn match GTMarkup${prefix}VarLength "length\\>\\_s*" contained nextgroup=GTMarkup${prefix}Over|]}
syn match GTMarkup${prefix}VarPiece "@{[$no->{length} ? "" : "\\%(length\\)\\\@!"]}@{[$yes->{not} ? "\\%(\\_s\\\@<=$re{not}\\)\\\@!" : ""]}$re{var_piece}\\>\\%(\\.\\)\\\@!\\_s*" contained@{[$nextgroup ? " nextgroup=$nextgroup" : ""]}

HiLink GTMarkup${prefix}Variable            Identifier
HiLink GTMarkup${prefix}DollarVar           Identifier
HiLink GTMarkup${prefix}Var                 Identifier
HiLink GTMarkup${prefix}VarDot              Structure
@{[$no->{length} ? "" : qq|HiLink GTMarkup${prefix}VarLength           Operator|]}
HiLink GTMarkup${prefix}VarPiece            Identifier
IF
}

# A 'string' "value" or bareword
sub GTMarkupValue {
    my ($prefix, $nextgroup) = @_;
    $prefix ||= '';
    return <<VALUE;
syn region GTMarkup${prefix}String matchgroup=GTMarkupStringDelimiter start=+"+ skip="\\\\." end=+"+ contains=GTMarkupStringEscape,GTMarkupStringVar contained@{[$nextgroup ? " nextgroup=$nextgroup" : ""]}
syn region GTMarkup${prefix}String matchgroup=GTMarkupStringDelimiter start="'" skip="\\\\[\\\\']" end="'" contains=GTMarkupSQEscape contained@{[$nextgroup ? " nextgroup=$nextgroup" : ""]}

syn match GTMarkup${prefix}Bareword "$re{bareword}" contained@{[$nextgroup ? " nextgroup=$nextgroup" : ""]}

HiLink GTMarkup${prefix}String          String
HiLink GTMarkup${prefix}Bareword        String
VALUE
}

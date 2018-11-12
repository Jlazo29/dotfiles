" A simple syntax example file. Open colors.example to display how each color
" sytanx group will be highlighted as.
"
syntax keyword exampleComment          Comment
syntax keyword exampleString           String
syntax keyword exampleCharacter        Character
syntax keyword exampleConstant         Constant
syntax keyword exampleNumber           Number
syntax keyword exampleBoolean          Boolean
syntax keyword exampleFloat            Float

syntax keyword exampleIdentifier       Identifier
syntax keyword exampleFunction         Function
syntax keyword exampleNoise            Noise
syntax keyword exampleBrace            Brace

syntax keyword exampleStatement        Statement
syntax keyword exampleConditional      Conditional
syntax keyword exampleRepeat           Repeat
syntax keyword exampleLabel            Label
syntax keyword exampleOperator         Operator
syntax keyword exampleKeyword          Keyword
syntax keyword exampleException        Exception

syntax keyword exampleType             Type
syntax keyword exampleStorageClass     StorageClass
syntax keyword exampleStructure        Structure
syntax keyword exampleTypedef          Typedef

syntax keyword exampleSpecial          Special
syntax keyword exampleSpecialChar      SpecialChar
syntax keyword exampleTag              Tag
syntax keyword exampleDelimiter        Delimiter
syntax keyword exampleSpecialComment   SpecialComment
syntax keyword exampleDebug            Debug

syntax keyword examplePreProc          PreProc
syntax keyword exampleInclude          Include
syntax keyword exampleDefine           Define
syntax keyword exampleMacro            Macro
syntax keyword examplePreCondit        PreCondit

if version >= 508 || !exists("did_typescript_syn_inits")
  if version < 508
    let did_typescript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink exampleComment        Comment
  HiLink exampleString         String
  HiLink exampleCharacter      Character
  HiLink exampleConstant       Constant
  HiLink exampleNumber         Number
  HiLink exampleBoolean        Boolean
  HiLink exampleFloat          Float

  HiLink exampleIdentifier     Identifier
  HiLink exampleFunction       Function
  HiLink exampleNoise          Noise
  HiLink exampleBrace          Brace

  HiLink exampleStatement      Statement
  HiLink exampleConditional    Conditional
  HiLink exampleRepeat         Repeat
  HiLink exampleLabel          Label
  HiLink exampleOperator       Operator
  HiLink exampleKeyword        Keyword
  HiLink exampleException      Exception

  HiLink exampleType           Type
  HiLink exampleStorageClass   StorageClass
  HiLink exampleStructure      Structure
  HiLink exampleTypedef        Typedef

  HiLink exampleSpecial        Special
  HiLink exampleSpecialChar    SpecialChar
  HiLink exampleTag            Tag
  HiLink exampleDelimiter      Delimiter
  HiLink exampleSpecialComment SpecialComment
  HiLink exampleDebug          Debug

  HiLink examplePreProc        PreProc
  HiLink exampleInclude        Include
  HiLink exampleDefine         Define
  HiLink exampleMacro          Macro
  HiLink examplePreCondit      PreCondit
  delcommand HiLink
endif

module Syntax

layout Layout = WhitespaceAndComment* !>> [\t\n\r\ ];
lexical WhitespaceAndComment = [\t\n\r\ ];

// Símbolo inicial del programa
start syntax Program 
    = aluProgram: Module* components
;

syntax Module 
    = dataBlock: Data dataDef
    | funcBlock: Function funcDef
;

syntax Data 
    = dataStructure: 
        Identifier title "=" "data" "with" 
        Identifier initialField ("," Identifier subsequentFields)*
        Identifier structLabel "=" "struct" Structoption structType
        Function* methods
        "end" Identifier endToken
;

syntax Structoption 
    = seqVariant: Sequence seqDef
    | pairVariant: Tuple tupleDef
;

syntax Sequence 
    = seqDeclaration: "sequence" "(" Identifier firstElem ("," Identifier otherElems)* ")"
;

syntax Tuple 
    = pairDeclaration: "(" Identifier elem1 "," Identifier elem2 ")"
;

syntax Function 
    = funcDeclaration: 
        Identifier funcId "=" "function" Fparameterset signature "do"
        Fexpressionset bodyExprs
        "end" Identifier endTag
;

syntax Fparameterset 
    = emptySignature: "()"
    | filledSignature: "(" {Identifier ","}+ paramNames ")"
;

syntax Fexpressionset 
    = bodySequence: Expression* statements
;

syntax Expression 
    = mathExpr: Arithmetic computation
    | flowExpr: Flow controlFlow
    | pathExpr: Access navigation
;

syntax Arithmetic 
    = baseValue: Term operand
    | sumOp: Arithmetic operandLeft "+" Term operandRight
    | diffOp: Arithmetic operandLeft "-" Term operandRight
;

syntax Term 
    = factorValue: Fact element
    | prodOp: Term operandLeft "*" Fact operandRight
    | quotOp: Term operandLeft "/" Fact operandRight
    | powerOp: Term operandLeft "**" Fact operandRight
    | modOp: Term operandLeft "%" Fact operandRight
;

syntax Fact 
    = wrappedArith: "(-)"* signs "(" Arithmetic expression ")"
    | wrappedDigit: "(-)"* signs "(" Digit+ number ")"
    | wrappedDecimal: "(-)"* signs "(" Decimal floatNum ")"
    | wrappedId: "(-)"* signs "(" Identifier symbol ")"
    | wrappedAccess: "(-)"* signs "(" Access path ")"
;

syntax Flow 
    = switchStmt: Condblock condSwitch
    | branchStmt: Ifblock ifBranch
    | iterStmt: Forblock forIter
;

syntax Condblock 
    = multiCase: "cond" Identifier condId "do" Option* cases "end"
;

syntax Option 
    = caseClause: Conditional test "-" "\>" Result value
;

syntax Conditional =
    ltComp:      Arithmetic operandLeft '\<'  Arithmetic operandRight
    | gtComp:      Arithmetic operandLeft '\>'  Arithmetic operandRight
    | leqComp:     Arithmetic operandLeft '\<=' Arithmetic operandRight
    | geqComp:     Arithmetic operandLeft '\>=' Arithmetic operandRight
    | eqComp:      Arithmetic operandLeft '='  Arithmetic operandRight
    | neqComp:     Arithmetic operandLeft '\<\>' Arithmetic operandRight
    | boolTrue:    "true"
    | boolFalse:   "false"
    | varTest:     Identifier variable
;

syntax Result 
    = computedValue: Expression evaluation
;

syntax Ifblock 
    = branchConstruct: "if" Conditional predicate "then" Expression whenTrue "else" Expression whenFalse "end"
;

syntax Forblock 
    = numericIter: "for" Identifier index "from" Expression lowerBound "to" Expression upperBound "do" Fexpressionset iterations "end"
    | elementIter: "for" Identifier item "in" Identifier container "do" Fexpressionset iterations "end"
;

syntax Access 
    = dollarPath: Dollaraccess dollarOp
    | memberPath: Dotaccess dotOp
    | callPath: Builtinaccess invocation
;

syntax Dollaraccess 
    = dollarAccess: Identifier target "$" Dollarparameterset arguments
;

syntax Dollarparameterset 
    = mappingArgs: "(" Identifier key1 ":" Expression val1 ("," Identifier keyN ":" Expression valN)* ")"
;

syntax Dotaccess 
    = propertyAccess: Identifier entity "." Identifier property
;

syntax Builtinaccess 
    = zeroAryCall: Identifier funcName "()"
    | nAryCall: Identifier funcName "(" {ArgumentItem ","}+ params ")"
;

syntax ArgumentItem
    = simpleArg: Identifier name
    | complexArg: Expression value
;

// Tokens léxicos
lexical Identifier = [a-z][a-z0-9]* !>> Reserved;

lexical Digit = [0-9];

lexical Decimal = [0-9]+ "." [0-9]+;

// Palabras reservadas
keyword Reserved = 
    "cond" | "do" | "data" | "if" | "else" | "elseif" | "end" | "for" | 
    "from" | "then" | "function" | "in" | "iterator" | "sequence" | 
    "struct" | "to" | "tuple" | "type" | "with" | "yielding" | 
    "true" | "false" | "and" | "or" | "neg";

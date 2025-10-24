module Syntax

layout Layout = WhitespaceAndComment* !>> [\t\n\r\ ];
lexical WhitespaceAndComment 
    = [\t\n\r\ ]
    | "//" ![\n]* [\n]
    ;

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
    > left sumOp: Arithmetic left "+" Term right
    | left diffOp: Arithmetic left "-" Term right
;

syntax Term 
    = factorValue: Fact element
    > left prodOp: Term left "*" Fact right
    | left quotOp: Term left "/" Fact right
    | right powerOp: Term left "**" Fact right
    | left modOp: Term left "%" Fact right
;

syntax Fact 
    = negative: "(-)" Fact inner
    | wrappedArith: "(" Arithmetic expression ")"
    | wrappedDigit: "(" Digit+ number ")"
    | wrappedDecimal: "(" Decimal floatNum ")"
    | wrappedId: "(" Identifier symbol ")"
    | wrappedAccess: "(" Access path ")"
;

syntax Flow 
    = switchStmt: Condblock condSwitch
    | branchStmt: Ifblock ifBranch
    | iterStmt: Forblock forIter
;

syntax Condblock 
    = multiCase: "cond" Identifier condId "do" CaseOption* cases "end"
;


syntax CaseOption 
    = caseClause: Condition condition "-" "\>" CaseResult resultValue
;


syntax Condition 
    = ltComp: Arithmetic left "\<" Arithmetic right
    | gtComp: Arithmetic left "\>" Arithmetic right
    | leqComp: Arithmetic left "\<=" Arithmetic right
    | geqComp: Arithmetic left "\>=" Arithmetic right
    | eqComp: Arithmetic left "=" Arithmetic right
    | neqComp: Arithmetic left "\<\>" Arithmetic right
    | boolTrue: "true"
    | boolFalse: "false"
    | varTest: Identifier variable
;


syntax CaseResult 
    = computedValue: Expression evaluation
;

syntax Ifblock 
    = branchConstruct: "if" Condition predicate "then" Expression whenTrue "else" Expression whenFalse "end"
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
    = mappingArgs: "(" {KeyValuePair ","}+ pairs ")"
;

syntax KeyValuePair 
    = keyValue: Identifier key ":" Expression val
;

syntax Dotaccess 
    = propertyAccess: Identifier entity "." Identifier property
;

syntax Builtinaccess 
    = zeroAryCall: Identifier funcName "()"
    | nAryCall: Identifier funcName "(" {ArgumentItem ","}+ params ")"
;

syntax ArgumentItem
    = simpleArg: Identifier argName
    | complexArg: Expression expr
;

lexical Identifier = ([a-z][a-z0-9\-]*) !>> [a-z0-9\-] \ Reserved;

lexical Digit = [0-9];

lexical Decimal = [0-9]+ "." [0-9]+;

keyword Reserved = 
    "cond" | "do" | "data" | "if" | "else" | "elseif" | "end" | "for" | 
    "from" | "then" | "function" | "in" | "iterator" | "sequence" | 
    "struct" | "to" | "tuple" | "type" | "with" | "yielding" | 
    "true" | "false" | "and" | "or" | "neg";

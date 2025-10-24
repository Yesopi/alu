module AST

data Program = aluProgram(list[Module] components);

data Module 
    = dataBlock(Data dataDef)
    | funcBlock(Function funcDef);

data Data = dataStructure(
    str title, 
    str initialField, 
    list[str] subsequentFields, 
    str structLabel, 
    Structoption structType, 
    list[Function] methods, 
    str endToken
);

data Structoption 
    = seqVariant(Sequence seqDef) 
    | pairVariant(Tuple tupleDef);

data Sequence = seqDeclaration(
    str firstElem, 
    list[str] otherElems
);

data Tuple = pairDeclaration(str elem1, str elem2);

data Function = funcDeclaration(
    str funcId, 
    Fparameterset signature, 
    Fexpressionset bodyExprs, 
    str endTag
);

data Fparameterset 
    = emptySignature() 
    | filledSignature(list[str] paramNames);

data Fexpressionset = bodySequence(list[Expression] statements);

data Expression 
    = mathExpr(Arithmetic computation) 
    | flowExpr(Flow controlFlow) 
    | pathExpr(Access navigation);

data Arithmetic 
    = baseValue(Term operand) 
    | sumOp(Arithmetic left, Term right) 
    | diffOp(Arithmetic left, Term right);

data Term 
    = factorValue(Fact element) 
    | prodOp(Term left, Fact right) 
    | quotOp(Term left, Fact right) 
    | powerOp(Term left, Fact right) 
    | modOp(Term left, Fact right);

data Fact 
    = negative(Fact inner)
    | wrappedArith(Arithmetic expression)
    | wrappedDigit(int number)
    | wrappedDecimal(real floatNum)
    | wrappedId(str symbol)
    | wrappedAccess(Access path);

data Flow 
    = switchStmt(Condblock condSwitch) 
    | branchStmt(Ifblock ifBranch) 
    | iterStmt(Forblock forIter);

data Condblock = multiCase(str condId, list[CaseOption] cases);

// ✅ TOTALMENTE CORREGIDO: test → condition, value → resultValue
data CaseOption = caseClause(Condition condition, CaseResult resultValue);

data Condition 
    = ltComp(Arithmetic left, Arithmetic right) 
    | gtComp(Arithmetic left, Arithmetic right) 
    | leqComp(Arithmetic left, Arithmetic right) 
    | geqComp(Arithmetic left, Arithmetic right) 
    | eqComp(Arithmetic left, Arithmetic right) 
    | neqComp(Arithmetic left, Arithmetic right) 
    | boolTrue() 
    | boolFalse() 
    | varTest(str variable);

data CaseResult = computedValue(Expression evaluation);

data Ifblock = branchConstruct(
    Condition predicate, 
    Expression whenTrue, 
    Expression whenFalse
);

data Forblock 
    = numericIter(str index, Expression lowerBound, Expression upperBound, Fexpressionset iterations)
    | elementIter(str item, str container, Fexpressionset iterations);

data Access 
    = dollarPath(Dollaraccess dollarOp) 
    | memberPath(Dotaccess dotOp) 
    | callPath(Builtinaccess invocation);

data Dollaraccess = dollarAccess(str target, Dollarparameterset arguments);

data Dotaccess = propertyAccess(str entity, str property);

data Builtinaccess 
    = zeroAryCall(str funcName) 
    | nAryCall(str funcName, list[ArgumentItem] params);

data ArgumentItem 
    = simpleArg(str argName) 
    | complexArg(Expression expr);
data KeyValuePair = keyValue(str key, Expression val);
data Dollarparameterset = mappingArgs(list[KeyValuePair] pairs);
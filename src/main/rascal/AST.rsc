module AST

data Program = aluProgram(list[Module] components);

data Module = dataBlock(Data dataDef)
            | funcBlock(Function funcDef);

data Data = dataStructure(Identifier title, "=", "data", "with", Identifier initialField, list[Identifier] subsequentFields, Identifier structLabel, "=", "struct", Structoption structType, list[Function] methods, "end", Identifier endToken);

data Identifier = id(Identifier name);//Duda sobre qué hacer con los tres lexical

data Digit = digit(Digit number);//

data Decimal = decimal(Decimal floatNum);//

data Structoption = seqVariant(Sequence seqDef) | pairVariant(Tuple tupleDef);

data Sequence = seqDeclaration("sequence", "(", Identifier firstElem, list[Identifier] otherElems, ")");

data Tuple = pairDeclaration("(", Identifier elem1, ",", Identifier elem2, ")");

data Function = funcDeclaration(Identifier funcId, "=", "function", Fparameterset signature, "do", Fexpressionset bodyExprs, "end", Identifier endTag);

data Fparameterset = emptySignature("()") | filledSignature("(" ,list[Identifier] paramNames ,")");

data Fexpressionset = bodySequence(list[Expression] statements);

data Expression = mathExpr(Arithmetic computation) | flowExpr(Flow controlFlow) | pathExpr(Access navigation);

data Arithmetic = baseValue(Term operand) | sumOp(Arithmetic operandLeft, "+", Term operandRight) | diffOp(Arithmetic operandLeft, "-", Term operandRight);

data Term = factorValue(Fact element) | prodOp(Term operandLeft, "*", Fact operandRight) | quotOp(Term operandLeft, "/", Fact operandRight) | powerOp(Term operandLeft, "**", Fact operandRight) | modOp(Term operandLeft, "%", Fact operandRight);

data Fact = wrappedArith(list["(-)"] signs, "(", Arithmetic expression, ")") | wrappedDigit(list["(-)"] signs, "(", list[Digit] number, ")") | wrappedDecimal(list["(-)"] signs, "(", Decimal floatNum, ")") | wrappedId(list["(-)"] signs, "(", Identifier symbol, ")") | wrappedAccess(list["(-)"] signs, "(", Access path, ")");

data Flow = switchStmt(Condblock condSwitch) | branchStmt(Ifblock ifBranch) | iterStmt(Forblock forIter);

data Condblock = multiCase( "cond", Identifier condId, "do", list[Option] cases, "end");

data Option = caseClause(Conditional tests, "-" , "\>", Result values);

data Conditional = ltComp(Arithmetic operandLeft, "\<", Arithmetic operandRight) | gtComp(Arithmetic operandLeft, "\>", Arithmetic operandRight) | leqComp(Arithmetic operandLeft, "\<=", Arithmetic operandRight) | geqComp(Arithmetic operandLeft, "\>=", Arithmetic operandRight) | eqComp(Arithmetic operandLeft, "=", Arithmetic operandRight) | neqComp(Arithmetic operandLeft, "\<\>", Arithmetic operandRight) | boolTrue("true") | boolFalse("false") | varTest(Identifier variable);

data Result = computedValue(Expression evaluation);

data Ifblock = branchConstruct( "if", Conditional predicate, "then", Expression whenTrue, "else", Expression whenFalse, "end");

data Forblock = numericIter( "for", Identifier index, "from", Expression lowerBound, "to", Expression upperBound, "do", Fexpressionset iterations, "end") | elementIter("for", Identifier item, "in", Identifier container, "do", Fexpressionset iterations, "end");

data Access = dollarPath(Dollaraccess dollarOp) | memberPath(Dotaccess dotOp) | callPath(Builtinaccess invocation);

data Dollaraccess = dollarAccess( Identifier target, "$", Dollarparameterset arguments);

data Dollarparameterset = mappingArgs("(", list[tuple[Identifier, Expression]] keyValuePairs, ")");

data Dotaccess = propertyAccess(Identifier entity, ".", Identifier property);

data Builtinaccess = zeroAryCall(Identifier funcName, "()") | nAryCall(Identifier funcName, "(", list[ArgumentItem] params, ")");

data ArgumentItem = simpleArg(Identifier name) | complexArg(Expression values);
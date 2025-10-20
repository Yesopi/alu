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

data Fparameterset = emptySignature("(",")") | filledSignature("(" ,list[Identifier] paramNames ,")");

data Fexpressionset = bodySequence(list[Expression] statements);

data Expression = mathExpr(Arithmetic computation) | flowExpr(Flow controlFlow) | pathExpr(Access navigation);

data Arithmetic = baseValue(Term operand) | sumOp(Arithmetic sum_operandLeft, "+", Term sum_operandRight) | diffOp(Arithmetic diff_operandLeft, "-", Term diff_operandRight);

data Term = factorValue(Fact element) | prodOp(Term prod_operandLeft, "*", Fact prod_operandRight) | quotOp(Term quot_operandLeft, "/", Fact quot_operandRight) | powerOp(Term power_operandLeft, "**", Fact power_operandRight) | modOp(Term mod_operandLeft, "%", Fact mod_operandRight);

data Fact = wrappedArith(list["(-)"] signs, "(", Arithmetic expression, ")") | wrappedDigit(list["(-)"] signs, "(", list[Digit] number, ")") | wrappedDecimal(list["(-)"] signs, "(", Decimal floatNum, ")") | wrappedId(list["(-)"] signs, "(", Identifier symbol, ")") | wrappedAccess(list["(-)"] signs, "(", Access path, ")");

data Flow = switchStmt(Condblock condSwitch) | branchStmt(Ifblock ifBranch) | iterStmt(Forblock forIter);

data Condblock = multiCase( "cond", Identifier condId, "do", list[Option] cases, "end");

data Option = caseClause(Conditional tests, "-" , "\>", Result values);

data Conditional = ltComp(Arithmetic lt_operandLeft, "\<", Arithmetic lt_operandRight) | gtComp(Arithmetic gt_operandLeft, "\>", Arithmetic gt_operandRight) | leqComp(Arithmetic leq_operandLeft, "\<=", Arithmetic leq_operandRight) | geqComp(Arithmetic geq_operandLeft, "\>=", Arithmetic geq_operandRight) | eqComp(Arithmetic eq_operandLeft, "=", Arithmetic eq_operandRight) | neqComp(Arithmetic neq_operandLeft, "\<\>", Arithmetic neq_operandRight) | boolTrue("true") | boolFalse("false") | varTest(Identifier variable);

data Result = computedValue(Expression evaluation);

data Ifblock = branchConstruct( "if", Conditional predicate, "then", Expression whenTrue, "else", Expression whenFalse, "end");

data Forblock = numericIter( "for", Identifier index, "from", Expression lowerBound, "to", Expression upperBound, "do", Fexpressionset iterations, "end") | elementIter("for", Identifier item, "in", Identifier container, "do", Fexpressionset iterations, "end");

data Access = dollarPath(Dollaraccess dollarOp) | memberPath(Dotaccess dotOp) | callPath(Builtinaccess invocation);

data Dollaraccess = dollarAccess( Identifier target, "$", Dollarparameterset arguments);

data Dollarparameterset = mappingArgs("(", list[tuple[Identifier, Expression]] keyValuePairs, ")");

data Dotaccess = propertyAccess(Identifier entity, ".", Identifier property);

data Builtinaccess = zeroAryCall(Identifier zero_funcName, "(",")") | nAryCall(Identifier nAry_funcName, "(", list[ArgumentItem] params, ")");

data ArgumentItem = simpleArg(Identifier name) | complexArg(Expression values);
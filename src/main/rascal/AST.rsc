module AST

data Program = aluProgram(list[Module] components);

data Module = dataBlock(Data dataDef)
            | funcBlock(Function funcDef);

data Data = dataStructure(Identifier title, "=", "data", "with", Identifier initialField, list[Identifier] subsequentFields, Identifier structLabel, "=", "struct", Structoption structType, list[Function] methods, "end", Identifier endToken);

data Identifier= id(Identifier name); 

data Structoption = seqVariant(Sequence seqDef) | pairVariant(Tuple tupleDef);

data Sequence = seqDeclaration("sequence", "(", Identifier firstElem, list[Identifier] otherElems, ")");

data Tuple = pairDeclaration("(", Identifier elem1, ",", Identifier elem2, ")");

data Function = funcDeclaration(Identifier funcId, "=", "funcion", Fparameterset signature, "do", Fexpressionset bodyExprs, "end", Identifier endTag);

data Fparameterset = emptySignature("()") | filledSignature("(" ,list[Identifier] paramNames ,")");

data Fexpressionset = bodySequence(list[Expression] statements);

data Expression = mathExpr(Arithmetic computation) | flowExpr(Flow controlFlow) | pathExpr(Access navigation);

data Arithmetic = baseValue(Term operand) | sumOp(Arithmetic operandLeft, "+", Term operandRight) | diffOp(Arithmetic operandLeft, "-", Term operandRight);
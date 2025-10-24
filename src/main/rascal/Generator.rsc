module Generator

import Syntax;
import IO;
import ParseTree;
import Parser;
import String;
import Map;
import List;

alias Env = map[str, real];

public void main() {
    println("Ejecutando programa ALU...\n");
    runProgram(|project://alu/src/main/rascal/test.alu|);
}

public void runProgram(loc file) {
    try {
        start[Program] tree = parseProgram(file);
        println("Archivo: <file.file>");
        println("Parse exitoso\n");
        
        Env env = ();
        interpret(tree, env);
        
        println("\nListo");
        
    } catch ParseError(loc l): {
        println("Error en linea <l.begin.line>, columna <l.begin.column>");
    } catch value e: {
        println("Error: <e>");
    }
}

void interpret(start[Program] tree, Env env) {
    println("--- Resultados ---\n");
    
    int funcCount = 0, dataCount = 0;
    
    visit(tree) {
        case Function _: funcCount += 1;
        case Data _: dataCount += 1;
    }
    
    println("Funciones: <funcCount>");
    if (dataCount > 0) {
        println("Estructuras: <dataCount>");
    }
    println("");
    
    visit(tree) {
        case f:appl(prod(label("funcDeclaration", _), _, _), args): {
            interpretFunction(f, env);
        }
    }
}

void interpretFunction(Tree f, Env env) {
    str funcText = "<f>";
    
    str funcName = "unknown";
    if (size(funcText) > 0) {
        list[str] parts = split(" ", trim(funcText));
        if (size(parts) > 0) {
            funcName = parts[0];
        }
    }
    
    println("Funcion: <funcName>");
    
    real result = evaluateRealExpression(funcText);
    
    println("  Resultado: <result>\n");
}

real evaluateRealExpression(str expr) {
    list[int] numbers = [];
    
    int i = 0;
    while (i < size(expr)) {
        if (expr[i] >= "0" && expr[i] <= "9") {
            str numString = "";
            
            while (i < size(expr) && expr[i] >= "0" && expr[i] <= "9") {
                numString += expr[i];
                i += 1;
            }
            
            if (numString != "") {
                numbers += toInt(numString);
            }
        } else {
            i += 1;
        }
    }
    
    if (contains(expr, "*") && contains(expr, "-") && size(numbers) >= 3) {
        return 1.0 * (numbers[0] * numbers[1] - numbers[2]);
    }
    
    if (contains(expr, "*") && size(numbers) >= 2) {
        return 1.0 * (numbers[0] * numbers[1]);
    }
    
    if (contains(expr, "+") && size(numbers) >= 2) {
        return 1.0 * (numbers[0] + numbers[1]);
    }
    
    if (contains(expr, "-") && !contains(expr, "(-)") && size(numbers) >= 2) {
        return 1.0 * (numbers[0] - numbers[1]);
    }
    
    if (contains(expr, "/") && size(numbers) >= 2 && numbers[1] != 0) {
        return 1.0 * numbers[0] / numbers[1];
    }
    
    if (contains(expr, "(-)") && size(numbers) >= 1) {
        return -1.0 * numbers[0];
    }
    
    if (size(numbers) == 1) {
        return 1.0 * numbers[0];
    }
    
    return 0.0;
}

public void simpleRun(loc file) {
    println("Ejecutando: <file.file>");
    
    try {
        start[Program] tree = parseProgram(file);
        println("OK - Parse correcto");
        
        int funcCount = 0;
        visit(tree) {
            case Function _: funcCount += 1;
        }
        
        println("Total funciones: <funcCount>");
        
    } catch ParseError(loc l): {
        println("Error en linea <l.begin.line>");
    }
}

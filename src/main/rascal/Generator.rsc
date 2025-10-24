module Generator

import IO;
import ParseTree;
import Syntax;
import List;
import String;
import util::Maybe;

public void main() {
    println("═════════════════════════════════════════════");
    println("        EJECUTANDO PROGRAMA ALU");
    println("═════════════════════════════════════════════\n");
    
    runALU(|project://alu/test.alu|);
}

public void runALU(loc file) {
    try {
        // Parsear el archivo
        start[Program] tree = parse(#start[Program], file);
        println(" Parse exitoso de <file.file>\n");
        
        // Analizar el programa
        analyzeProgram(tree);
        
        println("\n Ejecución completada");
        
    } catch ParseError(loc l): {
        println("❌Error de parseo en línea <l.begin.line>, columna <l.begin.column>");
    } catch value v: {
        println(" Error durante ejecución: <v>");
    }
}

// =============================================================
// 🧩 Análisis del programa
// =============================================================

public void analyzeProgram(start[Program] tree) {
    println("═════════════════════════════════════════════");
    println("           ANÁLISIS DEL PROGRAMA");
    println("═════════════════════════════════════════════\n");
    
    int moduleCount = 0;
    int funcCount = 0;
    int dataCount = 0;
    
    // Contar módulos
    visit(tree) {
        case Module m: {
            moduleCount += 1;
            
            // Detectar si es función o data
            if (/Function _ := m) {
                funcCount += 1;
            }
            
            if (/Data d := m) {
                dataCount += 1;
                analyzeData(d);
            }
        }
    }
    
    println("\nEstadísticas:");
    println("  • Total módulos: <moduleCount>");
    println("  • Funciones: <funcCount>");
    println("  • Estructuras: <dataCount>\n");
    
    println("═════════════════════════════════════════════");
}


public void analyzeData(Data d) {
    visit(d) {
        case appl(prod(label("dataStructure", _), _, _), args): {
            str title = extractTextFromTree(args[0]);
            str structLabel = extractTextFromTree(args[3]);
            
            println("\n┌─────────────────────────────────────────");
            println("│ ESTRUCTURA: <title>");
            println("├─────────────────────────────────────────");
            println("│ Etiqueta: <structLabel>");
            
            // Extraer campos - SIMPLIFICADO
            println("│ Campos:");
            str field1 = extractTextFromTree(args[1]);
            println("│   • <field1>");
            
            str otherFields = extractTextFromTree(args[2]);
            if (otherFields != "") {
                for (str f <- split(",", otherFields)) {
                    str cleaned = trim(f);
                    if (cleaned != "" && cleaned != ",") {
                        println("│   • <cleaned>");
                    }
                }
            }
            
            // Contar métodos
            int methodCount = countMethods(args[5]);
            println("│ Métodos: <methodCount>");
            
            if (methodCount > 0) {
                extractMethods(args[5]);
            }
            
            println("└─────────────────────────────────────────");
        }
    }
}


str extractTextFromTree(Tree t) {
    if (char(int c) := t) {
        return stringChar(c);
    }
    
    if (appl(_, list[Tree] args) := t) {
        return ("" | it + extractTextFromTree(arg) | arg <- args);
    }
    
    return "";
}

int countMethods(Tree methodsTree) {
    int count = 0;
    visit(methodsTree) {
        case Function _: count += 1;
    }
    return count;
}

void extractMethods(Tree methodsTree) {
    visit(methodsTree) {
        case appl(prod(label("funcDeclaration", _), _, _), args): {
            str funcName = extractTextFromTree(args[0]);
            str params = extractParams(args[1]);
            println("│   → <funcName>(<params>)");
        }
    }
}

str extractParams(Tree paramsTree) {
    visit(paramsTree) {
        case appl(prod(label("emptySignature", _), _, _), _):
            return "sin parámetros";
        case appl(prod(label("filledSignature", _), _, _), args): {
            str allParams = extractTextFromTree(args[0]);
            // Limpiar comas y espacios
            list[str] paramList = [];
            for (str p <- split(",", allParams)) {
                str cleaned = trim(p);
                if (cleaned != "" && cleaned != ",") {
                    paramList += cleaned;
                }
            }
            return intercalate(", ", paramList);
        }
    }
    return "";
}


public void simpleRun(loc file) {
    println("═════════════════════════════════════════════");
    println("     ANÁLISIS SIMPLE DE PROGRAMA ALU");
    println("═════════════════════════════════════════════\n");
    
    try {
        start[Program] tree = parse(#start[Program], file);
        println("✓ Archivo: <file.file>");
        println("✓ Parse exitoso\n");
        
        // Contar elementos
        int modules = 0, functions = 0, expressions = 0;
        
        visit(tree) {
            case Module _: modules += 1;
            case Function _: functions += 1;
            case Expression _: expressions += 1;
        }
        
        println("Contenido del programa:");
        println("  • Módulos: <modules>");
        println("  • Funciones: <functions>");
        println("  • Expresiones: <expressions>");
        
        println("\n✓ Análisis completado");
        
    } catch ParseError(loc l): {
        println("❌ Error en línea <l.begin.line>");
    }
}

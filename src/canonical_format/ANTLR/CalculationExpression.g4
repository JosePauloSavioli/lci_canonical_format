grammar CalculationExpression;

// The grammar is hierarchycal, meaning it start with expressions as the higher layer and descend until the identified component in the expression.

expression
    : conditionalExpression EOF
    ;

conditionalExpression
    : IF LPAREN logicalOr COMMA conditionalExpression COMMA conditionalExpression RPAREN
      # IfFunctionExpression
    | logicalOr
      # PlainExpression
    ;

logicalOr
    : logicalAnd (OR logicalAnd)*
    ;

logicalAnd
    : equality (AND equality)*
    ;

// Here, "?" means that it stops in the first, to avoid "a < b < c" concatenation cases, which is not the purpose of the language.

equality
    : comparison ((EQUAL | NOT_EQUAL) comparison)?
    ;

comparison
    : additive ((LESS | LESS_EQUAL | GREATER | GREATER_EQUAL) additive)?
    ;

additive
    : multiplicative ((PLUS | MINUS) multiplicative)*
    ;

multiplicative
    : unary ((MULTIPLY | DIVIDE) unary)*
    ;

// Here, unary can be power due to exponenciation rules, in which 3^3^3 should be equivalent to 3^(3^3) and not (3^3)^3. That is why (POWER unary) is in power and unary permits power.

unary
    : (NOT | PLUS | MINUS) unary
    | power
    ;

power
    : primary (POWER unary)?
    ;

primary
    : NUMBER
    | BOOLEAN
    | STRING
    | functionCall
    | IDENTIFIER
    | LPAREN conditionalExpression RPAREN
    ;

functionCall
    : functionName LPAREN argumentList? RPAREN
    ;

argumentList
    : conditionalExpression (COMMA conditionalExpression)*
    ;

functionName
    : IDENTIFIER (DOT IDENTIFIER)*
    ;

IF:            'if';
BOOLEAN:       'true' | 'false';

OR:            '||';
AND:           '&&';
NOT:           '!';

EQUAL:         '==';
NOT_EQUAL:     '!=';
LESS_EQUAL:    '<=';
GREATER_EQUAL: '>=';
LESS:          '<';
GREATER:       '>';

POWER:         '^';
MULTIPLY:      '*';
DIVIDE:        '/';
PLUS:          '+';
MINUS:         '-';

LPAREN:        '(';
RPAREN:        ')';
COMMA:         ',';
DOT:           '.';

STRING
    : '"' (ESCAPED_CHARACTER | ~["\\\r\n])* '"'
    | '\'' (ESCAPED_CHARACTER | ~['\\\r\n])* '\''
    ;

fragment ESCAPED_CHARACTER
    : '\\' (
        '"'
        | '\''
        | '\\'
        | '/'
        | 'b'
        | 'f'
        | 'n'
        | 'r'
        | 't'
        | 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    )
    ;

fragment HEX_DIGIT
    : [0-9a-fA-F]
    ;

NUMBER
    : DIGIT+ ('.' DIGIT*)? EXPONENT?
    | '.' DIGIT+ EXPONENT?
    ;

IDENTIFIER
    : [a-zA-Z_] [a-zA-Z_0-9]*
    ;

fragment DIGIT
    : [0-9]
    ;

fragment EXPONENT
    : [eE] [+-]? DIGIT+
    ;

// Skips any quantity of whitespace.

WS
    : [ \t\r\n]+ -> skip
    ;


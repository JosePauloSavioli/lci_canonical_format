# Generated from /home/jotape42p/Documents/Projetos/Lavoisier/Dev/src/Lavoisier/conversions/ANTLR/CalculationExpression.g4 by ANTLR 4.13.2
# encoding: utf-8
from antlr4 import *
from io import StringIO
import sys
if sys.version_info[1] > 5:
	from typing import TextIO
else:
	from typing.io import TextIO

def serializedATN():
    return [
        4,1,24,130,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        1,0,1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,42,8,1,1,
        2,1,2,1,2,5,2,47,8,2,10,2,12,2,50,9,2,1,3,1,3,1,3,5,3,55,8,3,10,
        3,12,3,58,9,3,1,4,1,4,1,4,3,4,63,8,4,1,5,1,5,1,5,3,5,68,8,5,1,6,
        1,6,1,6,5,6,73,8,6,10,6,12,6,76,9,6,1,7,1,7,1,7,5,7,81,8,7,10,7,
        12,7,84,9,7,1,8,1,8,1,8,3,8,89,8,8,1,9,1,9,1,9,3,9,94,8,9,1,10,1,
        10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,3,10,105,8,10,1,11,1,11,1,
        11,3,11,110,8,11,1,11,1,11,1,12,1,12,1,12,5,12,117,8,12,10,12,12,
        12,120,9,12,1,13,1,13,1,13,5,13,125,8,13,10,13,12,13,128,9,13,1,
        13,0,0,14,0,2,4,6,8,10,12,14,16,18,20,22,24,26,0,5,1,0,6,7,1,0,8,
        11,1,0,15,16,1,0,13,14,2,0,5,5,15,16,132,0,28,1,0,0,0,2,41,1,0,0,
        0,4,43,1,0,0,0,6,51,1,0,0,0,8,59,1,0,0,0,10,64,1,0,0,0,12,69,1,0,
        0,0,14,77,1,0,0,0,16,88,1,0,0,0,18,90,1,0,0,0,20,104,1,0,0,0,22,
        106,1,0,0,0,24,113,1,0,0,0,26,121,1,0,0,0,28,29,3,2,1,0,29,30,5,
        0,0,1,30,1,1,0,0,0,31,32,5,1,0,0,32,33,5,17,0,0,33,34,3,4,2,0,34,
        35,5,19,0,0,35,36,3,2,1,0,36,37,5,19,0,0,37,38,3,2,1,0,38,39,5,18,
        0,0,39,42,1,0,0,0,40,42,3,4,2,0,41,31,1,0,0,0,41,40,1,0,0,0,42,3,
        1,0,0,0,43,48,3,6,3,0,44,45,5,3,0,0,45,47,3,6,3,0,46,44,1,0,0,0,
        47,50,1,0,0,0,48,46,1,0,0,0,48,49,1,0,0,0,49,5,1,0,0,0,50,48,1,0,
        0,0,51,56,3,8,4,0,52,53,5,4,0,0,53,55,3,8,4,0,54,52,1,0,0,0,55,58,
        1,0,0,0,56,54,1,0,0,0,56,57,1,0,0,0,57,7,1,0,0,0,58,56,1,0,0,0,59,
        62,3,10,5,0,60,61,7,0,0,0,61,63,3,10,5,0,62,60,1,0,0,0,62,63,1,0,
        0,0,63,9,1,0,0,0,64,67,3,12,6,0,65,66,7,1,0,0,66,68,3,12,6,0,67,
        65,1,0,0,0,67,68,1,0,0,0,68,11,1,0,0,0,69,74,3,14,7,0,70,71,7,2,
        0,0,71,73,3,14,7,0,72,70,1,0,0,0,73,76,1,0,0,0,74,72,1,0,0,0,74,
        75,1,0,0,0,75,13,1,0,0,0,76,74,1,0,0,0,77,82,3,16,8,0,78,79,7,3,
        0,0,79,81,3,16,8,0,80,78,1,0,0,0,81,84,1,0,0,0,82,80,1,0,0,0,82,
        83,1,0,0,0,83,15,1,0,0,0,84,82,1,0,0,0,85,86,7,4,0,0,86,89,3,16,
        8,0,87,89,3,18,9,0,88,85,1,0,0,0,88,87,1,0,0,0,89,17,1,0,0,0,90,
        93,3,20,10,0,91,92,5,12,0,0,92,94,3,16,8,0,93,91,1,0,0,0,93,94,1,
        0,0,0,94,19,1,0,0,0,95,105,5,22,0,0,96,105,5,2,0,0,97,105,5,21,0,
        0,98,105,3,22,11,0,99,105,5,23,0,0,100,101,5,17,0,0,101,102,3,2,
        1,0,102,103,5,18,0,0,103,105,1,0,0,0,104,95,1,0,0,0,104,96,1,0,0,
        0,104,97,1,0,0,0,104,98,1,0,0,0,104,99,1,0,0,0,104,100,1,0,0,0,105,
        21,1,0,0,0,106,107,3,26,13,0,107,109,5,17,0,0,108,110,3,24,12,0,
        109,108,1,0,0,0,109,110,1,0,0,0,110,111,1,0,0,0,111,112,5,18,0,0,
        112,23,1,0,0,0,113,118,3,2,1,0,114,115,5,19,0,0,115,117,3,2,1,0,
        116,114,1,0,0,0,117,120,1,0,0,0,118,116,1,0,0,0,118,119,1,0,0,0,
        119,25,1,0,0,0,120,118,1,0,0,0,121,126,5,23,0,0,122,123,5,20,0,0,
        123,125,5,23,0,0,124,122,1,0,0,0,125,128,1,0,0,0,126,124,1,0,0,0,
        126,127,1,0,0,0,127,27,1,0,0,0,128,126,1,0,0,0,13,41,48,56,62,67,
        74,82,88,93,104,109,118,126
    ]

class CalculationExpressionParser ( Parser ):

    grammarFileName = "CalculationExpression.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'if'", "<INVALID>", "'||'", "'&&'", "'!'", 
                     "'=='", "'!='", "'<='", "'>='", "'<'", "'>'", "'^'", 
                     "'*'", "'/'", "'+'", "'-'", "'('", "')'", "','", "'.'" ]

    symbolicNames = [ "<INVALID>", "IF", "BOOLEAN", "OR", "AND", "NOT", 
                      "EQUAL", "NOT_EQUAL", "LESS_EQUAL", "GREATER_EQUAL", 
                      "LESS", "GREATER", "POWER", "MULTIPLY", "DIVIDE", 
                      "PLUS", "MINUS", "LPAREN", "RPAREN", "COMMA", "DOT", 
                      "STRING", "NUMBER", "IDENTIFIER", "WS" ]

    RULE_expression = 0
    RULE_conditionalExpression = 1
    RULE_logicalOr = 2
    RULE_logicalAnd = 3
    RULE_equality = 4
    RULE_comparison = 5
    RULE_additive = 6
    RULE_multiplicative = 7
    RULE_unary = 8
    RULE_power = 9
    RULE_primary = 10
    RULE_functionCall = 11
    RULE_argumentList = 12
    RULE_functionName = 13

    ruleNames =  [ "expression", "conditionalExpression", "logicalOr", "logicalAnd", 
                   "equality", "comparison", "additive", "multiplicative", 
                   "unary", "power", "primary", "functionCall", "argumentList", 
                   "functionName" ]

    EOF = Token.EOF
    IF=1
    BOOLEAN=2
    OR=3
    AND=4
    NOT=5
    EQUAL=6
    NOT_EQUAL=7
    LESS_EQUAL=8
    GREATER_EQUAL=9
    LESS=10
    GREATER=11
    POWER=12
    MULTIPLY=13
    DIVIDE=14
    PLUS=15
    MINUS=16
    LPAREN=17
    RPAREN=18
    COMMA=19
    DOT=20
    STRING=21
    NUMBER=22
    IDENTIFIER=23
    WS=24

    def __init__(self, input:TokenStream, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.2")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None




    class ExpressionContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def conditionalExpression(self):
            return self.getTypedRuleContext(CalculationExpressionParser.ConditionalExpressionContext,0)


        def EOF(self):
            return self.getToken(CalculationExpressionParser.EOF, 0)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_expression

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitExpression" ):
                return visitor.visitExpression(self)
            else:
                return visitor.visitChildren(self)




    def expression(self):

        localctx = CalculationExpressionParser.ExpressionContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_expression)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 28
            self.conditionalExpression()
            self.state = 29
            self.match(CalculationExpressionParser.EOF)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ConditionalExpressionContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser


        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_conditionalExpression

     
        def copyFrom(self, ctx:ParserRuleContext):
            super().copyFrom(ctx)



    class IfFunctionExpressionContext(ConditionalExpressionContext):

        def __init__(self, parser, ctx:ParserRuleContext): # actually a CalculationExpressionParser.ConditionalExpressionContext
            super().__init__(parser)
            self.copyFrom(ctx)

        def IF(self):
            return self.getToken(CalculationExpressionParser.IF, 0)
        def LPAREN(self):
            return self.getToken(CalculationExpressionParser.LPAREN, 0)
        def logicalOr(self):
            return self.getTypedRuleContext(CalculationExpressionParser.LogicalOrContext,0)

        def COMMA(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.COMMA)
            else:
                return self.getToken(CalculationExpressionParser.COMMA, i)
        def conditionalExpression(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(CalculationExpressionParser.ConditionalExpressionContext)
            else:
                return self.getTypedRuleContext(CalculationExpressionParser.ConditionalExpressionContext,i)

        def RPAREN(self):
            return self.getToken(CalculationExpressionParser.RPAREN, 0)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitIfFunctionExpression" ):
                return visitor.visitIfFunctionExpression(self)
            else:
                return visitor.visitChildren(self)


    class PlainExpressionContext(ConditionalExpressionContext):

        def __init__(self, parser, ctx:ParserRuleContext): # actually a CalculationExpressionParser.ConditionalExpressionContext
            super().__init__(parser)
            self.copyFrom(ctx)

        def logicalOr(self):
            return self.getTypedRuleContext(CalculationExpressionParser.LogicalOrContext,0)


        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitPlainExpression" ):
                return visitor.visitPlainExpression(self)
            else:
                return visitor.visitChildren(self)



    def conditionalExpression(self):

        localctx = CalculationExpressionParser.ConditionalExpressionContext(self, self._ctx, self.state)
        self.enterRule(localctx, 2, self.RULE_conditionalExpression)
        try:
            self.state = 41
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [1]:
                localctx = CalculationExpressionParser.IfFunctionExpressionContext(self, localctx)
                self.enterOuterAlt(localctx, 1)
                self.state = 31
                self.match(CalculationExpressionParser.IF)
                self.state = 32
                self.match(CalculationExpressionParser.LPAREN)
                self.state = 33
                self.logicalOr()
                self.state = 34
                self.match(CalculationExpressionParser.COMMA)
                self.state = 35
                self.conditionalExpression()
                self.state = 36
                self.match(CalculationExpressionParser.COMMA)
                self.state = 37
                self.conditionalExpression()
                self.state = 38
                self.match(CalculationExpressionParser.RPAREN)
                pass
            elif token in [2, 5, 15, 16, 17, 21, 22, 23]:
                localctx = CalculationExpressionParser.PlainExpressionContext(self, localctx)
                self.enterOuterAlt(localctx, 2)
                self.state = 40
                self.logicalOr()
                pass
            else:
                raise NoViableAltException(self)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class LogicalOrContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def logicalAnd(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(CalculationExpressionParser.LogicalAndContext)
            else:
                return self.getTypedRuleContext(CalculationExpressionParser.LogicalAndContext,i)


        def OR(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.OR)
            else:
                return self.getToken(CalculationExpressionParser.OR, i)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_logicalOr

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitLogicalOr" ):
                return visitor.visitLogicalOr(self)
            else:
                return visitor.visitChildren(self)




    def logicalOr(self):

        localctx = CalculationExpressionParser.LogicalOrContext(self, self._ctx, self.state)
        self.enterRule(localctx, 4, self.RULE_logicalOr)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 43
            self.logicalAnd()
            self.state = 48
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==3:
                self.state = 44
                self.match(CalculationExpressionParser.OR)
                self.state = 45
                self.logicalAnd()
                self.state = 50
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class LogicalAndContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def equality(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(CalculationExpressionParser.EqualityContext)
            else:
                return self.getTypedRuleContext(CalculationExpressionParser.EqualityContext,i)


        def AND(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.AND)
            else:
                return self.getToken(CalculationExpressionParser.AND, i)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_logicalAnd

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitLogicalAnd" ):
                return visitor.visitLogicalAnd(self)
            else:
                return visitor.visitChildren(self)




    def logicalAnd(self):

        localctx = CalculationExpressionParser.LogicalAndContext(self, self._ctx, self.state)
        self.enterRule(localctx, 6, self.RULE_logicalAnd)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 51
            self.equality()
            self.state = 56
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==4:
                self.state = 52
                self.match(CalculationExpressionParser.AND)
                self.state = 53
                self.equality()
                self.state = 58
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class EqualityContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def comparison(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(CalculationExpressionParser.ComparisonContext)
            else:
                return self.getTypedRuleContext(CalculationExpressionParser.ComparisonContext,i)


        def EQUAL(self):
            return self.getToken(CalculationExpressionParser.EQUAL, 0)

        def NOT_EQUAL(self):
            return self.getToken(CalculationExpressionParser.NOT_EQUAL, 0)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_equality

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitEquality" ):
                return visitor.visitEquality(self)
            else:
                return visitor.visitChildren(self)




    def equality(self):

        localctx = CalculationExpressionParser.EqualityContext(self, self._ctx, self.state)
        self.enterRule(localctx, 8, self.RULE_equality)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 59
            self.comparison()
            self.state = 62
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la==6 or _la==7:
                self.state = 60
                _la = self._input.LA(1)
                if not(_la==6 or _la==7):
                    self._errHandler.recoverInline(self)
                else:
                    self._errHandler.reportMatch(self)
                    self.consume()
                self.state = 61
                self.comparison()


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ComparisonContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def additive(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(CalculationExpressionParser.AdditiveContext)
            else:
                return self.getTypedRuleContext(CalculationExpressionParser.AdditiveContext,i)


        def LESS(self):
            return self.getToken(CalculationExpressionParser.LESS, 0)

        def LESS_EQUAL(self):
            return self.getToken(CalculationExpressionParser.LESS_EQUAL, 0)

        def GREATER(self):
            return self.getToken(CalculationExpressionParser.GREATER, 0)

        def GREATER_EQUAL(self):
            return self.getToken(CalculationExpressionParser.GREATER_EQUAL, 0)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_comparison

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitComparison" ):
                return visitor.visitComparison(self)
            else:
                return visitor.visitChildren(self)




    def comparison(self):

        localctx = CalculationExpressionParser.ComparisonContext(self, self._ctx, self.state)
        self.enterRule(localctx, 10, self.RULE_comparison)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 64
            self.additive()
            self.state = 67
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if (((_la) & ~0x3f) == 0 and ((1 << _la) & 3840) != 0):
                self.state = 65
                _la = self._input.LA(1)
                if not((((_la) & ~0x3f) == 0 and ((1 << _la) & 3840) != 0)):
                    self._errHandler.recoverInline(self)
                else:
                    self._errHandler.reportMatch(self)
                    self.consume()
                self.state = 66
                self.additive()


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class AdditiveContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def multiplicative(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(CalculationExpressionParser.MultiplicativeContext)
            else:
                return self.getTypedRuleContext(CalculationExpressionParser.MultiplicativeContext,i)


        def PLUS(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.PLUS)
            else:
                return self.getToken(CalculationExpressionParser.PLUS, i)

        def MINUS(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.MINUS)
            else:
                return self.getToken(CalculationExpressionParser.MINUS, i)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_additive

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitAdditive" ):
                return visitor.visitAdditive(self)
            else:
                return visitor.visitChildren(self)




    def additive(self):

        localctx = CalculationExpressionParser.AdditiveContext(self, self._ctx, self.state)
        self.enterRule(localctx, 12, self.RULE_additive)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 69
            self.multiplicative()
            self.state = 74
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==15 or _la==16:
                self.state = 70
                _la = self._input.LA(1)
                if not(_la==15 or _la==16):
                    self._errHandler.recoverInline(self)
                else:
                    self._errHandler.reportMatch(self)
                    self.consume()
                self.state = 71
                self.multiplicative()
                self.state = 76
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class MultiplicativeContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def unary(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(CalculationExpressionParser.UnaryContext)
            else:
                return self.getTypedRuleContext(CalculationExpressionParser.UnaryContext,i)


        def MULTIPLY(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.MULTIPLY)
            else:
                return self.getToken(CalculationExpressionParser.MULTIPLY, i)

        def DIVIDE(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.DIVIDE)
            else:
                return self.getToken(CalculationExpressionParser.DIVIDE, i)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_multiplicative

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitMultiplicative" ):
                return visitor.visitMultiplicative(self)
            else:
                return visitor.visitChildren(self)




    def multiplicative(self):

        localctx = CalculationExpressionParser.MultiplicativeContext(self, self._ctx, self.state)
        self.enterRule(localctx, 14, self.RULE_multiplicative)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 77
            self.unary()
            self.state = 82
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==13 or _la==14:
                self.state = 78
                _la = self._input.LA(1)
                if not(_la==13 or _la==14):
                    self._errHandler.recoverInline(self)
                else:
                    self._errHandler.reportMatch(self)
                    self.consume()
                self.state = 79
                self.unary()
                self.state = 84
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class UnaryContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def unary(self):
            return self.getTypedRuleContext(CalculationExpressionParser.UnaryContext,0)


        def NOT(self):
            return self.getToken(CalculationExpressionParser.NOT, 0)

        def PLUS(self):
            return self.getToken(CalculationExpressionParser.PLUS, 0)

        def MINUS(self):
            return self.getToken(CalculationExpressionParser.MINUS, 0)

        def power(self):
            return self.getTypedRuleContext(CalculationExpressionParser.PowerContext,0)


        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_unary

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitUnary" ):
                return visitor.visitUnary(self)
            else:
                return visitor.visitChildren(self)




    def unary(self):

        localctx = CalculationExpressionParser.UnaryContext(self, self._ctx, self.state)
        self.enterRule(localctx, 16, self.RULE_unary)
        self._la = 0 # Token type
        try:
            self.state = 88
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [5, 15, 16]:
                self.enterOuterAlt(localctx, 1)
                self.state = 85
                _la = self._input.LA(1)
                if not((((_la) & ~0x3f) == 0 and ((1 << _la) & 98336) != 0)):
                    self._errHandler.recoverInline(self)
                else:
                    self._errHandler.reportMatch(self)
                    self.consume()
                self.state = 86
                self.unary()
                pass
            elif token in [2, 17, 21, 22, 23]:
                self.enterOuterAlt(localctx, 2)
                self.state = 87
                self.power()
                pass
            else:
                raise NoViableAltException(self)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class PowerContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def primary(self):
            return self.getTypedRuleContext(CalculationExpressionParser.PrimaryContext,0)


        def POWER(self):
            return self.getToken(CalculationExpressionParser.POWER, 0)

        def unary(self):
            return self.getTypedRuleContext(CalculationExpressionParser.UnaryContext,0)


        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_power

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitPower" ):
                return visitor.visitPower(self)
            else:
                return visitor.visitChildren(self)




    def power(self):

        localctx = CalculationExpressionParser.PowerContext(self, self._ctx, self.state)
        self.enterRule(localctx, 18, self.RULE_power)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 90
            self.primary()
            self.state = 93
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la==12:
                self.state = 91
                self.match(CalculationExpressionParser.POWER)
                self.state = 92
                self.unary()


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class PrimaryContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def NUMBER(self):
            return self.getToken(CalculationExpressionParser.NUMBER, 0)

        def BOOLEAN(self):
            return self.getToken(CalculationExpressionParser.BOOLEAN, 0)

        def STRING(self):
            return self.getToken(CalculationExpressionParser.STRING, 0)

        def functionCall(self):
            return self.getTypedRuleContext(CalculationExpressionParser.FunctionCallContext,0)


        def IDENTIFIER(self):
            return self.getToken(CalculationExpressionParser.IDENTIFIER, 0)

        def LPAREN(self):
            return self.getToken(CalculationExpressionParser.LPAREN, 0)

        def conditionalExpression(self):
            return self.getTypedRuleContext(CalculationExpressionParser.ConditionalExpressionContext,0)


        def RPAREN(self):
            return self.getToken(CalculationExpressionParser.RPAREN, 0)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_primary

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitPrimary" ):
                return visitor.visitPrimary(self)
            else:
                return visitor.visitChildren(self)




    def primary(self):

        localctx = CalculationExpressionParser.PrimaryContext(self, self._ctx, self.state)
        self.enterRule(localctx, 20, self.RULE_primary)
        try:
            self.state = 104
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)
                self.state = 95
                self.match(CalculationExpressionParser.NUMBER)
                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 96
                self.match(CalculationExpressionParser.BOOLEAN)
                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 97
                self.match(CalculationExpressionParser.STRING)
                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 98
                self.functionCall()
                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 99
                self.match(CalculationExpressionParser.IDENTIFIER)
                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 100
                self.match(CalculationExpressionParser.LPAREN)
                self.state = 101
                self.conditionalExpression()
                self.state = 102
                self.match(CalculationExpressionParser.RPAREN)
                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class FunctionCallContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def functionName(self):
            return self.getTypedRuleContext(CalculationExpressionParser.FunctionNameContext,0)


        def LPAREN(self):
            return self.getToken(CalculationExpressionParser.LPAREN, 0)

        def RPAREN(self):
            return self.getToken(CalculationExpressionParser.RPAREN, 0)

        def argumentList(self):
            return self.getTypedRuleContext(CalculationExpressionParser.ArgumentListContext,0)


        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_functionCall

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitFunctionCall" ):
                return visitor.visitFunctionCall(self)
            else:
                return visitor.visitChildren(self)




    def functionCall(self):

        localctx = CalculationExpressionParser.FunctionCallContext(self, self._ctx, self.state)
        self.enterRule(localctx, 22, self.RULE_functionCall)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 106
            self.functionName()
            self.state = 107
            self.match(CalculationExpressionParser.LPAREN)
            self.state = 109
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if (((_la) & ~0x3f) == 0 and ((1 << _la) & 14909478) != 0):
                self.state = 108
                self.argumentList()


            self.state = 111
            self.match(CalculationExpressionParser.RPAREN)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ArgumentListContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def conditionalExpression(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(CalculationExpressionParser.ConditionalExpressionContext)
            else:
                return self.getTypedRuleContext(CalculationExpressionParser.ConditionalExpressionContext,i)


        def COMMA(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.COMMA)
            else:
                return self.getToken(CalculationExpressionParser.COMMA, i)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_argumentList

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitArgumentList" ):
                return visitor.visitArgumentList(self)
            else:
                return visitor.visitChildren(self)




    def argumentList(self):

        localctx = CalculationExpressionParser.ArgumentListContext(self, self._ctx, self.state)
        self.enterRule(localctx, 24, self.RULE_argumentList)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 113
            self.conditionalExpression()
            self.state = 118
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==19:
                self.state = 114
                self.match(CalculationExpressionParser.COMMA)
                self.state = 115
                self.conditionalExpression()
                self.state = 120
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class FunctionNameContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def IDENTIFIER(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.IDENTIFIER)
            else:
                return self.getToken(CalculationExpressionParser.IDENTIFIER, i)

        def DOT(self, i:int=None):
            if i is None:
                return self.getTokens(CalculationExpressionParser.DOT)
            else:
                return self.getToken(CalculationExpressionParser.DOT, i)

        def getRuleIndex(self):
            return CalculationExpressionParser.RULE_functionName

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitFunctionName" ):
                return visitor.visitFunctionName(self)
            else:
                return visitor.visitChildren(self)




    def functionName(self):

        localctx = CalculationExpressionParser.FunctionNameContext(self, self._ctx, self.state)
        self.enterRule(localctx, 26, self.RULE_functionName)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 121
            self.match(CalculationExpressionParser.IDENTIFIER)
            self.state = 126
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==20:
                self.state = 122
                self.match(CalculationExpressionParser.DOT)
                self.state = 123
                self.match(CalculationExpressionParser.IDENTIFIER)
                self.state = 128
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx






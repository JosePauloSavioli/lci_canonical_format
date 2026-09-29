# Generated from /home/jotape42p/Documents/Projetos/Lavoisier/Dev/src/Lavoisier/conversions/ANTLR/CalculationExpression.g4 by ANTLR 4.13.2
from antlr4 import *
if "." in __name__:
    from .CalculationExpressionParser import CalculationExpressionParser
else:
    from CalculationExpressionParser import CalculationExpressionParser

# This class defines a complete generic visitor for a parse tree produced by CalculationExpressionParser.

class CalculationExpressionVisitor(ParseTreeVisitor):

    # Visit a parse tree produced by CalculationExpressionParser#expression.
    def visitExpression(self, ctx:CalculationExpressionParser.ExpressionContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#IfFunctionExpression.
    def visitIfFunctionExpression(self, ctx:CalculationExpressionParser.IfFunctionExpressionContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#PlainExpression.
    def visitPlainExpression(self, ctx:CalculationExpressionParser.PlainExpressionContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#logicalOr.
    def visitLogicalOr(self, ctx:CalculationExpressionParser.LogicalOrContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#logicalAnd.
    def visitLogicalAnd(self, ctx:CalculationExpressionParser.LogicalAndContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#equality.
    def visitEquality(self, ctx:CalculationExpressionParser.EqualityContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#comparison.
    def visitComparison(self, ctx:CalculationExpressionParser.ComparisonContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#additive.
    def visitAdditive(self, ctx:CalculationExpressionParser.AdditiveContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#multiplicative.
    def visitMultiplicative(self, ctx:CalculationExpressionParser.MultiplicativeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#unary.
    def visitUnary(self, ctx:CalculationExpressionParser.UnaryContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#power.
    def visitPower(self, ctx:CalculationExpressionParser.PowerContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#primary.
    def visitPrimary(self, ctx:CalculationExpressionParser.PrimaryContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#functionCall.
    def visitFunctionCall(self, ctx:CalculationExpressionParser.FunctionCallContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#argumentList.
    def visitArgumentList(self, ctx:CalculationExpressionParser.ArgumentListContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by CalculationExpressionParser#functionName.
    def visitFunctionName(self, ctx:CalculationExpressionParser.FunctionNameContext):
        return self.visitChildren(ctx)



del CalculationExpressionParser
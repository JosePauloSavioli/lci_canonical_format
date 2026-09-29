#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Aug  1 12:40:49 2026

@author: jotape42p
"""

import ast
from decimal import Decimal
from antlr4 import CommonTokenStream, InputStream
from .python.CalculationExpressionLexer import CalculationExpressionLexer
from .python.CalculationExpressionParser import CalculationExpressionParser
from .python.CalculationExpressionVisitor import CalculationExpressionVisitor


BINARY_OPERATIONS = {
    "+": "add",
    "-": "subtract",
    "*": "multiply",
    "/": "divide",
    "^": "power",
    "==": "equal",
    "!=": "notEqual",
    "<": "less",
    "<=": "lessEqual",
    ">": "greater",
    ">=": "greaterEqual",
    "&&": "and",
    "||": "or"
}


UNARY_OPERATIONS = {
    "-": "negate",
    "+": "positive",
    "!": "not"
}


# Abstract Syntax Tree
# The visitor has expressions for each of the parser rules
# Operands are the values of the variables
# Operators are the commands (+, -, / for example)
class AstBuilder(CalculationExpressionVisitor):

    def __init__(self):
        self.variables = set()
        self.functions = set()

    # Conditional expressions
    def visitExpression(self, ctx):
        return self.visit(ctx.conditionalExpression())

    def visitPlainExpression(self, ctx): # Root
        return self.visit(ctx.logicalOr())

    def visitIfFunctionExpression(self, ctx):
        return {
            "type": "conditional",
            "condition": self.visit(ctx.logicalOr()),
            "whenTrue": self.visit(ctx.conditionalExpression(0)),
            "whenFalse": self.visit(ctx.conditionalExpression(1)),
        }

    # Boolean and comparison expressions
    def visitLogicalOr(self, ctx):
        return self._fold_binary(
            ctx, 
            operands=ctx.logicalAnd(),
            allowed_operators={"||"},
        )

    def visitLogicalAnd(self, ctx):
        return self._fold_binary(
            ctx, 
            operands=ctx.equality(),
            allowed_operators={"&&"},
        )

    def visitEquality(self, ctx):
        return self._fold_binary(
            ctx, 
            operands=ctx.comparison(),
            allowed_operators={"==", "!="},
        )

    def visitComparison(self, ctx):
        return self._fold_binary(
            ctx, 
            operands=ctx.additive(),
            allowed_operators={"<", "<=", ">", ">="},
        )

    # Arithmetic expressions
    def visitAdditive(self, ctx):
        return self._fold_binary(
            ctx, 
            operands=ctx.multiplicative(),
            allowed_operators={"+", "-"},
        )

    def visitMultiplicative(self, ctx):
        return self._fold_binary(
            ctx, 
            operands=ctx.unary(),
            allowed_operators={"*", "/"},
        )

    # Unary / power couple (recursive, not left associative)
    def visitUnary(self, ctx):
        if ctx.power() is not None:
            return self.visit(ctx.power())

        operator_text = ctx.getChild(0).getText()
        operand = self.visit(ctx.unary())
        operation = UNARY_OPERATIONS.get(operator_text)
        if operation is None:
            raise ValueError(f"Unsupported unary operator: {operator_text!r}")

        return {
            "type": operation,
            "operand": operand,
        }

    def visitPower(self, ctx):
        base = self.visit(ctx.primary())
        exponent = ctx.unary()
        if exponent is None:
            return base

        return {
            "type": "power",
            "left": base,
            "right": self.visit(exponent),
        }

    # Values, variables, parentheses and calls
    def visitPrimary(self, ctx):
        if ctx.NUMBER() is not None:
            return {
                "type": "number",
                "value": self._parse_number(ctx.NUMBER().getText()),
            }

        if ctx.BOOLEAN() is not None:
            return {
                "type": "boolean",
                "value": ctx.BOOLEAN().getText() == "true",
            }

        if ctx.STRING() is not None:
            return {
                "type": "string",
                "value": self._parse_string(ctx.STRING().getText()),
            }

        if ctx.functionCall() is not None:
            return self.visit(ctx.functionCall())

        if ctx.IDENTIFIER() is not None:
            name = ctx.IDENTIFIER().getText()
            self.variables.add(name)
            
            return {
                "type": "variable",
                "name": name,
            }

        # Parenthesized expression: LPAREN conditionalExpression RPAREN
        if ctx.conditionalExpression() is not None:
            return self.visit(ctx.conditionalExpression())

        raise ValueError(f"Unsupported primary expression: {ctx.getText()!r}")

    def visitFunctionCall(self, ctx):
        name = self.visit(ctx.functionName())
        arguments = []
        self.functions.add(name)
        if ctx.argumentList() is not None:
            arguments = [
                self.visit(argument)
                for argument in ctx.argumentList().conditionalExpression()
            ]

        return {
            "type": "call",
            "name": name,
            "arguments": arguments,
        }

    def visitFunctionName(self, ctx):
        return ".".join(token.getText() for token in ctx.IDENTIFIER())

    # Helpers
    # Fold binary get the operations and make them more compact for AST
    # Recursive call with self.visit (left associative)
    def _fold_binary(self, ctx, operands, allowed_operators):
        if not operands:
            raise ValueError("Binary expression has no operands")

        result = self.visit(operands[0])
        operators = [ # Get the operands for the rest of the tree
            child.getText()
            for child in ctx.children
            if child.getText() in allowed_operators
        ]

        if len(operators) != len(operands) - 1:
            raise ValueError(
                f"Could not match operators to operands: {operators=}, operand_count={len(operands)}"
            )

        for operator_text, operand_ctx in zip(operators, operands[1:]):
            operation = BINARY_OPERATIONS.get(operator_text)
            if operation is None:
                raise ValueError(f"Unsupported binary operator: {operator_text!r}")

            result = {
                "type": operation,
                "left": result,
                "right": self.visit(operand_ctx),
            }

        return result

    @staticmethod
    def _parse_number(text):
        if any(character in text for character in ".eE"):
            return Decimal(text)
        return int(text)

    @staticmethod
    def _parse_string(text):
        return ast.literal_eval(text)

    @classmethod
    def parse(cls, source):
        input_stream = InputStream(source)
        lexer = CalculationExpressionLexer(input_stream)
        tokens = CommonTokenStream(lexer)
        parser = CalculationExpressionParser(tokens)
        tree = parser.expression()

        builder = cls()
        ast = builder.visit(tree)
        return {
            "ast": ast,
            "variables": sorted(builder.variables),
            "functions": sorted(builder.functions)
        } 


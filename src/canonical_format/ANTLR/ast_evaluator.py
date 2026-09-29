#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Aug  1 12:44:11 2026

@author: jotape42p
"""

import operator
from decimal import Decimal


BINARY_OPERATIONS = {
    "add": operator.add,
    "subtract": operator.sub,
    "multiply": operator.mul,
    "divide": operator.truediv,
    "power": operator.pow,
    "equal": operator.eq,
    "notEqual": operator.ne,
    "less": operator.lt,
    "lessEqual": operator.le,
    "greater": operator.gt,
    "greaterEqual": operator.ge,
}


class AstEvaluator:

    def __init__(self, variables=None, functions=None, operand=None):
        self.variables = variables or {}
        self.functions = functions or {}
        self.operand = operand or (lambda value: value)

    def evaluate(self, node):
        node_type = node["type"]

        if node_type == "number":
            return Decimal(str(node["value"]))

        if node_type in {"boolean", "string"}:
            return node["value"]

        if node_type == "variable":
            return self._evaluate_variable(node)

        if node_type in {"negate", "positive", "not"}:
            return self._evaluate_unary(node)

        if node_type in {"and", "or"}:
            return self._evaluate_logical(node)

        if node_type in BINARY_OPERATIONS:
            return self._evaluate_binary(node)

        if node_type == "call":
            return self._evaluate_call(node)

        if node_type == "conditional":
            return self._evaluate_conditional(node)

        raise ValueError(f"Unsupported AST node type: {node_type}")

    def _evaluate_variable(self, node):
        name = node["name"]
        if name not in self.variables:
            raise NameError(f"Unknown variable: {name}")
        return self.variables[name]

    def _evaluate_unary(self, node):
        value = self.operand(self.evaluate(node["operand"]))
        if node["type"] == "negate":
            return -value
        if node["type"] == "positive":
            return +value
        return not value

    def _evaluate_logical(self, node):
        left = self.operand(self.evaluate(node["left"]))
        if node["type"] == "and":
            if not left:
                return False
            return bool(self.operand(self.evaluate(node["right"])))
        if left:
            return True
        return bool(self.operand(self.evaluate(node["right"])))

    def _evaluate_binary(self, node):
        left = self.operand(self.evaluate(node["left"]))
        right = self.operand(self.evaluate(node["right"]))
        return BINARY_OPERATIONS[node["type"]](left, right)

    def _evaluate_call(self, node):
        function_name = node["name"]
        if function_name not in self.functions:
            raise NameError(f"Unknown function: {function_name}")

        arguments = [
            self.evaluate(argument)
            for argument in node["arguments"]
        ]
        return self.functions[function_name](*arguments)

    def _evaluate_conditional(self, node):
        condition = self.operand(self.evaluate(node["condition"]))
        branch = node["whenTrue"] if condition else node["whenFalse"]
        return self.evaluate(branch)


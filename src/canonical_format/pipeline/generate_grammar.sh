#!/usr/bin/env bash
set -euo pipefail


PIPELINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$PIPELINE_DIR/.." && pwd)"

OUTPUT_ROOT="$PROJECT_ROOT/ANTLR"
OUTPUT_DIR="$OUTPUT_ROOT/python"
ANTLR_ROOT="$PIPELINE_DIR/antlr"
GRAMMAR_FILE="$OUTPUT_ROOT/CalculationExpression.g4"


ANTLR_VERSION="$(
    wget -qO- https://www.antlr.org/download.html |
        grep -oE 'antlr-[0-9]+\.[0-9]+\.[0-9]+-complete\.jar' |
        head -n 1 |
        sed -E 's/antlr-([0-9.]+)-complete\.jar/\1/'
)"

ANTLR_JAR="$ANTLR_ROOT/antlr-$ANTLR_VERSION-complete.jar"
export ANTLR4_TOOLS_ANTLR_VERSION="$ANTLR_VERSION"

mkdir -p "$ANTLR_ROOT"

if [[ ! -f "$ANTLR_JAR" ]]; then
    wget \
        -O "$ANTLR_JAR" \
        "https://www.antlr.org/download/antlr-$ANTLR_VERSION-complete.jar"
fi

python3 -m pip install \
    "antlr4-python3-runtime==$ANTLR_VERSION"

python3 -m pip install \
    "antlr4-tools"

# antlr4-parse CalculationExpression.g4 expression -gui

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

touch "$OUTPUT_ROOT/__init__.py"
touch "$OUTPUT_DIR/__init__.py"

java -jar "$ANTLR_JAR" \
    -Dlanguage=Python3 \
    -visitor \
    -no-listener \
    -o "$OUTPUT_DIR" \
    "$GRAMMAR_FILE"

rm -rf "$ANTLR_ROOT"

echo "ANTLR parser generated: $OUTPUT_DIR"


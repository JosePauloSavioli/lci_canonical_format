#!/usr/bin/env bash
set -euo pipefail


PIPELINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$PIPELINE_DIR/.." && pwd)"

CUE_SOURCE_DIR="${CUE_SOURCE_DIR:-$PROJECT_ROOT/../cue}"


if [[ ! -f "$CUE_SOURCE_DIR/go.mod" ]]; then
    echo "CUE source repository not found: $CUE_SOURCE_DIR" >&2
    echo "Set CUE_SOURCE_DIR to the CUE repository path." >&2
    exit 1
fi

cd "$CUE_SOURCE_DIR"

GO_VERSION="$(
    awk '$1 == "go" { print $2; exit }' go.mod
)"

asdf install golang "$GO_VERSION"
asdf global golang "$GO_VERSION"

if ! grep -q 'func cueRefInstanceID(inst cue.Value)' \
    encoding/jsonschema/generate.go; then

    git apply <<'PATCH'
diff --git a/encoding/jsonschema/generate.go b/encoding/jsonschema/generate.go
--- a/encoding/jsonschema/generate.go
+++ b/encoding/jsonschema/generate.go
@@ -1480,15 +1480,59 @@
 //
 // The [CUERef.Name] field is not included in the hash or equality
 // because it's set after the map is populated.
 type cueRefHasher struct{}

+// cueRefInstanceID returns a stable identity for a package instance.
+//
+// Different cue.Value values can represent the same imported package.
+// Using the package ID allows references reached through different import
+// branches to be treated as the same reference.
+func cueRefInstanceID(inst cue.Value) (string, bool) {
+	bi := inst.BuildInstance()
+	if bi == nil {
+		return "", false
+	}
+
+	if id := bi.ID(); id != "" {
+		return id, true
+	}
+
+	if bi.ImportPath != "" {
+		return bi.ImportPath, true
+	}
+
+	return "", false
+}
+
 func (cueRefHasher) Hash(h *maphash.Hash, r *CUERef) {
-	maphash.WriteComparable(h, r.Inst)
+	if id, ok := cueRefInstanceID(r.Inst); ok {
+		h.WriteString("package:")
+		h.WriteString(id)
+	} else {
+		h.WriteString("value:")
+		maphash.WriteComparable(h, r.Inst)
+	}
+
+	h.WriteString("\x00path:")
 	h.WriteString(r.Path.String())
 }

 func (cueRefHasher) Equal(x, y *CUERef) bool {
-	return x.Inst == y.Inst && x.Path.Compare(y.Path) == 0
+	if x.Path.Compare(y.Path) != 0 {
+		return false
+	}
+
+	xID, xOK := cueRefInstanceID(x.Inst)
+	yID, yOK := cueRefInstanceID(y.Inst)
+
+	if xOK || yOK {
+		return xOK && yOK && xID == yID
+	}
+
+	return x.Inst == y.Inst
 }
PATCH

fi


# Make NamesFunc failures actionable: report the exact unnamed CUE references.
if ! grep -q 'unnamed CUERef:' encoding/jsonschema/generate.go; then
    python3 - <<'PY'
from pathlib import Path

path = Path("encoding/jsonschema/generate.go")
text = path.read_text()

old = '\t\tif defKeys[0].Name == "" {\n\t\t\treturn nil, fmt.Errorf("NamesFunc did not set Name field in all *CUERef values")\n\t\t}\n'

new = '\t\tif defKeys[0].Name == "" {\n\t\t\tvar unnamed []string\n\t\t\tfor _, k := range defKeys {\n\t\t\t\tif k.Name != "" {\n\t\t\t\t\tcontinue\n\t\t\t\t}\n\t\t\t\tinstanceID := "<unknown>"\n\t\t\t\tif id, ok := cueRefInstanceID(k.Inst); ok {\n\t\t\t\t\tinstanceID = id\n\t\t\t\t}\n\t\t\t\tunnamed = append(unnamed, fmt.Sprintf(\n\t\t\t\t\t"unnamed CUERef: instance=%q path=%q selectors=%d",\n\t\t\t\t\tinstanceID,\n\t\t\t\t\tk.Path.String(),\n\t\t\t\t\tlen(k.Path.Selectors()),\n\t\t\t\t))\n\t\t\t}\n\t\t\treturn nil, fmt.Errorf(\n\t\t\t\t"NamesFunc did not set Name field in all *CUERef values:\\\\n%s",\n\t\t\t\tstrings.Join(unnamed, "\\\\n"),\n\t\t\t)\n\t\t}\n'

if old not in text:
    raise SystemExit(
        "Could not find the NamesFunc error block in "
        "encoding/jsonschema/generate.go"
    )

path.write_text(text.replace(old, new, 1))
PY
fi



# ReferencePath can return a package together with an unusable/bottom path
# (for example "_|_"). The JSON Schema generator currently treats any
# existing package as a valid reference and stores that path as a CUERef.
# DefaultNamesFunc cannot name such a reference. Inline/evaluate these
# values instead of turning them into $defs references.
if ! grep -q 'func validJSONSchemaReferencePath' \
    encoding/jsonschema/generate.go; then

    python3 - <<'PY'
from pathlib import Path

path = Path("encoding/jsonschema/generate.go")
text = path.read_text()

marker = "func (g *generator) addErrorf(pos cue.Value, f string, a ...any) {\n"

helper = (
    "func validJSONSchemaReferencePath(path cue.Path) bool {\n"
    "\tsels := path.Selectors()\n"
    "\tif len(sels) == 0 {\n"
    "\t\treturn false\n"
    "\t}\n\n"
    "\tfor _, sel := range sels {\n"
    "\t\tif sel.Type() == cue.InvalidSelectorType || sel.String() == \"_|_\" {\n"
    "\t\t\treturn false\n"
    "\t\t}\n"
    "\t}\n\n"
    "\treturn true\n"
    "}\n\n"
)

if marker not in text:
    raise SystemExit(
        "Could not find addErrorf insertion point in "
        "encoding/jsonschema/generate.go"
    )

text = text.replace(marker, helper + marker, 1)

old = (
    "\t\tpkg, path := v.ReferencePath()\n"
    "\t\tif !pkg.Exists() {\n"
    "\t\t\tbreak\n"
    "\t\t}\n"
)

new = (
    "\t\tpkg, path := v.ReferencePath()\n"
    "\t\tif !pkg.Exists() {\n"
    "\t\t\tbreak\n"
    "\t\t}\n"
    "\t\tif !validJSONSchemaReferencePath(path) {\n"
    "\t\t\tv = v.Eval()\n"
    "\t\t\tbreak\n"
    "\t\t}\n"
)

if old not in text:
    raise SystemExit(
        "Could not find makeItem0 ReferencePath block in "
        "encoding/jsonschema/generate.go"
    )

text = text.replace(old, new, 1)

old = (
    "\t\tpkg, path := v.ReferencePath()\n"
    "\t\tif pkg.Exists() && mode != open && !isDefinition(path) && v.Kind() == cue.StructKind {\n"
    "\t\t\t// In a closed context, inline non-definition references so\n"
    "\t\t\t// their properties become local to additionalProperties.\n"
    "\t\t\tv = pkg.LookupPath(path)\n"
    "\t\t} else if pkg.Exists() || v.Kind() != cue.StructKind {\n"
)

new = (
    "\t\tpkg, path := v.ReferencePath()\n"
    "\t\thasReference := pkg.Exists() && validJSONSchemaReferencePath(path)\n"
    "\t\tif pkg.Exists() && !hasReference {\n"
    "\t\t\tv = v.Eval()\n"
    "\t\t}\n\n"
    "\t\tif hasReference && mode != open && !isDefinition(path) && v.Kind() == cue.StructKind {\n"
    "\t\t\t// In a closed context, inline non-definition references so\n"
    "\t\t\t// their properties become local to additionalProperties.\n"
    "\t\t\tv = pkg.LookupPath(path)\n"
    "\t\t} else if hasReference || v.Kind() != cue.StructKind {\n"
)

if old not in text:
    raise SystemExit(
        "Could not find makeStructItem ReferencePath block in "
        "encoding/jsonschema/generate.go"
    )

text = text.replace(old, new, 1)
path.write_text(text)
PY

    gofmt -w encoding/jsonschema/generate.go
fi


ASDF_ROOT="${ASDF_DATA_DIR:-$HOME/.asdf}"
CUE_VERSION="patched-jsonschema"
CUE_BIN_DIR="$ASDF_ROOT/installs/cue/$CUE_VERSION/bin"

mkdir -p "$CUE_BIN_DIR"

go build \
    -o "$CUE_BIN_DIR/cue" \
    ./cmd/cue

asdf reshim cue "$CUE_VERSION"
asdf global cue "$CUE_VERSION"

hash -r

asdf which cue
cue version


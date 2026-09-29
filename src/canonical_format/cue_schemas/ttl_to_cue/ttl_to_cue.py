#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 30 23:39:11 2026

@author: jotape42p
"""

from pathlib import Path

from rdflib import Graph, OWL, RDF, RDFS, URIRef


def is_deprecated(graph: Graph, subject) -> bool:
    return any(
        value.toPython() is True
        for value in graph.objects(subject, OWL.deprecated)
    )


def is_subclass_of(
    graph: Graph,
    subject: URIRef,
    parent: URIRef,
    visited: set[URIRef] | None = None,
) -> bool:
    if subject == parent:
        return True

    visited = set() if visited is None else visited

    if subject in visited:
        return False

    visited.add(subject)

    for superclass in graph.objects(subject, RDFS.subClassOf):
        if not isinstance(superclass, URIRef):
            continue

        if is_subclass_of(
            graph,
            superclass,
            parent,
            visited,
        ):
            return True

    return False


def extract_subclasses(
    graph: Graph,
    namespace: str,
    parent: URIRef,
    excluded: set[URIRef] | None = None,
) -> list[str]:
    excluded = set() if excluded is None else excluded
    classes: set[str] = set()

    class_types = {
        OWL.Class,
        RDFS.Class,
    }

    for subject, _, class_type in graph.triples((None, RDF.type, None)):
        if class_type not in class_types:
            continue

        if not isinstance(subject, URIRef):
            continue

        if subject == parent or subject in excluded:
            continue

        subject_iri = str(subject)

        if not subject_iri.startswith(namespace):
            continue

        if is_deprecated(graph, subject):
            continue

        if not is_subclass_of(graph, subject, parent):
            continue

        classes.add(
            subject_iri.removeprefix(namespace)
        )

    return sorted(classes)


def extract_terms(
    graph: Graph,
    namespace: str,
    rdf_types: set,
    excluded: set[str] | None = None,
) -> list[str]:
    excluded = excluded or set()
    terms: set[str] = set()

    for subject, _, rdf_type in graph.triples((None, RDF.type, None)):
        if rdf_type not in rdf_types:
            continue

        subject_iri = str(subject)

        if not subject_iri.startswith(namespace):
            continue

        term_name = subject_iri.removeprefix(namespace)

        if not term_name or term_name in excluded:
            continue

        if is_deprecated(graph, subject):
            continue

        terms.add(term_name)

    return sorted(terms)


def make_cue_fields(prefix: str, properties: list[str]) -> str:
    return "\n".join(
        f'\t"{prefix}:{name}"?: util.#JSONValue'
        for name in properties
    )


def make_cue_union(prefix: str, terms: list[str]) -> str:
    if not terms:
        return "_|_"

    return " |\n\t".join(
        f'"{prefix}:{name}"'
        for name in terms
    )


# %% vCard

VCARD_TTL_PATH = Path("vcard.ttl")
VCARD_OUTPUT_PATH = Path("vcard.cue")
VCARD_NAMESPACE = "http://www.w3.org/2006/vcard/ns#"

VCARD_EXCLUDED_PROPERTIES = {
    "fn",
    "hasEmail",
}

VCARD_KIND = URIRef(f"{VCARD_NAMESPACE}Kind")
VCARD_LOCATION = URIRef(f"{VCARD_NAMESPACE}Location")

vcard_graph = Graph()
vcard_graph.parse(VCARD_TTL_PATH, format="turtle")

vcard_properties = extract_terms(
    graph=vcard_graph,
    namespace=VCARD_NAMESPACE,
    rdf_types={
        RDF.Property,
        OWL.DatatypeProperty,
        OWL.ObjectProperty,
    },
    excluded=VCARD_EXCLUDED_PROPERTIES,
)

vcard_classes = extract_subclasses(
    graph=vcard_graph,
    namespace=VCARD_NAMESPACE,
    parent=VCARD_KIND,
    excluded={
        VCARD_LOCATION,
    },
)

vcard_fields = make_cue_fields(
    "vcard",
    vcard_properties,
)

vcard_class_union = make_cue_union(
    "vcard",
    vcard_classes,
)

vcard_output = f'''package vcard

import "example.com/models:util"

#VCardActorClass:
\t{vcard_class_union}

#AdditionalVCardInformation: {{
{vcard_fields}
}}
'''

VCARD_OUTPUT_PATH.write_text(
    vcard_output,
    encoding="utf-8",
)

print(
    f"Generated {len(vcard_properties)} non-deprecated additional "
    f"vCard properties and {len(vcard_classes)} subclasses of "
    f"vcard:Kind, excluding vcard:Location."
)
print(f"Output: {VCARD_OUTPUT_PATH}")


# %% BIBO and Dublin Core

BIBO_URL = (
    "https://www.dublincore.org/"
    "specifications/bibo/bibo/bibo.ttl"
)
DCTERMS_URL = "http://purl.org/dc/terms/"

BIBO_DC_OUTPUT_PATH = Path("bibo_dc.cue")

BIBO_NAMESPACE = "http://purl.org/ontology/bibo/"
DCTERMS_NAMESPACE = "http://purl.org/dc/terms/"

BIBO_DOCUMENT = URIRef(f"{BIBO_NAMESPACE}Document")

BIBO_EXCLUDED_PROPERTIES = {
    "authorList",
}

DCTERMS_EXCLUDED_PROPERTIES = {
    "title",
    "issued",
}

bibo_graph = Graph()
bibo_graph.parse(BIBO_URL, format="turtle")

dcterms_graph = Graph()
dcterms_graph.parse(DCTERMS_URL)

bibo_properties = extract_terms(
    graph=bibo_graph,
    namespace=BIBO_NAMESPACE,
    rdf_types={
        RDF.Property,
        OWL.DatatypeProperty,
        OWL.ObjectProperty,
    },
    excluded=BIBO_EXCLUDED_PROPERTIES,
)

bibo_classes = extract_subclasses(
    graph=bibo_graph,
    namespace=BIBO_NAMESPACE,
    parent=BIBO_DOCUMENT,
)

# Include the root class itself.
bibo_classes = sorted(set(["Document", *bibo_classes]))

dcterms_properties = extract_terms(
    graph=dcterms_graph,
    namespace=DCTERMS_NAMESPACE,
    rdf_types={
        RDF.Property,
        OWL.DatatypeProperty,
        OWL.ObjectProperty,
    },
    excluded=DCTERMS_EXCLUDED_PROPERTIES,
)

bibo_fields = make_cue_fields(
    "bibo",
    bibo_properties,
)

dcterms_fields = make_cue_fields(
    "dcterms",
    dcterms_properties,
)

bibo_class_union = make_cue_union(
    "bibo",
    bibo_classes,
)

bibo_dc_output = f'''package bibo_dc

import "example.com/models:util"

#BIBODocumentClass:
\t{bibo_class_union}

#AdditionalBIBOInformation: {{
{bibo_fields}
}}

#AdditionalDublinCoreInformation: {{
{dcterms_fields}
}}

#AdditionalSourceInformation:
\t#AdditionalBIBOInformation &
\t#AdditionalDublinCoreInformation
'''

BIBO_DC_OUTPUT_PATH.write_text(
    bibo_dc_output,
    encoding="utf-8",
)

print(
    f"Generated {len(bibo_properties)} BIBO properties, "
    f"{len(bibo_classes)} BIBO document classes, and "
    f"{len(dcterms_properties)} Dublin Core properties."
)
print(f"Output: {BIBO_DC_OUTPUT_PATH}")
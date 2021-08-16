%%%
title = "JavaScript Object Notation (JSON) Pointer Normalization"
abbrev = "JSON Pointer Normalization"
ipr= "none"
area = "Internet"
workgroup = "none"
submissiontype = "IETF"
keyword = ["json", "normalization", "json-pointer"]
date = 2021-08-16

[seriesInfo]
name = "Individual-Draft"
value = "draft-json-ptr-n11n-00"
status = "informational"

[[author]]
initials = "T."
surname = "Markovski"
fullname = "Tomislav Markovski"
#role = "editor"
organization = "Trinsic"
  [author.address]
  email = "tomislav@trinsic.id"
%%%

.# Abstract

This document describes a normalization algorithm where a JSON Value [@!RFC7159] is represented as flattened,
single depth JSON object using JSON Pointer [@!RFC6901] as key value. Normalized objects have no data loss and can be denormalized
to obtain the original JSON value.

{mainmatter}

# Introduction

Object normalization can be defined as converting a nested data layer object into a new object with one layer of key/value pairs.
We call the result normalized object, or normalized map. Any valid JSON value, as defined in [@!RFC7159] Section 3,
can be represented in normalized form. Semantically, normalized objects contain the same information as their original
JSON value and can be determinisitically converted between both formats.

JSON Pointer normalization is useful in different scenarios, such as nested data search, data indexing, object comparison,
attribute-based signatures, etc.

# Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL"
in this document are to be interpreted as described in [@!RFC2119].

# Normalization Algorithm

This section describes the details related to creating a normalized JSON representation.
Normalized JSON value is represented as a JSON object with a single level key/value entries.

The ABNF syntax of a normalized object is:

```abnf
normalized-object =
  begin-object
  [ normalized-entry *( value-separator normalized-entry ) ]
  end-object
    ; some rule names are referenced in RFC7159
normalized-entry  = json-pointer name-separator value
    ; some rule names are referenced in RFC6901 and RFC7159
```

## Input Data Requirements

The input JSON data **MUST** adhere to the rules:

- Input **MUST** be a valid JSON value as defined in [@!RFC7159]
- Input **MUST NOT** contain `NaN` or `Infinity` literals
- Input **MUST NOT** contain duplicate keys in any object element

## Generation of Normalized Data

Normalized objects have the following properties:

- Normalized JSON object **MUST** be of type "object"
- All nodes in the original object **MUST** be represented with a single entry in the normalized map
- The key of the normalized entry **MUST** be the JSON pointer [@!RFC6901] of the node in the original object
- The value of the normalized entry **MUST** follow the normalization for each type as described in the sections below
- Normalized objects **MUST NOT** contain extra information or metadata

### Normalization of Structured Data

Node elements of type "array" or "object" are normalized using their empty state.

- Objects **MUST** be normalized as empty JSON objects `{}`
- Arrays **MUST** be normalized as empty JSON arrays `[]`

### Normalizaton of Primitive Types

Node elements of type "string", "number", "null", or "boolean" **MUST** be normalized as their original value.

## Example

The input JSON object:

```
{
    "hello": "world",
    "foo": { "bar": "baz" },
    "knows": [ 42, null ]
}
```

Can be normalized into:

```
{
  "": {},
  "/hello": "world",
  "/foo": {},
  "/foo/bar": "baz",
  "/knows": [],
  "/knows/0": 42,
  "/knows/1": null
}
```

# Conformance

It is **RECOMMENDED** that implentations use the available test vectors to run conformance tests against this specification.

Repository
: https://github.com/trinsic-id/json-ptr-n11n-spec


{backmatter}
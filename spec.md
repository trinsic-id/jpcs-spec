%%%
title = "JavaScript Object Notation (JSON) Normalization"
abbrev = "JavaScript Object Notation (JSON) Normalization"
ipr= "none"
area = "Internet"
workgroup = "none"
submissiontype = "IETF"
keyword = [""]

[seriesInfo]
name = "Individual-Draft"
value = "draft-json-flat-ptr-00"
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

Object normalization can be defined as converting a nested data layer object into a new object with one layer of key/value pairs. We call the result normalized object, or normalized map. Any valid JSON value, as defined in [@!RFC7159] Section 3, can be represented in normalized form. Semantically, normalized objects contain the same information as their original JSON value and can be determinisitically converted between both formats.

JSON Pointer normalization is useful in different scenarios, such as nested data search, data indexing, object comparison, attribute-based signatures, etc.

# Normalization Algorithm

Normalized JSON value is represented as a JSON object with a single level children entries. Each node in the original object, including root node, is represented with a single entry in the normalized map. The key of the normalized entry is the JSON pointer of the node in the original object, while the value is the value of the original node, with an exception for arrays and objects. If the node in the original object is of type `"array"` or `"object"`, the value of the entry in the normalized map is empty array `[]` or empty object `{}` respectively.

For example, this input JSON object:

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

# Test Vectors

Implementations should use the provided test vectors to run conformance tests against this specification.


{backmatter}
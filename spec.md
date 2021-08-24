%%%
title = "JSON Pointer Canonicalization (JPC)"
abbrev = "jpc"
ipr= "none"
area = "Internet"
category = "info"
workgroup = "none"
submissiontype = "independent"
keyword = ["json", "canonicalization", "json-pointer"]
date = 2021-08-16

[pi]
toc = "yes"

[seriesInfo]
name = "Internet-Draft"
value = "draft-tmarkovski-jpc-latest"
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

This document describes a JSON normalization algorithm where a JSON Value [@!RFC7159] is represented as flattened,
single depth JSON object using JSON Pointer [@!RFC6901] as key value. Normalized objects have no data loss and can be denormalized
to obtain the original JSON value.

{mainmatter}

# Introduction

Object canonicalization can be defined as converting a nested data layer object into a new object with one layer of key/value pairs.
We call the result canonical object, or canonical map. Any valid JSON value, as defined in [@!RFC7159] Section 3,
can be represented in canonical form. Semantically, normalized objects contain the same information as their original
JSON value and can be determinisitically converted between both formats.

JSON Pointer Canonicalization is useful in different scenarios, such as nested data search, data indexing, object comparison,
aggregatable signatures, etc.

# Conventions

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**
in this document are to be interpreted as described in [@!RFC2119].

# Canonicalization Algorithm

This section describes the details related to creating a canonical JSON representation.
Canonical objects are represented as a JSON object with a single level key/value entries.
The key of each entry is the JSON Pointer of that entry in the original form.

The ABNF syntax of a normalized object is:

```abnf
normalized-object = begin-object
                    [ normalized-value *( value-separator normalized-value ) ]
                    end-object

normalized-value  = json-pointer name-separator value

value             = false / null / true / number / string / empty-object / empty-array

empty-object      = begin-object end-object

empty-array       = being-array end-array

                        ; some rule names are described in RFC7159 and RFC6901
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
- The value of the normalized entry **MUST** follow the canonicalization for each type as described in the sections below
- Normalized objects **MUST NOT** contain extra information or metadata

### canonicalization of Structured Data

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
  "foo": { "bar": true },
  "knows": [ 42, null ]
}
```

Can be normalized into:

```
{
  "": {},
  "/hello": "world",
  "/foo": {},
  "/foo/bar": true,
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

# ECMAScript Sample canonicalization

Below is an example function of JSON canonicalization for usage with ECMAScript-based [@!ECMA-262] systems:

~~~ js
const normalize = function (data, pathSegments = [""], normalizedObject = {}) {
  let currentPointer = pathSegments.join("");

  if (data === null) {
    Object.assign(normalizedObject, { [currentPointer]: data });
  } else if (Array.isArray(data)) {
    Object.assign(normalizedObject, { [currentPointer]: [] });
    data.forEach((element, index) => {
      pathSegments.push(`/${index}`);
      normalize(element, pathSegments, normalizedObject);
    });
  } else
    switch (typeof data) {
      case "string":
      case "number":
      case "boolean":
        Object.assign(normalizedObject, { [currentPointer]: data });
        break;
      case "object":
        Object.assign(normalizedObject, { [currentPointer]: {} });
        for (const [key, value] of Object.entries(data)) {
          pathSegments.push(`/${escape(key)}`);
          normalize(value, pathSegments, normalizedObject);
        }
        break;
      default:
        throw Error(`Invalid type: ${typeof data}`);
    }

  pathSegments.pop();
  return normalizedObject;
};

const escape = function (item) {
  return item.replace("~", "~0").replace("/", "~1");
};
~~~

# Development Portal

This specification is currently developed at https://github.com/trinsic-id/json-ptr-n11n-spec

<reference anchor="ECMA-262" target="https://www.ecma-international.org/ecma-262/10.0/index.html">
  <front>
    <title>ECMAScript 2019 Language Specification</title>
    <author>
      <organization>ECMA International</organization>
    </author>
    <date year="2019" month="June"/>
  </front>
  <refcontent>Standard ECMA-262 10th Edition</refcontent>
</reference>
%%%
title = "JSON Data Flattening using JSON Pointer"
abbrev = "JSON Data Flattening using JSON Pointer"
ipr= "none"
area = "Internet"
workgroup = "none"
submissiontype = "IETF"
keyword = [""]

[seriesInfo]
name = "Individual-Draft"
value = "draft-json-ptr-flat-00"
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

This document describes a transformation algorithm where a JSON Value [@!RFC7159] is represented as flattened,
single depth JSON object using JSON Pointer [@!RFC6901] as key values. Flattened objects have no data loss and can be unflattened
to obtain the original JSON value.

{mainmatter}

# Introduction

TODO

# Flattening Algorithm

TODO

## Examples

The object:

```
{
    "foo": "bar"
}
```

Will be flattened as:

```
{
    "": {},
    "/foo": "bar"
}
```

### Example array

An array with values of different types:

```
[
    "foo", "bar", true
]
```

Will be flattened as:

```json
{
    "": [],
    "/0": "foo",
    "/1": "bar",
    "/2": true
}
```

# Unflattening Algorithm

TODO

{backmatter}
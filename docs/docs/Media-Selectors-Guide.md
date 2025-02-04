**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2025
The MITRE Corporation. All Rights Reserved.

# Media Selectors Overview

Media selectors allow users to specify that only specific sections of a document should be
processed. A copy of the input file with the specified sections replaced by component output is
produced.


# New Job Request Fields

Below is an example of a job that uses media selectors. The job uses a two-stage pipeline.
The first stage performs language identification. The second performs translation.
```json
{
    "algorithmProperties": {},
    "buildOutput": true,
    "jobProperties": {},
    "media": [
        {
            "mediaUri": "file:///opt/mpf/share/remote-media/test-json-path-translation.json",
            "properties": {},
            "mediaSelectorsOutputAction": "ARGOS TRANSLATION (WITH FF REGION AND NO TASK MERGING) ACTION",
            "mediaSelectors": [
                {
                    "type": "JSON_PATH",
                    "expression": "$.spanishMessages.*.content",
                    "resultDetectionProperty": "TRANSLATION",
                    "selectionProperties": {}
                },
                {
                    "type": "JSON_PATH",
                    "expression": "$.chineseMessages.*.content",
                    "resultDetectionProperty": "TRANSLATION",
                    "selectionProperties": {}
                }
            ]
        }
    ],
    "pipelineName": "ARGOS TRANSLATION (WITH FASTTEXT LANGUAGE ID) TEXT FILE PIPELINE",
    "priority": 4
}
```
- `$.media.*.mediaSelectorsOutputAction`: Name of the action that produces content for the media
    selectors output file. In the above example, we specify that we want the translated content
    from Argos in the media selectors output file rather than the detected language from the first
    stage.
- `$.media.*.mediaSelectors`: List of media selectors that will be used for the media.
- `$.media.*.mediaSelectors.*.type`: The name of the [type of media selector](#media-selector-types)
    that is used in the `expression` field.
- `$.media.*.mediaSelectors.*.expression`: A case-sensitive string specifying the sections of the
    document that should be processed. The `type` field specifies the syntax of the expression.
- `$.media.*.mediaSelectors.*.resultDetectionProperty`: A detection property name from tracks
    produced by the `mediaSelectorsOutputAction`. The media selectors output document will be
    populated with the content of the specified property.
- `$.media.*.mediaSelectors.*.selectionProperties`: Job properties that will only be used for
    sub-jobs created for a specific media selector. For example, when performing Argos translation
    on a JSON file in a single-stage pipeline without an upstream language detection stage, this
    could set `DEFAULT_SOURCE_LANGUAGE=es` for some media selectors and
    `DEFAULT_SOURCE_LANGUAGE=zh` for others.


# New Job Properties

- `MEDIA_SELECTORS_DELIMETER`: When not provided and a job uses media selectors, the selected parts
    of the document will be replaced with the action output. When provided, the selected parts of
    the document will contain the original content, followed by the value of this property, and
    finally the action output.
- `MEDIA_SELECTORS_DUPLICATE_POLICY`: Specifies how to handle the case where a job uses media
    selectors and there are multiple outputs for a single selection. When set to `LONGEST`, the
    longer of the two outputs is chosen and the shorter one is discarded. When set to `ERROR`,
    duplicates are considered an error. When set to `JOIN`, the duplicates are combined using
    ` | ` as a delimiter.
- `MEDIA_SELECTORS_NO_MATCHES_IS_ERROR`: When true and a job uses media selectors, an error will be
    generated when none of the selectors match content from the media.


# Media Selector Types

`JSON_PATH` is only type currently supported, but others are planned.


## JSON_PATH

Used to extract content for JSON files. Uses the "Jayway JsonPath" library to parse the expressions.
The specific syntax supported is available on their
[GitHub page](https://github.com/json-path/JsonPath?tab=readme-ov-file#operators). JsonPath
expressions are case-sensitive.

When extracting content from the document, only strings, arrays, and objects are considered. All
other JSON types are ignored. When the JsonPath expression matches an array, each element is
recursively explored. When the expression matches an object, keys are left unchanged and each value
of the object is recursively explored.

### JSON_PATH Matching Example

```json
{
    "key1": ["a", "b", "c"],
    "key2": {
        "key3": [
            {
                "key4": ["d", "e"],
                "key5": ["f", "g"],
                "key6": 6
            }
        ]
    }
}
```
Expression           | Matches
---------------------|-----------
`$`                  | a, b, c, d, e, f, g
`$.*`                | a, b, c, d, e, f, g
`$.key1`             | a, b, c
`$.key1[0]`          | a
`$.key2`             | d, e, f, g
`$.key2.key3`        | d, e, f, g
`$.key2.key3.*.key4` | d, e
`$.key2.key3.*.*[0]` | d, f



# Media Selectors Output File

When media selectors are used, the JsonOutputObject will contain a URI referencing the file
location in the `$.media.*.mediaSelectorsOutputUri` field.

The job from the [New Job Request Fields section](#new-job-request-fields) could be used with the
document below.
```json
{
    "otherStuffKey": ["other stuff value"],
    "spanishMessages": [
        {
            "to": "spanish recipient 1",
            "from": "spanish sender 1",
            "content": "¿Hola, cómo estás?"
        },
        {
            "to": "spanish recipient 2",
            "from": "spanish sender 2",
            "content": "¿Dónde está la biblioteca?"
        }
    ],
    "chineseMessages": [
        {
            "to": "chinese recipient 1",
            "from": "chinese sender 1",
            "content": "现在是几奌？"
        },
        {
            "to": "chinese recipient 2",
            "from": "chinese sender 2",
            "content": "你叫什么名字？"
        },
        {
            "to": "chinese recipient 3",
            "from": "chinese sender 3",
            "content": "你在哪里？"
        }
    ]
}
```

The `mediaSelectorsOutputUri` field will refer to a document containing the content below.
```json
{
    "otherStuffKey": ["other stuff value"],
    "spanishMessages": [
        {
            "to": "spanish recipient 1",
            "from": "spanish sender 1",
            "content": "Hello, how are you?"
        },
        {
            "to": "spanish recipient 2",
            "from": "spanish sender 2",
            "content": "Where is the library?"
        }
    ],
    "chineseMessages": [
        {
            "to": "chinese recipient 1",
            "from": "chinese sender 1",
            "content": "What time is it?"
        },
        {
            "to": "chinese recipient 2",
            "from": "chinese sender 2",
            "content": "What is your name?"
        },
        {
            "to": "chinese recipient 3",
            "from": "chinese sender 3",
            "content": "Where are you?"
        }
    ]
}
```

If `MEDIA_SELECTORS_DELIMETER` was set to " | Translation: ", the file would contain the content
below.

```json
{
    "otherStuffKey": ["other stuff value"],
    "spanishMessages": [
        {
            "to": "spanish recipient 1",
            "from": "spanish sender 1",
            "content": "¿Hola, cómo estás? | Translation: Hello, how are you?"
        },
        {
            "to": "spanish recipient 2",
            "from": "spanish sender 2",
            "content": "¿Dónde está la biblioteca? | Translation: Where is the library?"
        }
    ],
    "chineseMessages": [
        {
            "to": "chinese recipient 1",
            "from": "chinese sender 1",
            "content": "现在是几奌？ | Translation: What time is it?"
        },
        {
            "to": "chinese recipient 2",
            "from": "chinese sender 2",
            "content": "你叫什么名字？ | Translation: What is your name?"
        },
        {
            "to": "chinese recipient 3",
            "from": "chinese sender 3",
            "content": "你在哪里？ | Translation: Where are you?"
        }
    ]
}
```

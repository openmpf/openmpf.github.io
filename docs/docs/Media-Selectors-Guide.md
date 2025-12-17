**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2025
The MITRE Corporation. All Rights Reserved.

# Media Selectors Overview

Media selectors allow users to specify that only specific sections of a document should be
processed. A copy of the input file with the specified sections replaced by component output is
produced.


# New Job Request Fields

Below is an example of a job that uses `JSON_PATH` media selectors. The job uses a two-stage
pipeline. The first stage performs language identification. The second performs translation.

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
- `$.media.*.mediaSelectors.*.expression`: A string specifying the sections of the document that
    should be processed. The `type` field specifies the syntax of the expression.
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

[`JSON_PATH`](#json_path) and [`CSV_COLS`](#csv_cols) are currently supported.


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


### JSON_PATH Output File

When media selectors are used, the JsonOutputObject will contain a URI referencing the file
location in the `$.media.*.mediaSelectorsOutputUri` field.

For example, consider that the `mediaUri` from job in the 
[New Job Request Fields section](#new-job-request-fields) refers to the document below.

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


## CSV_COLS

Used to extract content from specific columns of a CSV file.  The expression itself must be a
single row of CSV listing the columns to extract. The `CSV_SELECTORS_ARE_INDICES` job property
controls whether the entries refer to column names or zero-based integer indices.


### CSV-Specific Job Properties

- `CSV_SELECTORS_ARE_INDICES`: When `FALSE` (the default), the selector expression must contain
    column names.  When `TRUE` the selector should contain the zero-based integer indices of the
    columns that should be processed.

- `CSV_CSV_FIRST_ROW_IS_DATA`: When `FALSE` (the default), the first row is considered headers and
    will not be processed. When `TRUE`, the first row is considered data and the first row will be
    processed.

An issue when processing CSV is that sometimes the first row is considered headers (a.k.a. column
names) and in others the first row is actually data and there are no headers.

- In the default configuration (`CSV_SELECTORS_ARE_INDICES` = `FALSE` and
    `CSV_FIRST_ROW_IS_DATA` = `FALSE`), the selector expression refers to column names and the
    first row is not processed as data.

- If the first row is actual data, and you want to specify the columns by index instead of by
    name in the selector expression, set `CSV_SELECTORS_ARE_INDICES` = `TRUE` and
    `CSV_FIRST_ROW_IS_DATA` = `TRUE`.

- If the first row is headers, and you want to specify the columns by index instead of by
    name in the selector expression, set `CSV_SELECTORS_ARE_INDICES` = `TRUE` and
    `CSV_FIRST_ROW_IS_DATA` = `FALSE`.


### CSV_COLS Matching Example

The table below shows combinations of values for `CSV_SELECTORS_ARE_INDICES` and
`CSV_FIRST_ROW_IS_DATA` when matched against this CSV content:

```text
header0,header1,"header,2"
a,b,c
d,e,f,g
```

Expression | `CSV_SELECTORS_`<br>`ARE_INDICES` | `CSV_FIRST_ROW_`<br>`IS_DATA` | Matches
---------------------|---------------|-------------------|------------
`header0,"header,2"` |     FALSE     |       FALSE       | a, c, d, f
`header0,"header,2"` |     FALSE     |       TRUE        | header0, "header,2", a, c, d, f
`header0,headerX`    |     FALSE     |   TRUE / FALSE    | **Error**: "headerX" does not exist
`header0,header,2`   |     FALSE     |   TRUE / FALSE    | **Error**: "header" and "2" do not exist
`header0,"header,2"` |     TRUE      |   TRUE / FALSE    | **Error**: The expression contains non-integers.
`0,2`                |     TRUE      |       FALSE       | a, c, d, f
`0,2`                |     TRUE      |       TRUE        | header0, "header,2", a, c, d, f
`0,3,4`              |     TRUE      |       FALSE       | a, d, g
`0,2`                |     FALSE     |    TRUE / FALSE   | **Error**: There are no columns with "0" or "2" as the header.


### CSV Text Encodings

We recommend submitting UTF-8-encoded CSV files, but we do attempt to recognize other text
encodings. When attempting to determine the input file encoding, the Workflow Manager will inspect
the first 12,000 bytes of the file. If all of the 12,000 bytes are valid UTF-8 bytes, then the
Workflow Manager will treat the file as UTF-8. Otherwise, the Workflow Manager will use
[Tika's `CharsetDetector`](https://tika.apache.org/2.9.1/api/org/apache/tika/parser/txt/CharsetDetector.html)
to determine the encoding.

The media selectors output file will always be UTF-8-encoded. If the input file was UTF-8-encoded
and had a byte-order mark, then a byte-order mark will be added to the output file.


#### Byte-order mark

The UTF-8, UTF-16, and UTF-32 text encodings may have a byte-order mark present. The byte-order
mark is the Unicode character named "ZERO WIDTH NO-BREAK SPACE" with a code point of U+FEFF. Each
encoding will encode it as different bytes. For example, in UTF-8 it is encoded with three bytes:
`0xEF`, `0xBB`, `0xBF`.

Many CSV parsers do not have special handling for the byte-order mark. They just treat it as a
normal character and consider it to be the first character in the first cell. The Workflow Manager
discards the byte-order mark before parsing the CSV.


#### Excel

- If you open a CSV file in Microsoft Excel and the text is garbled, you should open the file
    in a text editor that supports UTF-8 and see if the text is garbled there too.

- When saving a CSV file from Excel, if you select "CSV (Comma delimited)(*.csv)", Excel will
    silently replace East Asian characters with question marks. Selecting
    "CSV UTF-8 (Comma delimited) (.csv)" preserves the East Asian characters, but it adds a
    byte-order mark to the file.

- If you open a UTF-8-encoded file in Excel, it will treat it as ISO-8859-1 unless the file has
    a UTF-8 byte-order mark.

Using a byte-order mark with UTF-8 is uncommon because the UTF-8 encoding does not have endianess
like UTF-16 and UTF-32. The byte-order mark added by Excel can cause problems because a
lot of software does not expect it to be present.


As an example, consider an Excel spreadsheet with the following content:

Col,1 | Col,2
------|--------
item1 | item2


If you save that as "CSV UTF-8 (Comma delimited) (.csv)" and then `cat` the file you will get:

```text
"Col,1","Col,2"
item1,item2
```

Since the two column names contain commas, the cells need to be escaped with quotation marks so that
the internal comma is not interpreted as a record separator. If you parse that file with
[Python's built-in CSV parser](https://docs.python.org/3/library/csv.html) you get the following
result:

 ﻿"Col | 1"    | Col,2
-------|-------|------
item1  | item2 |


While the first cell above appears to be four characters in length, it is actually five. The first
character is U+FEFF (ZERO WIDTH NO-BREAK SPACE). Since the first cell starts with
U+FEFF (ZERO WIDTH NO-BREAK SPACE), rather than U+0022 (QUOTATION MARK), the first comma is
unescaped so it is interpreted as the record separator.

Since the byte-order mark is invisible when rendered, simply printing the content will not reveal
the issue. It is visible in a hexdump produced with `hexdump -C` on Linux or `Format-Hex` in
Windows Powershell. In the output from `hexdump -C` below, you can see that there is content before
the quotation mark and that content matches the UTF-8-encoded byte-order mark of `0xEF`, `0xBB`,
`0xBF`.

```text
00000000  ef bb bf 22 43 6f 6c 2c  31 22 2c 22 43 6f 6c 2c  |..."Col,1","Col,|
00000010  32 22 0d 0a 69 74 65 6d  31 2c 69 74 65 6d 32 0d  |2"..item1,item2.|
00000020  0a                                                |.|
```


### CSV_COLS Output File

When media selectors are used, the JsonOutputObject will contain a URI referencing the file
location in the `$.media.*.mediaSelectorsOutputUri` field.

TODO: Provide an example input file. (JSON_PATH refers to an example from an earlier section,
but we need to create an example CSV here.)

TODO: Provide an example output without and with delimiters, like the JSON_PATH examples.
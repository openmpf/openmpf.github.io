**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2023
The MITRE Corporation. All Rights Reserved.


# Roll Up Overview

The Workflow Manager can be configured to replace the values of track and detection properties after
receiving tracks and detections from a component. This feature is commonly used to replace specific
terms with a more general category. For example, the "CLASSIFICATION" property may be set to "car",
"bus", and "truck". Those are all a kind of "vehicle". To use this feature, a JSON file in the
format described below must be created. Then, the `ROLL_UP_FILE` job property must be set to the
file path where that file is located.


# Roll Up File

The JSON below is an example of a roll up file.

```json
[
    {
        "propertyToProcess": "CLASSIFICATION",
        "originalPropertyCopy": "ORIGINAL CLASSIFICATION",
        "groups": [
            {
                "rollUp": "vehicle",
                "members": [
                    "truck",
                    "car",
                    "bus"
                ]
            },
            {
                "rollUp": "sandwich",
                "members": [
                    "grilled cheese",
                    "reuben",
                    "hamburger",
                    "hot dog"
                ]
            }
        ]
    },
    {
        "propertyToProcess": "COLOR",
        "groups": [
            {
                "rollUp": "purple",
                "members": [
                    "indigo"
                ]
            }
        ]
    },
    {
        "propertyToProcess": "PROP3",
        "groups": [
            {
                "rollUp": "new name",
                "members": [
                    "old name"
                ]
            }
        ]
    }
]
```

At the top level, the roll up file contains an array where each element defines a detection property
that should be modified. In this example, there is one element for "CLASSIFICATION", one for
"COLOR", and one for "PROP3". Each element contains the following fields:

- `propertyToProcess`: (Required) A detection property key. The value will be modified according to
    the `groups` key.
- `originalPropertyCopy`: (Optional) Copies the value of `propertyToProcess` prior to roll up to
    another property. The copy is made even if the property is not modified.
- `groups`: (Optional) Array containing an element for each roll up name. If the value of the
    detection property specified by `propertyToProcess` matches a string listed in `members`, it
    will be replaced by the content of the `rollUp` property.

In the example above, the value of the "CLASSIFICATION" detection property will be copied to
"ORIGINAL CLASSIFICATION" before the roll up is performed. If the "CLASSIFICATION" detection
property is set to "truck", "car", or "bus", the value of the detection property will be replaced
by "vehicle".

In a real use case there will generally be multiple roll up groups for a single detection property.
The "sandwich" group shows how to include an additional mapping for the same "CLASSIFICATION"
property. The "COLOR" and "PROP3" sections show examples of how to apply roll up to different
detection properties with different configurations.

If the roll up above was applied to these detection properties:

```json
{
    "CLASSIFICATION": "truck",
    "COLOR": "red",
    "PROP3": "truck",
    "PROP4": "other"
}
```

it would result in:

```json
{
    "CLASSIFICATION": "vehicle",
    "ORIGINAL CLASSIFICATION": "truck",
    "COLOR": "red",
    "PROP3": "truck",
    "PROP4": "other"
}
```

"COLOR" was not modified since it does not define a roll up group with "red" as a member. "PROP3"
was not modified because only the "CLASSIFICATION" property has a roll up group with "truck" as a
member. "PROP4" was not modified because it is not in the roll up file.

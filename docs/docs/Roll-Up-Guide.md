**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2023
The MITRE Corporation. All Rights Reserved.


# Roll Up Overview

The Workflow Manager can be configured to replace the values of detection properties after
receiving detections from a component. This is commonly used to replace specific terms with a more
general category. To use this feature, a JSON file in the format described below must be created.
Then, the `ROLL_UP_FILE` job property must be set to the file path where that file is located.


# Roll Up File

At the top level, the roll up file contains an array. The array contains an object for each
detection property should be modified. Each object contains the following fields:

- `propertyToProcess`: (Required) A detection property key. The value will be modified according to
    the `groups` key.
- `originalPropertyCopy`: (Optional) Copies the value of `propertyToProcess` prior to roll up to
    another property. The copy is made even if property is not modified.
- `groups`: (Optional) Array containing an object for each roll up name. If the value of the
    detection property specified by `propertyToProcess` matches a string listed in `members`, it
    will be replaced by the content of the `rollUp` property.

In the example below, the value of the "CLASSIFICATION" detection property will be copied to
"ORIGINAL CLASSIFICATION" before the roll up is performed. If the "CLASSIFICATION" detection
property is set to "truck", "car", or "bus", the value of the detection property will be replaced
by "vehicle". In a real use case there will generally be multiple roll up groups for a single
detection property. The "sandwich" group shows how to include an additional mapping for the same
detection property. The "PROP2" section is an example of how to apply roll up to an additional
detection property with a different configuration.

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
        "propertyToProcess": "PROP2",
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

If the roll up above was applied to these detection properties:
```json
{
    "CLASSIFICATION": "truck",
    "PROP2": "truck",
    "PROP3": "other"
}
```

it would result in:
```json
{
    "CLASSIFICATION": "vehicle",
    "ORIGINAL CLASSIFICATION": "truck",
    "PROP2": "truck",
    "PROP3": "other"
}
```

"PROP2" was not modified because because only the "CLASSIFICATION" property has the "vehicle" roll
up group. "PROP3" was not changed because it is not in the roll up file.

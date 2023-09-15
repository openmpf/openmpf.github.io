**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2023
The MITRE Corporation. All Rights Reserved.


# Trigger Overview

The `TRIGGER` property enables pipelines that use [feed forward](Feed-Forward-Guide) to have
pipeline stages that only process certain tracks based on their track properties. It can be used
to select the best algorithm when there are multiple similar algorithms that each perform better
under certain circumstances. It can also be used to iteratively filter down tracks at each stage of
a pipeline.


# Syntax

The syntax for the `TRIGGER` property is: `<prop_name>=<prop_value1>[;<prop_value2>...]`.
The left hand side of the equals sign is the name of track property that will be used to determine
if a track matches the trigger. The right hand side specifies the required value for the specified
track property. More than one value can be specified by separating them with a semicolon. When
multiple properties are specified the track property must match any one of the specified values.
If the value should match a track property that contains a semicolon or backslash,
they must be escaped with a leading backslash. For example, `CLASSIFICATION=dog;cat` will match
"dog" or "cat". `CLASSIFICATION=dog\;cat` will match "dog;cat". `CLASSIFICATION=dog\\cat` will
match "dog\cat". When specifying a trigger in JSON it will need to [doubly escaped](#json-escaping).


# Trigger Algorithm

To describe the way that Workflow Manager applies the trigger we will use the example pipeline
defined below.

1. WHISPER SPEECH LANGUAGE DETECTION ACTION
    - (No TRIGGER)
2. SPHINX SPEECH DETECTION ACTION
    - TRIGGER: `ISO_LANGUAGE=eng`
3. WHISPER SPEECH DETECTION ACTION
    - TRIGGER: `ISO_LANGUAGE=spa`
4. ARGOS TRANSLATION (WITH FF REGION) ACTION
    - TRIGGER: `ISO_LANGUAGE=spa`
5. KEYWORD TAGGING (WITH FF REGION) ACTION
    - (No TRIGGER)



The goal of this pipeline is to determine if someone says one of the key words in an audio file or
the audio of a video file. The complication is that the input file could either be in English,
Spanish, or a combination of both, so the Spanish audio must also be translated. We want to use
Sphinx for English audio because we are pretending that Sphinx performs better than Whisper on
English audio for this example.

Triggers have no effect on the first stage because there are no input tracks to apply the trigger
to. In the example above, the first stage will output tracks containing an `ISO_LANGUAGE` track
property. The value will correspond to the language Whisper determines the audio to be in.

In the second stage, Workflow Manager will pass forward any tracks from stage one that match the
trigger. In the example above, Workflow Manager will check the track properties all of the tracks
from stage one. Tracks that have an `ISO_LANGUAGE` track property and have it set to "eng" will
be fed in to stage two.

When the Workflow Manager decides which tracks to feed in to stages beyond the second, it considers
all tracks generated prior to the stage that were not triggered by a previous stage. The third
stage in the example shows why we need to check all previous stages. If we only checked the
previous stage, then the third stage would be receiving the tracks that Sphinx already produced
a transcription for. The part of the algorithm where Workflow Manager filters out previously
triggered tracks has no effect because the triggers for stage two and stage three are mutually
exclusive. None of the tracks from stage two get fed in to stage three because Sphinx does not
add an `ISO_LANGUAGE` track property.

The fourth stage shows why Workflow Manager must filter out previously triggered tracks. If it did
not, stage four would receive the Spanish tracks from both stage one and stage three. Only the
tracks from stage three have the transcription, so they are the only tracks that can be translated.
In the example above, only the tracks from stage three get fed in to stage four. Workflow Manager
made the decision using the following steps:

1. **Get all tracks produced in stage one.**
2. Remove all tracks that have `ISO_LANGUAGE=eng` because they were triggered by stage two.
3. Remove all tracks that have `ISO_LANGUAGE=spa` because they were triggered by stage three.
    - After this operation, the only tracks that remain have no `ISO_LANGUAGE` or are a language
      other than English or Spanish.
4. Remove all tracks that do **not** have `ISO_LANGUAGE=spa` because they don't match the current
   stage's trigger.
    - This operation ends up removing all the tracks from stage one because the Spanish tracks were
      removed in step 3.
5. If there were any remaining tracks, they would be sent to stage four.
6. **Get all tracks produced in stage two.**
7. Remove all tracks that have `ISO_LANGUAGE=spa` because they were triggered by stage three.
      - Sphinx does not produce tracks with `ISO_LANGUAGE=spa`, so no tracks are excluded at this
      point.
8. Remove all tracks that do **not** have `ISO_LANGUAGE=spa`.
    - This operation ends up removing all the tracks because Sphinx does not produce tracks with
      `ISO_LANGUAGE=spa`
9. If there were any remaining tracks, they would be sent to stage four.
10. **Get all tracks produced in stage three.**
11. Stage three is the stage immediately before stage four, so there are no previous triggers to
    check.
12. Remove all tracks that do **not** have `ISO_LANGUAGE=spa`.
      - No tracks are removed. They all have `ISO_LANGUAGE=spa` because only Spanish tracks were
        fed in to stage 3.
13. Send the remaining tracks to stage four.



The fifth stage has no trigger set. When no trigger is set, that means all tracks will be triggered
by that stage. This decision ensures that pipelines that pipelines with no triggers behave the
same way as pipelines with triggers. If you apply the trigger algorithm to a pipeline where
each stage triggers all tracks, it will end up being the same as "pass stage N all the tracks
produced in stage N-1". Stage N will not get tracks from stage N-2, because stage N-2's tracks
would have been triggered by stage N-1.

In the example above stage five will receive:

- The tracks from stage one that were neither English nor Spanish.
    - The English tracks were triggered by stage two.
    - The Spanish tracks were triggered by stage three.
    - Tracks in other languages were never triggered.
- All of the tracks from stage two.
    - Sphinx didn't set `ISO_LANGUAGE` so they could not be triggered by a later stage.
- **None** of the tracks from stage three.
    - They were all triggered by stage four.
- All of the tracks from stage four.
    - Stage four is immediately before stage five, so there is no trigger to apply.



# Filtering Example

The example above shows an example of how triggers can be used to conditionally execute or skip
stages in a pipeline. Triggers can also be useful when all stages get triggered. In cases like
that, the individual triggers are logically `AND`ed together. This allows you to produce pipelines
that search for very specific things.

The pipeline below will extract the license plate numbers for all blue cars that contain either
an orangutan or a chimpanzee.


1. OCV YOLO OBJECT DETECTION TASK
    - (No TRIGGER)
2. CAFFE GOOGLENET DETECTION ACTION
    - TRIGGER: `CLASSIFICATION=car`
    - FEED_FORWARD_TYPE: `REGION`
3. TENSORFLOW VEHICLE COLOR DETECTION ACTION
    - TRIGGER: `CLASSIFICATION=orangutan, orang, orangutang, Pongo pygmaeus;chimpanzee, chimp, Pan troglodytes`
    - FEED_FORWARD_TYPE: `REGION`
4. OALPR LICENSE PLATE TEXT DETECTION ACTION
    - TRIGGER: `CLASSIFICATION=blue`
    - FEED_FORWARD_TYPE: `REGION`



# JSON escaping

Many times job properties are defined using JSON and track properties appear in the JSON output
object. JSON also uses backslash as its escape character. Since the TRIGGER property and JSON both
use backslash as the escape character, when specifying the TRIGGER property in JSON, the string
must be doubly escaped.

If the job request contains this JSON fragment:
```json
{ "algorithmProperties": { "DNNCV": {"TRIGGER": "CLASS=dog;cat"} } }
```
it will match either "dog" or "cat", but not "dog;cat".


This JSON fragment:
```json
{ "algorithmProperties": { "DNNCV": {"TRIGGER": "CLASS=dog\\;cat"} } }
```
would only match "dog;cat".

This JSON fragment:
```json
{ "algorithmProperties": { "DNNCV": {"TRIGGER": "CLASS=dog\\\\cat"} } }
```
would only match "dog\cat". The track property in the JSON output object would appear as:
```json
{ "trackProperties": { "CLASSIFICATION": "dog\\cat" } }
```

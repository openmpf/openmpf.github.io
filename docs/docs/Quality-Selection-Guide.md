**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the
Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2024 The MITRE Corporation. All Rights Reserved.

# Introduction

There are a few places in OpenMPF where the quality of a detection comes into play. Here, "detection quality" is defined
to be a measurement of how "good" the detection is that can be used to rank the detections in a track from highest to
lowest quality. In many cases, components use "confidence" as an indicator of quality; however, there are some
components that do not compute a confidence value for its detections, and there are others that compute a different
value that is a better measure of quality for that detection algorithm. As discussed in the next section, OpenMPF uses
detection quality for a variety of purposes.


# Quality Selection Properties

`QUALITY_SELECTION_PROPERTY` is a string that defines the name of the property to use for quality selection. For
example, a face detection component may generate detections with a `DESCRIPTOR_MAGNITUDE` property that represents the
quality of the face embedding and how useful it is for reidentification. The Workflow Manager will search the
`detection_properties` map in each detection and track for that key and use the corresponding value as the detection
quality. The value associated with this property must be an integer or floating point value, where higher values
indicate higher quality. The one exception is that if this property is set to `CONFIDENCE`, then the `confidence` member
of each detection and track is used to determine quality.

The choice of the exemplar to represent a track is most often determined based on the `QUALITY_SELECTION_PROPERTY`.
For components that do not compute a quality value or that assign identical quality to all detections, the
Workflow Manager will simply choose the first detection in the track as the exemplar. In this circumstance, if you want
to choose something other than the first detection in the track, you can use the `EXEMPLAR_POLICY` property to control
that. The allowed values for this property are:

- `FIRST`: which selects the first detection in each track as the exemplar
- `MIDDLE`: which chooses the detection closest to the middle of the track
- `LAST`: which chooses the last detection in the track
- `QUALITY`: which uses the `QUALITY_SELECTION_PROPERTY` to choose the exemplar. This is the default.


`QUALITY_SELECTION_THRESHOLD` is a numerical value used for filtering out low quality detections and tracks. All
detections below this threshold are discarded, and if all the detections in a track are discarded, then the track itself
is also discarded. Note that components may do this filtering themselves, while others leave it to the Workflow Manager
to do the filtering. The thresholding process can be circumvented by setting this threshold to a value less than the
lowest possible value. For example, if the detection quality value computed by a component has values in the range 0 to
1, then setting the threshold property to -1 will result in all detections and all tracks being retained.

`FEED_FORWARD_TOP_QUALITY_COUNT` can be used to select the number of detections to include in a feed-forward track. For
example, if set to 10, only the top 10 highest quality detections are fed forward to the downstream component for that
track. If less then 10 detections meet the `QUALITY_SELECTION_THRESHOLD`, then only that many detections are fed
forward. Refer to the [Feed Forward Guide](Feed-Forward-Guide/index.html) for more information.

`ARTIFACT_EXTRACTION_POLICY_TOP_QUALITY_COUNT` can be used to select the number of detections that will be used to
extract artifacts. For example, if set to 10, the detections in a track will be sorted by their detection quality value,
and then the artifacts for the 10 detections with the highest quality will be extracted. If less then 10 detections meet
the `QUALITY_SELECTION_THRESHOLD`, then only that many artifacts will be extracted. Refer to the [Artifact Extraction Guide](Artifact-Extraction-Guide/index.html) for more information about artifact extraction.


# Hybrid Quality Selection

In some cases, there may be a detection property that a component would like to use as a measure of quality but it
doesn't lend itself to simple thresholding, perhaps because its value is not linearly increasing, or it is not numeric. The
component can in this case create a custom property that represents the quality of detections using a numerical value that
corresponds to the ordering of the detections from low to high quality.

As a simple example, a face detector might be able to calculate the face pose and would like to select for artifact
extraction the face that is closest to frontal pose, and the two that are closest to left and right profile pose. If the face
detector computes the yaw with values between -90 degrees and +90 degrees, then the numerical order of those values would
not produce the desired result. In this case, the component could create a custom detection property called `RANK`, and
assign values to that property that orders the detections from highest to lowest quality. The face detection component would
assign the highest value of `RANK` to the detection with a value of yaw closest to 0, and the detections with values of yaw
closest to +/-90 degrees would be assigned the second and third highest values of `RANK`. Detections without the `RANK`
property would be treated as having the lowest possible quality value. Thus, the track exemplar would be the face with the
frontal pose, and the `ARTIFACT_EXTRACTION_POLICY_TOP_QUALITY_COUNT` property would be set to 3, so that the frontal and
two profile pose detections would be kept as track artifacts in addition to the exemplar.


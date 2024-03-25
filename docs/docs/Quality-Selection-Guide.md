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
indicate higher quality.

One exception is when this property is set to `CONFIDENCE` and no `CONFIDENCE` property exists in the
`detection_properties` map. Then the `confidence` member of each detection and track is used instead.

The primary way in which OpenMPF uses detection quality is to determine the track "exemplar", which is the highest
quality detection in the track. For components that do not compute a quality value, or where all detections have
identical quality, the Workflow Manager will choose the first detection in the track as the exemplar.

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
the `QUALITY_SELECTION_THRESHOLD`, then only that many artifacts will be extracted.


# Hybrid Quality Selection

In some cases, there may be a detection property that a component would like to use as a measure of quality but it
doesn't lend itself to simple thresholding. For example, a face detector might be able to calculate the face pose, and
would like to select faces that are in the most frontal pose as the highest quality detections. The yaw of the face pose
may be used to indicate this, but if it's values are between, say, -90 degrees and +90 degrees, then the highest quality
detection would be the one with a value of yaw closest to 0. This violates the need for the quality selection property
to take on a range of values where the highest value indicates the highest quality.

Another use case might be where the component would like to choose detections based on a set of quality values, or
properties. Continuing with the face pose example, the component might like to designate the detection with pose closest
to frontal as the highest quality, but would also like to assign high quality to detections where the pose is closest to
profile, meaning values of yaw closest to -90 or +90 degrees.

In both of these cases, the component can create a custom detection property that is used to rank these detections as it
sees fit. It could use a detection property called `RANK`, and assign values to that property to rank the detections
from lowest to highest quality. In the example of the face detector wanting to use the yaw of the face pose, the
detection with a value of yaw closest to 0 would be assigned a `RANK` property with the highest value, then the
detections with values of yaw closest to +/-90 degrees would be assigned the second and third highest values of `RANK`.
Detections without the `RANK` property would be treated as having the lowest possible quality value. Thus, the track
exemplar would be the face with the frontal pose, and the `ARTIFACT_EXTRACTION_POLICY_TOP_QUALITY_COUNT` property could
be set to 3, so that the frontal and two profile pose detections would be kept as track artifacts.


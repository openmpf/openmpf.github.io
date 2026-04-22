**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2026
The MITRE Corporation. All Rights Reserved.

<div style="background-color:orange">
    <p style="color:white; padding:5px">
        <b>WARNING: </b> The Subject Tracking API is not complete, and there are no future
        development plans. Use at your own risk.
    </p>
</div>

# API Overview

API for Subject Tracking components. Components implementing this API analyze image, video,
audio, or generic media inputs and return structured information about detected entities
(`mpf_subject_api.Entity`), the relationships between those entities
(`mpf_subject_api.Relationship`), and any accompanying properties. This specification describes the
job objects passed to components and the structured results they should return to the OpenMPF
framework.


# How to Create a Python Subject Tracking Component

In this example, we create a subject tracking component named "MySubjectComponent". An example can
be found
[here](https://github.com/openmpf/openmpf-python-component-sdk/tree/master/subject/examples/PythonSubjectComponent)

```
MySubjectComponent
├── Dockerfile
├── plugin-files
│   └── descriptor
│       └── descriptor.json
├── pyproject.toml
└── my_subject_component
    └── __init__.py
```

**1\. Create directory structure:**
```bash
mkdir -p MySubjectComponent/plugin-files/descriptor
mkdir MySubjectComponent/my_subject_component
touch MySubjectComponent/Dockerfile
touch MySubjectComponent/plugin-files/descriptor/descriptor.json
touch MySubjectComponent/pyproject.toml
touch MySubjectComponent/my_subject_component/__init__.py
```

**2\. Create pyproject.toml file in project's top-level directory:**

Example of a minimal pyproject.toml file:
```toml
[build-system]
requires = ["setuptools"]
build-backend = "setuptools.build_meta"

[project]
name = "MySubjectComponent"
version = "0.1"
dependencies = [
    "mpf_subject_api>=0.1"
]

[project.entry-points."mpf.exported_component"]
component = "my_subject_component:MySubjectComponent"

[tool.setuptools.package-data]
my_subject_component = ["models/*"]
```


The `project.name` parameter defines the distribution name. Typically the distribution name matches
the component name.

Any dependencies that component requires should be listed in the `project.dependencies` field.

The Component Executor looks in the `[project.entry-points."mpf.exported_component"]` element and
uses the `component` field to determine the component class. The `component` field should be the
(possibly dotted) module name, followed by a `:`, followed by the name of the class.  In the
example above, the module name is `my_subject_component` because the `MySubjectComponent` class is
defined in `my_subject_component/__init__.py`. If the class was defined in
`my_subject_component/other_file.py`, the entry point would be
`my_subject_component.other_file:MySubjectComponent`.

The `[tool.setuptools.package-data]` section is optional. It should be used when there are
non-Python files in a package directory that should be included when the component is installed.


**3\. Create descriptor.json file in MySubjectComponent/plugin-files/descriptor:**

Example of a minimal descriptor.json file:
```json
{
    "componentName": "MySubjectComponent",
    "componentVersion": "10.0",
    "sourceLanguage": "python",
    "componentLibrary": "MySubjectComponent",
    "properties": [
        {
            "name": "MIN_IOU",
            "description" : "Minimum required intersection over union for two tracks to be associated.",
            "type": "FLOAT",
            "defaultValue": "0.03"
        }
    ]
}
```


# API Specification

An OpenMPF Python Subject Tracking Component is a Python class that implements the
`component.get_subjects(job)` method.


#### component.get_subjects(job)

Called by the Component Executor to perform subject tracking across the provided detection
results. Implementations receive a `mpf_subject_api.SubjectTrackingJob` containing sequences
of detection job results (video, image, audio, generic) and must return a
`mpf_subject_api.SubjectTrackingResults` instance describing the detected entities,
relationships, and any result-level properties.

* Method Definition:
```python
class MySubjectTrackingComponent:
    def get_subjects(self, job: mpf_subject_api.SubjectTrackingJob) -> mpf_subject_api.SubjectTrackingResults:
        return mpf_subject_api.SubjectTrackingResults(...)
```

* Parameters:

| Parameter | Data Type                            | Description |
|-----------|--------------------------------------|-------------|
| job       | `mpf_subject_api.SubjectTrackingJob` | Object containing details about the work to be performed.

* Returns: `mpf_subject_api.SubjectTrackingResults`


#### mpf_subject_api.SubjectTrackingJob

Container for the inputs provided to a subject tracking component. The job aggregates
pre-existing detection results (from other detection components) for video, image, audio,
and generic media types together with job-level properties and a unique job name. Components
use these inputs as the source detections to link tracks into entities and infer relationships.

* Members:

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Data Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>job_name</td>
            <td><code>str</code></td>
            <td>
                A specific name given to the job by the OpenMPF framework. This value may be used,
                for example, for logging and debugging purposes.
            </td>
        </tr>
        <tr>
            <td>job_properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                A mapping of job-level properties provided by the Workflow Manager. These
                properties affect overall processing and can be used to pass configuration
                options to the component.
            </td>
        </tr>
        <tr>
            <td>video_jobs</td>
            <td><code>Sequence[VideoDetectionJobResults]</code></td>
            <td>
                A sequence of per-media results for video inputs. Each item contains the
                source media path, identifiers, properties, and upstream detection/tracking
                output that the subject tracking component should correlate and consume.
            </td>
        </tr>
        <tr>
            <td>image_jobs</td>
            <td><code>Sequence[ImageDetectionJobResults]</code></td>
            <td>
                A sequence of per-media results for image inputs containing the image path,
                identifiers, properties, and detection results to be used when constructing
                entities and relationships.
            </td>
        </tr>
        <tr>
            <td>audio_jobs</td>
            <td><code>Sequence[AudioJobResults]</code></td>
            <td>
                A sequence of per-media results for audio inputs. Each entry holds the
                audio path, IDs, properties, and any audio track or transcription results
                that can contribute to subject identification or linkage.
            </td>
        </tr>
        <tr>
            <td>generic_jobs</td>
            <td><code>Sequence[GenericJobResults]</code></td>
            <td>
                A sequence of per-media results for generic (non-image/video/audio) media
                sources. Used when subject tracking requires detections from other data
                types.
            </td>
        </tr>
    </tbody>
</table>


#### mpf_subject_api.VideoDetectionJobResults

Represents the results produced by a detection component for a single video media item.
subject tracking components use these results as input when constructing entities and
cross-media relationships.

* Members:
<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Data Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>data_uri</td>
            <td><code>str</code></td>
            <td>
                The URI of the input media file to be processed. Currently, this is a file path.
                For example, "/opt/mpf/share/remote-media/test-file.avi".
            </td>
        </tr>
        <tr>
            <td>media_id</td>
            <td><code>str</code></td>
            <td>
                A unique identifier for the media item.  This ID distinguishes the media across
                jobs and is referenced by <code>MediaReference</code>.
            </td>
        </tr>
        <tr>
            <td>algorithm</td>
            <td><code>str</code></td>
            <td>
                The name of the detection algorithm that produced these upstream
                results. Useful for provenance and for selecting or weighting detections
                from different algorithms during entity fusion.
            </td>
        </tr>
        <tr>
            <td>component_type</td>
            <td><code>str</code></td>
            <td>
                Indicates the kind of detections contained in <code>results</code> and helps map
                tracks to entity or track types. Example values include <code>FACE</code> and
                <code>CLASS</code>.
            </td>
        </tr>
        <tr>
            <td>job_properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Contains the properties that were provided when the detection job originally ran.
            </td>
        </tr>
        <tr>
            <td>media_properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Metadata associated with the media item that was determined when the detection job
                originally ran. Contains the same information as
                <code><a href="../Python-Batch-Component-API#mpf_component_apivideojob">mpf_component_api.VideoJob</a>.media_properties</code>.
            </td>
        </tr>
        <tr>
            <td>results</td>
            <td><code>Mapping[str, <a href="../Python-Batch-Component-API#mpf_component_apivideotrack">mpf_component_api.VideoTrack</a>]</code></td>
            <td>
                Mapping of track identifiers to the track objects produced by the
                upstream detection component. Keys are hex-encoded hashes, and values are
                <code>mpf_component_api.VideoTrack</code> instances with per-frame detections that
                the subject tracking component should consume and link into entities.
            </td>
        </tr>
    </tbody>
</table>


#### mpf_subject_api.ImageDetectionJobResults

Represents the results produced by a detection component for a single image. Components performing
subject tracking use these image-level detection results to identify entities and to establish
relationships with detections in other media.

* Members:
<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Data Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>data_uri</td>
            <td><code>str</code></td>
            <td>
                The URI of the input media file to be processed. Currently, this is a file path.
                For example, "/opt/mpf/share/remote-media/test-file.jpg".
            </td>
        </tr>
        <tr>
            <td>media_id</td>
            <td><code>str</code></td>
            <td>
                A unique identifier for the media item.  This ID distinguishes the media across
                jobs and is referenced by <code>MediaReference</code>.
            </td>
        </tr>
        <tr>
            <td>algorithm</td>
            <td><code>str</code></td>
            <td>
                The name of the detection algorithm that produced these image
                detections.
            </td>
        </tr>
        <tr>
            <td>component_type</td>
            <td><code>str</code></td>
            <td>
                Indicates the kind of detections contained in <code>results</code> and helps map
                tracks to entity or track types. Example values include <code>FACE</code> and
                <code>CLASS</code>.
            </td>
        </tr>
        <tr>
            <td>job_properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Contains the properties that were provided when the detection job originally ran.
            </td>
        </tr>
        <tr>
            <td>media_properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Metadata associated with the media item that was determined when the detection job
                originally ran. Contains the same information as
                <code><a href="../Python-Batch-Component-API#mpf_component_apiimagejob">mpf_component_api.ImageJob</a>.media_properties</code>.
            </td>
        </tr>
        <tr>
            <td>results</td>
            <td><code>Mapping[str, <a href="../Python-Batch-Component-API#mpf_component_apiimagelocation">mpf_component_api.ImageLocation</a>]</code></td>
            <td>
                Mapping of detection identifiers to the detection objects produced by the
                upstream detection component. Keys are hex-encoded hashes, and values are
                <code>mpf_component_api.ImageLocation</code> instances that the subject tracking
                component should consume and link into entities.
            </td>
        </tr>
    </tbody>
</table>


#### mpf_subject_api.AudioJobResults

Represents the results produced by an audio detection component for a single audio
media item. Audio results can include tracked audio events or transcriptions that help
identify subjects or establish relationships (for example, speaker co-occurrence).

* Members:
<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Data Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>data_uri</td>
            <td><code>str</code></td>
            <td>
                The URI of the input media file to be processed. Currently, this is a file path.
                For example, "/opt/mpf/share/remote-media/test-file.mp3".
            </td>
        </tr>
        <tr>
            <td>media_id</td>
            <td><code>str</code></td>
            <td>
                A unique identifier for the media item.  This ID distinguishes the media across
                jobs and is referenced by <code>MediaReference</code>.
            </td>
        </tr>
        <tr>
            <td>algorithm</td>
            <td><code>str</code></td>
            <td>
                The name of the audio detection algorithm that generated the results (for
                example, a speech detection or speaker diarization algorithm).
            </td>
        </tr>
        <tr>
            <td>component_type</td>
            <td><code>str</code></td>
            <td>
                The detection component type indicating the nature of the audio results.
                For example, <code>SPEECH</code>.
            </td>
        </tr>
        <tr>
            <td>job_properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Contains the properties that were provided when the detection job originally ran.
            </td>
        </tr>
        <tr>
            <td>media_properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Metadata associated with the media item that was determined when the detection job
                originally ran. Contains the same information as
                <code><a href="../Python-Batch-Component-API#mpf_component_apiaudiojob">mpf_component_api.AudioJob</a>.media_properties</code>.
            </td>
        </tr>
        <tr>
            <td>results</td>
            <td><code>Mapping[str, mpf_component_api.AudioTrack]</code></td>
            <td>
                Mapping of track identifiers to the audio track objects produced by the
                upstream detection component. Keys are hex-encoded hashes, and values are
                <code>mpf_component_api.AudioTrack</code> instances.  These tracks describe audio
                events or transcriptions that can be associated with entities or relationships.
            </td>
        </tr>
    </tbody>
</table>


#### mpf_subject_api.GenericJobResults

Represents results produced by a detection component for generic media types. Generic
results are used when the detection output does not fit image, video, or audio
categories but still contributes to subject identification or relationships.

* Members:

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Data Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>data_uri</td>
            <td><code>str</code></td>
            <td>
                The URI of the input media file to be processed. Currently, this is a file path.
                For example, "/opt/mpf/share/remote-media/test-file.pdf".
            </td>
        </tr>
        <tr>
            <td>media_id</td>
            <td><code>str</code></td>
            <td>
                A unique identifier for the media item.  This ID distinguishes the media across
                jobs and is referenced by <code>MediaReference</code>.
            </td>
        </tr>
        <tr>
            <td>algorithm</td>
            <td><code>str</code></td>
            <td>
                The name of the algorithm that generated the generic detection results.
            </td>
        </tr>
        <tr>
            <td>component_type</td>
            <td><code>str</code></td>
            <td>
                Indicates the kind of detections contained in <code>results</code> and helps map
                tracks to entity or track types. Example values include <code>TRANSLATION</code> and
                <code>TEXT</code>.
            </td>
        </tr>
        <tr>
            <td>job_properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Contains the properties that were provided when the detection job originally ran.
            </td>
        </tr>
        <tr>
            <td>media_properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Contains the properties that were provided when the detection job originally ran.
                Metadata associated with the media item that was determined when the detection job
                originally ran. Contains the same information as
                <code><a href="../Python-Batch-Component-API#mpf_component_apigenericjob">mpf_component_api.GenericJob</a>.media_properties</code>.
            </td>
        </tr>
        <tr>
            <td>results</td>
            <td>
                <code>Mapping[str, <a href="../Python-Batch-Component-API#mpf_component_apigenerictrack">mpf_component_api.GenericTrack</a>]</code>
            </td>
            <td>
                Mapping of track identifiers to the track objects produced by the
                upstream detection component. Keys are hex-encoded hashes, and values are
                <code>mpf_component_api.GenericTrack</code>. These generic tracks are consumed by
                the subject tracking component to build entities and relationships.
            </td>
        </tr>
    </tbody>
</table>



#### mpf_subject_api.SubjectTrackingResults

Return type for `component.get_subjects`. Encapsulates the entities and relationships
discovered by the subject tracking component, along with optional top-level properties.
Entities group together related detection tracks, and relationships link entities across
time and media.

* Members:

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Data Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>entities</td>
            <td><code>Mapping[str, Collection[mpf_subject_api.Entity]]</code></td>
            <td>
                Mapping of entity type keys (for example, <code>subject</code>,
                <code>vehicle</code>) to collections of <code>mpf_subject_api.Entity</code> objects.
                Each <code>mpf_subject_api.Entity</code> represents a single identified entity
                composed of one or more detection tracks.
            </td>
        </tr>
        <tr>
            <td>relationships</td>
            <td><code>Mapping[str, Collection[mpf_subject_api.Relationship]]</code></td>
            <td>
                Mapping of relationship type keys (for example, <code>proximity</code>) to
                collections of <code>mpf_subject_api.Relationship</code> objects that describe how
                entities are related in time and/or space across media.
            </td>
        </tr>
        <tr>
            <td>properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Optional mapping of top-level result properties. These are free-form
                key/value pairs that components can use to return metadata about the
                subject tracking run (for example, version or summary statistics).
            </td>
        </tr>
    </tbody>
</table>



#### mpf_subject_api.Entity

Represents a single identified entity discovered by the subject tracking
component. An entity aggregates one or more detection tracks and carries a unique
identifier, score, and optional properties.

* Members:

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Data Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td><code>uuid.UUID</code></td>
            <td>
                A unique UUID assigned to the entity. Used in
                <code>mpf_subject_api.Relationship.entities</code> to specify which entities are
                part of the relationship.
            </td>
        </tr>
        <tr>
            <td>score</td>
            <td><code>float</code></td>
            <td>
                A confidence or quality score for the entity. The numeric range is
                algorithm-dependent; components should document their score semantics. Use
                -1 if no score is available.
            </td>
        </tr>
        <tr>
            <td>tracks</td>
            <td><code>Mapping[str, Collection[str]]</code></td>
            <td>
                Mapping from track type keys (for example, <code>face</code>, <code>person</code>,
                <code>truck</code>`) to collections of track IDs. These track ids reference the
                upstream detection tracks that were associated to this entity.
            </td>
        </tr>
        <tr>
            <td>properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Optional key/value properties for the entity. Components can use this to
                attach attributes such as labels, canonical names, or other metadata.
            </td>
        </tr>
    </tbody>
</table>


#### mpf_subject_api.Relationship

Represents a relationship between two or more entities. Relationships capture
associations observed across media and frames (for example, co-occurrence or spatial
proximity) and include the entities involved, the media frames where the relationship
was observed, and optional properties.

* Members:

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Data Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>entities</td>
            <td><code>Collection[uuid.UUID]</code></td>
            <td>
                Collection of <code>mpf_subject_api.Entity.id</code> UUIDs that participate in this
                relationship.
            </td>
        </tr>
        <tr>
            <td>frames</td>
            <td><code>Collection[mpf_subject_api.MediaReference]</code></td>
            <td>
                Collection of <code>mpf_subject_api.MediaReference</code> objects indicating the
                media ids and frame indices where the relationship was observed. Used to locate the
                specific occurrences supporting the relationship.
            </td>
        </tr>
        <tr>
            <td>properties</td>
            <td><code>Mapping[str, str]</code></td>
            <td>
                Optional properties describing the relationship (for example, proximity
                distance, relationship confidence, or a textual description).
            </td>
        </tr>
    </tbody>
</table>


#### mpf_subject_api.MediaReference

Reference to a specific media asset and the frame indices relevant to an entity or relationship.
Media references are used inside `mpf_subject_api.Relationship.frames` to pinpoint where an
association was observed.

* Members:

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Data Type</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>id</td>
            <td><code>str</code></td>
            <td>
                The identifier for the referenced media. Matches the <code>media_id</code> values
                found in the various detection job result objects.
            </td>
        </tr>
        <tr>
            <td>frames</td>
            <td><code>Collection[int]</code></td>
            <td>
                A collection of frame numbers (integers) where the referenced entity or
                relationship occurs in the media.  For image media this contains 0; for video it
                lists relevant frame indices.
            </td>
        </tr>
    </tbody>
</table>

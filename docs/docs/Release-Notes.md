**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the
Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2022 The MITRE Corporation. All Rights Reserved.

# OpenMPF 7.2.x

<h2>7.2.0: April 2023</h2>

<h3>Documentation</h3>

- Created a new TiesDb Guide.
- Updated the Component Descriptor Reference with `outputChangedCounter`.
- Updated the REST API with a new `[POST] /rest/jobs/tiesdbrepost` endpoint.
- Updated the REST API `POST /rest/jobs` response with `tiesDbCheckStatus` and `outputObjectUri`.

<h3>TiesDb Re-Post</h3>

- UI changes
- New endpoint

<h3>TiesDb Checking</h3>

- Motivation
- Will return most recent best status results first
- Bypass media inspection by providing `MEDIA_HASH` and `MIME_TYPE` `media.metadata` in the job request.
- S3 copy by default, what if turned off

<h3>TiesDb Linked Media</h3>

- Thumbnail use case
- Use of `LINKED_MEDIA_HASH` `media.mediaProperty`

<h3>Output Changed Counter</h3>

- Workflow Manager
- Component `descriptor.json`

<h3>Changes to JSON Output Object</h3>

- New JSON output objects will include `tiesDbSourceJobId` and `tiesDbSourceMediaPath` when the Workflow Manager can use previous job results stored in TiesDB. Note that the Workflow Manager will not generate new JSON output object unless `S3_RESULTS_BUCKET` is set to a valid value, S3 access and secret keys are provided, and `TIES_DB_S3_COPY_ENABLED=true`.

<h3>Features</h3>

- [[#1438](https://github.com/openmpf/openmpf/issues/1438)] Create a REST endpoint that will attempt to re-post to TiesDb
- [[#1613](https://github.com/openmpf/openmpf/issues/1613)] Check TiesDb before running a job
- [[#1650](https://github.com/openmpf/openmpf/issues/1650)] Create TiesDb records for thumbnail jobs under the parent media

<h3>Updates</h3>

- [[#1342](https://github.com/openmpf/openmpf/issues/1342)] Use ffprobe to get FPS during media inspection
- [[#1564](https://github.com/openmpf/openmpf/issues/1564)] Use ffprobe's JSON output instead of regexes during media inspection
- [[#1601](https://github.com/openmpf/openmpf/issues/1601)] Update the Workflow Manager jobs table to be more efficient
- [[#1611](https://github.com/openmpf/openmpf/issues/1611)] Remove Workflow Manager timeout and bootout behavior

# OpenMPF 7.1.x

<h2>7.1.12: March 2023</h2>

<h3>Bug Fixes</h3>

- [[#1667](https://github.com/openmpf/openmpf/issues/1667)] Handle Webp files with extra data at the end that cause components to crash

<h2>7.1.10: March 2023</h2>

<h3>Updates</h3>

- [[#1662](https://github.com/openmpf/openmpf/issues/1662)] Monitor StorageBackend

<h2>7.1.9: February 2023</h2>

<h3>Bug Fixes</h3>

- [[#1675](https://github.com/openmpf/openmpf/issues/1675)] Prevent upgrade of cudnn in yolo server dockerfile

<h2>7.1.8: February 2023</h2>

<h3>Bug Fixes</h3>

- [[#1649](https://github.com/openmpf/openmpf/issues/1649)] Install specific version of libcudnn8 in Docker build

<h2>7.1.7: February 2023</h2>

<h3>Updates</h3>

- [[#1674](https://github.com/openmpf/openmpf/issues/1674)] Update `SPEAKER_ID` logic, set `LONG_SPEAKER_ID=0`

<h2>7.1.5: January 2023</h2>

<h3>Features</h3>

- [[#1542](https://github.com/openmpf/openmpf/issues/1542)] Update Azure Speech Detection component to select transcription language based on feed-forward track
- [[#1543](https://github.com/openmpf/openmpf/issues/1543)] Update audio transcoder to accept subsegments
- [[#1605](https://github.com/openmpf/openmpf/issues/1605)] Update Azure Translation to use detected language from upstream

<h2>7.1.1: December 2022</h2>

<h3>Bug Fixes</h3>

- [[#1634](https://github.com/openmpf/openmpf/issues/1634)] Update version numbers to 7.1

<h2>7.1.0: December 2022</h2>

<h3>Documentation</h3>

- Updated the Object Storage Guide with `S3_UPLOAD_OBJECT_KEY_PREFIX`.
- Updated the Markup Guide with `MARKUP_TEXT_LABEL_MAX_LENGTH`.

<h3>Exemplar Selection Policy</h3>

- The policy for selecting the exemplar detection for each track can now be set using the `EXEMPLAR_POLICY` job property
  with following values:
    - `CONFIDENCE`: Select the detection with the maximum confidence. If some confidences are the same, select the
      detection with the lower frame number. This is the default setting.
    - `FIRST`: Select the detection with the lowest frame number
    - `LAST`: Select the detection with the highest frame number
    - `MIDDLE`: Select the detection with the frame number closest to the middle frame of the track, preferring the
      detection with the lower frame number if there is an even number of frames

<h3>Automatic Rotation and Horizontal Flip Enabled by Default</h3>

- It is no longer necessary to explicitly set `AUTO_ROTATE` and `AUTO_FLIP` to true since that is now the default value.
- These properties affect all video and image components that use the MPFImageReader and MPFVideoCapture tools. When
  true, if the image has EXIF data, or there is metadata associated with a video that ffmpeg understands, the tools will
  use that information to properly orient the frames before returning the frames to the component for processing.

<h3>Support S3 Object Storage Key Prefix</h3>

- Set the `S3_UPLOAD_OBJECT_KEY_PREFIX` job property or `s3.upload.object.key.prefix` system property to add a prefix to
  object keys when the Workflow Manager uploads objects to the S3 object store. This affects the JSON output object,
  artifacts, markup files, and derivative media.
- Specifically, the Workflow Manager will upload objects to
  `<S3_RESULTS_BUCKET>/<S3_UPLOAD_OBJECT_KEY_PREFIX><file-hash-first-two-chars>/<file-hash-second-two-chars>/<file-hash>`.
- For example, if you wish to add "work/" to the object key, then set `S3_UPLOAD_OBJECT_KEY_PREFIX=work/`.

<h3>Features</h3>

- [[#1526](https://github.com/openmpf/openmpf/issues/1526)] Allow markup to display more than 10 characters in the text
  part of the label
- [[#1527](https://github.com/openmpf/openmpf/issues/1527)] Enable the Workflow Manager to select the middle detection
  as the exemplar
- [[#1566](https://github.com/openmpf/openmpf/issues/1566)] Make `AUTO_ROTATE` and `AUTO_FLIP` true by default
- [[#1569](https://github.com/openmpf/openmpf/issues/1569)] Modify C++ and Python component executor to automatically
  add the job name to log messages
- [[#1621](https://github.com/openmpf/openmpf/issues/1621)] Make S3 object keys used for upload configurable

<h3>Updates</h3>

- [[#1602](https://github.com/openmpf/openmpf/issues/1602)] Update Workflow Manager to use Spring Boot
- [[#1631](https://github.com/openmpf/openmpf/issues/1631)] Update byte-buddy, Mockito, and Hibernate versions to
  resolve build issue. Most notably, update Hibernate to 5.6.14.
- [[#1632](https://github.com/openmpf/openmpf/issues/1632)] Update ActiveMQ to 5.17.3

<h3>Bug Fixes</h3>

- [[#1581](https://github.com/openmpf/openmpf/issues/1581)] Don't change track start and end frame when
  `FEED_FORWARD_TOP_CONFIDENCE_COUNT` is disabled
- [[#1595](https://github.com/openmpf/openmpf/issues/1595)] Work around how Ubuntu only recognizes certificate files
  that end in .crt
- [[#1610](https://github.com/openmpf/openmpf/issues/1610)] Prevent premature pipeline creation when using web UI
- [[#1612](https://github.com/openmpf/openmpf/issues/1612)] At startup, prevent Workflow Manager from consuming from
  queues before purging them

# OpenMPF 7.0.x

<h2>7.0.3: September 2022</h2>

<h3>Bug Fixes</h3>

- [[#1561](https://github.com/openmpf/openmpf/issues/1561)] Fix logging for Python components when running through CLI
  runner
- [[#1583](https://github.com/openmpf/openmpf/issues/1583)] Can now properly view media while job is in progress
- [[#1587](https://github.com/openmpf/openmpf/issues/1587)] Fix bugs in amq_detection_component's use of select

<h2>7.0.2: August 2022</h2>

<h3>Bug Fixes</h3>

- [[#1562](https://github.com/openmpf/openmpf/issues/1562)] Fix bug where an ffmpeg change prevented detecting video
  rotation

<h2>7.0.0: July 2022</h2>

<h3>Documentation</h3>

- Updated the Development Environment Guide by replacing steps for CentOS 7 with Ubuntu 20.04.
- Added the Derivative Media Guide.
- Updated the Batch Component APIs with revised error codes.
- Updated the Python Batch Component API and Python base Docker image README with instructions for
  using `pyproject.toml` and `setup.cfg`.
- Updated the Admin Guide and User Guide with images that show the new TiesDb and Callback columns in the job status UI.
- Updated the REST API with the `pipelineDefinition`, `frameRanges`, and `timeRanges` fields now supported by the
  `[POST] /rest/jobs` endpoint.
- Updated the OcvYoloDetection component README with information on using the NVIDIA Triton inference server.
- Updated the Markup Guide with `MARKUP_ANIMATION_ENABLED` and `MARKUP_LABELS_TRACK_INDEX_ENABLED`.
- Updated the Contributor Guide with new steps for generating documentation.

<h3>Transition from CentOS 7 to Ubuntu 20.04</h3>

- All the Docker images that previously used CentOS 7 as a base now use Ubuntu 20.04.
- We decided not to use CentOS 8, which is a version of CentOS Stream, due to concerns about stability.
- Also, Ubuntu is a very common OS within the AI and ML space, and has significant community support.

<h3>Use Job Id that Enables Load Balancing</h3>

- The Workflow Manager can now optionally accept job ids of the form `<openmpf-instance-wfm-hostname>-<job-id>` through
  the REST endpoints, where `<job-id>` is the same as the shorter id used in previous releases. The
  `<openmpf-instance-wfm-hostname>-` prefix enables better tracking and separation of jobs run across multiple
  Workflow Manager instances in a cluster.
- The prefix can be set in the `docker-compose.yml` file by assigning `{{.Node.Hostname}}` to the `NODE_HOSTNAME`
  environment variable for the Workflow Manager service, or hard-coding `NODE_HOSTNAME` to the desired hostname.
- The shorter version of the id can still be used in REST requests, but the longer id will always be returned by the
  Workflow Manager when responding to those requests.
- The shorter id will always be used internally by the Workflow Manager, meaning the job status web UI and log messages
  will all use the shorter job id. 

<h3>Support for Derivative Media</h3>

- The TikaImageDetection component now returns `MEDIA` tracks instead of `IMAGE` tracks when extracting images from
  documents, such as PDFs, Word documents, and PowerPoint slides. The document is considered the "source", or "parent",
  media, and the images are considered the "derivative", or "child", media.
- Actions can now be configured with `SOURCE_MEDIA_ONLY=true` or `DERIVATIVE_MEDIA_ONLY=true`, which will result in only
  performing the action on that kind of media. Feed forward can still be used to pass track information from one stage
  to another. The tracks will skip the stages (actions) that don't apply.
- This enables complex pipelines like one that extracts text from a PDF using TikaTextDetection, OCRs embedded images
  using EastTextDetection and TesseractOCRTextDetection, and runs all of the `TEXT` tracks through KeywordTagging.
- Added the following pipelines to the TikaImageDetection component:
    - `TIKA IMAGE DETECTION WITH DERIVATIVE MEDIA TESSERACT OCR PIPELINE`
    - `TIKA IMAGE DETECTION WITH DERIVATIVE MEDIA TESSERACT OCR AND KEYWORD TAGGING PIPELINE`
    - `TIKA IMAGE DETECTION WITH DERIVATIVE MEDIA TESSERACT OCR (WITH EAST REGIONS) AND KEYWORD TAGGING PIPELINE`
    - `TIKA IMAGE DETECTION WITH DERIVATIVE MEDIA TESSERACT OCR (WITH EAST REGIONS) AND KEYWORD TAGGING AND MARKUP PIPELINE`
    - `TIKA IMAGE DETECTION WITH DERIVATIVE MEDIA OCV FACE PIPELINE`
    - `TIKA IMAGE DETECTION WITH DERIVATIVE MEDIA OCV FACE AND MARKUP PIPELINE`

<h3>Report when Job Callbacks and TiesDb POSTs Fail</h3>

- The job status UI displays two new columns, one that indicates the status of posting to TiesDB, and one that indicates
  the status of posting the job callback to the job producer.
- Additionally, the `[GET] /rest/jobs/{id}` endpoint now includes a `tiesDbStatus` and `callbackStatus` field.
- Note that, by design, the JSON output itself does not contain these statuses.

<h3>Allow Pipelines to be Specified in a Job Request</h3>

- Optionally, the `pipelineDefinition` field can be provided instead of the `pipelineName` field when using the
  `[POST] /rest/jobs` endpoint in order to specify a pipeline on the fly for that specific job run. It will not be saved
  for later reuse.
- The format of the pipeline definition is similar to that in a `descriptor.json` file, with separate sections for
  defining `tasks` and `actions`. Pre-existing tasks and actions known to the Workflow Manager can be specified in the
  definition. They do not need to be defined again.
- This feature is a convenient alternative to creating persistent definitions using the `[POST] /rest/pipelines`,
  `[POST] /rest/tasks`, and `[POST] /rest/actions` endpoints. For example, this feature could be used to quickly add or
  remove a motion preprocessing stage from a pipeline.

<h3>Allow User-Specified Segment Boundaries</h3>

- Optionally, multiple `frameRanges` and/or `timeRanges` fields can be provided when using the `[POST] /rest/jobs`
  endpoint in order to manually specify segment boundaries. These values will override the normal segmenting behavior of
  the Workflow Manager.
- Note that overlapping ranges will be combined and large ranges may still be split up according to the value of
  `TARGET_SEGMENT_LENGTH` and `VFR_TARGET_SEGMENT_LENGTH`.
- Note that `frameRanges` is specified using the frame number and `timeRanges` is specified in milliseconds.

<h3>Add Triton Inference Server support to YOLO component</h3>

- The OcvYoloDetection component now supports the ability to send requests to an NVIDIA Triton Inference Server by
  setting `ENABLE_TRITON=true`. If set to false, the component will process jobs using OpenCV DNN on the local host
  running the Docker service, as per normal.
- By default `TRITON_SERVER=ocv-yolo-detection-server:8001`, which
  corresponds to the `ocv-yolo-detection-server` entry in your `docker-compose.yml` file. Refer to the example entry
  within [`docker-compose.components.yml`](https://github.com/openmpf/openmpf-docker/blob/develop/docker-compose.components.yml)
  . That entry uses a pre-built and pre-configured version of the Triton server.
- The Triton server runs the YOLOv4 model within the TensorRT framework, which performs a warmup operation when the
  server starts up to determine which optimizations to enable for the available GPU hardware. `*.engine` files are
  generated within the `yolo_engine_file` Docker volume for later reuse.
- To further improve inferencing speed, shared memory can be configured between the `ocv-yolo-detection` client service and the
  `ocv-yolo-detection-server` service if they are running on the same host. Set `TRITON_USE_SHM=true` and configure the
  server with a `/dev/shm:/dev/shm` Docker volume.
- Depending on the available GPU hardware, the Triton server can achieve speeds that are 5x faster than OpenCV DNN with
  tracking enabled, no shared memory, and nearly 9x faster with tracking disabled, with shared memory. Our tests used a
  single RTX 2080 GPU.

<h3>Removed Unused and Redundant Error Codes</h3>

- The error codes shown on the left were redundant and replaced with the corresponding error codes on the right:

| Old Error Code                | New Error Code                 |
| ----------------------------- | ------------------------------ |
| MPF_IMAGE_READ_ERROR          | MPF_COULD_NOT_READ_MEDIA       |
| MPF_BOUNDING_BOX_SIZE_ERROR   | MPF_BAD_FRAME_SIZE             |
| MPF_JOB_PROPERTY_IS_NOT_INT   | MPF_INVALID_PROPERTY           |
| MPF_JOB_PROPERTY_IS_NOT_FLOAT | MPF_INVALID_PROPERTY           |
| MPF_INVALID_FRAME_INTERVAL    | MPF_INVALID_PROPERTY           |
| MPF_DETECTION_TRACKING_FAILED | MPF_OTHER_DETECTION_ERROR_TYPE |

Also, the following error codes are no longer being used and have been removed:

- `MPF_UNRECOGNIZED_DATA_TYPE`
    -  All media types can now be processed since we support the `UNKNOWN` (a.k.a. "generic")
  media type
- `MPF_INVALID_DATAFILE_URI`
    - The Workflow Manager will reject a job with an invalid media URI before it gets to a
  component
- `MPF_INVALID_START_FRAME`
- `MPF_INVALID_STOP_FRAME`
- `MPF_INVALID_ROTATION`

<h3>Markup Improvements</h3>

- By default, the Markup component draws bounding boxes to fill in the gaps between detections in each track by
  interpolating the box size and position. This can now be disabled by setting the job property
  `MARKUP_ANIMATION_ENABLED=false`, or the system property `markup.video.animation.enabled=false`.
  Disabling this feature can be useful to prevent floating boxes from cluttering the marked-up frames.
- The Markup component will now start each bounding box label with a track index like `[0]` that can be used to
  correlate the box with the track in the JSON output object. The JSON output now contains an `index` field for every
  track, relative to each piece of media, that is simply an integer that starts at 0 and counts upward. This can be
  disabled by setting the job property `MARKUP_LABELS_TRACK_INDEX_ENABLED=false`, or the system property
  `markup.labels.track.index.enabled=false`.

<h3>Changes to JSON Output Object</h3>

- Components that generate `MEDIA` tracks will result in new derivative `media` entries in the JSON output file. This
  means it's possible to provide a single piece of media as an input and have more than one `media` entry in the JSON
  output. The output will always include the original media.
- Each `media` entry in the JSON output now contains a `parentMediaId` in addition to the `mediaId`. The `parentMediaId`
  for original source media will always be set to -1; otherwise, for derivative media, the `parentMediaId` is set the
  `mediaId` of the source media from which the child media was derived.
- Each `media` entry also contains a new `frameRanges` and `timeRanges` collection.
- The JSON output file also contains a new `index` field for every track, relative to each piece of media.

<h3>Features</h3>

- [[#792](https://github.com/openmpf/openmpf/issues/792)] Perform detection on images extracted from PDFs
- [[#1283](https://github.com/openmpf/openmpf/issues/1283)] Add user-specified segment boundaries
- [[#1374](https://github.com/openmpf/openmpf/issues/1374)] Transition from CentOS 7 to Ubuntu 20.04
- [[#1396](https://github.com/openmpf/openmpf/issues/1396)] Report when job callbacks and TiesDb POSTs fail
- [[#1398](https://github.com/openmpf/openmpf/issues/1398)] Add Triton Inference Server support to YOLO component
- [[#1428](https://github.com/openmpf/openmpf/issues/1428)] Allow pipelines to be specified in a job request
- [[#1454](https://github.com/openmpf/openmpf/issues/1454)] Transition from Clair scans to Trivy scans
- [[#1485](https://github.com/openmpf/openmpf/issues/1485)] Use `pyproject.toml` and `setup.cfg` instead of `setup.py`

<h3>Updates</h3>

- [[#803](https://github.com/openmpf/openmpf/issues/803)] Update Tika Image Detection to generate one track per piece of extracted media
- [[#808](https://github.com/openmpf/openmpf/issues/808)] Update Tika Text Detection component to not use leading zeros for `PAGE_NUM`
- [[#1105](https://github.com/openmpf/openmpf/issues/1105)] Remove dependency on QT from C++ SDK
- [[#1282](https://github.com/openmpf/openmpf/issues/1282)] Use job id that enables load balancing
- [[#1303](https://github.com/openmpf/openmpf/issues/1303)] Update Tika Image Detection to return `MEDIA` tracks
- [[#1319](https://github.com/openmpf/openmpf/issues/1319)] Review existing error codes and remove unused or redundant error codes
- [[#1384](https://github.com/openmpf/openmpf/issues/1384)] Update Apache Tika to 2.4.1 for TikaImageDetection and TikaTextDetection Components
- [[#1436](https://github.com/openmpf/openmpf/issues/1436)] CLI Runner should initialize a component once when handling multiple jobs
- [[#1465](https://github.com/openmpf/openmpf/issues/1465)] Remove YoloV3 support from OcvYoloDetection component
- [[#1513](https://github.com/openmpf/openmpf/issues/1513)] Update to Spring 5.3.18
- [[#1528](https://github.com/openmpf/openmpf/issues/1528)] CLI runner should also sort by startOffsetTime
- [[#1540](https://github.com/openmpf/openmpf/issues/1540)] Upgrade to Java 17
- [[#1549](https://github.com/openmpf/openmpf/issues/1549)] Allow markup animation to be disabled
- [[#1550](https://github.com/openmpf/openmpf/issues/1550)] Add track index to markup

<h3>Bug Fixes</h3>

- [[#1372](https://github.com/openmpf/openmpf/issues/1372)] Tika Image Detection no longer misses images in PowerPoint and Word documents
- [[#1449](https://github.com/openmpf/openmpf/issues/1449)] Simon data is now refreshed when clicking the Processes tab
- [[#1495](https://github.com/openmpf/openmpf/issues/1495)] Fix bug where invalid CSRF token found for `/workflow-manager/login`

# OpenMPF 6.3.x

<h2>6.3.14: May 2022</h2>

<h3>Bug Fixes</h3>

- [[#1530](https://github.com/openmpf/openmpf/issues/1530)] Fix S3 code memory leak

<h2>6.3.12: April 2022</h2>

<h3>Updates</h3>

- [[#1519](https://github.com/openmpf/openmpf/issues/1519)] Upgrade to OpenCV 4.5.5

<h3>Bug Fixes</h3>

- [[#1520](https://github.com/openmpf/openmpf/issues/1520)] S3 code now retries on most 400 errors

<h2>6.3.11: April 2022</h2>

<h3>Documentation</h3>

- Updated the Object Storage Guide with `S3_SESSION_TOKEN`, `S3_USE_VIRTUAL_HOST`, `S3_HOST`, and `S3_REGION`.

<h3>Updates</h3>

- [[#1496](https://github.com/openmpf/openmpf/issues/1496)] Update S3 client code
- [[#1514](https://github.com/openmpf/openmpf/issues/1514)] Update Tomcat to 8.5.78

<h2>6.3.10: March 2022</h2>

<h3>Bug Fixes</h3>

- [[#1486](https://github.com/openmpf/openmpf/issues/1486)] Fix bug where `MOVING` was being added to immutable map twice
- [[#1498](https://github.com/openmpf/openmpf/issues/1498)] Can now provide media metadata when frameTimeInfo is missing
- [[#1501](https://github.com/openmpf/openmpf/issues/1501)] MPFVideoCapture now properly reads frames from videos with rotation metadata
- [[#1502](https://github.com/openmpf/openmpf/issues/1502)] Detections with `HORIZONTAL_FLIP` will no longer result in illformed detections and incorrectly padded regions
- [[#1503](https://github.com/openmpf/openmpf/issues/1503)] Videos with rotation metadata will no longer result in corrupt markup

<h2>6.3.8: January 2022</h2>

<h3>Bug Fixes</h3>

- [[#1469](https://github.com/openmpf/openmpf/issues/1469)] `TENSORFLOW VEHICLE COLOR DETECTION` pipelines no longer refer to YOLO tasks that no longer exist

<h2>6.3.7: January 2022</h2>

<h3>Updates</h3>

- [[#1466](https://github.com/openmpf/openmpf/issues/1466)] Upgrade log4j to 2.17.1

<h2>6.3.6: December 2021</h2>

<h3>Updates</h3>

- [[#1457](https://github.com/openmpf/openmpf/issues/1457)] Upgrade log4j to 2.16.0

<h2>6.3.5: November 2021</h2>

<h3>Updates</h3>

- [[#1451](https://github.com/openmpf/openmpf/issues/1451)] Make concurrent callbacks configurable

<h2>6.3.4: November 2021</h2>

<h3>Bug Fixes</h3>

- [[#1441](https://github.com/openmpf/openmpf/issues/1441)] Modify AdminStatisticsController so that it doesn't hold all jobs in memory at once

<h2>6.3.3: October 2021</h2>

<h3>Features</h3>

- [[#1425](https://github.com/openmpf/openmpf/issues/1425)] Make protobuf size limit configurable

<h2>6.3.2: October 2021</h2>

<h3>Bug Fixes</h3>

- [[#1420](https://github.com/openmpf/openmpf/issues/1420)] Sphinx component no longer omits audio at end of video files
- [[#1422](https://github.com/openmpf/openmpf/issues/1422)] Media inspection now correctly calculates milliseconds from ffmpeg duration

<h2>6.3.1: September 2021</h2>

<h3>Features</h3>

- [[#1404](https://github.com/openmpf/openmpf/issues/1404)] Improve OcvDnnDetection vehicle color detection

<h3>Updates</h3>

- [[#1251](https://github.com/openmpf/openmpf/issues/1251)] Add version to JSON output object
- [[#1272](https://github.com/openmpf/openmpf/issues/1272)] Update Keyword Tagging to work on multiple inputs
- [[#1350](https://github.com/openmpf/openmpf/issues/1350)] Retire old components to the graveyard: DlibFaceDetection, DarknetDetection, and OcvPersonDetection

<h3>Bug Fixes</h3>

- [[#1010](https://github.com/openmpf/openmpf/issues/1010)] `mpf.output.objects.enabled` now behaves as expected
- [[#1271](https://github.com/openmpf/openmpf/issues/1271)] Azure speech component no longer omits audio at end of video files
- [[#1389](https://github.com/openmpf/openmpf/issues/1389)] NLP text correction component now properly reads the value of `FULL_TEXT_CORRECTION_OUTPUT`
- [[#1403](https://github.com/openmpf/openmpf/issues/1403)] Corrected README to state that the Azure Speech Component doesn't support v2 of the API
- [[#1406](https://github.com/openmpf/openmpf/issues/1406)] Speech detections in videos are no longer dropped if using keyword tagging
- [[#1411](https://github.com/openmpf/openmpf/issues/1411)] Exception no longer occurs when adding `SHRUNK_TO_NOTHING=TRUE` to an immutable map in multiple pipeline stages
- [[#1413](https://github.com/openmpf/openmpf/issues/1413)] Speech detections in videos are no longer dropped if using translation

<h2>6.3.0: September 2021</h2>

<h3>Documentation</h3>

- Updated the API documents, Development Environment Guide, Node Guide, Install Guide, User Guide, Admin Guide, and
  others to clarify the difference between Docker and non-Docker behaviors.
- Transformed Packaging and Registering a Component document into Component Descriptor Reference.
- Split Media Segmentation Guide from User Guide.
- Updated and renamed the Workflow Manager document to Workflow Manager Architecture.
- Updated the various Docker guides to clarify the difference between building Docker images from scratch versus
  building them using pre-built base images on Docker Hub, emphasizing the latter.
- Updated the Contributor Guide to document the hotfix pull request process.

<h3>TiesDb Integration</h3>

- TiesDb is a PostgreSQL DB with a RESTful API that stores media metadata. The metadata entries are queried using the
  hash (sha256, md5) of the media file. TIES stands
  for [Triage Import Export Schema](https://github.com/Noblis/ties-lib). TiesDb is deployed and managed externally to
  OpenMPF. For more information please contact us.
- When a job completes, OpenMPF can post assertions to media entries that exist in TiesDb. In general, one assertion is
  generated for each algorithm run on a piece of media. It contains the job status, algorithm name, detection
  type (`FACE`, `TEXT`, `MOTION`, etc.), and number of tracks generated, as well as a link to the full JSON output
  object.
- Each assertion serves as a lasting record so that job producers may first check TiesDb to see if an algorithm was run
  on a piece of media before submitting the same job to OpenMPF again.
- To enable TiesDb support, set the `TIES_DB_URL` job property or `ties.db.url` system property to
  the `<http|https>://<host>:<port>` part of the URL. The Workflow Manager will append
  the `/api/db/supplementals?sha256Hash=<hash>` part. Here is an example of a TiesDb POST:
```json
{
  "dataObject": {
    "sha256OutputHash": "1f8f2a8b2f5178765dd4a2e952f97f5037c290ee8d011cd7e92fb8f57bc75f17",
    "outputType": "FACE",
    "algorithm": "FACECV",
    "processDate": "2021-09-09T21:37:30.516-04:00",
    "pipeline": "OCV FACE DETECTION PIPELINE",
    "outputUri": "file:///home/mpf/git/openmpf-projects/openmpf/trunk/install/share/output-objects/1284/detection.json",
    "jobStatus": "COMPLETE",
    "jobId": 1284,
    "systemVersion": "6.3",
    "trackCount": 1,
    "systemHostname": "openmpf-master"
  },
  "system": "OpenMPF",
  "securityTag": "UNCLASSIFIED",
  "informationType": "OpenMPF FACE",
  "assertionId": "4874829f666d79881f7803207c7359dc781b97d2c68b471136bf7235a397c5cd"
}
```

<h3>Natural Language Processing (NLP) Text Correction Component</h3>

- This component utilizes the [CyHunspell](https://github.com/MSeal/cython_hunspell) library, which is a Python
  port of the [Hunspell](https://github.com/hunspell/hunspell) spell-checking library, to perform post-processing
  correction of OCR text. In general, it's intended to be used in a pipeline after a component like
  TesseractOCRTextDetection that generates `TEXT` tracks. These tracks are then fed-forward into NlpTextCorrection,
  which will add a `CORRECTED TEXT` property to the existing tracks.
  The `TESSERACT OCR TEXT DETECTION WITH NLP TEXT CORRECTION PIPELINE` performs this behavior. The component can also
  run on its own to process plain text files. Refer to
  the [README](https://github.com/openmpf/openmpf-components/tree/master/python/NlpTextCorrection#readme) for details.

<h3>Azure Cognitive Services (ACS) Read Component</h3>

- This component utilizes
  the [Azure Cognitive Services Read Detection REST endpoint](https://westcentralus.dev.cognitive.microsoft.com/docs/services/computer-vision-v3-1-ga/operations/5d986960601faab4bf452005)
  to extract formatted text from documents (PDFs), images, and videos. Refer to
  the [README](https://github.com/openmpf/openmpf-components/tree/master/python/AzureReadTextDetection#readme) for
  details.

<h3>Updates</h3>

- [[#1151](https://github.com/openmpf/openmpf/issues/1151)] Now supports `IN_PROGRESS_WITH_WARNINGS` status
- [[#1234](https://github.com/openmpf/openmpf/issues/1234)] Now sorts JSON output object media by media id
- [[#1341](https://github.com/openmpf/openmpf/issues/1341)] Added job id to all batch-job-specific Workflow Manager log
  messages
- [[#1349](https://github.com/openmpf/openmpf/issues/1349)] Improved reporting and recording job status
- [[#1353](https://github.com/openmpf/openmpf/issues/1353)] Updated the Workflow Manager to remove and warn about
  zero-size detections
- [[#1382](https://github.com/openmpf/openmpf/issues/1382)] Updated Tika version to 1.27 for TikaImageDetection and
  TikaTextDetection components
- [[#1387](https://github.com/openmpf/openmpf/issues/1387)] Markup can now be configured in a
  component's `descriptor.json`

<h3>Bug Fixes</h3>

- [[#1080](https://github.com/openmpf/openmpf/issues/1080)] Batch jobs no longer prematurely set to 100% completion
  during artifact extraction
- [[#1106](https://github.com/openmpf/openmpf/issues/1106)] When a job ends in `ERROR` or `CANCELLED_BY_SHUTDOWN` the
  job status UI now shows an End Date
- [[#1158](https://github.com/openmpf/openmpf/issues/1158)] JSON output object URI no longer changes when callback fails
- [[#1317](https://github.com/openmpf/openmpf/issues/1317)] TikaTextDetection no longer generates first PDF track
  at `PAGE_NUM` 2
- [[#1337](https://github.com/openmpf/openmpf/issues/1337)] Now using `MPF_BAD_FRAME_SIZE` instead
  of `MPF_DETECTION_FAILED` for OpenCV empty/resize exception
- [[#1359](https://github.com/openmpf/openmpf/issues/1359)] Image detection tracks no longer
  have `endOffsetFrameInclusive` set to 1
- [[#1373](https://github.com/openmpf/openmpf/issues/1373)] When uploading large files through the Workflow Manager web
  UI, now more than the first 865032704 bytes get written
- [[#1379](https://github.com/openmpf/openmpf/issues/1379)] TikaImageDetection component now avoids conflicts by no
  longer using the same path when extracting images for jobs with multiple pieces of media
- [[#1386](https://github.com/openmpf/openmpf/issues/1386)] FeedForwardFrameCropper in the Python SDK now handles
  negative coordinates properly
- [[#1391](https://github.com/openmpf/openmpf/issues/1391)] If a job is configured to upload markup and markup fails,
  the job no longer gets stuck

<h3>Known Issues</h3>

- [[#1372](https://github.com/openmpf/openmpf/issues/1372)] TikaImageDetection misses images in PowerPoint and Word
  documents
- [[#1389](https://github.com/openmpf/openmpf/issues/1389)] NlpTextCorrection does not properly read the value
  of `FULL_TEXT_CORRECTION_OUTPUT`

# OpenMPF 6.2.x

<h2>6.2.5: July 2021</h2>

<h3>Updates</h3>

- [[#1367](https://github.com/openmpf/openmpf/issues/1367)] Enable cross-origin resource sharing on Workflow Manager

<h2>6.2.4: June 2021</h2>

<h3>Bug Fixes</h3>

- [[#1356](https://github.com/openmpf/openmpf/issues/1356)] AzureSpeech now properly reports when media is missing audio stream
- [[#1357](https://github.com/openmpf/openmpf/issues/1357)] AzureSpeech now handles case where speaker id is not present

<h2>6.2.2: June 2021</h2>

<h3>Updates</h3>

- [[#1333](https://github.com/openmpf/openmpf/issues/1333)] Combine media name and job id into one WFM log line
- [[#1336](https://github.com/openmpf/openmpf/issues/1336)] Remove duplicate "Setting status of job to COMPLETE" Workflow Manager log line and other improvements
- [[#1338](https://github.com/openmpf/openmpf/issues/1338)] Update OpenCV DNN Detection component to optionally use feed-forward confidence values

<h3>Bug Fixes</h3>

- [[#1237](https://github.com/openmpf/openmpf/issues/1237)] Fixed jQuery DataTables bug: "int parameter 'draw' is present but cannot be translated into a null value"
- [[#1254](https://github.com/openmpf/openmpf/issues/1254)] Jobs table no longer flickers when polling is enabled and the search box is used
- [[#1308](https://github.com/openmpf/openmpf/issues/1308)] Prevent OCV YOLO Tracking from generating zero-sized detections
- [[#1313](https://github.com/openmpf/openmpf/issues/1313)] Fix JSON output object timestamps for variable frame rate videos

<h2>6.2.1: May 2021</h2>

<h3>Updates</h3>

- [[#1330](https://github.com/openmpf/openmpf/issues/1330)] Return error codes for `models_ini_parser.py` exceptions

<h3>Bug Fixes</h3>

- [[#1331](https://github.com/openmpf/openmpf/issues/1331)] Decoding certain heic images no longer causes Workflow Manager to segfault

<h2>6.2.0: May 2021</h2>

<h3>Tesseract OCR Text Detection Component Support for Videos</h3>

- The component can now process videos in addition to images and PDFs. Each video frame is processed sequentially.
  The `MAX_PARALLEL_SCRIPT_THREADS` property determines how many threads to use to process each frame, one thread per
  language or script.
- Note that for videos without much text, it may be faster to disable threading by
  setting `MAX_PARALLEL_SCRIPT_THREADS=1`. This will allow the component to reuse TessAPI instances instead of creating
  new ones for every frame. Please refer to the Known Issues section.
- Resolved issues: [#1285](https://github.com/openmpf/openmpf/issues/1285)

<h3>Updates</h3>

- [[#1086](https://github.com/openmpf/openmpf/issues/1086)] Added support for `COULD_NOT_OPEN_MEDIA`
  and `COULD_NOT_READ_MEDIA` error types
- [[#1159](https://github.com/openmpf/openmpf/issues/1159)] Split `IssueCodes.REMOTE_STORAGE`
  into `REMOTE_STORAGE_DOWNLOAD` and `REMOTE_STORAGE_UPLOAD`
- [[#1250](https://github.com/openmpf/openmpf/issues/1250)] Modified `/rest/jobs/{id}` to include the job's media
- [[#1312](https://github.com/openmpf/openmpf/issues/1312)] Created `NETWORK_ERROR` error code for when a component
  can't connect to an external server. Updated Python HTTP retry code to return `NETWORK_ERROR`. This affects the Azure
  components.

<h3>Known Issues</h3>

- [[#1008](https://github.com/openmpf/openmpf/issues/1008)] Use global TessAPI instances with parallel processing

# OpenMPF 6.1.x

<h2>6.1.6: May 2021</h2>

<h3>Handle Variable Frame Rate Videos</h3>

- The Workflow Manager will attempt to detect if a video is constant frame rate (CFR) or variable frame rate (VFR)
  during media inspection. If no determination can be made, it will default to VFR behavior. If CFR, the JSON output
  object will have a `HAS_CONSTANT_FRAME_RATE=true` property in the `mediaMetadata` field.
- When `MPFVideoCapture` handles a CFR video it will use OpenCV to set the frame position, unless the position is within
  16 frames of the current position, in which case it will iteratively use OpenCV `grab()` to advance to the desired
  frame.
- When `MPFVideoCapture` handles a VFR video it will always iteratively use OpenCV `grab()` to advance to the desired
  frame because setting the frame position directly has been shown to not work correctly on VFR videos.
- When a video is split into multiple segments, `MPFVideoCapture` must iteratively use `grab()` to advance from frame 0
  to the start of the segment. This introduces performance overhead. To mitigate this we recommend using larger video
  segments than those used for CFR videos.
- In addition to the existing `TARGET_SEGMENT_LENGTH` and `MIN_SEGMENT_LENGTH` job
  properties (`detection.segment.target.length` and `detection.segment.minimum.length` system properties) for CFR
  videos, the Workflow Manager now supports the `VFR_TARGET_SEGMENT_LENGTH` and `VFR_MIN_SEGMENT_LENGTH` job
  properties (`detection.vfr.segment.target.length` and `detection.vfr.segment.minimum.length` system properties) for
  VFR videos.
- Note that the timestamps associated with tracks and detections in a VFR video may be wrong. Please refer to the Known
  Issues section.
- Resolved issues: [#1307](https://github.com/openmpf/openmpf/issues/1307)

<h3>Updates</h3>

- [[#1287](https://github.com/openmpf/openmpf/issues/1287)] Updated Tika Text Detection Component to break up large
  chunks of text. The component now generates tracks with both a `PAGE_NUM` property and `SECTION_NUM` property. Please
  refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/java/TikaTextDetection/README.md#overview).

<h3>Known Issues</h3>

- [[#1313](https://github.com/openmpf/openmpf/issues/1313)] Incorrect JSON output object timestamps for variable frame
  rate videos
- [[#1317](https://github.com/openmpf/openmpf/issues/1317)] Tika Text Detection component generates first PDF track
  at `PAGE_NUM` 2

<h2>6.1.5: April 2021</h2>

<h3>Updates</h3>

- [[#1300](https://github.com/openmpf/openmpf/issues/1300)] Parallelized S3 artifact upload. Use
  the `detection.artifact.extraction.parallel.upload.count` system property to configure the number of parallel uploads.

<h2>6.1.4: April 2021</h2>

<h3>Updates</h3>

- [[#1299](https://github.com/openmpf/openmpf/issues/1299)] Improved artifact extraction performance when there is no
  rotation or flip

<h2>6.1.3: April 2021</h2>

<h3>Updates</h3>

- [[#1295](https://github.com/openmpf/openmpf/issues/1295)] Improved artifact extraction and markup JNI memory
  utilization
- [[#1297](https://github.com/openmpf/openmpf/issues/1297)] Limited Workflow Manager IO threads to a reasonable number

<h3>Bug Fixes</h3>

- [[#1296](https://github.com/openmpf/openmpf/issues/1296)] Fixed ActiveMQ job priorities

<h2>6.1.2: April 2021</h2>

<h3>Updates</h3>

- [[#1294](https://github.com/openmpf/openmpf/issues/1294)] Limited ffmpeg threads to a reasonable number

<h2>6.1.1: April 2021</h2>

<h3>Bug Fixes</h3>

- [[#1292](https://github.com/openmpf/openmpf/issues/1292)] Don't skip artifact extraction for failed media

<h2>6.1.0: April 2021</h2>

<h3>OpenMPF Command Line Runner</h3>

- The Command Line Runner allows users to run jobs with a single component without the Workflow Manager.
- It outputs results in a JSON structure that is a subset of the regular OpenMPF output.
- It only supports C++ and Python components.
- See the
  [README](https://github.com/openmpf/openmpf-docker/blob/master/CLI_RUNNER.md)
  for more information.

<h3>C++ Batch Component API</h3>

- Component code should no longer configure Log4CXX. The component executor now handles configuring Log4CXX. Component
  code should call `log4cxx::Logger::getLogger("<component-name>")`
  to get access to the logger. Calls to `log4cxx::xml::DOMConfigurator::configure(logconfig_file);`
  should be removed.

<h3>Python Batch Component API </h3>

- Component code should no longer configure logging. The component executor now handles configuring logging. Calls
  to `mpf.configure_logging` should be replaced with
  `logging.getLogger('<component-name>')`.

<h3>Docker Component Base Images</h3>

- In order to support running a component through the CLI runner, C++ component developers should set
  the `LD_LIBRARY_PATH` environment variable in the final stage of their Dockerfiles. It should generally be set
  like: `ENV LD_LIBRARY_PATH $PLUGINS_DIR/<component-name>/lib`.

- Because of the logging changes mentioned above, components no longer need to set the
  `COMPONENT_LOG_NAME` environment variable in their Dockerfiles.

- Added the
  [`openmpf_python_executor_ssb` base image](https://github.com/openmpf/openmpf-docker/blob/master/components/python/README.md#openmpf_python_executor_ssb)
  . It can be used instead of `openmpf_python_component_build` and `openmpf_python_executor` to simplify Dockerfiles for
  Python components that are pure Python and have no build time dependencies.

<h3>Label Moving vs. Non-Moving Tracks</h3>

- The Workflow Manager can now identify whether a track is moving or non-moving. This is determined by calculating the
  average bounding box for a track by averaging the size and position of all the detections in the track. Then, for each
  detection in the track, the intersection over union (IoU) is calculated between that detection and the average
  detection. If the IoU for at least `MOVING_TRACK_MIN_DETECTIONS` number of detections is less than or equal to
  `MOVING_TRACK_MAX_IOU`, then the track is considered a moving track.
- Added the following Workflow Manager job properties. These can be set for any video job:
    - `MOVING_TRACK_LABELS_ENABLED`: When set to true, attempt to label tracks as either moving or non-moving objects.
      Each track will have a `MOVING` property set to `TRUE` or `FALSE`.
    - `MOVING_TRACKS_ONLY`: When set to true, remove any tracks that were marked as not moving.
    - `MOVING_TRACK_MAX_IOU`: The maximum IoU overlap between detection bounding boxes and the average per-track
      bounding box for objects to be considered moving. Value is expected to be between 0 and 1. Note that the lower
      IoU, the more likely the object is moving.
    - `MOVING_TRACK_MIN_DETECTIONS`: The minimum number of moving detections for a track to be labeled as moving.

<h3>Markup Improvements</h3>

- Users can now watch videos directly in the OpenMPF web UI within the media pop-up dialog for each job. Most modern web
  browsers support videos encoded in VP9 and H.264. If a video cannot be played, users have the option to download it
  and play it using a stand-alone media player.
- To set the markup encoder use `MARKUP_VIDEO_ENCODER`. The default encoder has changed from `mjpeg` to `vp9`. As a
  result, it will take longer to generate marked up videos, but they will be higher quality and can be viewed in the web
  UI.
- Each bounding box in the marked up media is now labeled. By default, the label shows the track-level `CLASSIFICATION`
  and associated confidence value. The information shown in the label can be changed by
  setting `MARKUP_LABELS_TEXT_PROP_TO_SHOW` and `MARKUP_LABELS_NUMERIC_PROP_TO_SHOW`. To show information for each
  individual detection, rather than the entire track, set `MARKUP_LABELS_FROM_DETECTIONS=TRUE`.
- Exemplar detections in video tracks include a star icon in their label.
- Optionally, set `MARKUP_VIDEO_MOVING_OBJECT_ICONS_ENABLED=TRUE` to show icons that represent if the track is moving or
  non-moving.
- Optionally, set `MARKUP_VIDEO_BOX_SOURCE_ICONS_ENABLED=TRUE` to show icons that represent the source of the detection.
  For example, if the box is the result of an algorithm detection, tracking performing gap fill, or Workflow Manager
  animation.
- Each frame of a marked-up video now has a frame number in the upper right corner.
- Please refer to the [Markup Guide](Markup-Guide.md) for the complete set of markup properties, icon definitions, and
  encoder considerations.

<h3>Updates</h3>

- [[#1181](https://github.com/openmpf/openmpf/issues/1181)] Updated the Tesseract OCR Text Detection component from
  Tesseract version 4.0.0 to 4.1.1
- [[#1232](https://github.com/openmpf/openmpf/issues/1232)] Updated the Azure Speech Detection component from Azure
  Batch Transcription version 2.0 to 3.0

<h3>Bug Fixes</h3>

- [[#1187](https://github.com/openmpf/openmpf/issues/1187)] EXIF orientation is now preserved during markup and artifact
  extraction
- [[#1257](https://github.com/openmpf/openmpf/issues/1257)] Updated `OUTPUT_LAST_TASK_ONLY` to work on all media types

# OpenMPF 6.0.x

<h2>6.0.11: March 2021</h2>

<h3>Bug Fixes</h3>

- [[#1284](https://github.com/openmpf/openmpf/issues/1284)] Updated the Azure Translation component to count emoji as 2
  characters

<h2>6.0.10: March 2021</h2>

<h3>Updates</h3>

- [[#1270](https://github.com/openmpf/openmpf/issues/1270)] The Azure Cognitive Services components now retry HTTP
  requests

<h2>6.0.9: March 2021</h2>

<h3>Bug Fixes</h3>

- [[#1273](https://github.com/openmpf/openmpf/issues/1273)] Setting `TRANSLATION` to the empty string no longer prevents
  Keyword Tagging

<h2>6.0.6: March 2021</h2>

<h3>Bug Fixes</h3>

- [[#1265](https://github.com/openmpf/openmpf/issues/1265)] Updated the Tika Text Detection component to handle
  spreadsheets
- [[#1268](https://github.com/openmpf/openmpf/issues/1268)] Updated the Tika Text Detection component to remove metadata

<h2>6.0.5: February 2021</h2>

<h3>Bug Fixes</h3>

- [[#1266](https://github.com/openmpf/openmpf/issues/1266)] The Azure Translation component now handles the final
  segment correctly when guessing sentence breaks

<h2>6.0.4: February 2021</h2>

<h3>Updates</h3>

- [[#1264](https://github.com/openmpf/openmpf/issues/1264)] Updated the Azure Translation component to handle large
  amounts of text
- [[#1269](https://github.com/openmpf/openmpf/issues/1269)] AzureTranslation no longer tries to translate text that is
  already in the `TO_LANGUAGE`

<h2>6.0.3: February 2021</h2>

<h3>OpenCV YOLO Detection Component</h3>

- This new component utilizes the OpenCV Deep Neural Networks (DNN) framework to detect and classify objects in images
  and videos using Darknet YOLOv4 models trained on the COCO dataset. It supports both CPU and GPU modes of operation.
  Tracking is performed using a combination of intersection over union, pixel difference after Fast Fourier transform (
  FFT) phase correlation, Kalman filtering, and OpenCV MOSSE tracking. Refer to
  the [README](https://github.com/openmpf/openmpf-components/tree/master/cpp/OcvYoloDetection#readme) for details.

<h2>6.0.2: January 2021</h2>

<h3>Bug Fixes</h3>

- [[#1249](https://github.com/openmpf/openmpf/issues/1249)] FFmpeg no longer reports different frame counts for the same
  piece of media

<h2>6.0.1: December 2020</h2>

<h3>Bug Fixes</h3>

- [[#1238](https://github.com/openmpf/openmpf/issues/1238)] The JSON output object is now generated when remote media
  cannot be downloaded.

<h2>6.0.0: December 2020</h2>

<h3>Upgrade to OpenCV 4.5.0</h3>

- Updated core framework and components from OpenCV 3.4.7 to OpenCV 4.5.0.
- OpenCV is now built with CUDA support, including cuDNN (CUDA Deep Neural Network library) and cuBLAS (CUDA Basic
  Linear Algebra Subroutines library). All C++ components that use the base C++ builder and executor Docker images have
  CUDA support built in, giving developers the option to make use of it.
- Added GPU support to the OcvDnnDetection component.

<h3>Azure Cognitive Services (ACS) Translation Component</h3>

- This new component utilizes
  the [Azure Cognitive Services Translator REST endpoint](https://docs.microsoft.com/en-us/azure/cognitive-services/translator/reference/v3-0-translate)
  to translate text from one language (locale) to another. Generally, it's intended to operate on feed-forward tracks
  that contain detections with `TEXT` and `TRANSCRIPT` properties. It can also operate on plain text file inputs. Refer
  to the [README](https://github.com/openmpf/openmpf-components/blob/master/python/AzureTranslation/README.md) for
  details.

<h3>Interoperability Package</h3>

- Added `algorithm` field to the element that describes a collection of tracks generated by an action in the JSON output
  object. For example:

```
"output": {
  "FACE": [{
    "source": "+#MOG MOTION DETECTION PREPROCESSOR ACTION#OCV FACE DETECTION ACTION",
    "algorithm": "FACECV",
    "tracks": [{ ... }],
    ...
   },
```

<h3>Merge Tasks in JSON Output Object</h3>

- The output of two tasks in the JSON output object can be merged by setting the `OUTPUT_MERGE_WITH_PREVIOUS_TASK`
  property to true. This is a Workflow Manager property and can be set on any task in any pipeline, although it has no
  effect when set on the first task or the Markup task.
- When the output of two tasks are merged, the tracks for the previous task will not be shown in the JSON output object,
  and no artifacts are generated for it. The task will be listed under `TRACKS MERGED`, if it's not already listed
  under `TRACKS SUPPRESSED` due to the `mpf.output.objects.last.task.only` system property setting,
  or `OUTPUT_LAST_TASK_ONLY` property. The tracks associated with the second task will inherit the detection type and
  algorithm of the previous task.
- For example, the `TESSERACT OCR TEXT DETECTION WITH KEYWORD TAGGING PIPELINE` is defined as
  the `TESSERACT OCR TEXT DETECTION TASK` followed by the `KEYWORD TAGGING (WITH FF REGION) TASK`. The second task
  sets `OUTPUT_MERGE_WITH_PREVIOUS_TASK` to true. The resulting JSON output object contains one set of keyword-tagged
  OCR tracks that have the `TEXT` detection type and `TESSERACTOCR` algorithm (both inherited from
  the `TESSERACT OCR TEXT DETECTION TASK`):

```
"output": {
  "TRACKS MERGED": [{
    "source": "+#TESSERACT OCR TEXT DETECTION ACTION",
    "algorithm": "TESSERACTOCR"
  }],
  "TEXT": [{
    "source": "+#TESSERACT OCR TEXT DETECTION ACTION#KEYWORD TAGGING (WITH FF REGION) ACTION",
    "algorithm": "TESSERACTOCR",
    "tracks": [{
      "type": "TEXT",
      "trackProperties": {
         "TAGS": "ANIMAL",
         "TEXT": "The quick brown fox",
         "TEXT_LANGUAGE": "script/Latin",
         "TRIGGER_WORDS": "fox",
         "TRIGGER_WORDS_OFFSET": "16-18"
         ...
```

- Note that you can use the `OUTPUT_MERGE_WITH_PREVIOUS_TASK` setting on multiple tasks. For example, if you set it as a
  job property it will be applied to all tasks (with the exception of Markup - in which case the task before Markup is
  used), so you will only get the output of the last task in the pipeline. The last task will inherit the detection type
  and algorithm of the first task in the pipeline.

<h3>Tesseract Custom Dictionaries</h3>

- The Tesseract component Docker image now contains an `/opt/mpf/tessdata_model_updater` binary that you can use to
  update `*.traineddata` models with a custom dictionary, as well as extract files from existing models. Refer to
  the [DICTIONARIES](https://github.com/openmpf/openmpf-components/blob/master/cpp/TesseractOCRTextDetection/DICTIONARIES.md)
  guide to learn how to use the tool.
- In general, legacy `*.traineddata` models are more influenced by words in their dictionary than more modern
  LSTM `*.traineddata` models. Also, refer to the known issue below.

<h3>Known Issues</h3>

- [[#1243](https://github.com/openmpf/openmpf/issues/1243)] Unpacking a `*.traineddata` model, for example, in order to
  modify its dictionary, and then repacking it may result in dropping some of the words present in the original
  dictionary file. This may be due to some kind of compression or filtering. It's unknown what effect this has on OCR
  results.

# OpenMPF 5.1.x

<h2>5.1.3: December 2020</h2>

<h3>Setting Properties as Docker Environment Variables</h3>

- Any property that can be set as a job property can now be set as a Docker environment variable by prefixing it
  with `MPF_PROP_`. For example, setting the `MPF_PROP_TRTIS_SERVER` environment variable in the `trtis-detection`
  service in your `docker-compose.yml` file will have the same effect as setting the `TRTIS_SERVER` job property.
- Properties set in this way will take precedence over all other property types (job, algorithm, media, etc). It is not
  possible to change the value of properties set via environment variables at runtime and therefore they should only be
  used to specify properties that will not change throughout the entire lifetime of the service.

<h3>Updates</h3>

- The `mpf.output.objects.censored.properties` system property can be used to prevent properties from being shown in
  JSON output objects. The value for these properties will appear as `<censored>`.
- The Azure Speech Detection component now retries without diarization when diarization is not supported by the selected
  locale.

<h3>Bug Fixes</h3>

- [[#1230](https://github.com/openmpf/openmpf/issues/1230)] The Azure Speech Detection component now uses a UUID for the
  recording id associated with a piece of media in order to prevent deleting a piece of media while it's in use.

<h2>5.1.1: December 2020</h2>

<h3>Updates</h3>

- Only generate `FRAME_COUNT` warning when the frame difference is > 1. This can be configured using
  the `warn.frame.count.diff` system property.

<h3>Bug Fixes</h3>

- [[#1209](https://github.com/openmpf/openmpf/issues/1209)] The Keyword Tagging component now generates video tracks in
  the JSON output object.
- [[#1212](https://github.com/openmpf/openmpf/issues/1212)] The Keyword Tagging component now preserves the detection
  bounding box and confidence.

<h2>5.1.0: November 2020</h2>

<h3>Media Inspection Improvements</h3>

- The Workflow Manager will now handle video files that don't have a video stream as an `AUDIO` type, and handle video
  files that don't have a video or audio stream as an `UNKNOWN` type. The JSON output object contains a
  new `media.mediaType` field that will be set to `VIDEO`, `AUDIO`, `IMAGE`, or `UNKNOWN`.
- The Workflow Manager now configures Tika
  with [custom MIME type support](https://github.com/openmpf/openmpf/blob/master/trunk/workflow-manager/src/main/resources/org/apache/tika/mime/custom-mimetypes.xml)
  . Currently, this enables the detection of `video/vnd.dlna.mpeg-tts` and `image/jxr` MIME types.
- If the Workflow Manager cannot use Tika to determine the media MIME type then it will fall back to using the
  Linux `file` command with
  a [custom magicfile](https://github.com/openmpf/openmpf/blob/master/trunk/workflow-manager/src/main/resources/magic/custom-magic)
  .
- OpenMPF now supports Apple-optimized PNGs and HEIC images. Refer to the Bug Fixes section below.

<h3>EAST Text Region Detection Component Improvements</h3>

- The `TEMPORARY_PADDING` property has been separated into `TEMPORARY_PADDING_X` and `TEMPORARY_PADDING_Y` so that X and
  Y padding can be configured independently.
- The `MERGE_MIN_OVERLAP` property has been renamed to `MERGE_OVERLAP_THRESHOLD` so that setting it to a value of 0 will
  merge all regions that touch, regardless of how small the amount of overlap.
- Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/python/EastTextDetection/README.md#properties)
  for details.

<h3>MPFVideoCapture and MPFImageReader Tool Improvements</h3>

- These tools now support a `ROTATION_FILL_COLOR` property for setting the fill color for pixels near the corners and
  edges of frames when performing non-orthogonal rotations. Previously, the color was hardcoded to `BLACK`. That is
  still the default setting for most components. Now the color can be set to `WHITE`, which is the default setting for
  the Tesseract component.
- These tools now support a `ROTATION_THRESHOLD` property for adjusting the threshold at which the frame transformer
  performs rotation. Previously, the value was hardcoded to 0.1 degrees. That is still the default value. Rotation is
  not performed on any `ROTATION` value less than that threshold. The motivation is that some algorithms detect small
  rotations (for example, on structured text) when there is no rotation. In such cases rotating the frame results in
  fewer detections.
- OpenMPF now uses FFmpeg when counting video frames. Refer to the Bug Fixes section below.

<h3>Azure Cognitive Services (ACS) Form Detection Component</h3>

- This new component utilizes
  the [Azure Cognitive Services Form Detection REST endpoint](https://westus2.dev.cognitive.microsoft.com/docs/services/form-recognizer-api-v2/operations/AnalyzeLayoutAsync)
  to extract formatted text from documents (PDFs) and images. Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/python/AzureFormDetection/README.md) for
  details.
- This component is capable of performing detections using a specified ACS endpoint URL. For example, different
  endpoints support receipt detection, business card detection, layout analysis, and support for custom models trained
  with or without labeled data.
- This component may output the following detection properties depending on the endpoint, model, and media being
  processed: `TEXT`, `TABLE_CSV_OUTPUT`, `KEY_VALUE_PAIRS_JSON`, and `DOCUMENT_JSON_FIELDS`.

<h3>Keyword Tagging Component</h3>

- This new component performs the same keyword tagging behavior that was previously part of the Tesseract component, but
  does so on feed-forward tracks that generate detections with `TEXT` and `TRANSCRIPT` properties. Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/cpp/KeywordTagging/README.md) for details.
- In addition to the Tesseract component, keyword tagging behavior has been removed from the Tika Text component and ACS
  OCR component.
- Example pipelines have been added to the following components which make use of a final Keyword Tagging component
  stage:
    - Tesseract
    - Tika Text
    - ACS OCR
    - Sphinx
    - ACS Speech

<h3>Optionally Skip Media Inspection</h3>

- The Workflow Manager will skip media inspection if all of the required media metadata is provided in the job request.
  The `MEDIA_HASH` and `MIME_TYPE` fields are always required. Depending on the media data type, other fields may be
  required or optional:
    - Images
        - Required: `FRAME_WIDTH`, `FRAME_HEIGHT`
        - Optional: `HORIZONTAL_FLIP`, `ROTATION`
    - Videos
        - Required: `FRAME_WIDTH`, `FRAME_HEIGHT`, `FRAME_COUNT`, `FPS`, `DURATION`
        - Optional: `HORIZONTAL_FLIP`, `ROTATION`
    - Audio files
        - Required: `DURATION`

<h3>Updates</h3>

- Update OpenMPF Python SDK exception handling for Python 3. Now instead of raising an `EnvironmentError`, which has
  been deprecated in Python 3, the SDK will raise an `mpf.DetectionError` or allow the underlying exception to be
  thrown.

<h3>Bug Fixes</h3>

- [[#1028](https://github.com/openmpf/openmpf/issues/1028)] OpenMPF can now properly handle Apple-optimized PNGs, which
  have a non-standard data chunk named CgBI before the IHDR chunk. The Workflow Manager
  uses [pngdefry](http://www.jongware.com/pngdefry.html) to convert the image into a standard PNG for processing. Before
  this fix, Tika would throw an error when trying to determine the MIME type of the Apple-optimized PNG.
- [[#1130](https://github.com/openmpf/openmpf/issues/1130)] OpenMPF can now properly handle HEIC images. The Workflow
  Manager uses [libheif](https://github.com/strukturag/libheif) to convert the image into a standard PNG for processing.
  Before this fix, the HEIC image was sometimes falsely identified as a video and the Workflow Manager would fail to
  count the number of frames.
- [[#1171](https://github.com/openmpf/openmpf/issues/1171)] The MIME type in the JSON output object is no longer null
  when there is a frame counting exception.
- [[#1192](https://github.com/openmpf/openmpf/issues/1192)] When processing videos, the frame count is now obtained from
  both OpenCV and FFmpeg. The lower of the two is used. If they don't match, a `FRAME_COUNT` warning is generated.
  Before this fix, on some videos OpenCV would return frame counts that were magnitudes higher than the frames that
  could actually be read. This resulted in failing to process many video segments with a  `BAD_FRAME_SIZE` error.

# OpenMPF 5.0.x

<h2>5.0.9: October 2020</h2>

<h3>Bug Fixes</h3>

- [[#1200](https://github.com/openmpf/openmpf/issues/1200)] The MPFVideoCapture and MPFImageReader tools now properly
  handle cropping to frame regions when the region coordinates fall outside of the frame boundary. There was a bug that
  would result in an OpenCV error. Note that the bug only occurred when cropping was not performed with rotation or
  flipping.

<h2>5.0.8: October 2020</h2>

<h3>Updates</h3>

- The Tesseract component now supports a `TESSDATA_MODELS_SUBDIRECTORY` property. The component will look for tessdata
  files in `<MODELS_DIR_PATH>/<TESSDATA_MODELS_SUBDIRECTORY>`. This allows users to easily switch between `tessdata`
  , `tessdata_best`, and `tessdata_fast` subdirectories.

<h3>Bug Fixes</h3>

- [[#1199](https://github.com/openmpf/openmpf/issues/1199)] Added missing synchronized to InProgressBatchJobsService,
  which was resulting in some jobs staying `IN_PROGRESS` indefinitely.

<h2>5.0.7: September 2020</h2>

<h3>TensorRT Inference Server (TRTIS) Object Detection Component</h3>

- This new component detects objects in images and videos by making use of
  an [NVIDIA TensorRT Inference Server](https://docs.nvidia.com/deeplearning/sdk/tensorrt-inference-server-guide/docs/) (
  TRTIS), and calculates features that can later be used by other systems to recognize the same object in other media.
  We provide support for running the server as a separate service during a Docker deployment, but an external server
  instance can be used instead.
- By default, the ip_irv2_coco model is supported and will optionally classify detected objects
  using [COCO labels](https://github.com/openmpf/openmpf-components/blob/master/cpp/TrtisDetection/plugin-files/models/ip_irv2_coco/ip_irv2_coco.labels)
  . Additionally, features can be generated for whole frames, automatically-detected object regions, and user-specified
  regions. Refer to the [README](https://github.com/openmpf/openmpf-components/blob/master/cpp/TrtisDetection/README.md)
  .

<h2>5.0.6: August 2020</h2>

<h3>Enable OcvDnnDetection to Annotate Feed-forward Detections</h3>

- The OcvDnnDetection component can now by configured to operate only on certain feed-forward detections and annotate
  them with supplementary information. For example, the following pipeline can be configured to generate detections that
  have both `CLASSIFICATION` and `COLOR` detection properties:

```
DarknetDetection (person + vehicle) --> OcvDnnDetection (vehicle color)
```

- For example:

```
  "detectionProperties": {
    "CLASSIFICATION": "car",
    "CLASSIFICATION CONFIDENCE LIST": "0.397336",
    "CLASSIFICATION LIST": "car",
    "COLOR": "blue",
    "COLOR CONFIDENCE LIST": "0.93507; 0.055744",
    "COLOR LIST": "blue; gray"
  }
```

- The OcvDnnDetection component now supports the following properties:
    - `CLASSIFICATION_TYPE`: Set this value to change the `CLASSIFICATION*` part of each output property name to
      something else. For example, setting it to `COLOR` will generate `COLOR`, `COLOR LIST`,
      and `COLOR CONFIDENCE LIST`. When handling feed-foward detections, the pre-existing `CLASSIFICATION*` properties
      will be carried over and the `COLOR*` properties will be added to the detection.
    - `FEED_FORWARD_WHITELIST_FILE`: When `FEED_FORWARD_TYPE` is provided and not set to `NONE`, only feed-forward
      detections with class names contained in the specified file will be processed. For, example, a file with only "
      car" in it will result in performing the exclude behavior (below) for all feed-foward detections that do not have
      a `CLASSIFICATION` of "car".
    - `FEED_FORWARD_EXCLUDE_BEHAVIOR`: Specifies what to do when excluding detections not specified in
      the `FEED_FORWARD_WHITELIST_FILE`. Acceptable values are:
        - `PASS_THROUGH`: Return the excluded detections, without modification, along with any annotated detections.
        - `DROP`: Don't return the excluded detections. Only return annotated detections.

<h3>Updates</h3>

- Make interop package work with Java 8 to better support exernal job producers and consumers.

<h2>5.0.5: August 2020</h2>

<h3>Updates</h3>

- Configure Camel not to auto-acknowledge messages. Users can now see the number of pending messages in the ActiveMQ
  management console for queues consumed by the Workflow Manager.
- Improve Tesseract OSD fallback behavior. This prevents selecting the OSD rotation from the fallback pass without the
  OSD script from the fallback pass.

<h2>5.0.4: August 2020</h2>

<h3>Updates</h3>

- Retry job callbacks when they fail. The Workflow Manager now supports the `http.callback.timeout.ms`
  and `http.callback.retries` system properties.
- Drop "duplicate paged in from cursor" DLQ messages.

<h2>5.0.3: July 2020</h2>

<h3>Updates</h3>

- Update ActiveMQ to 5.16.0.

<h2>5.0.2: July 2020</h2>

<h3>Updates</h3>

- Disable video segmentation for ACS Speech Detection to prevent issues when generating speaker ids.

<h2>5.0.1: July 2020</h2>

<h3>Updates</h3>

- Updated Tessseract component with `MAX_PIXELS` setting to prevent processing large images.

<h2>5.0.0: June 2020</h2>

<h3>Documentation</h3>

- Updated the openmpf-docker repo [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md)
  and [SWARM](https://github.com/openmpf/openmpf-docker/blob/master/SWARM.md) guides to describe the new build process,
  which now includes automatically copying the openmpf repo source code into the openmpf-build image instead of using
  various bind mounts, and building all of the component base builder and executor images.
- Updated the openmpf-docker repo [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md) with the
  following sections:
    - How
      to [Use Kibana for Log Viewing and Aggregation](https://github.com/openmpf/openmpf-docker/blob/master/README.md#optional-use-kibana-for-log-viewing-and-aggregation)
    - How
      to [Restrict Media Types that a Component Can Process](https://github.com/openmpf/openmpf-docker/blob/master/README.md#optional-restrict-media-types-that-a-component-can-process)
    - How
      to [Import Root Certificates for Additional Certificate Authorities](https://github.com/openmpf/openmpf-docker/blob/master/README.md#optional-import-root-certificates-for-additional-certificate-authorities)
- Updated the [CONTRIBUTING](https://github.com/openmpf/openmpf-docker/blob/master/CONTRIBUTING.md) guide for Docker
  deployment with information on the new build process and component base builder and executor images.
- Updated the [Install Guide](Install-Guide.md) with a pointer to the "Quick Start" section on DockerHub.
- Updated the [REST API](REST-API.md) with the new endpoints for getting, deleting, and creating actions, tasks, and
  pipelines, as well as a change to the `[GET] /rest/info` endpoint.
- Updated the [C++ Batch Component API](CPP-Batch-Component-API.md) to describe changes to the `GetDetection()` calls,
  which now return a collection of detections or tracks instead of an error code, and to describe improvements to
  exception handling.
- Updated the [C++ Batch Component API](CPP-Batch-Component-API.md)
  , [Python Batch Component API](Python-Batch-Component-API.md),
  and [Java Batch Component API](Java-Batch-Component-API.md) with `MIME_TYPE`, `FRAME_WIDTH`, and `FRAME_HEIGHT` media
  properties.
- Updated the [Python Batch Component API](Python-Batch-Component-API.md) with information on Python3 and the
  simplification of using a `dict` for some of the data members.

<h3>JSON Output Object</h3>

- Renamed `stages` to `tasks` for clarity and consistency with the rest of the code.
- The `media` element no longer contains a `message` field.
- Each `detectionProcessingError` element now contains a `code` field.
- Errors and warnings are now grouped by `mediaId` and summarized using a `details` element that contains a `source`
  , `code`, and `message` field. Refer
  to [this comment](https://github.com/openmpf/openmpf/issues/780#issuecomment-641295884) for an example of the JSON
  structure. Note that errors and warnings generated by the Workflow Manager do not have a `mediaId`.
    - When an error or warning occurs in multiple frames of a video for a single piece of media it will be represented
      in one `details` element and the `message` will list the frame ranges.

<h3>Interoperability Package</h3>

- Renamed `JsonStage.java` to `JsonTask.java`.
- Removed `JsonJobRequest.java`.
- Modified `JsonDetectionProcessingError.java` by removing the `startOffset` and `stopOffset` fields and adding the
  following new fields: `startOffsetFrame`, `stopOffsetFrame`, `startOffsetTime`, `stopOffsetTime`, and `code`.
- Updated `JsonMediaOutputObject.java` by removing `message` field.
- Added `JsonMediaIssue.java` and `JsonIssueDetails.java`.

<h3>Persistent Database</h3>

- The `input_object` column in the `job_request` table has been renamed to `job` and the content now contains a
  serialized form of `BatchJob.java` instead of `JsonJobRequest.java`.

<h3>C++ Batch Component API</h3>

- The `GetDetection()` calls now return a collection instead of an error code:
    - `std::vector<MPFImageLocation> GetDetections(const MPFImageJob &job)`
    - `std::vector<MPFVideoTrack> GetDetections(const MPFVideoJob &job)`
    - `std::vector<MPFAudioTrack> GetDetections(const MPFAudioJob &job)`
    - `std::vector<MPFGenericTrack> GetDetections(const MPFGenericJob &job)`
- `MPFDetectionException` can now be constructed with a `what` parameter representing a descriptive error message:
    - `MPFDetectionException(MPFDetectionError error_code, const std::string &what = "")`
    - `MPFDetectionException(const std::string &what)`

<h3>Python Batch Component API</h3>

- Simplified the `detection_properties` and `frame_locations` data members to use a Python `dict` instead of a custom
  data type.

<h3>Full Docker Conversion</h3>

- Each component is now encapsulated in its own Docker image which self-registers with the Workflow Manager at runtime.
  This deconflicts component dependencies, and allows for greater flexibility when deciding which components to deploy
  at runtime.
- The Node Manager image has been removed. For Docker deployments, component services should be managed using Docker
  tools external to OpenMPF.
- In Docker deployments, streaming job REST endpoints are disabled, the Nodes web page is no longer available, component
  tar.gz packages cannot be registered through the Component Registration web page, and the `mpf` command line script
  can now only be run on the Workflow Manager container to modify user settings. The preexisting features are now
  reserved for non-Docker deployments and development environments.
- The OpenMPF Docker stack can optionally be deployed with [Kibana](https://www.elastic.co/kibana) (which depends on
  Elasticsearch and Filebeat) for viewing log files. Refer to the
  openmpf-docker [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md#optional-use-kibana-for-log-viewing-and-aggregation)
  .

<h3>Docker Component Base Images</h3>

- A base builder image and executor image are provided for
  C++ ([README](https://github.com/openmpf/openmpf-docker/blob/master/components/cpp_executor/README.md)),
  Python ([README](https://github.com/openmpf/openmpf-docker/blob/master/components/python_executor/README.md)), and
  Java ([README](https://github.com/openmpf/openmpf-docker/blob/master/components/java_executor/README.md)) component
  development. Component developers can also refer to the Dockerfile in the source code for each component as reference
  for how to make use of the base images.

<h3>Restrict Media Types that a Component Can Process</h3>

- Each component service now supports an optional `RESTRICT_MEDIA_TYPES` Docker environment variable that specifies the
  types of media that service will process. For example, `RESTRICT_MEDIA_TYPES: VIDEO,IMAGE` will process both videos
  and images, while `RESTRICT_MEDIA_TYPES: IMAGE` will only process images. If not specified, the service will process
  all of the media types it natively supports. For example, this feature can be used to ensure that some services are
  always available to process images while others are processing long videos.

<h3>Import Additional Root Certificates into the Workflow Manager</h3>

- Additional root certificates can be imported into the Workflow Manager at runtime by adding an entry
  for `MPF_CA_CERTS` to the workflow-manager service's environment variables in `docker-compose.core.yml`
  . `MPF_CA_CERTS` must contain a colon-delimited list of absolute file paths. Of note, a root certificate may be used
  to trust the identity of a remote object storage server.

<h3>DockerHub</h3>

- Pushed prebuilt OpenMPF Docker images to [DockerHub](https://hub.docker.com/u/openmpf). Refer to the "Quick Start"
  section of the OpenMPF Workflow Manager
  image [documentation](https://hub.docker.com/r/openmpf/openmpf_workflow_manager).

<h3>Version Updates</h3>

- Updated from Oracle Java 8 to OpenJDK 11, which required updating to Tomcat 8.5.41. We now
  use [Cargo](https://codehaus-cargo.github.io/cargo/Home.html) to run integration tests.
- Updated OpenCV from 3.0.0 to 3.4.7 to update Deep Neural Networks (DNN) support.
- Updated Python from 2.7 to 3.8.2.

<h3>FFmpeg</h3>

- We are no longer building separate audio and video encoders and decoders for FFmpeg. Instead, we are using the
  built-in decoders that come with FFmpeg by default. This simplifies the build process and redistribution via Docker
  images.

<h3>Artifact Extraction</h3>

- The  `ARTIFACT_EXTRACTION_POLICY` property can now be assigned a value of `NONE`, `VISUAL_TYPES_ONLY`, `ALL_TYPES`,
  or `ALL_DETECTIONS`.
    - With the `VISUAL_TYPES_ONLY` or `ALL_TYPES` policy, artifacts will be extracted according to
      the `ARTIFACT_EXTRACTION_POLICY*` properties. With the `NONE` and `ALL_DETECTIONS` policies, those settings are
      ignored.
    - Note that previously `NONE`, `VISUAL_EXEMPLARS_ONLY`, `EXEMPLARS_ONLY`, `ALL_VISUAL_DETECTIONS`,
      and `ALL_DETECTIONS` were supported.
- The following `ARTIFACT_EXTRACTION_POLICY*` properties are now supported:
    - `ARTIFACT_EXTRACTION_POLICY_EXEMPLAR_FRAME_PLUS`: Extract the exemplar frame from the track, plus this many frames
      before and after the exemplar.
    - `ARTIFACT_EXTRACTION_POLICY_FIRST_FRAME`: If true, extract the first frame from the track.
    - `ARTIFACT_EXTRACTION_POLICY_MIDDLE_FRAME`: If true, extract the frame with a detection that is closest to the
      middle frame from the track.
    - `ARTIFACT_EXTRACTION_POLICY_LAST_FRAME`: If true, extract the last frame from the track.
    - `ARTIFACT_EXTRACTION_POLICY_TOP_CONFIDENCE_COUNT`: Sort the detections in a track by confidence and then extract
      this many detections, starting with those which have the highest confidence.
    - `ARTIFACT_EXTRACTION_POLICY_CROPPING`: If true, an artifact will be extracted for each detection in each frame
      that is selected according to the other `ARTIFACT_EXTRACTION_POLICY*` properties. The extracted artifact will be
      cropped to the width and height of the detection bounding box, and the artifact will be rotated according to the
      detection `ROTATION` property. If false, the artifact extraction behavior is unchanged from the previous release:
      the entire frame will be extracted without any rotation.
- For clarity, `OUTPUT_EXEMPLARS_ONLY` has been renamed to `OUTPUT_ARTIFACTS_AND_EXEMPLARS_ONLY`. Extracted artifacts
  will always be reported in the JSON output object.
- The `mpf.output.objects.exemplars.only` system property has been renamed
  to `mpf.output.objects.artifacts.and.exemplars.only`. It works the same as before with the exception that if an
  artifact is extracted for a detection then that detection will always be represented in the JSON output object,
  whether it's an exemplar or not.
- The `mpf.output.objects.last.stage.only` system property has been renamed to `mpf.output.objects.last.task.only`. It
  works the same as before with the exception that when set to true artifact extraction is skipped for all tasks but the
  last task.

<h3>REST Endpoints</h3>

- Modified `[GET] /rest/info`. Now returns output like `{"version": "4.1.0", "dockerEnabled": true}`.
- Added the following REST endpoints for getting, removing, and creating actions, tasks, and pipelines. Refer to
  the [REST API](REST-API.md) for more information:
    - `[GET] /rest/actions`, `[GET] /rest/tasks`, `[GET] /rest/pipelines`
    - `[DELETE] /rest/actions`, `[DELETE] /rest/tasks`, `[DELETE] /rest/pipelines`
    - `[POST] /rest/actions` , `[POST] /rest/tasks`, `[POST] /rest/pipelines`
- All of the endpoints above are new with the exception of `[GET] /rest/pipelines`. The endpoint has changed since the
  last version of OpenMPF. Some fields in the response JSON have been removed and renamed. Also, it now returns a
  collection of tasks for each pipelines. Refer to the REST API.
- `[GET] /rest/algorithms` can be used to get information about algorithms. Note that algorithms are tied to registered
  components, so to remove an algorithm you must unregister the associated component. To add an algorithm, start the
  associated component's Docker container so it self-registers with the Workflow Manager.

<h3>Incomplete Actions, Tasks, and Pipelines</h3>

- The previous version of OpenMPF would generate an error when attempting to register a component that included actions,
  tasks, or pipelines that depend on algorithms, actions, or tasks that are not yet registered with the Workflow
  Manager. This required components to be registered in a specific order. Also, when unregistering a component, it
  required the components which depend on it to be unregistered. These dependency checks are no longer enforced.
- In general, the Workflow Manager now appropriately handles incomplete actions, tasks, and pipelines by checking if all
  of the elements are defined before executing a job, and then preserving that information in memory until the job is
  complete. This allows components to be registered and removed in an arbitrary order without affecting the state of
  other components, actions, tasks, or pipelines. This also allows actions and tasks to be removed using the new REST
  endpoints and then re-added at a later time while still preserving the elements that depend on them.
- Note that unregistering a component while a job is running will cause it to stall. Please ensure that no jobs are
  using a component before unregistering it.

<h3>Python Arbitrary Rotation</h3>

- The Python MPFVideoCapture and MPFImageReader tools now support `ROTATION` values other than 0, 90, 180, and 270
  degrees. Users can now specify a clockwise `ROTATION` job property in the range [0, 360). Values outside that range
  will be normalized to that range. Floating point values are accepted. This is similar to the existing support
  for [C++ arbitrary rotation](#cpp-arbitrary-rotation).

<h3>OpenCV Deep Neural Networks (DNN) Detection Component</h3>

- This new component replaces the old CaffeDetection component. It supports the same GoogLeNet and Yahoo Not Suitable
  For Work (NSFW) models as the old component, but removes support for the Rezafuad vehicle color detection model in
  favor of a custom TensorFlow vehicle color detection model. In our tests, the new model has proven to be more
  generalizable and provide more accurate results on never-before-seen test data. Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/cpp/OcvDnnDetection/README.md).

<h3>Azure Cognitive Services (ACS) Speech Detection Component</h3>

- This new component utilizes
  the [Azure Cognitive Services Batch Transcription REST endpoint](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/batch-transcription)
  to transcribe speech from audio and video files. Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/python/AzureSpeechDetection/README.md).

<h3>Tesseract OCR Text Detection Component</h3>

- Text tagging has been simplified to only support regular expression searches. Whole keyword searches are a subset of
  regular expression searches, and are therefore still supported. Also, the `text-tags.json` file format has been
  updated to allow for specifying case-sensitive regular expression searches.
- Additionally, the `TRIGGER_WORDS` and `TRIGGER_WORDS_OFFSET` detection properties are now supported, which list the
  OCR'd words that resulted in adding a `TAG` to the detection, and the character offset of those words within the
  OCR'd `TEXT`, respectively.
- Key changes to tagging output and `text-tags.json` format are outlined below. Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/cpp/TesseractOCRTextDetection/README.md#text-tagging)
  for more information:
    - Regex patterns should now be entered in the format `{"pattern": "regex_pattern"}`. Users can add and toggle
      the `"caseSensitive"` regex flag for each pattern.
        - For example: `{"pattern": "(\\b)bus(\\b)", "caseSensitive": true}` enables case-sensitive regex pattern
          matching.
        - By default, each regex pattern, including those in the legacy format, will be case-insensitive.
    - As part of the text tagging update, the `TAGS` outputs are now separated by semicolons `;` rather than commas `,`
      to be consistent with the delimiters for `TRIGGER_WORDS` and `TRIGGER_WORDS_OFFSET` output patterns.
        - Because semicolons can be part of the trigger word itself, those semicolons will be encapsulated in brackets.
            - For example, `detected trigger with a ;` in the OCR'd `TEXT` is reported
              as `TRIGGER_WORDS=detected trigger with a [;]; some other trigger`.
        - Commas are now used to group each set of `TRIGGER_WORDS_OFFSET` with its respective `TRIGGER_WORDS` output.
          Both `TAGS` and `TRIGGER_WORDS` are separated by semicolons only.
            - For example: `TRIGGER_WORDS=trigger1; trigger2`, `TRIGGER_WORDS_OFFSET=0-5, 6-10; 12-15`, means
              that `trigger1` occurs twice in the text at the index ranges 0-5 and 6-10, and `trigger2` occurs at index
              range 12-15.
    - Regex tagging now follows the C++ ECMAS format (
      see [examples here](http://www.cplusplus.com/reference/regex/ECMAScript/)) after resolving JSON string conversion
      for regex tags.
    - As a result the regex patterns `\b` and `\p` in the text tagging file must now be written as `\\b` and `\\p`,
      respectively, to match the format of other regex character patterns (ex. `\\d`, `\\w`, `\\s`, etc.).
- The `MAX_PARALLEL_SCRIPT_THREADS` and `MAX_PARALLEL_PAGE_THREADS` properties are now supported. When processing
  images, the first property is used to determine how many threads to run in parallel. Each thread performs OCR using a
  different language or script model. When processing PDFs, the second property is used to determine how many threads to
  run in parallel. Each thread performs OCR on a different page of the PDF.
- The `ENABLE_OSD_FALLBACK` property is now supported. If enabled, an additional round of OSD is performed when the
  first round fails to generate script predictions that are above the OSD score and confidence thresholds. In the second
  pass, the component will run OSD on multiple copies of the input text image to get an improved prediction score
  and `OSD_FALLBACK_OCCURRED` detection property will be set to true.
- If any OSD-detected models are missing, the new `MISSING_LANGUAGE_MODELS` detection property will list the missing
  models.

<h3>Tika Text Detection Component</h3>

- The Tika text detection component now supports text tagging in the same way as the Tesseract component. Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/java/TikaTextDetection/README.md#text-tagging).

<h3>Other Improvements</h3>

- Simplified component `descriptor.json` files by moving the specification of common properties, such
  as `CONFIDENCE_THRESHOLD`, `FRAME_INTERVAL`, `MIN_SEGMENT_LENGTH`, etc., to a single `workflow-properties.json` file.
  Now when the Workflow Manager is updated to support new features, the component `descriptor.json` file will not need
  to be updated.
- Updated the Sphinx component to return `TRANSCRIPT` instead of `TRANSCRIPTION`, which is grammatically correct.
- Whitespace is now trimmed from property names when jobs are submitted via the REST API.
- The Darknet Docker image now includes the YOLOv3 model weights.
- The C++ and Python ModelsIniParser now allows users to specify optional fields.
- When a job completion callback fails, but otherwise the job is successful, the final state of the job will
  be `COMPLETE_WITH_WARNINGS`.

<h3>Bug Fixes</h3>

- [[#772](https://github.com/openmpf/openmpf/issues/772)] Can now create a custom pipeline with long action names using
  the Pipelines 2 UI.
- [[#812](https://github.com/openmpf/openmpf/issues/812)] Now properly setting the start and stop index for elements in
  the `detectionProcessingErrors` collection in the JSON output object. Errors reported for each job segment will now
  appear in the collection.
- [[#941](https://github.com/openmpf/openmpf/issues/941)] Tesseract component no longer segfaults when handling corrupt
  media.
- [[#1005](https://github.com/openmpf/openmpf/issues/1005)] Fixed a bug that caused a NullPointerException when
  attempting to get output object JSON via REST before a job completes.
- [[#1035](https://github.com/openmpf/openmpf/issues/1035)] The search bar in the Job Status UI can once again for used
  to search for job id.
- [[#1104](https://github.com/openmpf/openmpf/issues/1104)] Fixed C++/Python component executor memory leaks.
- [[#1108](https://github.com/openmpf/openmpf/issues/1108)] Fixed a bug when handling frames and detections that are
  horizontally flipped. This affected both markup and feed-forward behaviors.
- [[#1119](https://github.com/openmpf/openmpf/issues/1119)] Fixed Tesseract component memory leaks and uninitialized
  read issues.

<h3>Known Issues</h3>

- [[#1028](https://github.com/openmpf/openmpf/issues/1028)] Media inspection fails to handle Apple-optimized PNGs with
  the CgBI data chunk before the IHDR chunk.
- [[#1109](https://github.com/openmpf/openmpf/issues/1109)] We made the search bar in the Job Status UI more efficient
  by shifting it to a database query, but in doing so introduced a bug where the search operates on UTC time instead of
  local system time.
- [[#1010](https://github.com/openmpf/openmpf/issues/1010)] `mpf.output.objects.enabled` does not behave as expected for
  batch jobs. A user would expect it to control whether the JSON output object is generated, but it's generated
  regardless of that setting.
- [[#1032](https://github.com/openmpf/openmpf/issues/1032)] Jobs fail on corrupt QuickTime videos. For these videos, the
  OpenCV-reported frame count is more than twice the actual frame count.
- [[#1106](https://github.com/openmpf/openmpf/issues/1106)] When a job ends in ERROR the job status UI does not show an
  End Date.

# OpenMPF 4.1.x

<h2>4.1.14: June 2020</h2>

<h3>Bug Fixes</h3>

- [[#1120](https://github.com/openmpf/openmpf/issues/1120)] The node-manager Docker image now correctly installs CUDA
  libraries so that GPU-enabled components on that image can run on the GPU.
- [[#1064](https://github.com/openmpf/openmpf/issues/1064)] Fixed memory leaks in the Darknet component for various
  network types, and when using GPU resources. This bug covers everything not addressed
  by [#1062](https://github.com/openmpf/openmpf/issues/1062).

<h2>4.1.13: June 2020</h2>

<h3>Updates</h3>

- Updated the OpenCV build and media inspection process to properly handle webp images.

<h2>4.1.12: May 2020</h2>

<h3>Updates</h3>

- Updated JDK from `jdk-8u181-linux-x64.rpm` to `jdk-8u251-linux-x64.rpm`.

<h2>4.1.11: May 2020</h2>

<h3>Tesseract OCR Text Detection Component</h3>

- Added `INVALID_MIN_IMAGE_SIZE` job property to filter out images with extremely low width or height.
- Updated image rescaling behavior to account for image dimension limits.
- Fixed handling of `nullptr` returns from Tesseract API OCR calls.

<h2>4.1.8: May 2020</h2>

<h3>Azure Cognitive Services (ACS) OCR Component</h3>

- This new component utilizes
  the [ACS OCR REST endpoint](https://westus.dev.cognitive.microsoft.com/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fc)
  to extract text from images and videos. Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/python/AzureOcrTextDetection/README.md).

<h2>4.1.6: April 2020</h2>

<h3>Updates</h3>

- Now silently discarding ActiveMQ DLQ "Suppressing duplicate delivery on connection" messages in addition to "duplicate
  from store" messages.

<h2>4.1.5: March 2020</h2>

<h3>Bug Fixes</h3>

- [[#1062](https://github.com/openmpf/openmpf/issues/1062)] Fixed a memory leak in the Darknet component that occurred
  when running jobs on CPU resources with the Tiny YOLO model.

<h3>Known Issues</h3>

- [[#1064](https://github.com/openmpf/openmpf/issues/1064)] The Darknet component has memory leaks for various network
  types, and potentially when using GPU resources. This bug covers everything not addressed
  by [#1062](https://github.com/openmpf/openmpf/issues/1062).

<h2>4.1.4: March 2020</h2>

<h3>Updates</h3>

- Updated from Hibernate 5.0.8 to 5.4.12 to support schema-based multitenancy. This allows multiple instances of OpenMPF
  to use the same PostgreSQL database as long as each instance connects to the database as a separate user, and the
  database is configured appropriately. This also required updating Tomcat from 7.0.72 to 7.0.76.

<h3>JSON Output Object</h3>

- Updated the Workflow Manager to include an `outputobjecturi` in GET callbacks, and `outputObjectUri` in POST
  callbacks, when jobs complete. This URI specifies a file path, or path on the object storage server, depending on
  where the JSON output object is located.

<h3>Interoperability Package</h3>

- Updated `JsonCallbackBody.java` to contain an `outputObjectUri` field.

<h2>4.1.3: February 2020</h2>

<h3>Features</h3>

- Added support for `DETECTION_PADDING_X` and `DETECTION_PADDING_Y` optional job properties. The value can be a
  percentage or whole-number pixel value. When positive, each detection region in each track will be expanded. When
  negative, the region will shrink. If the detection region is shrunk to nothing, the shrunk dimension(s) will be set to
  a value of 1 pixel and the `SHRUNK_TO_NOTHING` detection property will be set to true.
- Added support for `DISTANCE_CONFIDENCE_WEIGHT_FACTOR` and `SIZE_CONFIDENCE_WEIGHT_FACTOR` SuBSENSE algorithm
  properties. Increasing the value of the first property will generate detection confidence values that favor being
  closer to the center frame of a track. Increasing the value of the second property will generate detection confidence
  values that favor large detection regions.

<h2>4.1.1: January 2020</h2>

<h3>Bug Fixes</h3>

- [[#1016](https://github.com/openmpf/openmpf/issues/1016)] Fixed a bug that caused a deadlock situation when the media
  inspection process failed quickly when processing many jobs using a pipeline with more than one stage.

<h2>4.1.0: July 2019</h2>

<h3>Documentation</h3>

- Updated the [C++ Batch Component API](CPP-Batch-Component-API.md#mpfimagelocation) to describe the `ROTATION`
  detection property. See the [C++ Arbitrary Rotation](#cpp-arbitrary-rotation) section below.
- Updated the [REST API](REST-API.md) with new component registration REST endpoints. See
  the [Component Registration REST Endpoints](#component-registration-rest-endpoints) section below.
- Added a [README](https://github.com/openmpf/openmpf-components/blob/develop/python/EastTextDetection/README.md) for
  the EAST text region detection component. See
  the [EAST Text Region Detection Component](#east-text-region-detection-component) section below.
- Updated the Tesseract OCR text detection
  component [README](https://github.com/openmpf/openmpf-components/blob/develop/cpp/TesseractOCRTextDetection/README.md)
  . See the  [Tesseract OCR Text Detection Component](#tesseract-ocr-text-detection-component) section below.
- Updated the openmpf-docker repo [README](https://github.com/openmpf/openmpf-docker/blob/develop/README.md)
  and [SWARM](https://github.com/openmpf/openmpf-docker/blob/develop/SWARM.md) guide to describe the new streamlined
  approach to using `docker-compose config`. See the [Docker Deployment](#docker-deployment) section below.
- Fixed the description of `MIN_SEGMENT_LENGTH` and associated examples in
  the [User Guide](User-Guide.md#min_segment_length-property) for
  issue [#891](https://github.com/openmpf/openmpf/issues/891).
- Updated the [Java Batch Component API](Java-Batch-Component-API.md#logging) with information on how to use Log4j2.
  Related to resolving issue [#855](https://github.com/openmpf/openmpf/issues/855).
- Updated the [Install Guide](Install-Guide/index.html) to point to the
  Docker [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md#getting-started).
- Transformed the Build Guide into a [Development Environment Guide](Development-Environment-Guide/index.html).

<span id="cpp-arbitrary-rotation"></span>
<h3>C++ Arbitrary Rotation</h3>

- The C++ MPFVideoCapture and MPFImageReader tools now support `ROTATION` values other than 0, 90, 180, and 270 degrees.
  Users can now specify a clockwise `ROTATION` job property in the range [0, 360). Values outside that range will be
  normalized to that range. Floating point values are accepted.
- When using those tools to read frame data, they will automatically correct for rotation so that the returned frame is
  horizontally oriented toward the normal 3 o'clock position.
    - When `FEED_FORWARD_TYPE=REGION`, these tools will look for a `ROTATION` detection property in the feed-forward
      detections and automatically correct for rotation. For example, a detection property of `ROTATION=90` represents
      that the region is rotated 90 degrees counter clockwise, and therefore must be rotated 90 degrees clockwise to
      correct for it.
    - When `FEED_FORWARD_TYPE=SUPERSET_REGION`, these tools will properly account for the `ROTATION` detection property
      associated with each feed-forward detection when calculating the bounding box that encapsulates all of those
      regions.
    - When `FEED_FORWARD_TYPE=FRAME`, these tools will rotate the frame according to the `ROTATION` job property. It's
      important to note that for rotations other than 0, 90, 180, and 270 degrees the rotated frame dimensions will be
      larger than the original frame dimensions. This is because the frame needs to be expanded to encapsulate the
      entirety of the original rotated frame region. Black pixels are used to fill the empty space near the edges of the
      original frame.
- The Markup component now places a colored dot at the upper-left corner of each detection region so that users can
  determine the rotation of the region relative to the entire frame.

<span id="component-registration-rest-endpoints"></span>
<h3>Component Registration REST Endpoints</h3>

- Added a `[POST] /rest/components/registerUnmanaged` endpoint so that components running as separate Docker containers
  can self-register with the Workflow Manager.
    - Since these components are not managed by the Node Manager, they are considered unmanaged OpenMPF components.
      These components are not displayed in Nodes web UI and are tagged as unmanaged in the Component Registration web
      UI where they can only be removed.
    - Note that components uploaded to the Component Registration web UI as .tar.gz files are considered managed
      components.
- Added a `[DELETE] /rest/components/{componentName}` endpoint that can be used to remove managed and unmanaged
  components.

<h3>Python Component Executor Docker Image</h3>

- Component developers can now use a Python component executor Docker image to write a Python component for OpenMPF that
  can be encapsulated within a Docker container. This isolates the build and execution environment from the rest of
  OpenMPF. For more information, see
  the [README](https://github.com/openmpf/openmpf-docker/blob/develop/openmpf_runtime/python_executor/README.md).
- Components developed with this image are not managed by the Node Manager; rather, they self-register with the Workflow
  Manager and their lifetime is determined by their own Docker container.

<span id="docker-deployment"></span>
<h3>Docker Deployment</h3>

- Streamlined single-host `docker-compose up` deployments and multi-host `docker stack deploy` swarm deployments. Now
  users are instructed to create a single `docker-compose.yml` file for both types of deployments.
- Removed the `docker-generate-compose-files.sh` script in favor of allowing users the flexibility of combining
  multiple `docker-compose.*.yml` files together using `docker-compose config`. See
  the [Generate docker-compose.yml](https://github.com/openmpf/openmpf-docker/blob/develop/README.md#generate-docker-composeyml)
  section of the README.
- Components based on the Python component executor Docker image can now be defined and configured directly
  in `docker-compose.yml`.
- OpenMPF Docker images now make use of Docker labels.

<span id="east-text-region-detection-component"></span>
<h3>EAST Text Region Detection Component</h3>

- This new component uses the Efficient and Accurate Scene Text (EAST) detection model to detect text regions in images
  and videos. It reports their location, angle of rotation, and text type (`STRUCTURED` or `UNSTRUCTURED`), and supports
  a variety of settings to control the behavior of merging text regions into larger regions. It does not perform OCR on
  the text or track detections across video frames. Thus, each video track is at most one detection long. For more
  information, see
  the [README](https://github.com/openmpf/openmpf-components/blob/develop/python/EastTextDetection/README.md).
- Optionally, this component can be built as a Docker image using the Python component executor Docker image, allowing
  it to exist apart from the Node Manager image.

<span id="tesseract-ocr-text-detection-component"></span>
<h3>Tesseract OCR Text Detection Component</h3>

- Updated to support reading tessdata `*.traineddata` files at a specified `MODELS_DIR_PATH`. This allows users to
  install new `*.traineddata` files post deployment.
- Updated to optionally perform Tesseract Orientation and Script Detection (OSD). When enabled, the component will
  attempt to use the orientation results of OSD to automatically rotate the image, as well as perform OCR using the
  scripts detected by OSD.
- Updated to optionally rotate a feed-forward text region 180 degrees to account for upside-down text.
- Now supports the following preprocessing properties for both structured and unstructured text:
    - Text sharpening
    - Text rescaling
    - Otsu image thresholding
    - Adaptive thresholding
    - Histogram equalization
    - Adaptive histogram equalization (also known as Contrast Limited Adaptive Histogram Equalization (CLAHE))
- Will use the `TEXT_TYPE` detection property in feed-forward regions provided by the EAST component to determine which
  preprocessing steps to perform.
- For more information on these new features, see
  the [README](https://github.com/openmpf/openmpf-components/blob/develop/cpp/TesseractOCRTextDetection/README.md).
- Removed gibberish and string filters since they only worked on English text.

<h3>ActiveMQ Profiles</h3>

- The ActiveMQ Docker image now supports custom profiles. The container selects an `activemq.xml` and `env` file to use
  at runtime based on the value of the `ACTIVE_MQ_PROFILE` environment variable. Among others, these files contain
  configuration settings for Java heap space and component queue memory limits.
- This release only supports a `default` profile setting, as defined by `activemq-default.xml` and `env.default`;
  however, developers are free to add other `activemq-<profile>.xml` and `env.<profile>` files to the ActiveMQ Docker
  image to suit their needs.

<h3>Disabled ActiveMQ Prefetch</h3>

- Disabled ActiveMQ prefetching on all component queues. Previously, a prefetch value of one was resulting in situations
  where one component service could be dispatched two sub-jobs, thereby starving other available component services
  which could process one of those sub-jobs in parallel.

<h3>Search Region Percentages</h3>

- In addition to using exact pixel values, users can now use percentages for the following properties when specifying
  search regions for C++ and Python components:
    - `SEARCH_REGION_TOP_LEFT_X_DETECTION`
    - `SEARCH_REGION_TOP_LEFT_Y_DETECTION`
    - `SEARCH_REGION_BOTTOM_RIGHT_X_DETECTION`
    - `SEARCH_REGION_BOTTOM_RIGHT_Y_DETECTION`
- For example, setting `SEARCH_REGION_TOP_LEFT_X_DETECTION=50%` will result in components only processing the right half
  of an image or video.
- Optionally, users can specify exact pixel values of some of these properties and percentages for others.

<h3>Other Improvements</h3>

- Increased the number of ActiveMQ maxConcurrentConsumers for the `MPF.COMPLETED_DETECTIONS` queue from 30 to 60.
- The Create Job web UI now only displays the content of the `$MPF_HOME/share/remote-media` directory instead of all
  of `$MPF_HOME/share`, which prevents the Workflow Manager from indexing generated JSON output files, artifacts, and
  markup. Indexing the latter resulted in Java heap space issues for large scale production systems. This is a
  mitigation for issue [#897](https://github.com/openmpf/openmpf/issues/897).
- The Job Status web UI now makes proper use of pagination in SQL/Hibernate through the Workflow Manager to avoid
  retrieving the entire jobs table, which was inefficient.
- The Workflow Manager will now silently discard all duplicate messages in the ActiveMQ Dead Letter Queue (DLQ),
  regardless of destination. Previously, only messages destined for component sub-job request queues were discarded.

<h3>Bug Fixes</h3>

- [[#891](https://github.com/openmpf/openmpf/issues/891)] Fixed a bug where the Workflow Manager media segmenter
  generated short segments that were minimally `MIN_SEGMENT_LENGTH+1` in size instead of `MIN_SEGMENT_LENGTH`.
- [[#745](https://github.com/openmpf/openmpf/issues/745)] In environments where thousands of jobs are processed, users
  have observed that, on occasion, pending sub-job messages in ActiveMQ queues are not processed until a new job is
  created. This seems to have been resolved by disabling ActiveMQ prefetch behavior on component queues.
- [[#855](https://github.com/openmpf/openmpf/issues/855)] A logback circular reference suppressed exception no longer
  throws a StackOverflowError. This was resolved by transitioning the Workflow Manager and Java components from the
  Logback framework to Log4j2.

<h3>Known Issues</h3>

- [[#897](https://github.com/openmpf/openmpf/issues/897)] OpenMPF will attempt to index files located
  in `$MPF_HOME/share` as soon as the webapp is started by Tomcat. This is so that those files can be listed in a
  directory tree in the Create Job web UI. The main problem is that once a file gets indexed it's never removed from the
  cache, even if the file is manually deleted, resulting in a memory leak.

<h3>Late Additions: November 2019</h3>

- User names, roles, and passwords can now be set by using an optional `user.properties` file. This allows
  administrators to override the default OpenMPF users that come preconfigured, which may be a security risk. Refer to
  the "Configure Users" section of the
  openmpf-docker [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md#optional-configure-users) for
  more information.

<h3>Late Additions: December 2019</h3>

- Transitioned from using a mySQL persistent database to PostgreSQL to support users that use an external PostgreSQL
  database in the cloud.
- Updated the EAST component to support a `TEMPORARY_PADDING` and `FINAL_PADDING` property. The first property
  determines how much padding is added to detections during the non-maximum suppression or merging step. This padding is
  effectively removed from the final detections. The second property is used to control the final amount of padding on
  the output regions. Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/python/EastTextDetection/README.md#properties).

# OpenMPF 4.0.x

<h2>4.0.0: February 2019</h2>

<h3>Documentation</h3>

- Added an [Object Storage Guide](Object-Storage-Guide/index.html) with information on how to configure OpenMPF to work
  with a custom NGINX object storage server, and how to run jobs that use an S3 object storage server. Note that the
  system properties for the custom NGINX object storage server have changed since the last release.

<h3>Upgrade to Tesseract 4.0</h3>

- Both the Tesseract OCR Text Detection Component and OpenALPR License Plate Detection Components have been updated to
  use the new version of Tesseract.
- Additionally, Leptonica has been upgraded from 1.72 to 1.75.

<h3>Docker Deployment</h3>

- The Docker images now use the yum package manager to install ImageMagick6 from a public RPM repository instead of
  downloading the RPMs directly from imagemagick.org. This resolves an issue with the OpenMPF Docker build where RPMs
  on [imagemagick.org](https://imagemagick.org/script/download.php) were no longer available.

<h3>Tesseract OCR Text Detection Component</h3>

- Updated to allow the user to set a `TESSERACT_OEM` property in order to select an OCR engine mode (OEM).
- "script/Latin" can now be specified as the `TESSERACT_LANGUAGE`. When selected, Tesseract will select all Latin
  characters, which can be from different Latin languages.

<h3>Ceph S3 Object Storage</h3>

- Added support for downloading files from, and uploading files to, an S3 object storage server. The following job
  properties can be provided: `S3_ACCESS_KEY`, `S3_SECRET_KEY`, `S3_RESULTS_BUCKET`, `S3_UPLOAD_ONLY`.
- At this time, only support for Ceph object storage has been tested. However, the Workflow Manager uses the AWS SDK for
  Java to communicate with the object store, so it is possible that other S3-compatible storage solutions may work as
  well.

<h3>ISO-8601 Timestamps</h3>

- All timestamps in the JSON output object, and streaming video callbacks, are now in the ISO-8601 format (e.g. "
  2018-12-19T12:12:59.995-05:00"). This new format includes the time zone, which makes it possible to compare timestamps
  generated between systems in different time zones.
- This change does not affect the track and detection start and stop offset times, which are still reported in
  milliseconds since the start of the video.

<h3>Reduced Redis Usage</h3>

- The Workflow Manager has been refactored to reduce usage of the Redis in-memory database. In general, Redis is not
  necessary for storing job information and only resulted in introducing potential delays in accessing that data over
  the network stack.
- Now, only track and detection data is stored in Redis for batch jobs. This reduces the amount of memory the Workflow
  Manager requires of the Java Virtual Machine. Compared to the other job information, track and detection data can
  potentially be relatively much larger. In the future, we plan to store frame data in Redis for streaming jobs as well.

<h3>Caffe Vehicle Color Estimation</h3>

- The Caffe
  Component [models.ini](https://github.com/openmpf/openmpf-components/blob/master/cpp/CaffeDetection/plugin-files/models/models.ini)
  file has been updated with a "vehicle_color" section with links for downloading
  the [Reza Fuad Rachmadi's Vehicle Color Recognition Using Convolutional Neural Network](https://github.com/rezafuad/vehicle-color-recognition)
  model files.
- The following pipelines have been added. These require the above model files to be placed
  in `$MPF_HOME/share/models/CaffeDetection`:
    - `CAFFE REZAFUAD VEHICLE COLOR DETECTION PIPELINE`
    - `CAFFE REZAFUAD VEHICLE COLOR DETECTION (WITH FF REGION FROM TINY YOLO VEHICLE DETECTOR) PIPELINE`
    - `CAFFE REZAFUAD VEHICLE COLOR DETECTION (WITH FF REGION FROM YOLO VEHICLE DETECTOR) PIPELINE`

<h3>Track Merging and Minimum Track Length</h3>

- The following system properties now have "video" in their names:
    - `detection.video.track.merging.enabled`
    - `detection.video.track.min.gap`
    - `detection.video.track.min.length`
    - `detection.video.track.overlap.threshold`
- The above properties can be overridden by the following job properties, respectively. These have not been renamed
  since the last release:
    - `MERGE_TRACKS`
    - `MIN_GAP_BETWEEN_TRACKS`
    - `MIN_TRACK_LENGTH`
    - `MIN_OVERLAP`
- These system and job properties now only apply to video media. This resolves an issue where users had
  set `detection.track.min.length=5`, which resulted in dropping all image media tracks. By design, each image track can
  only contain a single detection.

<h3>Bug Fixes</h3>

- Fixed a bug where the Docker entrypoint scripts appended properties to the end
  of `$MPF_HOME/share/config/mpf-custom.properties` every time the Docker deployment was restarted, resulting in entries
  like `detection.segment.target.length=5000,5000,5000`.
- Upgrading to Tesseract 4 fixes a bug where, when specifying `TESSERACT_LANGUAGE`, if one of the languages is Arabic,
  then Arabic must be specified last. Arabic can now be specified first, for example: `ara+eng`.
- Fixed a bug where the minimum track length property was being applied to image tracks. Now it's only applied to video
  tracks.
- Fixed a bug where ImageMagick6 installation failed while building Docker images.

# OpenMPF 3.0.x

<h2>3.0.0: December 2018</h2>

> **NOTE:** The [Build Guide](Build-Environment-Setup-Guide/index.html) and [Install Guide](Install-Guide/index.html) are outdated. The old process for manually configuring a Build VM, using it to build an OpenMPF package, and installing that package, is deprecated in favor of Docker containers. Please refer to the openmpf-docker [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md).

> **NOTE:** Do not attempt to register or unregister a component through the Nodes UI in a Docker deployment. It may appear to succeed, but the changes will not affect the child Node Manager containers, only the Workflow Manager container. Also, do not attempt to use the `mpf` command line tools in a Docker deployment.

<h3>Documentation</h3>

- Added a [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md)
  , [SWARM](https://github.com/openmpf/openmpf-docker/blob/master/SWARM.md) guide,
  and [CONTRIBUTING](https://github.com/openmpf/openmpf-docker/blob/master/CONTRIBUTING.md) guide for Docker deployment.
- Updated the [User Guide](User-Guide/index.html#min_gap_between_segments-property) with information on how track
  properties and track confidence are handled when merging tracks.
- Added README files for new components. Refer to the component sections below.

<h3>Docker Support</h3>

- OpenMPF can now be built and distributed as 5 Docker images: openmpf_workflow_manager, openmpf_node_manager,
  openmpf_active_mq, mysql_database, and redis.
- These images can be deployed on a single host using `docker-compose up`.
- They can also be deployed across multiple hosts in a Docker swarm cluster using `docker stack deploy`.
- GPU support is enabled through the NVIDIA Docker runtime.
- Both HTTP and HTTPS deployments are supported.

<span id="json-output-object"></span>
<h3>JSON Output Object</h3>

- Added a `trackProperties` field at the track level that works in much the same way as the `detectionProperties` field
  at the detection level. Both are maps that contain zero or more key-value pairs. The component APIs have always
  supported the ability to return track-level properties, but they were never represented in the JSON output object,
  until now.
- Similarly, added a track `confidence` field. The component APIs always supported setting it, but the value was never
  used in the JSON output object, until now.
- Added `jobErrors` and`jobWarnings` fields. The `jobErrors` field will mention that there are items
  in `detectionProcessingErrors` fields.
- The `offset`, `startOffset`, and `stopOffset` fields have been removed in favor of the existing `offsetFrame`
  , `startOffsetFrame`, and `stopOffsetFrame` fields, respectively. They were redundant and deprecated.
- Added a `mpf.output.objects.exemplars.only` system property, and `OUTPUT_EXEMPLARS_ONLY` job property, that can be set
  to reduce the size of the JSON output object by only recording the track exemplars instead of all of the detections in
  each track.
- Added a `mpf.output.objects.last.stage.only` system property, and `OUTPUT_LAST_STAGE_ONLY` job property, that can be
  set to reduce the size of the JSON output object by only recording the detections for the last non-markup stage of a
  pipeline.

<h3>Darknet Component</h3>

- The Darknet component can now support processing streaming video.
- In batch mode, video frames are prefetched, decoded, and stored in a buffer using a separate thread from the one that
  performs the detection. The size of the prefetch buffer can be configured by setting `FRAME_QUEUE_CAPACITY`.
- The Darknet component can now perform basic tracking and generate video tracks with multiple detections. Both the
  default detection mode and preprocessor detection mode are supported.
- The Darknet component has been updated to support the full and tiny YOLOv3 models. The YOLOv2 models are no longer
  supported.

<h3>Tesseract OCR Text Detection Component</h3>

- This new component extracts text found in an image and reports it as a single-detection track.
- PDF documents can also be processed with one track detection per page.
- Users may set the language of each track using the `TESSERACT_LANGUAGE` property as well as adjust other image
  preprocessing properties for text extraction.
- Refer to
  the [README](https://github.com/openmpf/openmpf-components/blob/master/cpp/TesseractOCRTextDetection/README.md).

<h3>OpenCV Scene Change Detection Component</h3>

- This new component detects and segments a given video by scenes. Each scene change is detected using histogram
  comparison, edge comparison, brightness (fade outs), and overall hue/saturation/value differences between adjacent
  frames.
- Users can toggle each type of of scene change detection technique as well as threshold properties for each detection
  method.
- Refer to the [README](https://github.com/openmpf/openmpf-components/blob/master/cpp/SceneChangeDetection/README.md).

<h3>Tika Text Detection Component</h3>

- This new component extracts text contained in documents and performs language detection. 71 languages and most
  document formats (.txt, .pptx, .docx, .doc, .pdf, etc.) are supported.
- Refer to the [README](https://github.com/openmpf/openmpf-components/blob/master/java/TikaTextDetection/README.md).

<h3>Tika Image Detection Component</h3>

- This new component extracts images embedded in document formats (.pdf, .ppt, .doc) and stores them on disk in a
  specified directory.
- Refer to the [README](https://github.com/openmpf/openmpf-components/blob/master/java/TikaImageDetection/README.md).

<h3>Track-Level Properties and Confidence</h3>

- Refer to the addition of track-level properties and confidence in the [JSON Output Object](#json-output-object)
  section.
- Components have been updated to return meaningful track-level properties. Caffe and Darknet include `CLASSIFICATION`,
  OALPR includes the exemplar `TEXT`, and Sphinx includes the `TRANSCRIPTION`.
- The Workflow Manager will now populate the track-level confidence. It is the same as the exemplar confidence, which is
  the max of all of the track detections.

<h3>Custom NGINX HTTP Object Storage</h3>

- Added `http.object.storage.*` system properties for configuring an optional custom NGINX object storage server on
  which to store generated detection artifacts, JSON output objects, and markup files.
- When a file cannot be uploaded to the server, the Workflow Manager will fall back to storing it in `$MPF_HOME/share`,
  which is the default behavior when an object storage server is not specified.
- If and when a failure occurs, the JSON output object will contain a descriptive message in the `jobWarnings` field,
  and, if appropriate, the `markupResult.message` field. If the job completes without other issues, the final status
  will be `COMPLETE_WITH_WARNINGS`.
- The NGINX storage server runs custom server-side code which we can make available upon request. In the future, we plan
  to support more common storage server solutions, such as Amazon S3.

<span id="activemq"></span>
<h3>ActiveMQ</h3>

- The `MPF_OUTPUT` queue is no longer supported and has been removed. Job producers can specify a callback URL when
  creating a job so that they are alerted when the job is complete. Users observed heap space issues with ActiveMQ after
  running thousands of jobs without consuming messages from the `MPF_OUTPUT` queue.
- The Workflow Manager will now silently discard duplicate sub-job request messages in the ActiveMQ Dead Letter Queue (
  DLQ). This fixes a bug where the Workflow Manager would prematurely terminate jobs corresponding to the duplicate
  messages. It's assumed that ActiveMQ will only place a duplicate message in the DLQ if the original message, or
  another duplicate, can be delivered.

<h3>Node Auto-Configuration</h3>

- Added the `node.auto.config.enabled`, `node.auto.unconfig.enabled`, and `node.auto.config.num.services.per.component`
  system properties for automatically managing the configuration of services when nodes join and leave the OpenMPF
  cluster.
- Docker will assign a a hostname with a randomly-generated id to containers in a swarm deployment. The above properties
  allow the Workflow Manager to automatically discover and configure services on child Node Manager components, which is
  convenient since the hostname of those containers cannot be known in advance, and new containers with new hostnames
  are created when the swarm is restarted.

<h3>Job Status Web UI</h3>

- Added the `web.broadcast.job.status.enabled` and `web.job.polling.interval` system properties that can be used to
  configure if the Workflow Manager automatically broadcasts updates to the Job Status web UI. By default, the
  broadcasts are enabled.
- In a production environment that processes hundreds of jobs or more at the same time, this behavior can result in
  overloading the web UI, causing it to slow down and freeze up. To prevent this, set `web.broadcast.job.status.enabled`
  to `false`. If `web.job.polling.interval` is set to a non-zero value, the web UI will poll for updates at that
  interval (specified in milliseconds).
- To disable broadcasts and polling, set `web.broadcast.job.status.enabled` to `false` and `web.job.polling.interval` to
  a zero or negative value. Users will then need to manually refresh the Job Status web page using their web browser.

<h3>Other Improvements</h3>

- Now using variable-length text fields in the mySQL database for string data that may exceed 255 characters.
- Updated the MPFImageReader tool to use OpenCV video capture behind the scenes to support reading data from HTTP URLs.
- Python components can now include pre-built wheel files in the plugin package.
- We now use a [Jenkinsfile](https://github.com/openmpf/openmpf-docker/blob/master/Jenkinsfile) Groovy script for our
  Jenkins build process. This allows us to use revision control for our continuous integration process and share that
  process with the open source community.
- Added `remote.media.download.retries` and `remote.media.download.sleep` system properties that can be used to
  configure how the Workflow Manager will attempt to retry downloading remote media if it encounters a problem.
- Artifact extraction now uses MPFVideoCapture, which employs various fallback strategies for extracting frames in cases
  where a video is not well-formed or corrupted. For components that use MPFVideoCapture, this enables better
  consistency between the frames they process and the artifacts that are later extracted.

<h3>Bug Fixes</h3>

- Jobs now properly end in `ERROR` if an invalid media URL is provided or there is a problem accessing remote media.
- Jobs now end in `COMPLETE_WITH_ERRORS` when a detection splitter error occurs due to missing system properties.
- Components can now include their own version of the Google Protobuf library. It will not conflict with the version
  used by the rest of OpenMPF.
- The Java component executor now sets the proper job id in the job name instead of using the ActiveMQ message request
  id.
- The Java component executor now sets the run directory using `setRunDirectory()`.
- Actions can now be properly added using an "extras" component. An extras component only includes a `descriptor.json`
  file and declares Actions, Tasks, and Pipelines using other component algorithms.
- Refer to the items listed in the [ActiveMQ](#activemq) section.
- Refer to the addition of track-level properties and confidence in the [JSON Output Object](#json-output-object)
  section.

<h3>Known Issues</h3>

- [[#745](https://github.com/openmpf/openmpf/issues/745)] In environments where thousands of jobs are processed, users
  have observed that, on occasion, pending sub-job messages in ActiveMQ queues are not processed until a new job is
  created. The reason is currently unknown.
- [[#544](https://github.com/openmpf/openmpf/issues/544)] Image artifacts retain some permissions from source files
  available on the local host. This can result in some of the image artifacts having executable permissions.
- [[#604](https://github.com/openmpf/openmpf/issues/604)] The Sphinx component cannot be unregistered
  because `$MPF_HOME/plugins/SphinxSpeechDetection/lib` is owned by root on a deployment machine.
- [[#623](https://github.com/openmpf/openmpf/issues/623)] The Nodes UI does not work correctly
  when `[POST] /rest/nodes/config` is used at the same time. This is because the UI's state is not automatically updated
  to reflect changes made through the REST endpoint.
- [[#783](https://github.com/openmpf/openmpf/issues/783)] The Tesseract OCR Text Detection Component has
  a [known issue](https://github.com/tesseract-ocr/tesseract/issues/235) because it uses Tesseract 3. If a combination
  of languages is specified using `TESSERACT_LANGUAGE`, and one of the languages is Arabic, then Arabic must be
  specified last. For example, for English and Arabic, `eng+ara` will work, but `ara+eng` will not.
- [[#784](https://github.com/openmpf/openmpf/issues/784)] Sometimes services do not start on OpenMPF nodes, and those
  services cannot be started through the Nodes web UI. This is not a Docker-specific problem, but it has been observed
  in a Docker swarm deployment when auto-configuration is enabled. The workaround is to restart the Docker swarm
  deployment, or remove the entire node in the Nodes UI and add it again.

# OpenMPF 2.1.x

<h2>2.1.0: June 2018</h2>

> **NOTE:** If building this release on a machine used to build a previous version of OpenMPF, then please run `sudo pip install --upgrade pip` to update to at least pip 10.0.1. If not, the OpenMPF build script will fail to properly download .whl files for Python modules.

<h3>Documentation</h3>

- Added the [Python Batch Component API](Python-Batch-Component-API/index.html).
- Added the [Node Guide](Node-Guide/index.html).
- Added the [GPU Support Guide](GPU-Support-Guide).
- Updated the [Install Guide](Install-Guide/index.html) with an "(Optional) Install the NVIDIA CUDA Toolkit" section.
- Renamed Admin Manual to Admin Guide for consistency.

<h3>Python Batch Component API</h3>

- Developers can now write batch components in Python using the mpf_component_api module.
- Dependencies can be specified in a setup.py file. OpenMPF will automatically download the .whl files using pip at
  build time.
- When deployed, a virtualenv is created for the Python component so that it runs in a sandbox isolated from the rest of
  the system.
- OpenMPF ImageReader and VideoCapture tools are provided in the mpf_component_util module.
- Example Python components are provided for reference.

<h3>Spare Nodes</h3>

- Spare nodes can join and leave an OpenMPF cluster while the Workflow Manager is running. You can create a spare node
  by cloning an existing OpenMPF child node. Refer to the [Node Guide](Node-Guide/index.html).
- Note that changes made using the Component Registration web page only affect core nodes, not spare nodes. Core nodes
  are those configured during the OpenMPF installation process.
- Added `mpf list-nodes` command to list the core nodes and available spare nodes.
- OpenMPF now uses the JGroups FILE_PING protocol for peer discovery instead of TCPPING. This means that the list of
  OpenMPF nodes no longer needs to be fully specified when the Workflow Manager starts. Instead, the Workflow Manager,
  and Node Manager process on each node, use the files in `$MPF_HOME/share/nodes` to determine which nodes are currently
  available.
- Updated JGroups from 3.6.4. to 4.0.11.
- The environment variables specified in `/etc/profile.d/mpf.sh` have been simplified. Of note, `ALL_MPF_NODES` has been
  replaced by `CORE_MPF_NODES`.

<h3>Default Detection System Properties</h3>

- The detection properties that specify the default values when creating new jobs can now be updated at runtime without
  restarting the Workflow Manager. Changing these properties will only have an effect on new jobs, not jobs that are
  currently running.
- These default detection system properties are separated from the general system properties in the Properties web page.
  The latter still require the Workflow Manager to be restarted for changes to take effect.
- The Apache Commons Configuration library is now used to read and write properties files. When defining a property
  value using an environment variable in the Properties web page, or `$MPF_HOME/config/mpf-custom.properties`, be sure
  to prepend the variable name with `env:`. For example:

```
detection.models.dir.path=${env:MPF_HOME}/models/
```

> Alternatively, you can define system properties using other system properties:

```
detection.models.dir.path=${mpf.share.path}/models/
```

<h3>Adaptive Frame Interval</h3>

- The `FRAME_RATE_CAP` property can be used to set a threshold on the maximum number of frames to process within one
  second of the native video time. This property takes precedence over the user-provided / pipeline-provided value
  for `FRAME_INTERVAL`. When the `FRAME_RATE_CAP` property is specified, an internal frame interval value is calculated
  as follows:

```
calcFrameInterval = max(1, floor(mediaNativeFPS / frameRateCapProp));
```

- `FRAME_RATE_CAP` may be disabled by setting it <= 0. `FRAME_INTERVAL` can be disabled in the same way.
- If `FRAME_RATE_CAP` is disabled, then `FRAME_INTERVAL` will be used instead.
- If both `FRAME_RATE_CAP` and `FRAME_INTERVAL` are disabled, then a value of 1 will be used for `FRAME_INTERVAL`.

<h3>Darknet Component</h3>

- This release includes a component that uses the [Darknet neural network framework](https://pjreddie.com/darknet/) to
  perform detection and classification of objects using trained models.
- Pipelines for the Tiny YOLO and YOLOv2 models are provided. Due to its large size, the YOLOv2 weights file must be
  downloaded separately and placed in `$MPF_HOME/share/models/DarknetDetection` in order to use the YOLOv2 pipelines.
  Refer to `DarknetDetection/plugin-files/models/models.ini` for more information.
- This component supports a preprocessor mode and default mode of operation. If preprocessor mode is enabled, and
  multiple Darknet detections in a frame share the same classification, then those are merged into a single detection
  where the region corresponds to the superset region that encapsulates all of the original detections, and the
  confidence value is the probability that at least one of the original detections is a true positive. If disabled,
  multiple Darknet detections in a frame are not merged together.
- Detections are not tracked across frames. One track is generated per detection.
- This component supports an optional `CLASS_WHITELIST_FILE` property. When provided, only detections with class names
  listed in the file will be generated.
- This component can be compiled with GPU support if the NVIDIA CUDA Toolkit is installed on the build machine. Refer to
  the [GPU Support Guide](GPU-Support-Guide). If the toolkit is not found, then the component will compile with CPU
  support only.
- To run on a GPU, set the `CUDA_DEVICE_ID` job property, or set the detection.cuda.device.id system property, >= 0.
- When `CUDA_DEVICE_ID` >= 0, you can set the `FALLBACK_TO_CPU_WHEN_GPU_PROBLEM` job property, or the
  detection.use.cpu.when.gpu.problem system property, to `TRUE` if you want to run the component logic on the CPU
  instead of the GPU when a GPU problem is detected.

<h3>Models Directory</h3>

- The`$MPF_HOME/share/models` directory is now used by the Darknet and Caffe components to store model files and
  associated files, such as classification names files, weights files, etc. This allows users to more easily add model
  files post-deployment. Instead of copying the model files to `$MPF_HOME/plugins/<component-name>/models` directory on
  each node in the OpenMPF cluster, they only need to copy them to the shared directory once.
- To add new models to the Darknet and Caffe component, add an entry to the
  respective `<component-name>/plugin-files/models/models.ini` file.

<h3>Packaging and Deployment</h3>

- Python components are packaged with their respective dependencies as .whl files. This can be automated by providing a
  setup.py file. An example OpenCV Python component is provided that demonstrates how the component is packaged and
  deployed with the opencv-python module. When deployed, a virtualenv is created for the component with the .whl files
  installed in it.
- When deploying OpenMPF, `LD_LIBRARY_PATH` is no longer set system-wide. Refer to Known Issues.

<h3>Web User Interface</h3>

- Updated the Nodes page to distinguish between core nodes and spare nodes, and to show when a node is online or
  offline.
- Updated the Component Registration page to list the core nodes as a reminder that changes will not affect spare nodes.
- Updated the Properties page to separate the default detection properties from the general system properties.

<h3>Bug Fixes</h3>

- Custom Action, task, and pipeline names can now contain "(" and ")" characters again.
- Detection location elements for audio tracks and generic tracks in a JSON output object will now have a y value of `0`
  instead of `1`.
- Streaming health report and summary report timestamps have been corrected to represent hours in the 0-23 range instead
  of 1-24.
- Single-frame .gif files are now segmented properly and no longer result in a NullPointerException.
- `LD_LIBRARY_PATH` is now set at the process level for Tomcat, the Node Manager, and component services, instead of at
  the system level in `/etc/profile.d/mpf.sh`. Also, deployments no longer create `/etc/ld.so.conf.d/mpf.conf`. This
  better isolates OpenMPF from the rest of the system and prevents issues, such as being unable to use SSH, when system
  libraries are not compatible with OpenMPF libraries. The latter situation may occur when running `yum update` on the
  system, which can make OpenMPF unusable until a new deployment package with compatible libraries is installed.
- The Workflow Manager will no longer generate an "Error retrieving the SingleJobInfo model" line in the log if someone
  is viewing the Job Status page when a job submitted through the REST API is in progress.

<h3>Known Issues</h3>

- When multiple component services of the same type on the same node log to the same file at the same time, sometimes
  log lines will not be captured in the log file. The logging frameworks (log4j and log4cxx) do not support that usage.
  This problem happens more frequently on systems running many component services at the same time.
- The following exception was observed:

```
com.google.protobuf.InvalidProtocolBufferException: Message missing required fields: data_uri

```

> Further debugging is necessary to determine the reason why that message was missing that field. The situation is not easily reproducible. It may occur when ActiveMQ and / or the system is under heavy load and sends duplicate messages in attempt to ensure message delivery. Some of those messages seem to end up in the dead letter queue (DLQ). For now, we've improved the way we handle messages in the DLQ. If OpenMPF can process a message successfully, the job is marked as `COMPLETED_WITH_ERRORS`, and the message is moved from `ActiveMQ.DLQ` to `MPF.DLQ_PROCESSED_MESSAGES`. If OpenMPF cannot process a message successfully, it is moved from `ActiveMQ.DLQ to MPF.DLQ_INVALID_MESSAGES`.

- The `mpf stop` command will stop the Workflow Manager, which will in turn send commands to all of the available nodes
  to stop all running component services. If a service is processing a sub-job when the quit command is received, that
  service process will not terminate until that sub-job is completely processed. Thus, the service may put a sub-job
  response on the ActiveMQ response queue after the Workflow Manager has terminated. That will not cause a problem
  because the queues are flushed the next time the Workflow Manager starts; however, there will be a problem if the
  service finishes processing the sub-job after the Workflow Manager is restarted. At that time, the Workflow Manager
  will have no knowledge of the old job and will in turn generate warnings in the log about how the job id is "not known
  to the system" and/or "not found as a batch or a streaming job". These can be safely ignored. Often, if these messages
  appear in the log, then C++ services were running after stopping the Workflow Manager. To address this, you may wish
  to run `sudo killall amq_detection_component` after running `mpf stop`.

# OpenMPF 2.0.x

<h2>2.0.0: February 2018</h2>

> **NOTE:** Components built for previous releases of OpenMPF are not compatible with OpenMPF 2.0.0 due to Batch Component API changes to support generic detections, and changes made to the format of the `descriptor.json` file to support stream processing.

> **NOTE:** This release contains basic support for processing video streams. Currently, the only way to make use of that functionality is through the REST API. Streaming jobs and services cannot be created or monitored through the web UI. Only the SuBSENSE component has been updated to support streaming. Only single-stage pipelines are supported at this time.

<h3>Documentation</h3>

- Updated documents to distinguish the batch component APIs from the streaming component API.
- Added the [C++ Streaming Component API](CPP-Streaming-Component-API/index.html).
- Updated the [C++ Batch Component API](CPP-Batch-Component-API/index.html) to describe support for generic detections.
- Updated the [REST API](REST-API/index.html) with endpoints for streaming jobs.

<h3>Support for Generic Detections</h3>

- C++ and Java components can now declare support for the `UNKNOWN` data type. The respective batch APIs have been
  updated with a function that will enable a component to process an `MPFGenericJob`, which represents a piece of media
  that is not a video, image, or audio file.
- Note that these API changes make OpenMPF R2.0.0 incompatible with components built for previous releases of OpenMPF.
  Specifically, the new component executor will not be able to load the component logic library.

<h3>C++ Batch Component API</h3>

- Added the following function to support generic detections:
    - `MPFDetectionError GetDetections(const MPFGenericJob &job, vector<MPFGenericTrack> &tracks)`

<h3>Java Batch Component API</h3>

- Added the following method to support generic detections:
    - `List<MPFGenericTrack> getDetections(MPFGenericJob job)`

<h3>Streaming REST API</h3>

- Added the following REST endpoints for streaming jobs:
    - `[GET] /rest/streaming/jobs`: Returns a list of streaming job ids.
    - `[POST] /rest/streaming/jobs`: Creates and submits a streaming job. Users can register for health report and
      summary report callbacks.
    - `[GET] /rest/streaming/jobs/{id}`: Gets information about a streaming job.
    - `[POST] /rest/streaming/jobs/{id}/cancel`: Cancels a streaming job.

<h3>Workflow Manager</h3>

- Updated to support generic detections.
- Updated Redis to store information about streaming jobs.
- Added controllers for streaming job REST endpoints.
- Added ability to generate health reports and segment summary reports for streaming jobs.
- Improved code flow between the Workflow Manager and master Node Manager to support streaming jobs.
- Added ActiveMQ queues to enable the C++ Streaming Component Executor to send reports and job status to the Workflow
  Manager.

<h3>Node Manager</h3>

- Updated the master Node Manager and child Node Managers to spawn component services on demand to handle streaming
  jobs, cancel those jobs, and to monitor the status of those processes.
- Using .ini files to represent streaming job properties and enable better communication between a child Node Manager
  and C++ Streaming Component Executor.

<h3>C++ Streaming Component API</h3>

- Developed the C++ Streaming Component API with the following functions:
    - `MPFStreamingDetectionComponent(const MPFStreamingVideoJob &job)`: Constructor that takes a streaming video job.
    - `string GetDetectionType()`: Returns the type of detection (i.e. "FACE").
    - `void BeginSegment(const VideoSegmentInfo &segment_info)`: Indicates the beginning of a new video segment.
    - `bool ProcessFrame(const cv::Mat &frame, int frame_number)`: Processes a single frame for the current video
      segment.
    - `vector<MPFVideoTrack> EndSegment()`: Indicates the end of the current video segment.
- Updated the C++ Hello World component to support streaming jobs.

<h3>C++ Streaming Component Executor</h3>

- Developed the C++ Streaming Component Executor to load a streaming component logic library, read frames from a video
  stream, and exercise the component logic through the C++ Streaming Component API.
- When the C++ Streaming Component Executor cannot read a frame from the stream, it will sleep for at least 1
  millisecond, doubling the amount of sleep time per attempt until it reaches the  `stallTimeout` value specified when
  the job was created. While stalled, the job status will be `STALLED`. After the timeout is exceeded, the job will
  be `TERMINATED`.
- The C++ Streaming Component Executor supports `FRAME_INTERVAL`, as well as rotation, horizontal flipping, and
  cropping (region of interest) properties. Does not support `USE_KEY_FRAMES`.

<h3>Interoperability Package</h3>

- Added the following Java classes to the interoperability package to simplify third party integration:
    - `JsonHealthReportCollection`: Represents the JSON content of a health report callback. Contains one or
      more `JsonHealthReport` objects.
    - `JsonSegmentSummaryReport`: Represents the JSON content of a summary report callback. Content is similar to the
      JSON output object used for batch processing.

<h3>SuBSENSE Component</h3>

- The SuBSENSE component now supports both batch processing and stream processing.
- Each video segment will be processed independently of the rest. In other words, tracks will be generated on a
  segment-by-segment basis and tracks will not carry over between segments.
- Note that the last frame in the previous segment will be used to determine if there is motion in the first frame of
  the next segment.

<h3>Packaging and Deployment</h3>

- Updated `descriptor.json` fields to allow components to support batch and/or streaming jobs. Components that use the
  old `descriptor.json` file format cannot be registered through the web UI.
- Batch component logic and streaming component logic are compiled into separate libraries.
- The mySQL `streaming_job_request` table has been updated with the following fields, which are used to populate the
  JSON health reports:
    - `status_detail`: (Optional) A user-friendly description of the current job status.
    - `activity_frame_id`: The frame id associated with the last job activity. Activity is defined as the start of a new
      track for the current segment.
    - `activity_timestamp`: The timestamp associated with the last job activity.

<h3>Web User Interface</h3>

- Added column names to the table that appears when the user clicks in the Media button associated with a job on the Job
  Status page. Now descriptive comments are provided when table cells are empty.

<h3>Bug Fixes</h3>

- Upgraded Tika to 1.17 to resolve an issue with improper indentation in a Python file (rotation.py) that resulted in
  generating at least one error message per image processed. When processing a large number of images, this would
  generate may error messages, causing the Automatic Bug Reporting Tool daemon (abrtd) process to run at 100% CPU. Once
  in that state, that process would stay there, essentially wasting on CPU core. This resulted in some of the Jenkins
  virtual machines we used for testing to become unresponsive.

<h3>Known Issues</h3>

- OpenCV 3.3.0 `cv::imread()` does not properly decode some TIFF images that have EXIF orientation metadata. It can
  handle images that are flipped horizontally, but not vertically. It also has issues with rotated images. Since most
  components rely on that function to read image data, those components may silently fail to generate detections for
  those kinds of images.

- Using single quotes, apsotrophes, or double quotes in the name of an algorithm, action, task, or pipeline configured
  on an existing OpenMPF system will result in a failure to perform an OpenMPF upgrade on that system. Specifically, the
  step where pre-existing custom actions, tasks, and pipelines are carried over to the upgraded version of OpenMPF will
  fail. Please do not use those special characters while naming those elements. If this has been done already, then
  those elements should be manually renamed in the XML files prior to an upgrade attempt.

- OpenMPF uses OpenCV, which uses FFmpeg, to connect to video streams. If a proxy and/or firewall prevents the network
  connection from succeeding, then OpenCV, or the underlying FFmpeg library, will segfault. This causes the C++
  Streaming Component Executor process to fail. In turn, the job status will be set to `ERROR` with a status detail
  message of "Unexpected error. See logs for details". In this case, the logs will not contain any useful information.
  You can identify a segfault by the following line in the node-manager log:

```
2018-02-15 16:01:21,814 INFO [pool-3-thread-4] o.m.m.nms.streaming.StreamingProcess - Process: Component exited with exit code 139 
```

> To determine if FFmpeg can connect to the stream or not, run `ffmpeg -i <stream-uri>` in a terminal window. Here's an example when it's successful:

```bash
[mpf@localhost bin]$ ffmpeg -i rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov
ffmpeg version n3.3.3-1-ge51e07c Copyright (c) 2000-2017 the FFmpeg developers
  built with gcc 4.8.5 (GCC) 20150623 (Red Hat 4.8.5-4)
  configuration: --prefix=/apps/install --extra-cflags=-I/apps/install/include --extra-ldflags=-L/apps/install/lib --bindir=/apps/install/bin --enable-gpl --enable-nonfree --enable-libtheora --enable-libfreetype --enable-libmp3lame --enable-libvorbis --enable-libx264 --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-version3 --enable-shared --disable-libsoxr --enable-avresample
  libavutil      55. 58.100 / 55. 58.100
  libavcodec     57. 89.100 / 57. 89.100
  libavformat    57. 71.100 / 57. 71.100
  libavdevice    57.  6.100 / 57.  6.100
  libavfilter     6. 82.100 /  6. 82.100
  libavresample   3.  5.  0 /  3.  5.  0
  libswscale      4.  6.100 /  4.  6.100
  libswresample   2.  7.100 /  2.  7.100
  libpostproc    54.  5.100 / 54.  5.100
[rtsp @ 0x1924240] UDP timeout, retrying with TCP
Input #0, rtsp, from 'rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov':
  Metadata:
    title           : BigBuckBunny_115k.mov
  Duration: 00:09:56.48, start: 0.000000, bitrate: N/A
    Stream #0:0: Audio: aac (LC), 12000 Hz, stereo, fltp
    Stream #0:1: Video: h264 (Constrained Baseline), yuv420p(progressive), 240x160, 24 fps, 24 tbr, 90k tbn, 48 tbc
At least one output file must be specified
```

> Here's an example when it's not successful, so there may be network issues:

```bash
[mpf@localhost bin]$ ffmpeg -i rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov
ffmpeg version n3.3.3-1-ge51e07c Copyright (c) 2000-2017 the FFmpeg developers
  built with gcc 4.8.5 (GCC) 20150623 (Red Hat 4.8.5-4)
  configuration: --prefix=/apps/install --extra-cflags=-I/apps/install/include --extra-ldflags=-L/apps/install/lib --bindir=/apps/install/bin --enable-gpl --enable-nonfree --enable-libtheora --enable-libfreetype --enable-libmp3lame --enable-libvorbis --enable-libx264 --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-version3 --enable-shared --disable-libsoxr --enable-avresample
  libavutil      55. 58.100 / 55. 58.100
  libavcodec     57. 89.100 / 57. 89.100
  libavformat    57. 71.100 / 57. 71.100
  libavdevice    57.  6.100 / 57.  6.100
  libavfilter     6. 82.100 /  6. 82.100
  libavresample   3.  5.  0 /  3.  5.  0
  libswscale      4.  6.100 /  4.  6.100
  libswresample   2.  7.100 /  2.  7.100
  libpostproc    54.  5.100 / 54.  5.100
[tcp @ 0x171c300] Connection to tcp://184.72.239.149:554?timeout=0 failed: Invalid argument
rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov: Invalid argument
```

- Tika 1.17 does not come pre-packaged with support for some embedded image formats in PDF files, possibly to avoid
  patent issues. OpenMPF does not handle embedded images in PDFs, so that's not a problem. Tika will print out the
  following warnings, which can be safely ignored:

```
Jan 22, 2018 11:02:15 AM org.apache.tika.config.InitializableProblemHandler$3 handleInitializableProblem
WARNING: JBIG2ImageReader not loaded. jbig2 files will be ignored
See https://pdfbox.apache.org/2.0/dependencies.html#jai-image-io
for optional dependencies.
TIFFImageWriter not loaded. tiff files will not be processed
See https://pdfbox.apache.org/2.0/dependencies.html#jai-image-io
for optional dependencies.
J2KImageReader not loaded. JPEG2000 files will not be processed.
See https://pdfbox.apache.org/2.0/dependencies.html#jai-image-io
for optional dependencies.

```

# OpenMPF 1.0.x

<h2>1.0.0: October 2017</h2>

<h3>Documentation</h3>

- Updated the [Build Guide](Build-Environment-Setup-Guide/index.html) with instructions for installing the latest JDK,
  latest JRE, FFmpeg 3.3.3, new codecs, and OpenCV 3.3.
- Added an [Acknowledgements](Acknowledgements/index.html) section that provides information on third party dependencies
  leveraged by the OpenMPF.
- Added a [Feed Forward Guide](Feed-Forward-Guide/index.html) that explains feed forward processing and how to use it.
- Added missing requirements checklist content to
  the [Install Guide](Install-Guide/index.html#pre-installation-checklist).
- Updated the README at the top level of each of the primary repositories to help with user navigation and provide
  general information.

<h3>Upgrade to FFmpeg 3.3.3 and OpenCV 3.3</h3>

- Updated core framework from FFmpeg 2.6.3 to FFmpeg 3.3.3.
- Added the following FFmpeg codecs: x256, VP9, AAC, Opus, Speex.
- Updated core framework and components from OpenCV 3.2 to OpenCV 3.3. No longer building with opencv_contrib.

<h3>Feed Forward Behavior</h3>

- Updated the workflow manager (WFM) and all video components to optionally perform feed forward processing for batch
  jobs. This allows tracks to be passed forward from one pipeline stage to the next. Components in the next stage will
  only process the frames associated with the detections in those tracks. This differs from the default segmenting
  behavior, which does not preserve detection regions or track information between stages.
- To enable this behavior, the optional `FEED_FORWARD_TYPE` property must be set to `FRAME`, `SUPERSET_REGION`,
  or `REGION`. If set to `FRAME` then the components in the next stage will process the whole frame region associated
  with each detection in the track passed forward. If set to `SUPERSET_REGION` then the components in the next stage
  will determine the bounding box that encapsulates all of the detection regions in the track, and only process the
  pixel data within that superset region. If set to `REGION` then the components in the next stage will process the
  region associated with each detection in the track passed forward, which may vary in size and position from frame to
  frame.
- The optional `FEED_FORWARD_TOP_CONFIDENCE_COUNT` property can be set to a number to limit the number of detections
  passed forward in a track. For example, if set to "5", then only the top 5 detections in the track will be passed
  forward and processed by the next stage. The top detections are defined as those with the highest confidence values,
  or if the confidence values are the same, those with the lowest frame index.
- Note that setting the feed forward properties has no effect on the first pipeline stage because there is no prior
  stage that can pass tracks to it.

<h3>Caffe Component</h3>

- Updated the Caffe component to process images in the BGR color space instead of the RGB color space. This addresses a
  bug found in OpenCV. Refer to the Bug Fixes section below.
- Added support for processing videos.
- Added support for an optional `ACTIVATION_LAYER_LIST` property. For each network layer specified in the list,
  the `detectionProperties` map in the JSON output object will contain one entry. The value is an encoded string of the
  JSON representation of an OpenCV matrix of the activation values for that layer. The activation values are obtained
  after the Caffe network has processed the frame data.
- Added support for an optional `SPECTRAL_HASH_FILE_LIST` property. For each JSON file specified in the list,
  the `detectionProperties` map in the JSON output object will contain one entry. The value is a string of 0's and 1's
  representing the spectral hash calculated using the information in the spectral hash JSON file. The spectral hash is
  calculated using activation values after the Caffe network has processed the frame data.
- Added a pipeline to showcase the above two features for the GoogLeNet Caffe model.
- Removed the `TRANSPOSE` property from the Caffe component since it was not necessary.
- Added red, green, and blue mean subtraction values to the GoogLeNet pipeline.

<h3>Use Key Frames</h3>

- Added support for an optional `USE_KEY_FRAMES` property to each video component. When true the component will only
  look at key frames (I-frames) from the input video. Can be used in conjunction with `FRAME_INTERVAL`. For example,
  when `USE_KEY_FRAMES` is true, and `FRAME_INTERVAL` is set to "2", then every other key frame will be processed.

<h3>MPFVideoCapture and MPFImageReader Tools</h3>

- Updated the MPFVideoCapture and MPFImageReader tools to handle feed forward properties.
- Updated the MPFVideoCapture tool to handle `FRAME_INTERVAL` and `USE_KEY_FRAMES` properties.
- Updated all existing components to leverage these tools as much as possible.
- We encourage component developers to use these tools to automatically take care of common frame grabbing and frame
  manipulation behaviors, and not to reinvent the wheel.

<h3>Dead Letter Queue</h3>

- If for some reason a sub-job request that should have gone to a component ends up on the ActiveMQ Dead Letter Queue (
  DLQ), then the WFM will now process that failed request so that the job can complete. The ActiveMQ management page
  will now show that `ActiveMQ.DLQ` has 1 consumer. It will also show unconsumed messages
  in `MPF.PROCESSED_DLQ_MESSAGES`. Those are left for auditing purposes. The "Message Detail" for these shows the string
  representation of the original job request protobuf message.

<h3>Upgrade Path</h3>

- Removed the Release 0.8 to Release 0.9 upgrade path in the deployment scripts.
- Added support for a Release 0.9 to Release 1.0.0 upgrade path, and a Release 0.10.0 to Release 1.0.0 upgrade path.

<h3>Markup</h3>

- Bounding boxes are now drawn along the interpolated path between detection regions whenever there are one or more
  frames in a track which do not have detections associated with them.
- For each track, the color of the bounding box is now a randomly selected hue in the HSV color space. The colors are
  evenly distributed using the golden ratio.

<h3>Bug Fixes</h3>

- Fixed a [bug in OpenCV](https://github.com/opencv/opencv/issues/9625) where the Caffe example code was processing
  images in the RGB color space instead of the BGR color space. Updated the OpenMPF Caffe component accordingly.
- Fixed a bug in the OpenCV person detection component that caused bounding boxes to be too large for detections near
  the edge of a frame.
- Resubmitting jobs now properly carries over configured job properties.
- Fixed a bug in the build order of the OpenMPF project so that test modules that the WFM depends on are built before
  the WFM itself.
- The Markup component draws bounding boxes between detections when a `FRAME_INTERVAL` is specified. This is so that the
  bounding box in the marked-up video appears in every frame. Fixed a bug where the bounding boxes drawn on
  non-detection frames appeared to stand still rather than move along the interpolated path between detection regions.
- Fixed a bug on the OALPR license plate detection component where it was not properly handling the `SEARCH_REGION_*`
  properties.
- Support for the `MIN_GAP_BETWEEN_SEGMENTS` property was not implemented properly. When the gap between two segments is
  less than this property value then the segments should be merged; otherwise, the segments should remain separate. In
  some cases, the exact opposite was happening. This bug has been fixed.

<h3>Known Issues</h3>

- Because of the number of additional ActiveMQ messages involved, enabling feed forward for low resolution video may
  take longer than the non-feed-forward behavior.

# OpenMPF 0.x.x

<h2>0.10.0: July 2017</h2>

> **WARNING:** There is no longer a `DEFAULT CAFFE ACTION`, `DEFAULT CAFFE TASK`, or `DEFAULT CAFFE PIPELINE`. There is now a `CAFFE GOOGLENET DETECTION PIPELINE` and `CAFFE YAHOO NSFW DETECTION PIPELINE`, which each have a respective action and task.

> **NOTE:** MPFImageReader has been re-enabled in this version of OpenMPF since we upgraded to OpenCV 3.2, which addressed the known issues with `imread()`, auto-orientation, and jpeg files in OpenCV 3.1.

<h3>Documentation</h3>

- Added a [Contributor Guide](Contributor-Guide/index.html) that provides guidelines for contributing to the OpenMPF
  codebase.
- Updated the [Java Batch Component API](Java-Batch-Component-API/index.html) with links to the example Java components.
- Updated the [Build Guide](Build-Environment-Setup-Guide/index.html) with instructions for OpenCV 3.2.

<h3>Upgrade to OpenCV 3.2</h3>

- Updated core framework and components from OpenCV 3.1 to OpenCV 3.2.

<h3>Support for Animated gifs</h3>

- All gifs are now treated as videos. Each gif will be handled as an MPFVideoJob.
- Unanimated gifs are treated as 1-frame videos.
- The WFM Media Inspector now populates the `media_properties` map with a `FRAME_COUNT` entry (in addition to
  the `DURATION` and `FPS` entries).

<h3>Caffe Component</h3>

- Added support for the Yahoo Not Suitable for Work (NSFW) Caffe model for explicit material detection.
- Updated the Caffe component to support the OpenCV 3.2 Deep Neural Network (DNN) module.

<h3>Future Support for Streaming Video</h3>

> **NOTE:** At this time, OpenMPF does not support streaming video. This section details what's being / has been done so far to prepare for that feature.

- The codebase is being updated / refactored to support both the current "batch" job functionality and new "streaming"
  job functionality.
    - batch job: complete video files are written to disk before they are processed
    - streaming job: video frames are read from a streaming endpoint (such as RTSP) and processed in near real time
- The REST API is being updated with endpoints for streaming jobs:
    - `[POST] /rest/streaming/jobs`: Creates and submits a streaming job
    - `[POST] /rest/streaming/jobs/{id}/cancel`: Cancels a streaming job
    - `[GET] /rest/streaming/jobs/{id}`: Gets information about a streaming job
- The Redis and mySQL databases are being updated to support streaming video jobs.
    - A batch job will never have the same id as a streaming job. The integer ids will always be unique.

<h3>Bug Fixes</h3>

- The MOG and SuBSENSE component services could segfault and terminate if the `USE_MOTION_TRACKING` property was set to
  “1” and a detection was found close to the edge of the frame. Specifically, this would only happen if the video had a
  width and/or height dimension that was not an exact power of two.
    - The reason was because the code downsamples each frame by a power of two and rounds the value of the width and
      height up to the nearest integer. Later on when upscaling detection rectangles back to a size that’s relative to
<h3>Known Issues</h3>

- If a job is submitted through the REST API, and a user to logged into the web UI and looking at the job status page,
  the WFM may generate "Error retrieving the SingleJobInfo model for the job with id" messages.
    - This is because the job status is only added to the HTTP session object if the job is submitted through the web
      UI. When the UI queries the job status it inspects this object.
    - This message does not appear if job status is obtained using the `[GET] /rest/jobs/{id}` endpoint.
- The `[GET] /rest/jobs/stats` endpoint aggregates information about all of the jobs ever run on the system. If
  thousands of jobs have been run, this call could take minutes to complete. The code should be improved to execute a
  direct mySQL query.

<h2>0.9.0: April 2017</h2>

> **WARNING:** MPFImageReader has been disabled in this version of OpenMPF. Component developers should use MPFVideoCapture instead. This affects components developed against previous versions of OpenMPF and components developed against this version of OpenMPF. Please refer to the Known Issues section for more information.

> **WARNING:** The OALPR Text Detection Component has been renamed to OALPR **License Plate** Text Detection Component. This affects the name of the component package and the name of the actions, tasks, and pipelines. When upgrading from R0.8 to R0.9, if the old OALPR Text Detection Component is installed in R0.8 then you will be prompted to install it again at the end of the upgrade path script. We recommend declining this prompt because the old component will conflict with the new component.

> **WARNING:** Action, task, and pipeline names that started with `MOTION DETECTION PREPROCESSOR` have been renamed `MOG MOTION DETECTION PREPROCESSOR`. Similarly, `WITH MOTION PREPROCESSOR` has changed to `WITH MOG MOTION PREPROCESSOR`.

<h3>Documentation</h3>

- Updated the [REST API](REST-API/index.html) to reflect job properties, algorithm-specific properties, and
  media-specific properties.
- Streamlined the [C++ Batch Component API](CPP-Batch-Component-API/index.html) document for clarity and simplicity.
- Completed the [Java Batch Component API](Java-Batch-Component-API/index.html) document.
- Updated the [Admin Guide](Admin-Guide/index.html) and [User Guide](User-Guide/index.html) to reflect web UI changes.
- Updated the [Build Guide](Build-Environment-Setup-Guide/index.html) with instructions for GitHub repositories.

<h3>Workflow Manager</h3>

- Added support for job properties, which will override pre-defined pipeline properties.
- Added support for algorithm-specific properties, which will apply to a single stage of the pipeline and will override
  job properties and pre-defined pipeline properties.
- Added support for media-specific properties, which will apply to a single piece and media and will override job
  properties, algorithm-specific properties, and pre-defined pipeline properties.
- Components can now be automatically registered and installed when the web application starts in Tomcat.

<h3>Web User Interface</h3>

- The "Close All" button on pop-up notifications now dismisses all notifications from the queue, not just the visible
  ones.
- Job completion notifications now only appear for jobs created during the current login session instead of all jobs.
- The `ROTATION`, `HORIZONTAL_FLIP`, and `SEARCH_REGION_*` properties can be set using the web interface when creating a
  job. Once files are selected for a job, these properties can be set individually or by groups of files.
- The Node and Process Status page has been merged into the Node Configuration page for simplicity and ease of use.
- The Media Markup results page has been merged into the Job Status page for simplicity and ease of use.
- The File Manager UI has been improved to handle large numbers of files and symbolic links.
- The side navigation menu is now replaced by a top navigation bar.

<h3>REST API</h3>

- Added an optional jobProperties object to the `/rest/jobs/` request which contains String key-value pairs which
  override the pipeline's pre-configured job properties.
- Added an optional algorithmProperties object to the `/rest/jobs/` request which can be used to configure properties
  for specific algorithms in the pipeline. These properties override the pipeline's pre-configured job properties. They
  also override the values in the jobProperties object.
- Updated the `/rest/jobs/` request to add more detail to media, replacing a list of mediaUri Strings with a list of
  media objects, each of which contains a mediaUri and an optional mediaProperties map. The mediaProperties map can be
  used to configure properties for the specific piece of media. These properties override the pipeline's pre-configured
  job properties, values in the jobProperties object, and values in the algorithmProperties object.
- Streamlined the actions, tasks, and pipelines endpoints that are used by the web UI.

<h3>Flipping, Rotation, and Region of Interest</h3>

- The `ROTATION`, `HORIZONTAL_FLIP`, and `SEARCH_REGION_*` properties will no longer appear in the detectionProperties
  map in the JSON detection output object. When applied to an algorithm these properties now appear in the
  pipeline.stages.actions.properties element. When applied to a piece of media these properties will now appear in the
  the media.mediaProperties element.
- The OpenMPF now supports multiple regions of interest in a single media file. Each region will produce tracks
  separately, and the tracks for each region will be listed in the JSON output as if from a separate media file.

<h3>Component API</h3>

- Java Batch Component API is functionally complete for third-party development, with the exception of Component Adapter
  and frame transformation utilities classes.
- Re-architected the Java Batch Component API to use a more traditional Java method structure of returning track lists
  and throwing exceptions (rather than modifying input track lists and returning statuses), and encapsulating job
  properties into MPFJob objects:
    - `List<MPFVideoTrack> getDetections(MPFVideoJob job) throws MPFComponentDetectionError`
    - `List<MPFAudioTrack> getDetections(MPFAudioJob job) throws MPFComponentDetectionError`
    - `List<MPFImageLocation> getDetections(MPFImageJob job) throws MPFComponentDetectionError`
- Created examples for the Java Batch Component API.
- Reorganized the Java and C++ component source code to enable component development without the OpenMPF core, which
  will simplify component development and streamline the code base.

<h3>JSON Output Objects</h3>

- The JSON output object for the job now contains a jobProperties map which contains all properties defined for the job
  in the job request. For example, if the job request specifies a `CONFIDENCE_THRESHOLD` of then the jobProperties map
  in the output will also list a `CONFIDENCE_THRESHOLD` of 5.
- The JSON output object for the job now contains a algorithmProperties element which contains all algorithm-specific
  properties defined for the job in the job request. For example, if the job request specifies a `FRAME_INTERVAL` of 2
  for FACECV then the algorithmProperties element in the output will contain an entry for "FACECV" and that entry will
  list a `FRAME_INTERVAL` of 2.
- Each JSON media output object now contains a mediaProperties map which contains all media-specific properties defined
  by the job request. For example, if the job request specifies a `ROTATION` of 90 degrees for a single piece of media
  then the mediaProperties map for that piece of piece will list a `ROTATION` of 90.
- The content of JSON output objects are now organized by detection type (e.g. MOTION, FACE, PERSON, TEXT, etc.) rather
  than action type.

<h3>Caffe Component</h3>

- Added support for flip, rotation, and cropping to regions of interest.
- Added support for returning multiple classifications per detection based on user-defined settings. The classification
  list is in order of decreasing confidence value.

<h3>New Pipelines</h3>

- New SuBSENSE motion preprocessor pipelines have been added to components that perform detection on video.

<h3>Packaging and Deployment</h3>

- `Actions.xml`, `Algorithms.xml`, `nodeManagerConfig.xml`, `nodeServicesPalette.json`, `Pipelines.xml`, and `Tasks.xml`
  are no longer stored within the Workflow Manager WAR file. They are now stored under `$MPF_HOME/data`. This makes it
  easier to upgrade the Workflow Manager and makes it easier for users to access these files.
- Each component can now be optionally installed and registered during deployment. Components not registered are set to
  the `UPLOADED` state. They can then be removed or registered through the Component Registration page.
- Java components are now packaged as tar.gz files instead of RPMs, bringing them into alignment with C++ components.
- OpenMPF R0.9 can be installed over OpenMPF R0.8. The deployment scripts will determine that an upgrade should take
  place.
    - After the upgrade, user-defined actions, tasks, and pipelines will have "CUSTOM" prepended to their name.
    - The job_request table in the mySQL database will have a new "output_object_version" column. This column will
      have "1.0" for jobs created using OpenMPF R0.8 and "2.0" for jobs created using OpenMPF R0.9. The JSON output
      object schema has changed between these versions.
- Reorganized source code repositories so that component SDKs can be downloaded separately from the OpenMPF core and so
  that components are grouped by license and maturity. Build scripts have been created to streamline and simplify the
  build process across the various repositories.

<h3>Upgrade to OpenCV 3.1</h3>

- The OpenMPF software has been ported to use OpenCV 3.1, including all of the C++ detection components and the markup
  component. For the OpenALPR license plate detection component, the versions of the openalpr, tesseract, and leptonica
  libraries were also upgraded to openalpr-2.3.0, tesseract-3.0.4, and leptonica-1.7.2. For the SuBSENSE motion
  component, the version of the SuBSENSE library was upgraded to use the code found at this
  location: <https://bitbucket.org/pierre_luc_st_charles/subsense/src>.

<h3>Bug Fixes</h3>

- MOG motion detection always detected motion in frame 0 of a video. Because motion can only be detected between two
  adjacent frames, frame 1 is now the first frame in which motion can be detected.
- MOG motion detection never detected motion in the first frame of a video segment (other than the first video segment
  because of the frame 0 bug described above). Now, motion is detected using the first frame before the start of a
  segment, rather than the first frame of the segment.
- The above bugs were also present in SuBSENSE motion detection and have been fixed.
- SuBSENSE motion detection generated tracks where the frame numbers were off by one. Corrected the frame index logic.
- Very large video files caused an out of memory error in the system during Workflow Manager media inspection.
- A job would fail when processing images with an invalid metadata tag for the camera flash setting.
- Users were permitted to select invalid file types using the File Manager UI.

<h3>Known Issues</h3>

- **MPFImageReader does not work reliably with the current release version of OpenCV 3.1**: In OpenCV 3.1, new
  functionality was introduced to interpret EXIF information when reading jpeg files.
- There are two issues with this new functionality that impact our ability to use the OpenCV `imread()` function with
  MPFImageReader:
    - First, because of a bug in the OpenCV code, reading a jpeg file that contains exif information could cause it to
      hang. (See <https://github.com/opencv/opencv/issues/6665>.)
    - Second, it is not possible to tell the `imread()`function to ignore the EXIF data, so the image it returns is
      automatically rotated. (See <https://github.com/opencv/opencv/issues/6348>.) This results in the MPFImageReader
      applying a second rotation to the image due to the EXIF information.
- To address these issues, we developed the following workarounds:
    - Created a version of the MPFVideoCapture that works with an MPFImageJob. The new MPFVideoCapture can pull frames
      from both video files and images. MPFVideoCapture leverages cv::VideoCapture, which does not have the two issues
      described above.
    - Disabled the use of MPFImageReader to prevent new users from trying to develop code leveraging this previous
      functionality.

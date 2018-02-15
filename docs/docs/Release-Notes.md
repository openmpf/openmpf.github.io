> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2018 The MITRE Corporation. All Rights Reserved.


# OpenMPF 2.0.0: February 2018

> **NOTE:** This release contains basic support for processing video streams. Currently, the only way to make use of that functionality is through the REST API. Streaming jobs and services cannot be created or monitored through the web UI. Only the SuBSENSE component has been updated to support streaming. Only single-stage pipelines are supported at this time. 

<h2>Documentation</h2>

- Added the [C++ Streaming Component API](CPP-Streaming-Component-API/index.html). 
- Updated documents to distinguish between the batch component APIs and streaming component API.
- Updated the [REST API](REST-API/index.html) with endpoints for streaming jobs.

<h2>Streaming REST API</h2>

- Added the following REST endpoints for streaming jobs:
    - `[GET] /rest/streaming/jobs`: Returns a list of streaming job ids.
    - `[POST] /rest/streaming/jobs`: Creates and submits a streaming job. Users can register for health report and summary report callbacks.
    - `[GET] /rest/streaming/jobs/{id}`: Gets information about a streaming job.
    - `[POST] /rest/streaming/jobs/{id}/cancel`: Cancels a streaming job.

<h2>Workflow Manager</h2>

- Updated Redis to store information about streaming jobs.
- Added controllers for streaming job REST endpoints.
- Added ability to generate health reports and segment summary reports for streaming jobs.
- Improved code flow between the Workflow Manager and master Node Manager to support streaming jobs.
- Added ActiveMQ queues to enable the C++ Streaming Component Executor to send reports and job status to the Workflow Manager.

<h2>Node Manager</h2>

- Updated the master Node Manager and child Node Managers to spawn component services on demand to handle streaming jobs, cancel those jobs, and to monitor the status of those processes.
- Using .ini files to represent streaming job properties and enable better communication between a child Node Manager and C++ Streaming Component Executor. 

<h2>C++ Streaming Component API</h2>

- Developed the C++ Streaming Component API with the following functions:
    - `MPFStreamingDetectionComponent(const MPFStreamingVideoJob &job)`: Constructor that takes a streaming video job.
    - `string GetDetectionType()`: Returns the type of detection (i.e. "FACE").
    - `void BeginSegment(const VideoSegmentInfo &segment_info)`: Indicates the beginning of a new video segment.
    - `bool ProcessFrame(const cv::Mat &frame, int frame_number)`: Processes a single frame for the current video segment.
    - `vector<MPFVideoTrack> EndSegment()`: Indicates the end of the current video segment.
- Updated the C++ Hello World component to support streaming jobs.

<h2>C++ Streaming Component Executor</h2>

- Developed the C++ Streaming Component Executor to load a streaming component logic library, read frames from a video stream, and exercise the component logic through the C++ Streaming Component API.
- When the C++ Streaming Component Executor cannot read a frame from the stream, it will sleep for at least 1 millisecond, doubling the amount of sleep time per attempt until it reaches the  `stallTimeout` value specified when the job was created. While stalled, the job status will be STALLED. After the timeout is exceeded, the job will be TERMINATED.
- The C++ Streaming Component Executor supports FRAME_INTERVAL, as well as rotation, horizontal flipping, and cropping (region of interest) properties. Does not support USE_KEY_FRAMES.

<h2>Interoperability Package</h2>

- Added the following Java classes to the interoperability package to simplify third party integration:
    - `JsonHealthReportCollection`: Represents the JSON content of a health report callback. Contains one or more `JsonHealthReport` objects.
    - `JsonSegmentSummaryReport`: Represents the JSON content of a summary report callback. Content is similar to the JSON output object used for batch processing.

<h2>SuBSENSE Component</h2>

- The SuBSENSE component now supports both batch processing and stream processing.
- Each video segment will be processed independently of the rest. In other words, tracks will be generated on a segment-by-segment basis and tracks will not carry over between segments.
- Note that the last frame in the previous segment will be used to determine if there is motion in the first frame of the next segment.

<h2>Packaging and Deployment</h2>

- Updated descriptor.json fields to allow components to support batch and/or streaming jobs.
- Batch component logic and streaming component logic are compiled into separate libraries.
- The mySQL `streaming_job_request` table has been updated with the following fields, which are used to populate the JSON health reports:
    - `status_detail`: (Optional) A user-friendly description of the current job status.
    - `activity_frame_id`: The frame id associated with the last job activity. Activity is defined as the start of a new track for the current segment.
    - `activity_timestamp`: The timestamp associated with the last job activity.

<h2>Web User Interface</h2>

- Added column names to the table that appears when the user clicks in the Media button associated with a job on the Job Status page. Now descriptive comments are provided when table cells are empty.

<h2>Bug Fixes</h2>

- Upgraded Tika to 1.17 to resolve an issue with improper indentation in a Python file (rotation.py) that resulted in generating at least one error message per image processed. When processing a large number of images, this would generate may error messages, causing the Automatic Bug Reporting Tool daemon (abrtd) process to run at 100% CPU. Once in that state, that process would stay there, essentially wasting on CPU core. This resulted in some of the Jenkins virtual machines we used for testing to become unresponsive.

<h2>Known Issues</h2>

- Tika 1.17 does not come pre-packaged with support for some embedded image formats in PDF files, possibly to avoid patent issues. OpenMPF does not handle embedded images in PDFs, so that's not a problem. Tika will print out the following warnings, which can be safely ignored:

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

- OpenCV 3.3.0 `cv::imread()` does not properly decode some TIFF images that have EXIF orientation metadata. It can handle images that are flipped horizontally, but not vertically. It also has issues with rotated images. Since most components rely on that function to read image data, those components may silently fail to generate detections for those kinds of images.


# OpenMPF 1.0.0: October 2017

<h2>Documentation</h2>

- Updated the [Build Guide](Build-Environment-Setup-Guide/index.html) with instructions for installing the latest JDK, latest JRE, FFmpeg 3.3.3, new codecs, and OpenCV 3.3.
- Added an [Acknowledgements](Acknowledgements/index.html) section that provides information on third party dependencies leveraged by the OpenMPF.
- Added a [Feed Forward Guide](Feed-Forward-Guide/index.html) that explains feed forward processing and how to use it.
- Added missing requirements checklist content to the [Install Guide](Installation-Guide/index.html#pre-installation-checklist).
- Updated the README at the top level of each of the primary repositories to help with user navigation and provide general information.

<h2>Upgrade to FFmpeg 3.3.3 and OpenCV 3.3</h2>

- Updated core framework from FFmpeg 2.6.3 to FFmpeg 3.3.3.
- Added the following FFmpeg codecs: x256, VP9, AAC, Opus, Speex.
- Updated core framework and components from OpenCV 3.2 to OpenCV 3.3. No longer building with opencv_contrib.

<h2>Feed Forward Behavior</h2>

- Updated the workflow manager (WFM) and all video components to optionally perform feed forward processing for batch jobs. This allows tracks to be passed forward from one pipeline stage to the next. Components in the next stage will only process the frames associated with the detections in those tracks. This differs from the default segmenting behavior, which does not preserve detection regions or track information between stages.
- To enable this behavior, the optional FEED_FORWARD_TYPE property must be set to "FRAME", "SUPERSET_REGION", or "REGION". If set to "FRAME" then the components in the next stage will process the whole frame region associated with each detection in the track passed forward. If set to "SUPERSET_REGION" then the components in the next stage will determine the bounding box that encapsulates all of the detection regions in the track, and only process the pixel data within that superset region. If set to "REGION" then the components in the next stage will process the region associated with each detection in the track passed forward, which may vary in size and position from frame to frame.
- The optional FEED_FORWARD_TOP_CONFIDENCE_COUNT property can be set to a number to limit the number of detections passed forward in a track. For example, if set to "5", then only the top 5 detections in the track will be passed forward and processed by the next stage. The top detections are defined as those with the highest confidence values, or if the confidence values are the same, those with the lowest frame index.
- Note that setting the feed forward properties has no effect on the first pipeline stage because there is no prior stage that can pass tracks to it.

<h2>Caffe Component</h2>

- Updated the Caffe component to process images in the BGR color space instead of the RGB color space. This addresses a bug found in OpenCV. Refer to the Bug Fixes section below.
- Added support for processing videos.
- Added support for an optional ACTIVATION_LAYER_LIST property. For each network layer specified in the list, the `detectionProperties` map in the JSON output object will contain one entry. The value is an encoded string of the JSON representation of an OpenCV matrix of the activation values for that layer. The activation values are obtained after the Caffe network has processed the frame data.
- Added support for an optional SPECTRAL_HASH_FILE_LIST property. For each JSON file specified in the list, the `detectionProperties` map in the JSON output object will contain one entry. The value is a string of 0's and 1's representing the spectral hash calculated using the information in the spectral hash JSON file. The spectral hash is calculated using activation values after the Caffe network has processed the frame data.
- Added a pipeline to showcase the above two features for the GoogLeNet Caffe model.
- Removed the TRANSPOSE property from the Caffe component since it was not necessary.
- Added red, green, and blue mean subtraction values to the GoogLeNet pipeline.

<h2>Use Key Frames</h2>

- Added support for an optional USE_KEY_FRAMES property to each video component. When true the component will only look at key frames (I-frames) from the input video. Can be used in conjunction with FRAME_INTERVAL. For example, when USE_KEY_FRAMES is true, and FRAME_INTERVAL is set to "2", then every other key frame will be processed.

<h2>MPFVideoCapture and MPFImageReader Tools</h2>

- Updated the MPFVideoCapture and MPFImageReader tools to handle feed forward properties.
- Updated the MPFVideoCapture tool to handle FRAME_INTERVAL and USE_KEY_FRAMES properties.
- Updated all existing components to leverage these tools as much as possible.
- We encourage component developers to use these tools to automatically take care of common frame grabbing and frame manipulation behaviors, and not to reinvent the wheel.

<h2>Dead Letter Queue</h2>

- If for some reason a sub-job request that should have gone to a component ends up on the ActiveMQ Dead Letter Queue (DLQ), then the WFM will now process that failed request so that the job can complete. The ActiveMQ management page will now show that ActiveMQ.DLQ has 1 consumer. It will also show unconsumed messages in MPF.PROCESSED_DLQ_MESSAGES. Those are left for auditing purposes. The "Message Detail" for these shows the string representation of the original job request protobuf message.

<h2>Upgrade Path</h2>

- Removed the Release 0.8 to Release 0.9 upgrade path in the deployment scripts.
- Added support for a Release 0.9 to Release 1.0.0 upgrade path, and a Release 0.10.0 to Release 1.0.0 upgrade path.

<h2>Markup</h2>

- Bounding boxes are now drawn along the interpolated path between detection regions whenever there are one or more frames in a track which do not have detections associated with them.
- For each track, the color of the bounding box is now a randomly selected hue in the HSV color space. The colors are evenly distributed using the golden ratio.

<h2>Bug Fixes</h2>

- Fixed a [bug in OpenCV](https://github.com/opencv/opencv/issues/9625) where the Caffe example code was processing images in the RGB color space instead of the BGR color space. Updated the OpenMPF Caffe component accordingly.
- Fixed a bug in the OpenCV person detection component that caused bounding boxes to be too large for detections near the edge of a frame.
- Resubmitting jobs now properly carries over configured job properties.
- Fixed a bug in the build order of the OpenMPF project so that test modules that the WFM depends on are built before the WFM itself.
- The Markup component draws bounding boxes between detections when a FRAME_INTERVAL is specified. This is so that the bounding box in the marked-up video appears in every frame. Fixed a bug where the bounding boxes drawn on non-detection frames appeared to stand still rather than move along the interpolated path between detection regions.
- Fixed a bug on the OALPR license plate detection component where it was not properly handling the SEARCH_REGION* properties.
- Support for the MIN_GAP_BETWEEN_SEGMENTS property was not implemented properly. When the gap between two segments is less than this property value then the segments should be merged; otherwise, the segments should remain separate. In some cases, the exact opposite was happening. This bug has been fixed.

<h2>Known Issues</h2>

- Because of the number of additional ActiveMQ messages involved, enabling feed forward for low resolution video may take longer than the non-feed-forward behavior.


# OpenMPF 0.10.0: July 2017

> **WARNING:** There is no longer a “DEFAULT CAFFE ACTION”, “DEFAULT CAFFE TASK”, or “DEFAULT CAFFE PIPELINE”. There is now a “CAFFE GOOGLENET DETECTION PIPELINE” and “CAFFE YAHOO NSFW DETECTION PIPELINE”, which each have a respective action and task.

> **NOTE:** MPFImageReader has been re-enabled in this version of OpenMPF since we upgraded to OpenCV 3.2, which addressed the known issues with imread(), auto-orientation, and jpeg files in OpenCV 3.1.

<h2>Documentation</h2>

- Added a [Contributor Guide](Contributor-Guide/index.html) that provides guidelines for contributing to the OpenMPF codebase.
- Updated the [Java Batch Component API](Java-Batch-Component-API/index.html) with links to the example Java components.
- Updated the [Build Guide](Build-Environment-Setup-Guide/index.html) with instructions for OpenCV 3.2.

<h2>Upgrade to OpenCV 3.2</h2>

- Updated core framework and components from OpenCV 3.1 to OpenCV 3.2.

<h2>Support for Animated gifs</h2>

- All gifs are now treated as videos. Each gif will be handled as an MPFVideoJob.
- Unanimated gifs are treated as 1-frame videos.
- The WFM Media Inspector now populates the `media_properties` map with a "FRAME_COUNT" entry (in addition to the "DURATION, and "FPS" entries).

<h2>Caffe Component</h2>

- Added support for the Yahoo Not Suitable for Work (NSFW) Caffe model for explicit material detection.
- Updated the Caffe component to support the OpenCV 3.2 Deep Neural Network (DNN) module.

<h2>Future Support for Streaming Video</h2>

> **NOTE:** At this time, OpenMPF does not support streaming video. This section details what's being / has been done so far to prepare for that feature.

- The codebase is being updated / refactored to support both the current "batch" job functionality and new "streaming" job functionality.
    - batch job: complete video files are written to disk before they are processed
    - streaming job: video frames are read from a streaming endpoint (such as RTSP) and processed in near real time
- The REST API is being updated with endpoints for streaming jobs:
    - `[POST] /rest/streaming/jobs`: Creates and submits a streaming job
    - `[POST] /rest/streaming/jobs/{id}/cancel`: Cancels a streaming job
    - `[GET] /rest/streaming/jobs/{id}`: Gets information about a streaming job
- The Redis and mySQL databases are being updated to support streaming video jobs.
    - A batch job will never have the same id as a streaming job. The integer ids will always be unique.

<h2>Bug Fixes</h2>

- The MOG and SuBSENSE component services could segfault and terminate if the “USE_MOTION_TRACKING” property was set to “1” and a detection was found close to the edge of the frame. Specifically, this would only happen if the video had a width and/or height dimension that was not an exact power of two.
    - The reason was because the code downsamples each frame by a power of two and rounds the value of the width and height up to the nearest integer. Later on when upscaling detection rectangles back to a size that’s relative to the original image, the resized rectangle sometimes extended beyond the bounds of the original frame.

<h2>Known Issues</h2>

- If a job is submitted through the REST API, and a user to logged into the web UI and looking at the job status page, the WFM may generate "Error retrieving the SingleJobInfo model for the job with id" messages.
    - This is because the job status is only added to the HTTP session object if the job is submitted through the web UI. When the UI queries the job status it inspects this object.
    - This message does not appear if job status is obtained using the `[GET] /rest/jobs/{id}` endpoint.
- The `[GET] /rest/jobs/stats` endpoint aggregates information about all of the jobs ever run on the system. If thousands of jobs have been run, this call could take minutes to complete. The code should be improved to execute a direct mySQL query.


# OpenMPF 0.9.0: April 2017

> **WARNING:** MPFImageReader has been disabled in this version of OpenMPF. Component developers should use MPFVideoCapture instead. This affects components developed against previous versions of OpenMPF and components developed against this version of OpenMPF. Please refer to the Known Issues section for more information.

> **WARNING:** The OALPR Text Detection Component has been renamed to OALPR **License Plate** Text Detection Component. This affects the name of the component package and the name of the actions, tasks, and pipelines. When upgrading from R0.8 to R0.9, if the old OALPR Text Detection Component is installed in R0.8 then you will be prompted to install it again at the end of the upgrade path script. We recommend declining this prompt because the old component will conflict with the new component.

> **WARNING:** Action, task, and pipeline names that started with "MOTION DETECTION PREPROCESSOR" have been renamed "MOG MOTION DETECTION PREPROCESSOR". Similarly, "WITH MOTION PREPROCESSOR" has changed to "WITH MOG MOTION PREPROCESSOR".

<h2>Documentation</h2>

  - Updated the [REST API](REST-API/index.html) to reflect job properties, algorithm-specific properties, and media-specific properties.
  - Streamlined the [C++ Batch Component API](CPP-Batch-Component-API/index.html) document for clarity and simplicity.
  - Completed the [Java Batch Component API](Java-Batch-Component-API/index.html) document.
  - Updated the [Admin Manual](Admin-Manual/index.html) and [User Guide](User-Guide/index.html) to reflect web UI changes.
  - Updated the [Build Guide](Build-Environment-Setup-Guide/index.html) with instructions for GitHub repositories.

<h2>Workflow Manager</h2>

  - Added support for job properties, which will override pre-defined pipeline properties.
  - Added support for algorithm-specific properties, which will apply to a single stage of the pipeline and will override job properties and pre-defined pipeline properties.
  - Added support for media-specific properties, which will apply to a single piece and media and will override job properties, algorithm-specific properties, and pre-defined pipeline properties.
  - Components can now be automatically registered and installed when the web application starts in Tomcat.

<h2>Web User Interface</h2>

  - The "Close All" button on pop-up notifications now dismisses all notifications from the queue, not just the visible ones.
  - Job completion notifications now only appear for jobs created during the current login session instead of all jobs.
  - The ROTATION, HORIZONTAL_FLIP, and SEARCH_REGION_* properties can be set using the web interface when creating a job. Once files are selected for a job, these properties can be set individually or by groups of files.
  - The Node and Process Status page has been merged into the Node Configuration page for simplicity and ease of use.
  - The Media Markup results page has been merged into the Job Status page for simplicity and ease of use.
  - The File Manager UI has been improved to handle large numbers of files and symbolic links.
  - The side navigation menu is now replaced by a top navigation bar.

<h2>REST API</h2>

  - Added an optional jobProperties object to the /rest/jobs/ request which contains String key-value pairs which override the pipeline's pre-configured job properties.
  - Added an optional algorithmProperties object to the /rest/jobs/ request which can be used to configure properties for specific algorithms in the pipeline. These properties override the pipeline's pre-configured job properties. They also override the values in the jobProperties object.
  - Updated the /rest/jobs/ request to add more detail to media, replacing a list of mediaUri Strings with a list of media objects, each of which contains a mediaUri and an optional mediaProperties map. The mediaProperties map can be used to configure properties for the specific piece of media. These properties override the pipeline's pre-configured job properties, values in the jobProperties object, and values in the algorithmProperties object.
  - Streamlined the actions, tasks, and pipelines endpoints that are used by the web UI.

<h2>Flipping, Rotation, and Region of Interest</h2>

  - The ROTATION, HORIZONTAL_FLIP, and SEARCH_REGION_* properties will no longer appear in the detectionProperties map in the JSON detection output object. When applied to an algorithm these properties now appear in the pipeline.stages.actions.properties element. When applied to a piece of media these properties will now appear in the the media.mediaProperties element.
  - The OpenMPF now supports multiple regions of interest in a single media file.  Each region will produce tracks separately, and the tracks for each region will be listed in the JSON output as if from a separate media file.

<h2>Component API</h2>

  - Java Batch Component API is functionally complete for third-party development, with the exception of Component Adapter and frame transformation utilities classes.
  - Re-architected the Java Batch Component API to use a more traditional Java method structure of returning track lists and throwing exceptions (rather than modifying input track lists and returning statuses), and encapsulating job properties into MPFJob objects:
    - `List<MPFVideoTrack> getDetections(MPFVideoJob job) throws MPFComponentDetectionError`
    - `List<MPFAudioTrack> getDetections(MPFAudioJob job) throws MPFComponentDetectionError`
    - `List<MPFImageLocation> getDetections(MPFImageJob job) throws MPFComponentDetectionError`
  - Created examples for the Java Batch Component API.
  - Reorganized the Java and C++ component source code to enable component development without the OpenMPF core, which will simplify component development and streamline the code base.

<h2>JSON Output Objects</h2>

  - The JSON output object for the job now contains a jobProperties map which contains all properties defined for the job in the job request.  For example, if the job request specifies a CONFIDENCE_THRESHOLD of then the jobProperties map in the output will also list a CONFIDENCE_THRESHOLD of 5.
  - The JSON output object for the job now contains a algorithmProperties element which contains all algorithm-specific properties defined for the job in the job request.  For example, if the job request specifies a FRAME_INTERVAL of 2 for FACECV then the algorithmProperties element in the output will contain an entry for "FACECV" and that entry will list a FRAME_INTERVAL of 2.
  - Each JSON media output object now contains a mediaProperties map which contains all media-specific properties defined by the job request.  For example, if the job request specifies a ROTATION of 90 degrees for a single piece of media then the mediaProperties map for that piece of piece will list a ROTATION of 90.
  - The content of JSON output objects are now organized by detection type (e.g. MOTION, FACE, PERSON, TEXT, etc.) rather than action type.

<h2>Caffe Component</h2>

  - Added support for flip, rotation, and cropping to regions of interest.
  - Added support for returning multiple classifications per detection based on user-defined settings. The classification list is in order of decreasing confidence value.

<h2>New Pipelines</h2>

  - New SuBSENSE motion preprocessor pipelines have been added to components that perform detection on video.

<h2>Packaging and Deployment</h2>

  - Actions.xml, Algorithms.xml, nodeManagerConfig.xml, nodeServicesPalette.json, Pipelines.xml, and Tasks.xml are no longer stored within the Workflow Manager WAR file. They are now stored under `$MPF_HOME/data`. This makes it easier to upgrade the Workflow Manager and makes it easier for users to access these files.
  - Each component can now be optionally installed and registered during deployment. Components not registered are set to the UPLOADED state. They can then be removed or registered through the Component Registration page.
  - Java components are now packaged as tar.gz files instead of RPMs, bringing them into alignment with C++ components.
  - OpenMPF R0.9 can be installed over OpenMPF R0.8. The deployment scripts will determine that an upgrade should take place.
    - After the upgrade, user-defined actions, tasks, and pipelines will have "CUSTOM" prepended to their name.
    - The job_request table in the mySQL database will have a new "output_object_version" column. This column will have "1.0" for jobs created using OpenMPF R0.8 and "2.0" for jobs created using OpenMPF R0.9. The JSON output object schema has changed between these versions.
  - Reorganized source code repositories so that component SDKs can be downloaded separately from the OpenMPF core and so that components are grouped by license and maturity. Build scripts have been created to streamline and simplify the build process across the various repositories.

<h2>Upgrade to OpenCV 3.1</h2>

  - The OpenMPF software has been ported to use OpenCV 3.1, including all of the C++ detection components and the markup component. For the OpenALPR license plate detection component, the versions of the openalpr, tesseract, and leptonica libraries were also upgraded to openalpr-2.3.0, tesseract-3.0.4, and leptonica-1.7.2.  For the SuBSENSE motion component, the version of the SuBSENSE library was upgraded to use the code found at this location: <https://bitbucket.org/pierre_luc_st_charles/subsense/src>.

<h2>Bug Fixes</h2>

  - MOG motion detection always detected motion in frame 0 of a video. Because motion can only be detected between two adjacent frames, frame 1 is now the first frame in which motion can be detected.
  - MOG motion detection never detected motion in the first frame of a video segment (other than the first video segment because of the frame 0 bug described above). Now, motion is detected using the first frame before the start of a segment, rather than the first frame of the segment.
  - The above bugs were also present in SuBSENSE motion detection and have been fixed.
  - SuBSENSE motion detection generated tracks where the frame numbers were off by one. Corrected the frame index logic.
  - Very large video files caused an out of memory error in the system during Workflow Manager media inspection.
  - A job would fail when processing images with an invalid metadata tag for the camera flash setting.
  - Users were permitted to select invalid file types using the File Manager UI.

<h2>Known Issues</h2>

  - **MPFImageReader does not work reliably with the current release version of OpenCV 3.1**: In OpenCV 3.1, new functionality was introduced to interpret EXIF information when reading jpeg files.
   - There are two issues with this new functionality that impact our ability to use the OpenCV `imread()` function with MPFImageReader:
     - First, because of a bug in the OpenCV code, reading a jpeg file that contains exif information could cause it to hang. (See <https://github.com/opencv/opencv/issues/6665>.)
     - Second, it is not possible to tell the `imread()`function to ignore the EXIF data, so the image it returns is automatically rotated. (See <https://github.com/opencv/opencv/issues/6348>.) This results in the MPFImageReader applying a second rotation to the image due to the EXIF information.
   - To address these issues, we developed the following workarounds:
      - Created a version of the MPFVideoCapture that works with an MPFImageJob. The new MPFVideoCapture can pull frames from both video files and images. MPFVideoCapture leverages cv::VideoCapture, which does not have the two issues described above.
      - Disabled the use of MPFImageReader to prevent new users from trying to develop code leveraging this previous functionality.

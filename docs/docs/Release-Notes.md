> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2017 The MITRE Corporation. All Rights Reserved.

# OpenMPF Version 0.9:  April 2017

> **WARNING:** MPFImageReader has been disabled in this version of OpenMPF. Component developers should use MPFVideoCapture instead. This affects components developed against previous versions of MPF and components developed against this version of OpenMPF. Please refer to the [Known Issues](#known-issues) section for more information.

> **WARNING:** The OALPR Text Detection Component has been renamed to OALPR **License Plate** Text Detection Component. This affects the name of the component package and the name of the actions, tasks, and pipelines. When upgrading from R0.8 to R0.9, if the old OALPR Text Detection Component is installed in R0.8 then you will be prompted to install it again at the end of the upgrade path script. We recommend declining this prompt because the old component will conflict with the new component.

> **WARNING:** Action, task, and pipeline names that started with "MOTION DETECTION PREPROCESSOR" have been renamed "MOG MOTION DETECTION PREPROCESSOR". Similarly, "WITH MOTION PREPROCESSOR" has changed to "WITH MOG MOTION PREPROCESSOR".

## Documentation

  - Updated the [REST API](REST-API/) to reflect job properties, algorithm-specific properties, and media-specific properties.
  - Streamlined the [C++ Component API](CPP-Component-API/) document for clarity and simplicity.
  - Completed the [Java Component API](Java-Component-API/) document.
  - Updated the [Admin Manual](Admin-Manual/) and [User Guide](User-Guide/) to reflect web UI changes.
  - Updated the [Build Guide](Build-Environment-Setup-Guide/) with instructions for GitHub repositories.

## Workflow Manager

  - Added support for job properties, which will override pre-defined pipeline properties.
  - Added support for algorithm-specific properties, which will apply to a single stage of the pipeline and will override job properties and pre-defined pipeline properties.
  - Added support for media-specific properties, which will apply to a single piece and media and will override job properties, algorithm-specific properties, and pre-defined pipeline properties. 
  - Components can now be automatically registered and installed when the web application starts in Tomcat.

## Web User Interface

  - The "Close All" button on pop-up notifications now dismisses all notifications from the queue, not just the visible ones.
  - Job completion notifications now only appear for jobs created during the current login session instead of all jobs.
  - The ROTATION, HORIZONTAL_FLIP, and SEARCH_REGION_* properties can be set using the web interface when creating a job. Once files are selected for a job, these properties can be set individually or by groups of files.
  - The Node and Process Status page has been merged into the Node Configuration page for simplicity and ease of use.
  - The Media Markup results page has been merged into the Job Status page for simplicity and ease of use.
  - The File Manager UI has been improved to handle large numbers of files and symbolic links.
  - The side navigation menu is now replaced by a top navigation bar.

## REST API

  - Added an optional jobProperties object to the /rest/jobs/ request which contains String key-value pairs which override the pipeline's pre-configured job properties.
  - Added an optional jobAlgorithmProperties object to the /rest/jobs/ request which can be used to configure properties for specific algorithms in the pipeline. These properties override the pipeline's pre-configured job properties. They also override the values in the jobProperties object.
  - Updated the /rest/jobs/ request to add more detail to media, replacing a list of mediaUri Strings with a list of media objects, each of which contains a mediaUri and an optional mediaProperties map. The mediaProperties map can be used to configure properties for the specific piece of media. These properties override the pipeline's pre-configured job properties, values in the jobProperties object, and values in the jobAlgorithmProperties object.
  - Streamlined the actions, tasks, and pipelines endpoints that are used by the web UI.

## Flipping, Rotation, and Region of Interest

  - The ROTATION, HORIZONTAL_FLIP, and SEARCH_REGION_* properties will no longer appear in the detectionProperties map in the JSON detection output object. When applied to an algorithm these properties now appear in the pipeline.stages.actions.properties element. When applied to a piece of media these properties will now appear in the the media.mediaProperties element.
  - The OpenMPF now supports multiple regions of interest in a single media file.  Each region will produce tracks separately, and the tracks for each region will be listed in the JSON output as if from a separate media file.

## Component API

  - Java Component API is functionally complete for third-party development, with the exception of Component Adapter and frame transformation utilities classes.
  - Re-architected the Java component API to use a more traditional Java method structure of returning track lists and throwing exceptions (rather than modifying input track lists and returning statuses), and encapsulating job properties into MPFJob objects:
    - `List<MPFVideoTrack> getDetections(MPFVideoJob job) throws MPFComponentDetectionError`
    - `List<MPFAudioTrack> getDetections(MPFAudioJob job) throws MPFComponentDetectionError`
    - `List<MPFImageLocation> getDetections(MPFImageJob job) throws MPFComponentDetectionError`
  - Created examples for the Java Component API.
  - Reorganized the Java and C++ component source code to enable component development without the MPF core, which will simplify component development and streamline the code base.

## JSON Output Objects

  - The JSON output object for the job now contains a jobProperties map which contains all properties defined for the job in the job request.  For example, if the job request specifies a CONFIDENCE_THRESHOLD of then the jobProperties map in the output will also list a CONFIDENCE_THRESHOLD of 5.
  - The JSON output object for the job now contains a jobAlgorithmProperties element which contains all algorithm-specific properties defined for the job in the job request.  For example, if the job request specifies a FRAME_INTERVAL of 2 for FACECV then the jobAlgorithmProperties element in the output will contain an entry for "FACECV" and that entry will list a FRAME_INTERVAL of 2.
  - Each JSON media output object now contains a mediaProperties map which contains all media-specific properties defined by the job request.  For example, if the job request specifies a ROTATION of 90 degrees for a single piece of media then the mediaProperties map for that piece of piece will list a ROTATION of 90.
  - The content of JSON output objects are now organized by detection type (e.g. MOTION, FACE, PERSON, TEXT, etc.) rather than action type.

## Caffe Component

  - Added support for flip, rotation, and cropping to regions of interest.
  - Added support for returning multiple classifications per detection based on user-defined settings. The classification list is in order of decreasing confidence value.

## New Pipelines

  - New SubSENSE motion preprocessor pipelines have been added to components that perform detection on video.

## Packaging and Deployment

  - Actions.xml, Algorithms.xml, nodeManagerConfig.xml, nodeServicesPalette.json, Pipelines.xml, and Tasks.xml are no longer stored within the Workflow Manager WAR file. They are now stored under `$MPF_HOME/data`. This makes it easier to upgrade the Workflow Manager and makes it easier for users to access these files.
  - Each component can now be optionally installed and registered during deployment. Components not registered are set to the UPLOADED state. They can then be removed or registered through the Component Registration page.
  - Java components are now packaged as tar.gz files instead of RPMs, bringing them into alignment with C++ components.
  - OpenMPF R0.9 can be installed over OpenMPF R0.8. The deployment scripts will determine that an upgrade should take place.
    - After the upgrade, user-defined actions, tasks, and pipelines will have "CUSTOM" prepended to their name.
    - The job_request table in the mySQL database will have a new "output_object_version" column. This column will have "1.0" for jobs created using MPF R0.8 and "2.0" for jobs created using MPF R0.9. The JSON output object schema has changed between these versions. 
  - Reorganized source code repositories so that component SDKs can be downloaded separately from the MPF core and so that components are grouped by license and maturity. Build scripts have been created to streamline and simplify the build process across the various repositories.

## Upgrade to OpenCV 3.1

  - The MPF software has been ported to use OpenCV 3.1, including all of the C++ detection components and the markup component. For the OpenALPR license plate detection component, the versions of the openalpr, tesseract, and leptonica libraries were also upgraded to openalpr-2.3.0, tesseract-3.0.4, and leptonica-1.7.2.  For the subsense motion component, the version of the SubSENSE library was upgraded to use the code found at this location: <https://bitbucket.org/pierre_luc_st_charles/subsense/src>.

## Bug Fixes

  - MOG motion detection always detected motion in frame 0 of a video. Because motion can only be detected between two adjacent frames, frame 1 is now the first frame in which motion can be detected.
  - MOG motion detection never detected motion in the first frame of a video segment (other than the first video segment because of the frame 0 bug described above). Now, motion is detected using the first frame before the start of a segment, rather than the first frame of the segment.
  - The above bugs were also present in Subsense motion detection and have been fixed.
  - Subsense motion detection generated tracks where the frame numbers were off by one. Corrected the frame index logic.
  - Very large video files caused an out of memory error in the system during Workflow Manager media inspection.
  - A job would fail when processing images with an invalid metadata tag for the camera flash setting.
  - Users were permitted to select invalid file types using the File Manager UI.

## Known Issues

  - **MPFImageReader does not work reliably with the current release version of OpenCV 3.1**: In OpenCV 3.1, new functionality was introduced to interpret EXIF information when reading jpeg files. 
   - There are two issues with this new functionality that impact our ability to use the OpenCV `imread()` function with MPFImageReader:
     - First, because of a bug in the OpenCV code, reading a jpeg file that contains exif information could cause it to hang. (See <https://github.com/opencv/opencv/issues/6665>.) 
     - Second, it is not possible to tell the `imread()`function to ignore the EXIF data, so the image it returns is automatically rotated. (See <https://github.com/opencv/opencv/issues/6348>.) This results in the MPFImageReader applying a second rotation to the image due to the EXIF information. 
   - To address these issues, we developed the following workarounds:
      - Created a version of the MPFVideoCapture that works with an MPFImageJob. The new MPFVideoCapture can pull frames from both video files and images. MPFVideoCapture leverages cv::VideoCapture, which does not have the two issues described above.
      - Disabled the use of MPFImageReader to prevent new users from trying to develop code leveraging this previous functionality.
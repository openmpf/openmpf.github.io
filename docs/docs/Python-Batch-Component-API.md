> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to 
> the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). 
> Copyright 2018 The MITRE Corporation. All Rights Reserved.

# API Overview

In OpenMPF, a **component** is a plugin that receives jobs (containing media), processes that  media, and returns results.

The OpenMPF Batch Component API currently supports the development of **detection components**, which are used detect 
objects in image, video, audio, or other (generic) files that reside on disk.

Using this API, detection components can be built to provide:

* Detection (Localizing an object)
* Tracking (Localizing an object across multiple frames)
* Classification (Detecting the type of object and optionally localizing that object)
* Transcription (Detecting speech and transcribing it into text)

## How Components Integrate into OpenMPF

Components are integrated into OpenMPF through the use of OpenMPF's **Component Executable**. 
Developers create component libraries that encapsulate the component detection logic. 
Each instance of the Component Executable loads one of these libraries and uses it to service job requests 
sent by the OpenMPF Workflow Manager (WFM).

The Component Executable:

1. Receives and parses job requests from the WFM
2. Invokes functions on the component library to obtain detection results
3. Populates and sends the respective responses to the WFM

Each instance of a Component Executable runs as a separate process.

The Component Executable receives and parses requests from the WFM, invokes functions on the Component Logic to get 
detection objects, and subsequently populates responses with the component output and sends them to the WFM.

The basic psuedocode for the Component Executable is as follows:
```python
component_cls = locate_component_class()
component = component_cls()
detection_type = component.detection_type

while True:
    job = receive_job()
    
    if is_image_job(job) and hasattr(component, 'get_detections_from_image'):
        detections = component.get_detections_from_image(job)
        send_job_response(detections)
        
    elif is_video_job(job) and hasattr(component, 'get_detections_from_video'):
        detections = component.get_detections_from_video(job)
        send_job_response(detections)
        
    elif is_audio_job(job) and hasattr(component, 'get_detections_from_audio'):
        detections = component.get_detections_from_audio(job)
        send_job_response(detections)
        
    elif is_generic_job(job) and hasattr(component, 'get_detections_from_generic'):
        detections = component.get_detections_from_generic(job)
        send_job_response(detections)
```

Each instance of a Component Executable runs as a separate process.

The Component Executable receives and parses requests from the WFM, invokes functions on the Component Logic to get 
detection objects, and subsequently populates responses with the component output and sends them to the WFM.

A component developer implements a detection component by creating a class that defines one or more of the
get_detections_from_* methods and has a detection_type field.

During a component registration a [virtualenv](http://virtualenv.pypa.io) is created for each component. 
The virtualenv has access to the built in Python libraries, but does not have access to any third party packages 
that might be installed on the system. When creating the virtualenv for a setuptools-based component the only packages 
that get installed are the component itself and any dependencies specified in the setup.py 
file (including their transitive dependencies). When creating the virtualenv for a basic Python component the only 
package that gets installed is `mpf_component_api`.


# How to Create a Python Component
There are two types of Python components that are supported, setuptools-based components and basic Python components.
Basic Python components quicker to set up, but have no form of dependency management. Setuptools-based components 
are recommended since they use setuptools and pip for dependency management.

## Get openmpf-python-component-sdk
In order to create a Python component you will need to clone the 
[openmpf-python-component-sdk repository](https://github.com/openmpf/openmpf-python-component-sdk) if you don't 
already have it. While not technically required, it is recommended to also clone the 
[openmpf-build-tools repository](https://github.com/openmpf/openmpf-build-tools).
The rest of the steps assume you cloned openmpf-python-component-sdk and put in 
`~/openmpf-projects/openmpf-python-component-sdk`. The rest of the steps also assume that if you cloned the 
openmpf-build-tools repository, you put in `~/openmpf-projects/openmpf-build-tools`


## Setup Python Component Libraries
The component packaging steps require that wheel files for mpf_component_api, mpf_component_util, and 
their dependencies are available in the `~/mpf-sdk-install/python/wheelhouse` directory.

If you have openmpf-build-tools, then you can run:
```bash
~/openmpf-projects/openmpf-build-tools/build-openmpf-components/build_components.py -psdk ~/openmpf-projects/openmpf-python-component-sdk
```
To setup the libraries manually you can run:
```bash
pip wheel -w ~/mpf-sdk-install/python/wheelhouse ~/openmpf-projects/openmpf-python-component-sdk/detection/api
pip wheel -w ~/mpf-sdk-install/python/wheelhouse ~/openmpf-projects/openmpf-python-component-sdk/detection/component_util
```


## How to Create a Setuptools-based Python Component
In this example we create a setuptools-based video component named "MyComponent". 

This is the recommended project structure:
```
ComponentName
├── setup.py
├── component_name
│   ├── __init__.py
│   └── component_name.py
└── plugin-files
    └── descriptor
        └── descriptor.json
```

**1\. Create directory structure:**
```bash
mkdir MyComponent
mkdir MyComponent/my_component
mkdir -p MyComponent/plugin-files/descriptor
touch MyComponent/setup.py
touch MyComponent/my_component/__init__.py
touch MyComponent/my_component/my_component.py
touch MyComponent/plugin-files/descriptor/descriptor.json
```

**2\. Create setup.py file in project's top level directory:**

Example of a minimal setup.py file:
```python
import setuptools

setuptools.setup(
    name='MyComponent',
    version='0.1',
    packages=setuptools.find_packages(),
    install_requires=(
        'mpf_component_api>=0.1',
        'mpf_component_util>=0.1'
    ),
    entry_points={
        'mpf.exported_component': 'component = my_component.my_component:MyComponent'
    }
    
)
```
Any dependencies that component requires should be listed in the `install_requires` field.

The component executor uses the `mpf.exported_component` `entry_points` field to specify which class is the component.
The right hand side of `component = ` should be the dotted module name, followed by a `:`, followed by the name of the
class. In the above example, `MyComponent` is the class name. The module is listed as `my_component.my_component` 
because `MyComponent` is in the `my_component.py` file and `my_component.py` is in the `mpf_component` package.


**3\. Create descriptor.json file in MyComponent/plugin-files/descriptor.**

The `batchLibrary` field should match the distribution name. The distribution name is declared using the `name` field 
in the call to `setuptools.setup` from setup.py. Typically this is the same name as the component. In this example the 
field should be: `"batchLibrary" : "MyComponent"`. 
See [Packaging and Registering a Component](Packaging-and-Registering-a-Component/index.html) for details about 
the descriptor format.
  
  
**4\. Implement your component class:**

Below is an example of the structure of simple component. You would replace the call to
`run_detection_algorithm_on_frame` with your component specific logic.
```python
import mpf_component_api as mpf
import mpf_component_util as mpf_util

logger = mpf.configure_logging('my-component.log', __name__ == '__main__')

class MyComponent(mpf_util.VideoCaptureMixin, object):
    detection_type = 'FACE'

    @staticmethod
    def get_detections_from_video_capture(video_job, video_capture):
        logger.info('[%s] Received video job: %s', video_job.job_name, video_job)
        for frame_idx, frame in enumerate(video_capture):
            for result_track in run_detection_algorithm_on_frame(frame_idx, frame):
                yield result_track
```

**5\. Create the plugin package:**

The directory structure of the .tar.gz file will be:
```
MyComponent
├── descriptor
│   └── descriptor.json
└── wheelhouse
    ├── MyComponent-0.1-py2-none-any.whl
    ├── mpf_component_api-0.1-py2-none-any.whl
    ├── mpf_component_util-0.1-py2-none-any.whl
    ├── numpy-1.14.4-cp27-cp27mu-manylinux1_x86_64.whl
    └── opencv_python-3.4.1.15-cp27-cp27mu-manylinux1_x86_64.whl
```

To create the plugin packages you can run the build scripts as follows:
```
~/openmpf-projects/openmpf-build-tools/build-openmpf-components/build_components.py -psdk ~/openmpf-projects/openmpf-python-component-sdk -c MyComponent
```

The plugin package can also be built manually using the following commands:
```bash
mkdir -p plugin-packages/MyComponent/wheelhouse
pip wheel -w plugin-packages/MyComponent/wheelhouse -f ~/mpf-sdk-install/python/wheelhouse ./MyComponent/
cp -r MyComponent/plugin-files/* plugin-packages/MyComponent/
cd plugin-packages
tar -zcf MyComponent.tar.gz MyComponent
```


## How to Create a Basic Python Component
In this example we create a basic Python component that supports video.

This is the recommended project structure:
```
ComponentName
├── component_name.py
├── dependency.py
└── descriptor
    └── descriptor.json
```

**1\. Create directory structure:**
```bash
mkdir MyComponent
mkdir MyComponent/descriptor
touch MyComponent/descriptor/descriptor.json
touch MyComponent/my_component.py
```

**2\. Create descriptor.json file in MyComponent/descriptor.**

The `batchLibrary` field should be the full path to the Python file containing your component class. 
In this example the field should be: `"batchLibrary" : "${MPF_HOME}/plugins/MyComponent/my_component.py"`.
See [Packaging and Registering a Component](Packaging-and-Registering-a-Component/index.html) for details about
the descriptor format.


**3\. Implement your component class:**

Below is an example of the structure of simple component. You would replace the call to
`run_detection_algorithm` with your component specific logic.
```python
import mpf_component_api as mpf

logger = mpf.configure_logging('my-component.log', __name__ == '__main__')

class MyComponent(object):
    detection_type = 'FACE'
    
    @staticmethod
    def get_detections_from_video(video_job):
        logger.info('[%s] Received video job: %s', video_job.job_name, video_job)
        return run_detection_algorithm(video_job)

EXPORT_MPF_COMPONENT = MyComponent
```
The component executor looks for a module level variable named `EXPORT_MPF_COMPONENT` to specify which class 
is the component.

**4\. Create the plugin package**

The directory structure of the .tar.gz file will be:
```
ComponentName
├── component_name.py
├── dependency.py
└── descriptor
    └── descriptor.json
```  
To create the plugin packages you can run the build scripts as follows:
```
~/openmpf-projects/openmpf-build-tools/build-openmpf-components/build_components.py -c MyComponent
```

The plugin package can also be built manually using the following command:
```bash
tar -zcf MyComponent.tar.gz MyComponent
```


# API Specification

An OpenMPF Python component is a class that defines one or more of the get_detections_from_\* methods and has a 
detection_type field. 

All get_detections_from_\* methods are invoked through an instance of component class and the only 
parameter passed in is an appropriate job object (e.g. `mpf_component_api.ImageJob`, `mpf_component_api.VideoJob`). 
Since the methods are invoked through an instance, instance methods and class methods end up with two arguments,
the first is either the instance or the class respectively.
All get_detections_from_\* methods can be implemented either as an instance method, a static method, or a class method.
For example: 

instance method:
```python
class MyComponent(object):
    def get_detections_from_image(self, image_job):
        return [mpf_component_api.ImageLocation(...), ...]
```

static method:
```python
class MyComponent(object):
    @staticmethod
    def get_detections_from_image(image_job):
        return [mpf_component_api.ImageLocation(...), ...]
```

class method:
```python
class MyComponent(object):
    @classmethod
    def get_detections_from_image(cls, image_job):
        return [mpf_component_api.ImageLocation(...), ...]
```

All get_detections_from_\* must return an iterable of the appropriate detection type 
(e.g. `mpf_component_api.ImageLocation`, `mpf_component_api.VideoTrack`). The return value is normally a list or generator, 
but any iterable can be used.


#### component.detection_type
* `str` field describing the type of object that is detected by the component. Should be in all CAPS. 
Examples include: `FACE`, `MOTION`, `PERSON`, `SPEECH`, `CLASS` (for object classification), or `TEXT`.
* Example:
```python
class MyComponent(object):
    detection_type = 'FACE'

```


## Image API

#### component.get_detections_from_image(image_job)

Used to detect objects in an image file.

* Function Definition:
```python
class MyComponent(object):
    def get_detections_from_image(self, image_job):
        return [mpf_component_api.ImageLocation(...), ...]
```

`get_detections_from_image`, like all get_detections_from_\* methods, can be implemented either as an instance method,
a static method, or a class method. 

* Parameters:

| Parameter | Data Type                    | Description |
|-----------|------------------------------|-------------|
| image_job | `mpf_component_api.ImageJob` | Object containing details about the work to be performed.

* Returns: An iterable of `mpf_component_api.ImageLocation`

#### mpf_component_api.ImageJob

Class containing data used for detection of objects in an image file.

* Members:

| Member                | Data Type        | Description |
|-----------------------|------------------|-------------|
| job_name              | `str`            | A specific name given to the job by the OpenMPF framework. This value may be used, for example, for logging and debugging purposes. |
| data_uri              | `str`            | The URI of the input media file to be processed. Currently, this is a file path. For example, "/opt/mpf/share/remote-media/test-file.avi". |
| job_properties        | `dict[str, str]` | Contains a dict with keys and values of type `str` which represents the property name and the property value. The key corresponds to the property name specified in the component descriptor file described in [Packaging and Registering a Component](Packaging-and-Registering-a-Component/index.html). Values are determined when creating a pipeline or when submitting a job. <br/><br/> Note: The job_properties map may not contain the full set of job properties. For properties not contained in the map, the component must use a default value. |
| media_properties      | `dict[str, str]` | Contains a dict with keys and values of type `str` of metadata about the media associated with the job.|
| feed_forward_location | `None` or `mpf_component_api.ImageLocation` | An `mpf_component_api.ImageLocation` from the previous pipeline stage. Provided when feed forward is enabled. See [Feed Forward Guide](Feed-Forward-Guide/index.html). |


#### mpf_component_api.ImageLocation
Class used to store the location of detected objects in a image file.

* Constructor:
```python
def __init__(self, x_left_upper, y_left_upper, width, height, confidence=-1.0, detection_properties=None):
    ...
```

* Members:

| Member               | Data Type | Description |
|----------------------|-----------|-------------|
| x_left_upper         | `int`     | Upper left X coordinate of the detected object. |
| y_left_upper         | `int`     | Upper left Y coordinate of the detected object. |
| width                | `int`     | The width of the detected object. |
| height               | `int`     | The height of the detected object. |
| confidence           | `float`   | Represents the "quality" of the detection. The range depends on the detection algorithm. 0.0 is lowest quality. Higher values are higher quality. Using a standard range of [0.0 - 1.0] is advised. If the component is unable to supply a confidence value, it should return -1.0. |
| detection_properties | `mpf_component_api.Properties` | Dict-like object with keys and values of type `str` containing optional additional information about the detected object. For best practice, keys should be in all CAPS. |


#### mpf_component_util.ImageReader
`mpf_component_util.ImageReader` is an utility class for accessing images. It is the image equivalent to 
`mpf_component_util.VideoCapture`. Like `mpf_component_util.VideoCapture`, it may modify the image based on 
job_properties. From the point of view of someone using `mpf_component_util.ImageReader`, these modifications are 
mostly transparent. `mpf_component_util.ImageReader` makes it look like you are reading the original image file. 

One issue with this approach is that the detection bounding boxes will be relative to the 
modified image, not the original. To make the detections relative to the original image 
the `mpf_component_util.ImageReader.reverse_transform(image_location)` function must be called on each 
`mpf_component_api.ImageLocation`. Since the use of `mpf_component_util.ImageReader` is optional, the framework
cannot just do the reverse transform for the developer. 
See the documentation for `mpf_component_util.ImageReaderMixin` for a more concise way to use 
`mpf_component_util.ImageReader`

The general pattern for using `mpf_component_util.ImageReader` is as follows:
```python
class MyComponent(object):

    @staticmethod
    def get_detections_from_image(image_job):
        image_reader = mpf_component_util.ImageReader(image_job)
        image = image_reader.get_image()
        result_image_locations = run_component_specific_algorithm(image)
        for result in result_image_locations:
            image_reader.reverse_transform(result)
            yield result
```



#### mpf_component_util.ImageReaderMixin
A mixin class that can be used to simplify the usage of `mpf_component_util.ImageReader`. 
`mpf_component_util.ImageReaderMixin` takes care of initializing a `mpf_component_util.ImageReader` and 
performing the reverse transform.

There some requirements to properly use `mpf_component_util.ImageReaderMixin`:

* The component must extend `mpf_component_util.ImageReaderMixin`
* The component must implement `get_detections_from_image_reader(image_job, image_reader)`
* The component must read the image using the `mpf_component_util.ImageReader` 
  that is passed in to `get_detections_from_image_reader(image_job, image_reader)`.
* The component must NOT implement `get_detections_from_image(image_job)`
* The component must NOT call `mpf_component_util.ImageReader.reverse_transform`

The general pattern for using `mpf_component_util.ImageReaderMixin` is as follows:
```python
class MyComponent(mpf_component_util.ImageReaderMixin): 

    @staticmethod # Can also be a regular instance method or a class method
    def get_detections_from_image_reader(image_job, image_reader):
        image = image_reader.get_image() 
        
        # run_component_specific_algorithm is a placeholder for this example. 
        # Replace run_component_specific_algorithm with your component's detection logic
        return run_component_specific_algorithm(image)
```

`mpf_component_util.ImageReaderMixin` is a mixin class so it designed in a way that does not prevent the subclass
from extending other classes. If a component supports both videos and images, and it uses 
`mpf_component_util.VideoCaptureMixin`, it should also use `mpf_component_util.ImageReaderMixin`. 
See `mpf_component_util.VideoCaptureMixin` documentation for example.



## Video API

#### component.get_detections_from_video(video_job)

Used to detect objects in a video file. Prior to being sent to the component, videos are split into logical "segments" 
of video data and each segment (containing a range of frames) is assigned to a different job. Components are not 
guaranteed to receive requests in any order. For example, the first request processed by a component might receive a 
request for frames 300-399 of a Video A, while the next request may cover frames 900-999 of a Video B.

* Function Definition:
```python
class MyComponent(object):
    def get_detections_from_video(self, video_job):
        return [mpf_component_api.VideoTrack(...), ...]
```

`get_detections_from_video`, like all get_detections_from_\* methods, can be implemented either as an instance method,
a static method, or a class method.

* Parameters:

| Parameter | Data Type                    | Description |
|-----------|------------------------------|-------------|
| video_job | `mpf_component_api.VideoJob` | Object containing details about the work to be performed.

* Returns: An iterable of `mpf_component_api.VideoTrack`


#### mpf_component_api.VideoJob
Class containing data used for detection of objects in a video file.

* Members:

| Member                | Data Type        | Description |
|-----------------------|------------------|-------------|
| job_name              | `str`            | A specific name given to the job by the OpenMPF framework. This value may be used, for example, for logging and debugging purposes. |
| data_uri              | `str`            | The URI of the input media file to be processed. Currently, this is a file path. For example, "/opt/mpf/share/remote-media/test-file.avi". |
| start_frame           | `int`            | The first frame number (0-based index) of the video that should be processed to look for detections. |
| stop_frame            | `int`            | The last frame number (0-based index) of the video that should be processed to look for detections. |
| job_properties        | `dict[str, str]` | Contains a dict with keys and values of type `str` which represents the property name and the property value. The key corresponds to the property name specified in the component descriptor file described in [Packaging and Registering a Component](Packaging-and-Registering-a-Component/index.html). Values are determined when creating a pipeline or when submitting a job. <br/><br/> Note: The job_properties map may not contain the full set of job properties. For properties not contained in the map, the component must use a default value. |
| media_properties      | `dict[str, str]` | Contains a dict with keys and values of type `str` of metadata about the media associated with the job.|
| feed_forward_track    | `None` or `mpf_component_api.VideoTrack` | An `mpf_component_api.VideoTrack` from the previous pipeline stage. Provided when feed forward is enabled. See [Feed Forward Guide](Feed-Forward-Guide/index.html). |



#### mpf_component_api.VideoTrack
Class used to store the location of detected objects in a video file.

* Constructor:
```python
def __init__(self, start_frame, stop_frame, confidence=-1.0, frame_locations=None, detection_properties=None):
    ...
```

* Members:

| Member               | Data Type | Description |
|----------------------|-----------|-------------|
| start_frame          | `int`     | The first frame number (0-based index) that contained the detected object. |
| stop_frame           | `int`     | The last frame number (0-based index) that contained the detected object. |
| confidence           | `float`   | Represents the "quality" of the detection. The range depends on the detection algorithm. 0.0 is lowest quality. Higher values are higher quality. Using a standard range of [0.0 - 1.0] is advised. If the component is unable to supply a confidence value, it should return -1.0. |
| frame_locations      | `mpf_component_api.FrameLocationMap` |  A dict-like object of individual detections. The key for each entry is the frame number where the detection was generated, and the value is a `mpf_component_api.ImageLocation` calculated as if that frame was a still image. Note that a key-value pair is *not* required for every frame between the track start frame and track stop frame. |
| detection_properties | `mpf_component_api.Properties` | Dict-like object with keys and values of type `str` containing optional additional information about the detected object. For best practice, keys should be in all CAPS. |



#### mpf_component_util.VideoCapture
`mpf_component_util.VideoCapture` is an utility class for reading videos. 
`mpf_component_util.VideoCapture` works very similarly to `cv2.VideoCapture`, except that it might modify the video 
frames based on job properties. From the point of view of someone using `mpf_component_util.VideoCapture`, 
these modifications are mostly transparent. `mpf_component_util.VideoCapture` makes it look like you are reading the 
original video file. 

One issue with this approach is that the detection frame numbers and bounding box will be relative to the 
modified video, not the original. To make the detections relative to the original video 
the `mpf_component_util.VideoCapture.reverse_transform(video_track)` function must be called on each 
`mpf_component_api.VideoTrack`. Since the use of `mpf_component_util.VideoCapture` is optional, the framework
cannot just do the reverse transform for the developer. 
See the documentation for `mpf_component_util.VideoCaptureMixin` for a more concise way to use 
`mpf_component_util.VideoCapture`

The general pattern for using `mpf_component_util.VideoCapture` is as follows:
```python
class MyComponent(object):

    @staticmethod
    def get_detections_from_video(video_job):
        video_capture = mpf_component_util.VideoCapture(video_job)
        for frame_index, frame in enumerate(video_capture):
            result_tracks = run_component_specific_algorithm(frame_index, frame)
            for track in result_tracks:
                video_capture.reverse_transform(track)
                yield track
```



#### mpf_component_util.VideoCaptureMixin
A mixin class that can be used to simplify the usage of `mpf_component_util.VideoCapture`. 
`mpf_component_util.VideoCaptureMixin` takes care of initializing a `mpf_component_util.VideoCapture` and 
performing the reverse transform.

There some requirements to properly use `mpf_component_util.VideoCaptureMixin`:

* The component must extend `mpf_component_util.VideoCaptureMixin`
* The component must implement `get_detections_from_video_capture(video_job, video_capture)`
* The component must read the video using the `mpf_component_util.VideoCapture` 
  that is passed in to `get_detections_from_video_capture(video_job, video_capture)`.

* The component must NOT implement `get_detections_from_video(video_job)`
* The component must NOT call `mpf_component_util.VideoCapture.reverse_transform`


The general pattern for using `mpf_component_util.VideoCaptureMixin` is as follows:
```python
class MyComponent(mpf_component_util.VideoCaptureMixin):

    @staticmethod # Can also be a regular instance method or a class method
    def get_detections_from_video_capture(video_job, video_capture):
        # If frame index is not required, you can just loop over video_capture directly
        for frame_index, frame in enumerate(video_capture): 
            # run_component_specific_algorithm is a placeholder for this example. 
            # Replace run_component_specific_algorithm with your component's detection logic
            result_tracks = run_component_specific_algorithm(frame_index, frame)
            for track in result_tracks:
                # Could also just return add tracks to list and return list after iterating through video
                yield track
```

`mpf_component_util.VideoCaptureMixin` is a mixin class so it designed in a way that does not prevent the subclass
from extending other classes. If a component supports both videos and images, and it uses 
`mpf_component_util.VideoCaptureMixin`, it should also use `mpf_component_util.ImageReaderMixin`.
For example:
```python
class MyComponent(mpf_component_util.VideoCaptureMixin, mpf_component_util.ImageReaderMixin):

    @staticmethod 
    def get_detections_from_video_capture(video_job, video_capture):
        ...
    
    @staticmethod 
    def get_detections_from_image_reader(image_job, image_reader):
       ...
```



## Audio API

#### component.get_detections_from_audio(audio_job)

Used to detect objects in an audio file. Currently, audio files are not logically segmented, so a job will contain 
the entirety of the audio file.

* Function Definition:
```python
class MyComponent(object):
    def get_detections_from_audio(self, audio_job):
        return [mpf_component_api.AudioTrack(...), ...]
```

`get_detections_from_audio`, like all get_detections_from_\* methods, can be implemented either as an instance method,
a static method, or a class method. 

* Parameters:

| Parameter | Data Type                    | Description |
|-----------|------------------------------|-------------|
| audio_job | `mpf_component_api.AudioJob` | Object containing details about the work to be performed.

* Returns: An iterable of `mpf_component_api.AudioTrack`


#### mpf_component_api.AudioJob

Class containing data used for detection of objects in an audio file. 
Currently, audio files are not logically segmented, so a job will contain the entirety of the audio file.

* Members:

| Member                | Data Type        | Description |
|-----------------------|------------------|-------------|
| job_name              | `str`            | A specific name given to the job by the OpenMPF framework. This value may be used, for example, for logging and debugging purposes. |
| data_uri              | `str`            | The URI of the input media file to be processed. Currently, this is a file path. For example, "/opt/mpf/share/remote-media/test-file.avi". |
| start_time            | `int`            | The time (0-based index, in milliseconds) associated with the beginning of the segment of the audio file that should be processed to look for detections. |
| stop_time             | `int`            | The time (0-based index, in milliseconds) associated with the end of the segment of the audio file that should be processed to look for detections. |
| job_properties        | `dict[str, str]` | Contains a dict with keys and values of type `str` which represents the property name and the property value. The key corresponds to the property name specified in the component descriptor file described in [Packaging and Registering a Component](Packaging-and-Registering-a-Component/index.html). Values are determined when creating a pipeline or when submitting a job. <br/><br/> Note: The job_properties map may not contain the full set of job properties. For properties not contained in the map, the component must use a default value. |
| media_properties      | `dict[str, str]` | Contains a dict with keys and values of type `str` of metadata about the media associated with the job.|
| feed_forward_track    | `None` or `mpf_component_api.AudioTrack` | An `mpf_component_api.AudioTrack` from the previous pipeline stage. Provided when feed forward is enabled. See [Feed Forward Guide](Feed-Forward-Guide/index.html). |


#### mpf_component_api.AudioTrack

Class used to store the location of detected objects in an audio file.

* Constructor:
```python
def __init__(self, start_time, stop_time, confidence, detection_properties=None):
    ...
```

* Members:

| Member               | Data Type | Description |
|----------------------|-----------|-------------|
| start_time           | `int`     | The time (0-based index, in ms) when the audio detection event started. |
| stop_time            | `int`     | The time (0-based index, in ms) when the audio detection event stopped. |
| confidence           | `float`   | Represents the "quality" of the detection. The range depends on the detection algorithm. 0.0 is lowest quality. Higher values are higher quality. Using a standard range of [0.0 - 1.0] is advised. If the component is unable to supply a confidence value, it should return -1.0. |
| detection_properties | `mpf_component_api.Properties` | Dict-like object with keys and values of type `str` containing optional additional information about the detected object. For best practice, keys should be in all CAPS. |



## Generic API

#### component.get_detections_from_generic(generic_job)

Used to detect objects in files that are not video, image, or audio files. Such files are of the UNKNOWN type and 
handled generically. These files are not logically segmented, so a job will contain the entirety of the file.

* Function Definition:
```python
class MyComponent(object):
    def get_detections_from_generic(self, generic_job):
        return [mpf_component_api.GenericTrack(...), ...]
```

`get_detections_from_generic`, like all get_detections_from_\* methods, can be implemented either as an instance method,
a static method, or a class method. 

* Parameters:

| Parameter   | Data Type                      | Description |
|-------------|--------------------------------|-------------|
| generic_job | `mpf_component_api.GenericJob` | Object containing details about the work to be performed.

* Returns: An iterable of `mpf_component_api.GenericTrack`


#### mpf_component_api.GenericJob

Class containing data used for detection of objects in a file that isn't a video, image, or audio file. 
The file is of the UNKNOWN type and handled generically. The file is not logically segmented, so a job will 
contain the entirety of the file.

* Members:

| Member             | Data Type        | Description |
|--------------------|------------------|-------------|
| job_name           | `str`            | A specific name given to the job by the OpenMPF framework. This value may be used, for example, for logging and debugging purposes. |
| data_uri           | `str`            | The URI of the input media file to be processed. Currently, this is a file path. For example, "/opt/mpf/share/remote-media/test-file.avi". |
| job_properties     | `dict[str, str]` | Contains a dict with keys and values of type `str` which represents the property name and the property value. The key corresponds to the property name specified in the component descriptor file described in [Packaging and Registering a Component](Packaging-and-Registering-a-Component/index.html). Values are determined when creating a pipeline or when submitting a job. <br/><br/> Note: The job_properties map may not contain the full set of job properties. For properties not contained in the map, the component must use a default value. |
| media_properties   | `dict[str, str]` | Contains a dict with keys and values of type `str` of metadata about the media associated with the job.|
| feed_forward_track | `None` or `mpf_component_api.GenericTrack` | An `mpf_component_api.GenericTrack` from the previous pipeline stage. Provided when feed forward is enabled. See [Feed Forward Guide](Feed-Forward-Guide/index.html). |



#### mpf_component_api.GenericTrack

Class used to store the location of detected objects in a file that is not a video, image, or audio file. 
The file is of the UNKNOWN type and handled generically.

* Constructor:
```python
def __init__(self, confidence=-1.0, detection_properties=None):
    ...
```

* Members:

| Member               | Data Type | Description |
|----------------------|-----------|-------------|
| confidence           | `float`   | Represents the "quality" of the detection. The range depends on the detection algorithm. 0.0 is lowest quality. Higher values are higher quality. Using a standard range of [0.0 - 1.0] is advised. If the component is unable to supply a confidence value, it should return -1.0. |
| detection_properties | `mpf_component_api.Properties` | Dict-like object with keys and values of type `str` containing optional additional information about the detected object. For best practice, keys should be in all CAPS. |





> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2017 The MITRE Corporation. All Rights Reserved.

## 	Component Descriptor Overview
In order to registered within OpenMPF, each component must provide a JavaScript Object Notation (JSON) descriptor file which provides contextual information about the component.

This file must be named "descriptor.json".

For an example, please see: [**Hello World JSON Descriptor**](https://github.com/openmpf/openmpf/blob/master/trunk/detection/test-components/java/JavaTestDetection/plugin-files/descriptor/JavaTestDetection.json)

## Component Descriptor Data Elements

Contained within the JSON file should be the following elements:

### componentName
Required.

Contains the component’s name. Should follow CamelCaseFormat.

Example:
`"componentName" : "SampleComponent"`

### componentVersion
Required.

Contains the component’s version. Does not need to match the `componentAPIVersion`.

Example:
``"componentVersion" : "0.1.0"``

### componentAPIVersion
Required.

Contains the version of the MPF Component API that the component was built with.

Example:
`"middlewareVersion" :  "0.9.0"`

### sourceLanguage
Required.

Contains the language the component is coded in. Should be either “java” or “c++”.

Example:
`"sourceLanguage" : "c++"`

### pathName
Required.

For C++ components, this contains the name of the Component Executable that will be used to run the component. Generally, this is `amq_detection_component` (where “amq” stands for ActiveMQ) for all C++ detection components.

For Java components, this contains the path to the jar which contains the component implementation.

Example (C++):
`"pathName" : "amq_detection_component"`

Example (Java):
`"pathName" : "sample-component-0.1.0.jar"`

### launchArgs
C++: Required.
Java: Required; can be empty.

Holds the command line arguments in string format that should be passed to the Component Executable when it is launched.

For C++ detection components the one and only argument should be the full path to the Component Logic shared object library. The library must reside in a location that is accessible by each of the machines on which the component is deployed.

For Java detection components, this can be empty.

Example (C++):
`"launchArgs" : ["${MPF_HOME}/plugins/SampleComponent/lib/libsampleComponent.so"]`

Example (Java):
`"launchArgs" : []`

### environmentVariables
Required; can be empty.

Defines a collection of environment variables that will be set when executing the MPF Component Executable.

Contains the following sub-fields:

* **name:**
  Name of the environment variable.

* **value:**
  Value of the environment variable.
  Note that value can be a list of values separated by “:”.

* **sep:**
  The `sep` field (short for “separator”) should be set to “null” or “:”. When set to “null,” the content of the environment variable specified by `name` is the content of `value`; for an existing variable, its former value will be replaced, otherwise, a new variable will be created and assigned this value. When set to “:” any prior value of the environment variable is retained and the content of `value` is simply appended to the end after a “:” character.

>**IMPORTANT**: For C++ components, the LD_LIBRARY_PATH needs to be set in order for the Component Executable to load the component’s shared object library as well as any dependent libraries installed with the component. The usual form of the LD_LIBRARY_PATH variable should be `${MPF_HOME}/plugins/<componentName>/lib/`. Additional directories can be appended after a “:” delimiter.

Example:
```json
"environmentVariables": [
    {
      "name": "LD_LIBRARY_PATH",
      "value": "${MPF_HOME}/plugins/SampleComponent/lib",
      "sep": ":"
    }
  ]
```

### algorithm
Required.

Specifies information about the component’s algorithm.

Contains the following sub-fields:
* **name:**
  Required. Contains the algorithm’s name. Should be unique and all CAPS.


* **description:**
  Required. Contains a brief description of the algorithm.


* **detectionType:**
  Required. Defines the type of entity associated with the algorithm. For example: `CLASS`, `FACE`, `MOTION`, `PERSON`, `SPEECH`, or `TEXT`.


* **actionType:**
  Required. Defines the type of processing that the algorithm performs. Must be set to `DETECTION`.

* **supportsBatchProcessing:**
  At least one of supportsBatchProcessing or supportsStreamProcessing must be true. Indicates whether or not the 
  algorithm supports batch processing.
  
* **supportsStreamProcessing:**
  At least one of supportsBatchProcessing or supportsStreamProcessing must be true. Indicates whether or not the 
  algorithm supports stream processing.

* **requiresCollection:**
  Required, can be empty. Contains the state(s) that must be produced by previous algorithms in the pipeline.
  <br/>This value should be empty *unless* the component depends on the results of another algorithm.


* **providesCollection:**

  Contains the following sub-fields:
  * **states:** Required. Contains the state(s) that the algorithm provides.
  Should contain the following values:
    * `DETECTION`
    * `DETECTION_TYPE`, where `TYPE` is the `algorithm.detectionType`
    * `DETECTION_TYPE_ALGORITHM`, where `TYPE` is the value of `algorithm.detectionType` and `ALGORITHM` is the value of `algorithm.name`
    Example:
      ```
      "states": [
        "DETECTION",
        "DETECTION_FACE",
        "DETECTION_FACE_SAMPLECOMPONENT"]
      ```

  * **properties:**
  Required; can be empty. Declares a list of the configurable properties that the algorithm exposes.
  Contains the following sub-fields:
    * **name:**
      Required.
    * **type:**
      Required.
      `BOOLEAN`, `FLOAT`, `DOUBLE`, `INT`, `LONG`, or `STRING`.
    * **defaultValue:**
      Required.
      Must be provided in order to create a default action associated with the algorithm, where an action is a specific instance of an algorithm configured with a set of property values.
    * **description:**
      Required.
      Description of the property. By convention, the default value for a property should be described in its description text.

### actions
Optional.

Actions are used in the development of pipelines. Provides a list of custom actions that will be added during component registration.

>**NOTE:** For convenience, a default action will be created upon component registration if this element is not provided in the descriptor file.

Contains the following sub-fields:

* **name:**
  Required. Contains the action’s name. Must be unique among all actions, including those that already exist on the system and those specified in this descriptor.

* **description:**
  Required. Contains a brief description of the action.

* **algorithm:**
  Required. Contains the name of the algorithm for this action. The algorithm must either already exist on the system or be defined in this descriptor.

* **properties:**
  Optional. List of properties that will be passed to the algorithm. Each property has an associated name and value sub-field, which are both required. Name must be one of the properties specified in the algorithm definition for this action.

  Example:
```json
"actions": [
  {
    "name": "SAMPLE COMPONENT FACE DETECTION ACTION",
    "description": "Executes the sample component face detection algorithm using the default parameters.",
    "algorithm": "SAMPLECOMPONENT",
    "properties": []
  }
]
```

### tasks
Optional.

A list of custom tasks that will be added during component registration.

>**NOTE:** For convenience, a default task will be created upon component registration if this element is not provided in the descriptor file.

Contains the following sub-fields:

* **name:**
  Required. Contains the task's name. Must be unique among all tasks, including those that already exist on the system and those specified in this descriptor.

* **description:**
  Required. Contains a brief description of the task.

* **actions:**
  Required. Minimum length is 1. Contains the names of the actions that this task uses. Actions must either already exist on the system or be defined in this descriptor.

Example:
```json
"tasks": [
  {
    "name": "SAMPLE COMPONENT FACE DETECTION TASK",
    "description": "Performs sample component face detection.",
    "actions": [
      "SAMPLE COMPONENT FACE DETECTION ACTION"
    ]
  }
]
```

### pipelines
Optional.

A list of custom pipelines that will be added during component registration.

>**NOTE:** For convenience, a default pipeline will be created upon component registration if this element is not provided in the descriptor file.

Contains the following sub-fields:

* **name:**
  Required. Contains the pipeline's name. Must be unique among all pipelines, including those that already exist on the system and those specified in this descriptor.

* **description:**
  Required. Contains a brief description of the pipeline.

* **tasks:**
  Required. Minimum length is 1. Contains the names of the tasks that this pipeline uses. Tasks must either already exist on the system or be defined in this descriptor.

Example:
```json
"pipelines": [
  {
    "name": "SAMPLE COMPONENT FACE DETECTION PIPELINE",
    "description": "Performs sample component face detection.",
    "tasks": [
      "SAMPLE COMPONENT FACE DETECTION TASK"
    ]
  }
]
```

## Packaging a Component

Once the descriptor file is complete, the next step is to compile your component source code, and finally, create a .tar.gz package containing the descriptor file, component library, and all other necessary files.

The package should contain a top-level directory with a unique name that will (hopefully) not conflict with existing component packages that have already been developed. The top-level directory name should be the same as the `componentName`.

Within the top-level directory there must be a directory named “descriptor” with the descriptor JSON file in it. The name of the file must be “descriptor.json”.

Example:
```
//sample-component-0.1.0-tar.gz contents
SampleComponent/
  config/
  descriptor/
    descriptor.json
  lib/
```

### Installing and registering a component
The Component Registration web page, located in the Admin section of the MPF web user interface, can be used to upload and register the component.

Drag and drop the .tar.gz file containing the component onto the dropzone area of that page. The component will automatically be uploaded and registered.

Upon successful registration, the component will be available for deployment onto MPF nodes via the Node Configuration web page and `/rest/nodes/config` end point.

If the descriptor contains custom actions, tasks, or pipelines, then they will be automatically added to the system upon registration.

>**NOTE:** If the descriptor does not contain custom actions, tasks, or pipelines, then a default action, task, and pipeline will be generated and added to the system.
>
>The default action will use the component’s algorithm with its default property value settings.
The default task will use the default action.
The default pipeline will use the default task. This will only be generated if the algorithm does not specify any `requiresCollection` states.

### Unregistering a component
A component can be unregistered by using the remove button on the Component Registration page.

During unregistration, all services, algorithms, actions, tasks, and pipelines associated with the component are deleted. Additionally, all actions, tasks, and pipelines that depend on these elements are removed.

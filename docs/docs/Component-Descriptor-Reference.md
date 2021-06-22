**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the
Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2021 The MITRE Corporation. All Rights Reserved.

## 	Overview
In order to be registered within OpenMPF, each component must provide a JavaScript Object Notation (JSON) descriptor file which provides contextual information about the component.

This file must be named "descriptor.json".

For an example, please see: [**Hello World JSON Descriptor**](https://github.com/openmpf/openmpf-cpp-component-sdk/blob/develop/detection/examples/HelloWorldComponent/plugin-files/descriptor/descriptor.json)

## Data Elements

Contained within the JSON file should be the following elements:

<h3>componentName</h3>
Required.

Contains the component’s name. Should follow CamelCaseFormat.

Example:
`"componentName" : "SampleComponent"`

<h3>componentVersion</h3>
Required.

Contains the component’s version. Does not need to match the `componentAPIVersion`.

Example:
``"componentVersion" : "2.0.1"``

<h3>middlewareVersion</h3>
Required.

Contains the version of the OpenMPF Component API that the component was built with.

Example:
`"middlewareVersion" :  "2.0.0"`

<h3>sourceLanguage</h3>
Required.

Contains the language the component is coded in. Should be "c++", "python", or "java".

Example:
`"sourceLanguage" : "c++"`

<h3>batchLibrary</h3>
Optional. At least one of `batchLibrary` or `streamLibrary` must be provided.

For C++ components, this contains the full path to the Component Logic shared object library used for batch processing once the component is deployed.

For Java components, this contains the name of the jar which contains the component implementation used for batch processing.

For setuptools-based Python components, this contains the component's distribution name, which is declared in the 
component's `setup.py` file. The distribution name is usually the same name as the component.

For basic Python components, this contains the full path to the Python file containing the component class.

Example (C++):
`"batchLibrary" : "${MPF_HOME}/plugins/SampleComponent/lib/libbatchSampleComponent.so`

Example (Java):
`"batchLibrary" : "batch-sample-component-2.0.1.jar"`

Example (setuptools-based Python):
`"batchLibrary" : "SampleComponent"`

Example (basic Python):
`"batchLibrary" : "${MPF_HOME}/plugins/SampleComponent/sample_component.py"`

<h3>streamLibrary</h3>
Optional. At least one of `batchLibrary` or `streamLibrary` must be provided.

For C++ components, this contains the full path to the Component Logic shared object library used for stream processing once the component is deployed.

Note that Python and Java components currently do not support stream processing, so this field should be omitted from Python and Java component descriptor files.

Example (C++):
`"streamLibrary" : "${MPF_HOME}/plugins/SampleComponent/lib/libstreamSampleComponent.so`

<h3>environmentVariables</h3>
Required; can be empty.

Defines a collection of environment variables that will be set when executing the OpenMPF Component Executable.

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

<h3>algorithm</h3>
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


* **requiresCollection:**
  Required, can be empty. Contains the state(s) that must be produced by previous algorithms in the pipeline.
  <br/>This value should be empty *unless* the component depends on the results of another algorithm.


* **providesCollection:**
  Contains the following sub-fields:
    * **states:** Required. Contains the state(s) that the algorithm provides.
  Should contain the following values:
        * `DETECTION`
        * `DETECTION_TYPE`, where `TYPE` is the `algorithm.detectionType`
        * `DETECTION_TYPE_ALGORITHM`, where `TYPE` is the value of `algorithm.detectionType` and `ALGORITHM` is the value of `algorithm.name`<br/><br/>
        Example:<br/>
        ```
        "states": [
          "DETECTION",
          "DETECTION_FACE",
          "DETECTION_FACE_SAMPLECOMPONENT"]
        ```
        <br/><br/>
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

<h3>actions</h3>
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

<h3>tasks</h3>
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

<h3>pipelines</h3>
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

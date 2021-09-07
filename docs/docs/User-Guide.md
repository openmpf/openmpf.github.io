**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the
Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2021 The MITRE Corporation. All Rights Reserved.

<div style="background-color:DeepSkyBlue"><p style="color:white; padding:5px"><b>INFO:</b> This document refers to components and pipelines that are no longer supported by OpenMPF; however, the images and general content still reflect the appearance and usage of the OpenMPF web UI and its features.</p></div>

# General

The Open Media Processing Framework (OpenMPF) can be used in three ways:

* Through the OpenMPF Web user interface (UI)
* Through the [REST API endpoints](#rest-api)
* Through the [CLI Runner](https://github.com/openmpf/openmpf-docker/blob/master/CLI_RUNNER.md)

## Accessing the Web UI

On the server hosting the Open Media Processing Framework, the Web UI is accessible at http://localhost:8080/workflow-manager. To access it from other machines, substitute the hostname or IP address of the master node server in place of "localhost".

The OpenMPF user interface was designed and tested for use with Chrome and FireFox. It has not been tested with other browsers. Attempting to use an unsupported browser will result in a warning.

## Logging In

The OpenMPF Web UI requires user authentication and provides two default accounts: "mpf" and "admin". The password for the "mpf" user is "mpf123". These accounts are used to assign user or admin roles for OpenMPF cluster management. Note that an administrator can remove these accounts and/or add new ones using a command line tool. Refer to the [Admin Guide](Admin-Guide/index.html) for features available to an admin user.

![Login Page](img/mpf_login.png "Login Page")

The landing page for a user is the Job Status page:

![Landing Page](img/mpf_landing.png "Landing Page")

Logging in starts a user session. By default, after 30 minutes of inactivity the user will automatically be logged out of the system. Within one minute of logging out the user will be prompted to extend or end their session. Note that the timeout period can be configured by any admin user with the admin role.

A given user can only be logged into the OpenMPF from one machine using one browser at a time. If the same user attempts to log in from another machine, or another browser on the same machine, then the first user session will be terminated immediately and redirected back to the login page. This feature ensures that the user will be able to immediately log in again if the user accidentally closes the browser window or shuts down their machine without properly logging out first.

A user may have multiple browser tabs or windows open for the same session, for example, to view the Jobs Status page and Logs page at the same time. It is not recommended that two users login using the same browser at the same time in different tabs or windows. Technically, the second user to login will take precedence, but the first user session will not appear to be terminated. Instead the first user will appear to share recent jobs and other information with the second user. Also, when one of the users logs out in this scenario, they will both be logged out.

## Logging out

To log out a user can click the down arrow associated with the user icon at the top right hand corner of the page and then select "Logout":

![Logout Button](img/mpf_show_logout.png "Logout Button")

# User (Non-Admin) Features

The remainder of this document will describe the features available to a non-admin user.

## Creating Workflow Manager Jobs

A "job" consists of a set of image, video, or audio files and a set of exploitation algorithms that will operate on those files.  A job is created by assigning input media file(s) to a pipeline.  A pipeline specifies the order in which processing steps are performed. Each step consists of a single task and each task consists of one or more actions which may be performed in parallel. The following sections describe the UI views associated with the different aspects of job creation and job execution.

## Create Job

This is the primary page for creating jobs. Creating a job consists of uploading and selecting files as well as a pipeline and job priority.

![Create Job Page](img/mpf_create_job1.png "Create Job Page")

### Uploading Files

Selecting a directory in the File Manager will display all files in that directory.  The user can use previously uploaded files, or to choose from the icon bar at the bottom of the panel:

![Create New Folder Icon](img/create_new_folder_icon.png "Create New Folder Icon") Create New Folder
![Add Local Files Icon](img/add_local_file_icon.png "Add Local Files Icon") Add Local Files
![Upload from URL Icon](img/upload_from_url_icon.png "Upload from URL Icon") Upload from URL
![Refresh Icon](img/refresh_icon.png "Refresh Icon") Refresh

Note that the first three options are only available if the "remote-media" directory or one of its subdirectories is selected. That directory resides in the OpenMPF share directory. The full path is shown in the footer of the File Manager section.

Clicking the "Add Local Files" icon will display a file browser dialog so that the user can select and upload one or more files from their local machine. The files will be uploaded to the selected directory. The upload progress dialog will display a preview of each file (if possible) and whether or not each file is uploaded successfully.

Clicking the "Create New Folder" icon will allow the user to create a new directory within the one currently selected. If the user has selected "remote-media", then adding a directory called "Test Data" will place it within "remote-media". "Test Data" will appear as a subdirectory in the directory tree shown in the web UI. If the user then clicks on "Test Data" and then the "Add Local Files" button the user can upload files to that specific directory. In the screenshot below, "lena.png" has been uploaded to the parent "remote-media" directory.

![Create Job Page](img/mpf_create_job_media.png "Create Job Page")

Clicking the "Upload from URL" icon enables the user to specify URLs pointing to remote media. Each URL must appear on a new line. Note that if a URL to a video is submitted then it must be a direct link to the video file. Specifying a URL to a YouTube HTML page, for example, will not work.

![URL File Upload](img/mpf_create_job_upload.png "URL File Upload")

Clicking the "Refresh" icon updates the displayed file tree from the file system. Use this if an external process has added or removed files to or from the underlying file system.

### Creating Jobs

Creating a job consists of selecting files as well as a pipeline and job priority.

![Create Job Page](img/mpf_create_job2.png "Create Job Page")

Files are selected by first clicking the name of a directory to populate the files table in the center of the UI and then clicking the checkbox next to the file. Multiple files can be selected, including files from different directories. Also, the contents of an entire directory, and its subdirectories, can be selected by clicking the checkbox next to the parent directory name. To review which files have been selected, click the "View" button shown to the right of the "# Files" indicator.  If there are many files in a directory, you may need to page through the directory using the page number buttons at the bottom of the center pane.

You can remove a file from the selected files by clicking on the red "X" for the individual file.  You can also remove multiple files by first selecting the files using the checkboxes and then clicking on the "Remove Checked" button.

![Create Job Page](img/mpf_create_job3.png "Create Job Page")

The media properties can be adjusted for individual files by clicking on the "Set Properties" button for that file. You can modify the properties of a group of files by clicking on the "Set properties for Checked" after selecting multiple files.

![Create Job Page](img/mpf_create_job_media_properties.png "Create Job Page")

After files have been selected it's time to assign a pipeline and job priority. The "Select a pipeline and job priority" section is located on the right side of the screen.  Clicking on the down-arrow on the far right of the "Select a pipeline" area displays a drop-down menu containing the available pipelines.  Click on the desired pipeline to select it. Existing pipelines provided with the system are listed in the Default Pipelines section of this document.

"Select job priority" is immediately below "Select a pipeline" and has a similar drop-down menu.  Clicking on the down-arrow on the right hand side of the "Select job priority" area displays the drop-down menu of available priorities.  Clicking on the desired priority selects it.  Priority 4 is the default value used if no priority is selected by the user. Priority 0 is the lowest priority, and priority 9 is the highest priority. When a job is executed it's divided into tasks that are each executed by a component service running on one of the nodes in the OpenMPF cluster. Each service executes tasks with the highest priority first. Note that a service will first complete the task it's currently processing before moving on to the next task. Thus, a long-running low-priority task may delay the execution of a high-priority task.

After files have been selected and a pipeline and priority are assigned, clicking on the "Create Job" icon will start the job.  When the job starts, the user will be shown the "Job Status" view.

## Job Status

The Job Status page displays a summary of the status for all jobs run by any user in the past. The current status and progress of any running job can be monitored from this view, which is updated automatically.

![Job Status Page](img/mpf_job_status_complete.png "Job Status Page")

When a job is COMPLETE a user can view the generated JSON output object data by clicking the "Output Objects" button for that job. A new tab/window will open with the detection output. The detection object output displays a formatted JSON representation of the detection results.

![Job Output Objects](img/mpf_job_status_output.png "Job Output Objects")

A user can click the "Cancel" button to attempt to cancel the execution of a job before it completes. Note that if a service is currently processing part of a job, for example, a video segment that's part of a larger video file, then it will continue to process that part of the job until it completes or there is an error. The act of cancelling a job will prevent other parts of that job from being processed. Thus, if the "Cancel" button is clicked late into the job execution, or if each part of the job is already being processed by services executing in parallel, it may have no effect. Also, if the video segment size is set to a very large number, and the detection being performed is slow, then cancelling a job could take awhile.

A user can click the "Resubmit" button to execute a job again. The new job execution will retain the same job id and all generated artifacts, marked up media, and detection objects will be replaced with the new results. The results of the previous job execution will no longer be available. Note that the user has the option to change the job priority when resubmitting a job.

You can view the results of any Media Markup by clicking on the "Media" button for that job. This view will display the path of the source medium and the marked up output path of any media processed using a pipeline that contains a markup action. Clicking an image will display a popup with the marked up image. You cannot view a preview for marked up videos. In any case, the marked up data can be downloaded to the machine running the web browser by clicking the "Download" button.

![Media Markup Results](img/mpf_markup.png "Media Markup Results")

## Create Custom Pipelines

A pipeline consists of a series of tasks executed sequentially. A task consists of a single action or a set of two or more actions performed in parallel. An action is the execution of an algorithm. The ability to arrange tasks and actions in various ways provides a great deal of flexibility when creating pipelines. Users may combine pre-existing tasks in different ways, or create new tasks based on the pre-existing actions.

Selecting "Pipelines" from the "Configuration" dropdown menu in the top menu bar brings up the Pipeline Creation View, which enables users to create new pipelines. To create a new action, the user can scroll to the "Create A New Action" section of the page and select the desired algorithm from the "Select an Algorithm" dropdown menu:

![Pipeline Creation Page](img/mpf_custom_pipeline1.png "Pipeline Creation Page")

Selecting an algorithm will bring up a scrollable table of properties associated with the algorithm, including each property's name, description, data type, and an editable field allowing the user to set a custom value. The user may enter values for only those properties that they wish to change; any property value fields left blank will result in default values being used for those properties. For example, a custom action may be created based on the OpenCV face detection component to scan for faces equal to or exceeding a size of 100x100 pixels.

When done editing the property values, the user can click the "Create Action" button, enter a name and description for the action (both are required), and then click the "Create" button. The action will then be listed in the "Available Actions" table and also in the "Select an Action" dropdown menu used for task creation.

![Pipeline Creation Page](img/mpf_custom_pipeline2.png "Pipeline Creation Page")

To create a new task, the user can scroll to the "Create A New Task" section of the page:

![Pipeline Creation Page](img/mpf_custom_pipeline3.png "Pipeline Creation Page")

The user can use the "Select an Action" dropdown menu to select the desired action and then click "Add Action to Task". The user can follow this procedure to add additional actions to the task, if desired. Clicking on the "Remove" button next to an added action will remove it from the task. When the user is finished adding actions the user can click "Create Task", enter a name and description for the task (both are required), and then click the "Create" button. The task will be listed in the "Available Tasks" table as well as in the "Select a Task" dropdown menu used for pipeline creation.

![Pipeline Creation Page](img/mpf_custom_pipeline4.png "Pipeline Creation Page")

To build a new pipeline, the user can scroll down to the "Create A New Pipeline" section of the page:

![Pipeline Creation Page](img/mpf_custom_pipeline5.png "Pipeline Creation Page")

The user can use the "Select a Task" dropdown menu to select the first task and then click "Add Task to Pipeline". The user can follow this procedure to add additional tasks to the pipeline, if desired. Clicking on the "Remove" button next to an added task will remove it from the pipeline. When the user is finished adding tasks the user can click "Create Pipeline", enter a name and description for the pipeline (both are required), and then click the "Create" button. The pipeline will be listed in the "Available Pipelines" table.

![Pipeline Creation Page](img/mpf_custom_pipeline6.png "Pipeline Creation Page")

All pipelines successfully created in this view will also appear in the pipeline drop down selection menus on any job creation page:

![Pipeline Creation Page](img/mpf_custom_pipeline7.png "Pipeline Creation Page")

> NOTE: Pipeline, task, and action names are case-insensitive. All letters will be converted to uppercase.

## Logs

This page allows a user to view the various log files that are generated by system processes running on the various nodes in the OpenMPF cluster. A log file can be selected by first selecting a host from the "Available Hosts" drop-down and then selecting a log file from the "Available Logs" drop-down. The information in the log can be filtered for display based on the following log levels:  ALL, TRACE, DEBUG, INFO, WARN, ERROR, or FATAL.  Choosing a successive log level displays all information at that level and levels below (e.g., choosing WARN will cause all WARN, INFO, DEBUG, and TRACE information to be displayed, but will filter out ERROR and FATAL information).

![Logs Page](img/mpf_logs1.png "Logs Page")

In general, all services of the same component type running on the same node write log messages to the same file. For example, all OCV face detection services on somehost-7-mpfd2 write log messages to the same "ocv-face-detection" log file. All OCV face detection services on somehost-7-mpfd3 write log messages to a different "ocv-face-detection" log file.

Note that only the master node will have the "workflow-manager" log. This is because the workflow manager only runs on the master node. The same is true for the "activemq" and "tomcat" logs.

The "node-manager-startup" and "node-manager" logs will appear for every node in a non-Docker OpenMPF cluster. The "node-manager-startup" log captures information about the nodemanager startup process, such as if any errors occurred. The "node-manager" log captures information about node manager execution, such as starting and stopping services.

The "detection" log captures information about initializing C++ detection components and how they handle job request and response messages.

## Properties Settings

This page allows a user to view the various OpenMPF properties configured automatically or by an admin user:

![Edit Properties Page](img/mpf_properties.png "Edit Properties Page")

## Statistics

The "Jobs" tab on this page allows a user to view a bar graph representing the time it took to execute the longest running job for a given pipeline. Pipelines that do not have bars have not been used to run any jobs yet. Job statistics are preserved when the workflow manager is restarted.

![Job Statistics Page](img/mpf_stats_jobs.png "Job Statistics Page")

For example, the DLIB FACE DETECTION PIPELINE was run twice. Note that the Y-axis in the bar graph has a logarithmic scale. Hovering the mouse over any bar in the graph will show more information. Information about each pipeline is listed below the graph.

The "Processes" tab on this page allows a user to view a table with information about the runtime of various internal workflow manager operations. The "Count" field represents the number of times each operation was run. The min, max, and mean are calculated over the set of times each operation was performed. Runtime information is reset when the workflow manager is restarted.

![Job Statistics Page](img/mpf_stats_proc.png "Job Statistics Page")

## REST API

This page allows a user to try out the [various REST API endpoints](REST-API) provided by the workflow manager. It is intended to serve as a learning tool for technical users who wish to design and build systems that interact with the OpenMPF.

After selecting a functional category, such as "meta", "jobs", "statistics", "nodes", "pipelines", or "system-message", each REST endpoint for that category is shown in a list. Selecting one of them will cause it to expand and reveal more information about the request and response structures. If the request takes any parameters then a section will appear that allows the user to manually specify them.

![REST API Page](img/swagger1.png "REST API Page")

In the example above, the "/rest/jobs/{id}" endpoint was selected. It takes a required "id" parameter that corresponds to a previously run job and returns a JSON representation of that job's information. The screenshot below shows the result of specifying an "id" of "1", providing the "mpf" user credentials when prompted, and then clicking the "Try it out!" button:

![REST API Page](img/swagger2.png "REST API Page")

The HTTP response information is shown below the "Try it out!" button. Note that the structure of the "Response Body" is the same as the response model shown in the "Response Class" directly underneath the "/rest/jobs/{id}" label.

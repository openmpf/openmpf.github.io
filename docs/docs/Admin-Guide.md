**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the
Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2023 The MITRE Corporation. All Rights Reserved.

<div style="background-color:orange"><p style="color:white; padding:5px"><b>WARNING:</b> Please refer to the <a href="#user-configuration">User Configuration</a> section for changing the default user passwords.</p></div>

<div style="background-color:DeepSkyBlue"><p style="color:white; padding:5px"><b>INFO:</b> This document refers to components and pipelines that are no longer supported by OpenMPF; however, the images and general content still reflect the appearance and usage of the OpenMPF web UI and its features.</p></div>


# Web UI

The login procedure, as well as all of the pages accessible through the Workflow Manager sidebar, are the same for admin and non-admin users. Refer to the [User Guide](/User-Guide/index.html) for more information. The default account for an admin user has the username "admin" and password "mpfadm".

We highly recommend changing the default username and password settings for any environment which is exposed on a network, especially production environments. The default settings are public knowledge, which could be a security risk. Please refer to the [User Configuration](#user-configuration) section below.

This document will cover the additional functionality permitted to admin users through the Admin Console pages.

## Dashboard

The landing page for an admin user is the Job Status page:

![Admin Landing Page](img/mpf-adm-landing.png "Admin Landing Page")

The Job Status page displays a summary of the status for all jobs run by any user in the past. The current status and progress of any running job can be monitored from this view, which is updated automatically.

## Properties Settings

This page allows an admin user to view and edit various OpenMPF properties:

![Properties Settings Page](img/mpf-adm-property-settings.png "Properties Settings Page")

An admin user can click inside of the "Value" field for any of the properties and type a new value. Doing so will change the color of the property to orange and display an orange icon to the right of the property name.

Note that if the admin user types in the original value of the property, or clicks the "Reset" button, then it will return back to the normal coloration.

<div style="background-color:orange"><p style="color:white; padding:5px"><b>WARNING:</b> Changing the value of these properties can prevent the Workflow Manager from running after the web server is restarted. Also, no validation checks are performed on the user-provided values. Proceed with caution!</p></div>

At the bottom of the properties table is the "Save Properties" button. The number of modified properties is shown in parentheses. Clicking the button will make the necessary changes to the properties file on the file system, but the changes will not take effect until the Workflow Manager is restarted. The saved properties will be colored blue and a blue icon will be displayed to the right of the property name. Additionally, a notification will appear at the top of the page alerting all system users that a restart is required:

![Properties Settings Page](img/mpf-adm-property-settings-change.png "Properties Settings Page")

## Hawtio

The [Hawtio](https://hawt.io/) web console can be accessed by selecting "Hawtio" from the
"Configuration" dropdown menu in the top menu bar. Hawtio exposes various management information
and settings. It can be used to monitor the state of the ActiveMQ queues used for communication
between the Workflow Manager and the components.

# User Configuration

Every time the Workflow Manager starts it will attempt to create accounts for the users listed in the `user.properties` file. At runtime this file is extracted to `$MPF_HOME/config` on the machine running the Workflow Manager. For every user listed in that file, the Workflow Manager will create that user account if a user with the same name doesn't already exists in the SQL database. By default, that file contains two entries, one for the "admin" user with the "mpfadm" password, and one for a non-admin "mpf" user with the "mpf123" password.

We highly recommend modifying the `user.properties` file with your own user entries before attempting to start the Workflow Manager for the first time. This will ensure that the default user accounts are not created.

The official way to deploy OpenMPF is to use the Docker container platform. If you are using Docker, please follow the instructions in the openmpf-docker [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md#optional-configure-users) that explain how to use a `docker secret` for your custom `user.properties` file.


# (Optional) Configure HTTPS
The official way to deploy OpenMPF is to use the Docker container platform.
If you are using Docker, please follow the instructions in the openmpf-docker
[README](https://github.com/openmpf/openmpf-docker#optional-configure-https)
that explain how to configure HTTPS.

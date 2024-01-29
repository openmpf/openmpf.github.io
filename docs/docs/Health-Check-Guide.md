**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2023
The MITRE Corporation. All Rights Reserved.


# Health Check Overview

The C++ and Python component executors can be configured to run health checks on components prior
to running jobs. Health checks are configured using environment variables and an INI file. All of
the log lines pertaining to the health check will be prefixed with `[Health check] -`  instead
of `[Job #: media] -`.

When the component executor receives a job from ActiveMQ, it checks if health checks are enabled
and if more than the specified timeout has passed since the last health check. If both conditions
are true, the component executor will run a health check job before the actual job. Health checks
only run after a job from ActiveMQ is received. If the timeout period expires, but no job is
received or a job is already running, the health check will not run until the next job is received.

If the health check job completes successfully, then the component executor runs the job received
from ActiveMQ. If the health check fails, the job will be returned to ActiveMQ. If the maximum
number of consecutive health check failures has not been met, the component executor will wait the
timeout period before until attempting to receive another job from ActiveMQ. If the maximum number
of consecutive health check failures has been met, the component executor will exit with exit
code 39. If the component is running in a Docker container, the container will exit.


# Environment Variables

- `HEALTH_CHECK`: When set to "ENABLED", the component executor will run health checks.
- `HEALTH_CHECK_TIMEOUT`: When set to a positive integer, specifies the minimum number of seconds
    between health checks. When absent or set to 0, a health check will run before every job.
- `HEALTH_CHECK_RETRY_MAX_ATTEMPTS`: When set to a positive integer, specifies the number of
    consecutive health check failures that will cause the component service to exit. When absent or
    set to 0, the component service will never exit because of a failed health check.


# The INI File

When health checks are enabled, the component executor will look for an INI file at
`$MPF_HOME/plugins/<component-name>/health/health-check.ini`. Below is an example of the expected
INI file.

```ini
media=$MPF_HOME/plugins/OcvFaceDetection/health/meds_faces_image.png
min_num_tracks=2
media_type=IMAGE

[job_properties]
JOB PROP1=VALUE1
JOB PROP2=VALUE2

[media_properties]
MEDIA PROP=MEDIA VALUE
```

The supported keys are:

- `media`: (Required) Path to the media file that will be used in the health check.
- `min_num_tracks`: (Required) The minimum number of tracks the component must find for the health
    check to pass.
- `media_type`: (Required) The type of media referenced in the `media` key. It must be one of
    "IMAGE", "VIDEO", "AUDIO", or "GENERIC".
- `job_properties`: (Optional) Job properties that will set on the health check job.
- `media_properties`: (Optional) Media properties that will set on the health check job.

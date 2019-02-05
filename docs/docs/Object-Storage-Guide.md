> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007).
Copyright 2018 The MITRE Corporation. All Rights Reserved.

# Object Storage Overview

By default, OpenMPF will write markup files, JSON output objects, and extracted artifacts to directories in `$MPF_HOME/share`. For multi-node deployments, `$MPF_HOME/share` points to a directory on a network share. Most often, the share is managed by the Network File System (NFS) protocol, although using NFS is not a requirement.

Alternatively, OpenMPF supports writing these files to an object storage server. That may be desirable in cloud deployments to better support integration between systems, and/or to consolidate file storage as a cost-saving measure.

When a file cannot be uploaded to the server, the Workflow Manager will fall back to storing it in `$MPF_HOME/share`. If and when a failure occurs, the JSON output object will contain a descriptive message in the `jobWarnings` field. If the job completes without other issues, the final status will be `COMPLETE_WITH_WARNINGS`.

# Common Object Storage Properties

The following system properties are common to the various types of object storage solutions that OpenMPF supports:

- `http.object.storage.type`
    - If `NONE`, then the rest of the `http.object.storage.*` properties are ignored and objects will be stored in `$MPF_HOME/share`.
- `http.object.storage.upload.retry.count`
    - The number of times OpenMPF will attempt to upload an object to the storage server after the first failed attempt.
    - Exponential back off is used between retry attempts. There is a 500ms delay before the first retry. The delay doubles for each subsequent retry.

# Custom NGINX HTTP Object Storage

OpenMPF supports a custom NGINX object storage server solution. If you're interested, please contact us. We can make the server-side code available upon request.

For those who choose to run their own custom NGINX object storage server, please configure OpenMPF by setting the `http.object.storage.type` to `CUSTOM_NGINX`. The following system properties are unique to the custom NGINX object storage solution:

- `http.object.storage.service_uri`
    - The URI to the custom NGINX object storage server. For example:  `https://somehost:123543/somepath`.
    - You must provide a valid value.
- `http.object.storage.upload.thread.count`
    - The number of threads used to upload objects to the storage server.
    - In general, the default value is sufficient.
- `http.object.storage.upload.segment.size`
    - The chunk size, in bytes, that is used to upload objects to the storage server.
    - In general, the default value is sufficient.

The NGINX object storage server will determine the sha256 hash for the file once it's been uploaded. It then uses that hash to name the file and returns the file URI to OpenMPF.

# Ceph HTTP Object Storage

> **NOTE:** In the future, we plan to support the Ceph object storage server through the Amazon S3 API.

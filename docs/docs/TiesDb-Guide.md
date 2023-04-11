**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2022
The MITRE Corporation. All Rights Reserved.

# TiesDb Overview

Refer to <https://github.com/Noblis/ties-lib> for more information on the Triage Import Export
Schema (TIES). For each piece of media, we create one or more TIES
"supplementalDescription (Data Object)" entries in the database, one for each
analytic (algorithm) run on the media. In general, a "supplementalDescription" is a kind of TIES
"assertion", which is used to represent metadata about the media object. In our case it
represents the detection and track information in the OpenMPF JSON output object. Workflow Manager
can be configured to check TiesDb for a
[supplemental it previously created](#after-job-supplemental-creation) and
[use the results from that previous job to avoid re-running the job.](#before-job-check)
Workflow Manager can also be configured to [copy results to a different S3 bucket](#s3-copy)
when a matching job is found.


# Configuration
- `TIES_DB_URL` job property or `ties.db.url` system property
    - When provided, information about completed jobs will be sent to the specified TiesDb server.
    - For example: `https://tiesdb.example.com`
- `SKIP_TIES_DB_CHECK` job property or `ties.db.skip.check` system property
    - When true, TiesDb won't be checked for a compatible job before processing media.
- `TIES_DB_S3_COPY_ENABLED` job property or `ties.db.s3.copy.enabled` system property
    - When true and a job is skipped because a compatible job is found in TiesDb, the results
      from the previous job will be copied to a different S3 bucket. Copying results will always
      result in a new JSON output object, even if using the same S3 location as the previous job.
- `TIES_DB_COPY_SRC_S3_ACCESS_KEY` job property or `ties.db.copy.src.s3.access.key` system property
    - If a job is skipped because a compatible job was found in TiesDb, this is the S3 access key
      that will be used when getting the results from S3. If not provided, defaults to the value of
      `S3_ACCESS_KEY`.
- `TIES_DB_COPY_SRC_S3_SECRET_KEY` job property or `ties.db.copy.src.s3.secret.key` system property
    - If a job is skipped because a compatible job was found in TiesDb, this is the S3 secret key
      that will be used when getting the results from S3. If not provided, defaults to the value of
      `S3_SECRET_KEY`.
- `TIES_DB_COPY_SRC_S3_SESSION_TOKEN` job property or `ties.db.copy.src.s3.session.token` system
  property
    - If a job is skipped because a compatible job was found in TiesDb, this is the S3 session
      token that will be used when getting the results from S3. If not provided, defaults to the
      value of `S3_SESSION_TOKEN`.
- `TIES_DB_COPY_SRC_S3_REGION` job property or `ties.db.copy.src.s3.region` system property
    - If a job is skipped because a compatible job was found in TiesDb, this is the S3 region that
      will be used when getting the results from S3. If not provided, defaults to the value of
      `S3_REGION`.
- `TIES_DB_COPY_SRC_S3_USE_VIRTUAL_HOST` job property or `ties.db.copy.src.s3.use.virtual.host`
  system property
    - If a job is skipped because a compatible job was found in TiesDb, this enables virtual host
      style bucket URIs. If not provided, defaults to the value of `S3_USE_VIRTUAL_HOST`.
- `TIES_DB_COPY_SRC_S3_HOST` job property or `ties.db.copy.src.s3.host` system property
    - If a job is skipped because a compatible job was found in TiesDb, this is the S3 host that
      will be used when getting the results from S3. If not provided, defaults to the value of
      `S3_HOST`.
- `TIES_DB_COPY_SRC_S3_UPLOAD_OBJECT_KEY_PREFIX` job property or
  `ties.db.copy.src.s3.upload.object.key.prefix` system property
    - If a job is skipped because a compatible job was found in TiesDb, this is the S3 object key
      prefix that will be used when getting the results from S3. If not provided, defaults to the
      value of `S3_UPLOAD_OBJECT_KEY_PREFIX`.
- `data.ties.db.check.ignorable.properties.file` system property
    - Path to the
      [JSON file containing the list of properties that should not be considered](#ignorable-properties)
      when checking for a compatible job in TiesDb.


# After Job Supplemental Creation

When a URL is provided for the `TIES_DB_URL` job property or `ties.db.url` system property,
Workflow Manager will post a supplemental to TiesDb at the end of the job. The full URL that
Workflow Manager will post to is created by taking the provided URL and appending
`/api/db/supplementals?sha256Hash=<MEDIA_HASH>` to it. If, for example, the provided TiesDb URL
is `https://tiesdb.example.com/path` and the SHA-256 hash of the media is
`d1bc8d3ba4afc7e109612cb73acbdd`, Workflow Manager will post to <br/>
`https://tiesdb.example.com/path/api/db/supplementals?sha256Hash=d1bc8d3ba4afc7e109612cb73acbdd`


This is an example of what Workflow Manager will post to TiesDb:
```json
{
  "assertionId": "87298cc2f31fba73181ea2a9e6ef10dce21ed95e98bdac9c4e1504ea16f486e4",
  "dataObject": {
    "algorithm": "MOG",
    "pipeline": "MOG MOTION PIPELINE",
    "jobId": "mpf.example.com-13",
    "jobStatus": "COMPLETE",
    "outputType": "MOTION",
    "outputUri": "https://s3.example.com/2c/f2/2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824",
    "processDate": "2021-10-08T15:24:04.168448Z",
    "sha256OutputHash": "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824",
    "systemHostname": "mpf.example.com",
    "systemVersion": "6.0.2",
    "trackCount": 100,
    "jobConfigHash": "d52ad13e6e2db75e780b858e92b89df18c021674c24fd6c84dd151dcd28f5c56"
  },
  "informationType": "OpenMPF_MOTION",
  "securityTag": "UNCLASSIFIED",
  "system": "OpenMPF"
}
```


# Before Job Check

Workflow Manager can be configured to check TiesDb for a supplemental produced as a result of
a previously run OpenMPF job. In order for Workflow Manager to do this check, the `TIES_DB_URL`
job property or the `ties.db.url` system property must be set to the TiesDb server's URL and
the `SKIP_TIES_DB_CHECK` job property or the `ties.db.skip.check` system property must be set to
false. If Workflow Manager finds a supplemental with a `jobConfigHash` that matches the job that
Workflow Manager is currently running, Workflow Manager will not process the media in the current
job. Workflow Manager will use the output of the previous job to create the output for the
current job. Workflow Manager can also be configured to copy the results of the previous job to a
different S3 bucket.

It is possible for there to be multiple matching supplementals in TiesDb. In that case,
Workflow Manager will first pick the supplementals with the best job status. The job statuses
from best to worst are `COMPLETE`, `COMPLETE_WITH_WARNINGS`, and `COMPLETE_WITH_ERRORS`. If no jobs
with those statuses exist, all other statuses are considered equally bad. If there are multiple
supplementals with the same status, the most recently created supplemental will be used.

In order to determine if a previous job was similar enough to a current job, a hash of the
important parts of the jobs is computed. The parts of the job that are included in the hash are:

- Names of the algorithms used in the pipeline and their order
- Non-[ignorable job properties](#ignorable-properties)
- `output.changed.counter` system property
    - This is an integer that is incremented when there is a change to the Workflow Manager after
      which previous TiesDb records should not be used. Because this number is part of the job
      configuration hash, changing this number invalidates all previous TiesDb records.
- Component descriptor's `outputChangedCounter` property.
    - This works the same way as `output.changed.counter`, except that it only invalidates TiesDb
      records for jobs that used the component.
- Frame ranges and time ranges
- JSON output object major and minor version
- SHA-256 hashes of all input media
    - As a result of this, in order to find a matching job, both jobs must have been run on all
      of the same media. To improve the chances that a matching job is found in TiesDb, a user
      can choose to only submit jobs for a single piece of media.


### Ignorable Properties

There are certain job properties, that when changed, do not change the output. There are also job
properties that only affect certain types of media. To make it more likely that a matching job will
be found in TiesDb, Workflow Manager can be configured to ignore the previously mentioned job
properties when computing the job configuration hash.

The properties that should be ignored are specified in a JSON file. The
`data.ties.db.check.ignorable.properties.file` system property contains the path to the JSON file.
The JSON file must contain a list of objects with two properties: `ignorableForMediaTypes` and
`names`. `ignorableForMediaTypes` is a list of strings specifying which media types are able
to ignore the properties listed in the `names` list.

In the example below, the `VERBOSE` job property is never included in the job hash because all
media types are present in the `ignorableForMediaTypes` list. `ARTIFACT_EXTRACTION_POLICY`
is ignored when the media is audio or unknown. `FRAME_INTERVAL` appears in both the second
and third object, so it is ignorable when the media is audio, unknown, or image.
```json
[
  {
    "ignorableForMediaTypes": ["VIDEO", "IMAGE", "AUDIO", "UNKNOWN"],
    "names": ["VERBOSE"]
  },
  {
    "ignorableForMediaTypes": ["AUDIO", "UNKNOWN"],
    "names": ["ARTIFACT_EXTRACTION_POLICY", "FRAME_INTERVAL"]
  },
  {
    "ignorableForMediaTypes": ["IMAGE"],
    "names": ["FRAME_INTERVAL"]
  }
]
```

### Avoid Downloading Media

The SHA-256 hash of the job's media is also included when computing the job configuration hash.
If the job request contains the media's hash and MIME type, Workflow Manager can avoid downloading
the media if a match is found in TiesDB. If the media's hash and MIME type are not included in the
job request Workflow Manager will use the normal media inspection process to get that information.
If the media is not a local path, this will require Workflow Manager to download the media.

Below is an example of a job creation request that includes the media's hash and MIME type:
```json
{
  "algorithmProperties": {},
  "buildOutput": true,
  "jobProperties": {
    "S3_ACCESS_KEY": "xxxxxx",
    "S3_SECRET_KEY": "xxxxxx",
    "TIES_DB_URL": "https://tiesdb.example.com",
    "SKIP_TIES_DB_CHECK": "false"
  },
  "media": [
    {
      "mediaUri": "https://s3.example.com/bucket/my-video.mp4",
      "metadata": {
        "MEDIA_HASH": "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824",
        "MIME_TYPE": "video/mp4"
      }
    }
  ],
  "pipelineName": "OCV FACE DETECTION PIPELINE",
  "priority": 4
}
```

### S3 Copy

When the `TIES_DB_S3_COPY_ENABLED` job property or `ties.db.s3.copy.enabled` system property is
true and a matching job is found in TiesDb, Workflow Manager will copy the artifacts, markup,
and derivative media to the bucket specified in the current job's `S3_RESULTS_BUCKET` job property
or `s3.results.bucket` system property. Since the job's artifacts, markup, and derivative media
are in a new location, the output object must be updated before it is uploaded to the new S3 bucket.
In the updated output object, the `tiesDbSourceJobId` property will be set to the previous job's ID.
When the S3 copy is enabled and the results bucket is the same as the previous job, a new output
object is created, but copies of the artifacts, markup, and derivative media are not
created. If the S3 copy is disabled, `tiesDbSourceJobId` is not added because the original job's
output object is used without changes.

When performing the S3 copy, the [S3 job properties](Object-Storage-Guide#s3-object-storage) like
`S3_ACCESS_KEY` and `S3_SECRET_KEY` use the values from the current job and apply to the
destination of the copy. If the values for the S3 properties should be different for the source of
the copy, the properties prefixed with `TIES_DB_COPY_SRC_` can be set. If for a given property the
`TIES_DB_COPY_SRC_` prefixed version is not set, the non-prefixed version will be used.

For example, if a job is received with the following properties set:

- `S3_SECRET_KEY`=`new-secret-key`
- `S3_ACCESS_KEY`=`access-key`
- `TIES_DB_COPY_SRC_S3_SECRET_KEY`=`old-secret-key`

then, when accessing the previous job's results `access-key` will be used for the access key and
`old-secret-key` will be used for the secret key. When uploading the results to the new bucket,
`access-key` will be used for the access key and `new-secret-key` will be used for the secret key.

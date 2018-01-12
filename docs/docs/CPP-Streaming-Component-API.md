> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2017 The MITRE Corporation. All Rights Reserved.

# API Overview

In OpenMPF, a **component** is a plugin that receives jobs (containing media), processes that  media, and returns results.

The OpenMPF Streaming Component API currently supports the development of **detection components**, which are used detect objects in live RTSP or HTTP video streams.

Using this API, detection components can be built to provide:

* Detection (Localizing an object)
* Tracking (Localizing an object across multiple frames)
* Classification (Detecting the type of object and optionally localizing that object)

Each frame of the video is processed as it is read from the stream. After processing enough frames to form a segment (for example, 100 frames), the component starts starts processing the next segment. Like with batch processing, each segment read from the stream is processed independently of the rest. No detection or track information is carried over between segments. Tracks are not merged across segments.

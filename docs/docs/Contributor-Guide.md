> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2019 The MITRE Corporation. All Rights Reserved.

# High-level Overview

We're excited that you're considering contributing to the OpenMPF project! If you have any questions about the process or how to get involved, please feel free to send us an [e-mail](mailto:openmpf@googlegroups.com) with your question.

We encourage you to read the remainder of the guide as well as review the project's [License](https://github.com/openmpf/openmpf/blob/master/LICENSE) and other [Documentation](index.html).

The OpenMPF project consists of the following repositories:

 - [openmpf/openmpf](https://github.com/openmpf/openmpf)
 - [openmpf/openmpf-components](https://github.com/openmpf/openmpf-components)
 - [openmpf/openmpf-contrib-components](https://github.com/openmpf/openmpf-contrib-components)
 - [openmpf/openmpf-build-tools](https://github.com/openmpf/openmpf-build-tools)
 - [openmpf/openmpf-cpp-component-sdk](https://github.com/openmpf/openmpf-cpp-component-sdk)
 - [openmpf/openmpf-java-component-sdk](https://github.com/openmpf/openmpf-java-component-sdk)
 - [openmpf/openmpf-python-component-sdk](https://github.com/openmpf/openmpf-python-component-sdk) 
 - [openmpf/openmpf-projects](https://github.com/openmpf/openmpf-projects)

Work across the project is tracked using our [workboard](https://github.com/orgs/openmpf/projects/3).

# Contribution Guidelines

We welcome all contributions that are made in a good faith effort to meet the following criteria:

- In line with the spirit of the project. Refer to the [OpenMPF Overview](index.html).
- Addresses an issue in the issue tracker. If an issue doesn't exist yet, create one so that it can be discussed among the OpenMPF community.
- Functionally correct and logically sound. All code must pass a code review and round of regression tests.
- Designed to use existing interfaces, super classes, and utilities
- Makes use of well-known design patterns, polymorphism, and encapsulation where possible
- Employs best practices for integrating with the OpenMPF architecture. Refer to the [C++ Batch Component API](CPP-Batch-Component-API/index.html), [C++ Streaming Component API](CPP-Streaming-Component-API/index.html), and [Java Batch Component API](Java-Batch-Component-API/index.html).
- Employs [standard coding style](#coding-style) that is consistent with the rest of the project
- Sufficiently commented and, if necessary, comes with appropriate documentation
- Comes with sufficient test cases
- Does not introduce software vulnerabilities

# Code Merging Workflow

## Contributor Instructions

Perform the following instructions to create a feature branch off of develop, commit your changes, push your branch, and create a pull request. Before the pull request is accepted a Jenkins build must pass and an OpenMPF project administrator must review the changes. We do not have a public Jenkins server so a project administrator will have to start the build for you.

- Create a feature branch off of the latest version of develop
```
cd /path/to/repo
git checkout develop
git pull
git checkout -b <my-new-feature>
```
- Make Commits
```
git add .
git commit
```
- Push your feature branch.
```
git push -u origin <my-new-feature>
```
- Create a pull request.
 - Go to GitHub page for repo.
 - Click "New pull request"
 - Change the dropdown that says "base: master" to develop
 - Change the dropdown that says "compare: master" to your feature branch
 - If a message saying "Can’t automatically merge." appears to the right of the dropdowns, pull the latest version of develop, merge your feature branch with develop, and push it again:
```
git checkout develop
git pull
git checkout <my-new-feature>
git merge develop

# Fix conflicts
git add .
git commit
git push
```
  - Click on the gear next to "Reviewers" and select a reviewer
  - Click "Create pull request"
- Get approval
  - After creating the pull request you will see that the pull request says "Review required" and "Some checks haven't completed yet."
  - An OpenMPF project administrator will start a Jenkins build. Once the build completes, Jenkins will post a status check to the pull request.
    - If the Jenkins build passes, the pull request page will say "All checks have passed"
    - If the Jenkins build fails, a project administrator will provide further guidance.
  - An OpenMPF project administrator will review the pull request.
    - If the reviewer approves the changes, the reviewer will merge the change in to develop and close the pull request.
    - If the reviewer requests changes, you will need to make changes to your feature branch and push them. After you push your changes, the Jenkins status check will be reset. A project administrator will run another Jenkins build that will contain your most recent changes.

In order to be accepted and merged, pull requests need to comply with the [Contribution Guidelines](#contribution-guidelines). In cases where an issue is found, please refer to the reviewer's comments for more information on how to update your code. This review and acceptance process applies to all of the OpenMPF repositories, including the OpenMPF core and all of the OpenMPF components.

Large pull requests should be split up into smaller pull requests where possible. This will make it easier to review the code. In general, each pull request should add new functionality, update an existing feature, or fix a bug. We strive to keep the develop branch stable. If merging a smaller pull request will break the system before additional pull requests can be merged, then it's generally a better idea to merge one larger pull request.

Note that GitHub has a 100 MB file size limitation. There is currently no way to push files to any of the OpenMPF repositories that are larger than this size.

## Reviewer Instructions

- Go to the GitHub page for the pull request
- Click on the "Files changed"
- Review the code before you start a Jenkins build. You don't need to post your review comments immediately, but the Jenkins machine is on an internal network so for security you must review the code before you start the Jenkins build.
- After you have looked at the code, start an instance of the openmpf-github-with-pull-request Jenkins build.
-  If the Jenkins build fails, you will need to work with the developer to get the tests to pass.
- Checkout their branch locally to test it
```
git fetch
git checkout <new-feature>
```
- On the pull request page click "Add your review"
- Add comments
- Click the green "Review changes" dropdown
- If changes are necessary, click the radio button to "Request changes"
  - After the developer makes the necessary changes, go back to the pull request page
  - Review the changes
  - Start another instance of the openmpf-github-with-pull-request Jenkins build.
- If you are satisfied with the changes, click the "Review changes" dropdown
- Select the "Approve" radio button, and click "Submit review"
- Click "Squash and merge" on the pull request page
  - If you don't see a "Squash and merge" button, find the button that says "Merge pull request", click the upside down triangle on the right side of the button, select "Squash and merge"
- A text box showing the commit message will appear above the "Squash and merge button". Edit message if necessary.
- Click "Confirm squash and merge"
- A message will pop up saying "Pull request successfully merged and closed. You’re all set—the <my-new-feature> branch can be safely deleted."
- Click "Delete branch"
- Update the openmpf-projects' develop branch with the new changes:
```
cd openmpf-projects
git checkout develop
git pull
git submodule foreach 'git checkout develop'
git submodule foreach 'git pull'
git add .
git commit
git push
```

# Versioning a New Release

The decision to version a new release is based on the following factors:

- Changes have been made to the API which break backwards compatibility. Refer to the [Semantic Versioning Guide](http://semver.org).
- The system has been updated with major features and/or enhancements.
- The system has been updated to work with new versions of critical system dependencies, such as OpenCV and Spring.
- The packaging and/or deployment process has changed significantly.
- It's been a long time since the last release and many small updates have been made to the system.

When the OpenMPF team agrees that it's time to version a new release of the system, a project administrator will create a release branch in each repository off of the develop branch. The name of a release branch takes the form `r<major>.<minor>.<bugfix>`. For example, `r0.10.0`. Also, the first commit in the release branch will be tagged as release candidate 1. For example, `r0.10.0-rc1`. Beta testers will then have the opportunity to test the release candidate 1 code.

If a bug is found in the release candidate code, then developers should land the bug fix to the release branch via a pull request. Once it has landed, the most recent commit will be tagged as release candidate 2. For example, `r0.10.0-rc2`. Beta testers will then have the opportunity to test the release candidate 2 code. The release candidate number will increase by one each time bugs are fixed. The bug fix code should be merged into the develop branch after it lands to the release branch.

If no bugs are found in the release candidate code for a period of time (generally, a month) then the release candidate will be finalized. The release candidate branch for each repo will be merged into the master branch for that repo. That commit on the master branch will be tagged with the release number. For example, `r0.10.0`.

If a critical bug fix needs to be made to the master branch, this is known has a "hot fix". Developers should land a hot fix to the master branch via a pull request. Once the code lands, the commit will be tagged by incrementing the `<bugfix>` number. For example, `r0.10.1`. The bug fix code should be merged into the develop branch after it lands to the master branch.

Note that you should not use the `--no-ff` option when merging one branch into another. Doing so will make the commit history more verbose and difficult to follow.

This process is based on [GitFlow](https://datasift.github.io/gitflow/IntroducingGitFlow.html).

# Adding New Components

In general, a new component will initially go in the [openmpf-contrib-components](https://github.com/openmpf/openmpf-contrib-components) repository. That is a holding ground until it can be transitioned to the [openmpf-components](https://github.com/openmpf/openmpf-components) repository. To be a candidate for transition, it must meet the following criteria:

- Is strongly in line with the spirit of the project and there is a commitment to maintain and update the code as the project evolves
- Fully licensed under Apache 2.0 or a compatible license. All source code must be provided
- Comes with sufficient unit, system, and/or integration tests with a strong focus on regression testing

Note that new components should have a README.md file, LICENSE file, COPYING file, and optionally a NOTICE file. The LICENSE file should contain information about all of the licenses in the code base, including those licenses for code you didn't write.

# Coding Style

The following list of style guides provide a comprehensive explanation of some of the best coding practices for the programming languages used in the OpenMPF project:

- [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Google JavaScript Style Guide](https://google.github.io/styleguide/javascriptguide.xml)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)

Generally speaking, when writing new code, please refer to existing code in the repositories and match the style. Most style issues boil down to inconsistency. Not all of our code adheres to these style guidelines, but we are striving to improve it.

# Updating Online Documentation

Our [openmpf.github.io repo](https://github.com/openmpf/openmpf.github.io/tree/master) repo is forked from [Beautiful Jekyll](http://deanattali.com/beautiful-jekyll/). In general, everything within `openmpf.github.io/docs` is part of a Read the Docs subsite within our overall Beautiful Jekyll site.

<h2>Install Tools</h2>

To install `mkdocs` run:

```
pip install mkdocs
```

Note that you need version 0.16.0 or higher.

To install the Ruby bundler dependency management tool with the jekyll gem run:

```
sudo yum install ruby-devel
gem install bundler
bundle install
```

<h2>Updating Read the Docs</h2>

Use [mkdocs](http://www.mkdocs.org) to generate HTML files from Markdown (.md) files stored in `openmpf.github.io/docs/docs`. When modifying the files locally, run `mkdocs serve` within the `openmpf.github.io/docs` directory. That spawns a local webserver so that you can view changes to the docs in real time by browsing to <http://localhost:8000>. 

<h2>Updating Beautiful Jekyll</h2>

When making updates to our landing page, or any other page other than those that are part of Read the Docs, run `./build-site.sh` within the top-level `openmpf.github.io` directory to generate the HTML for those changes, and then run `./serve.sh` to spawn a local webserver so that you can view changes by browsing to <http://localhost:4000>. Note that unlike the `mkdocs serve` command explained above, this site is not updated in real time as you make changes to the source code.

<h2>Committing Changes</h2>

When your changes look good, make sure to run the `./build-site.sh` command explained above to generate the HTML site content. Commit all of the generated files and generate a pull request to merge them into the develop branch.

When a commit is made to the master branch on GitHub, the <https://openmpf.github.io/docs/site/> page will automatically update (often within 5 minutes).

# Maven To Git Service Bash Script

**This repo has been forked to be compatible with any git hosting service.**

## Description

Use simple bash script to create Maven repository on the GitHub. You can save multiple artifacts in the single repo.

1. Upload your artifacts to the GitHub using this script.
1. In your main project, add the URL provided by script as remote Maven repository.
1. Now you can add your dependencies in Maven or Gradle.

## Usage

To upload `path-to-jar.jar` to `https://gitlab.com/elte156/privateMavenRepo` as artifact `com.example:example:1.0.0`, follow the example below:

```bash
GROUP_ID=com.example \
ARTIFACT_ID=example \
VERSION=1.0.0 \
FILE=path-to-jar.jar \
PACKAGING=jar \
TMP_REPO=$HOME/.git2m2/elte156/privateMavenRepo \
REPO=https://gitlab.com/elte156/privateMavenRepo.git \
bash maven-publisher.sh
```

It could be also used to upload `aar`, just replace `PACKAGING=jar` with `PACKAGING=aar` and provide correct file name.

To specify dependencies for your artifact you should create custom `pom.xml` file. Then pass it as `POM=pom.xml` to the script variables.

## Troubleshooting

* Make sure you have public access to the GitHub repository.
* Use the URL provided by script as your Maven repo.

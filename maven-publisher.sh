#!/bin/bash

# GROUP_ID="[YOUR_GROUP_ID]"
# ARTIFACT_ID="[YOUR_ARTIFACT_ID]"
# VERSION=[ARTIFACT_VERSION]
# FILE=[PATH_TO_ARTIFACT]
# PACKAGING=[aar|jar]
# POM=[PATH_TO_POM_XML] (optional)
#
# TMP_REPO=[LOCAL_REPOSITORY_DIRECTORY]
# REPO=[REMOTE_REPOSITORY_HTTP]
#   OR
# GIT_OWNER="[GIT_OWNER]"
# GIT_REPO="[GIT_REPOSITORY_NAME]"
#
# Leave POM empty to use default.
# You can use POM to describe dependencies of your artifact.

if [ -z "$TMP_REPO" ]; then
    TMP_REPO="$HOME/.git2m2/$GIT_OWNER/$GIT_REPO"
fi

if [ -z "$REPO" ]; then
    REPO="https://github.com/$GIT_OWNER/$GIT_REPO"
fi

ensureLocalRepo()
{
    if [ -d "$TMP_REPO" ]; then
        echo "Pulling latest changed from $REPO into $TMP_REPO"
        pushd "$TMP_REPO"
        git pull
        popd
    else
        echo "Cloning from $REPO into $TMP_REPO"
        git clone "$REPO" "$TMP_REPO"
    fi
}

generateMavenArtifact()
{
    echo "Generating artifacts for $GROUP_ID/$ARTIFACT_ID/$VERSION from $FILE into $REPO"

    if [ -z "$POM" ]; then
        mvn deploy:deploy-file -DgroupId="$GROUP_ID" -DartifactId="$ARTIFACT_ID" \
            -Dversion="$VERSION" -Dfile="$FILE" -Dpackaging="$PACKAGING" -DgeneratePom=true -DcreateChecksum=true \
            -Durl="file://$TMP_REPO/.m2" -e
    else
        echo "Using POM file $POM:"
        cat "$POM"
        mvn deploy:deploy-file -DgroupId="$GROUP_ID" -DartifactId="$ARTIFACT_ID" \
            -Dversion="$VERSION" -Dfile="$FILE" -Dpackaging="$PACKAGING" -DgeneratePom=true -DcreateChecksum=true \
            -Durl="file://$TMP_REPO/.m2" -DpomFile="$POM" -e
    fi
    echo "Maven artifact successfully generated"
}

commitAndPushChanges()
{
    pushd "$TMP_REPO"

    echo "Adding all changes to git"
    git add -A
    git commit -m "Release $GROUP_ID/$ARTIFACT_ID version $VERSION"

    echo "Pushing to $REPO"
    git push

    popd
}

printRepoPath()
{
    echo "============================"
    echo "Your Maven Repo URL is $REPO/tree/master/.m2"
    echo "============================"
}

set -e
ensureLocalRepo
generateMavenArtifact
commitAndPushChanges
printRepoPath
set +e
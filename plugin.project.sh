#!/bin/sh

# VARIABLES
PROJECTS_DIR=projects
group_id=kikaha.sample
version=1.0.0-SNAPSHOT

project_configure(){
  mvn -f $1/${PROJECTS_DIR}/pom.xml
}

project_run(){
  expected_params 1 $@
  project_$@ || halt
}

project_create(){
  name=$1
  if [ "$artifact_id" = "" ]; then
    artifact_id=$1
  fi

  if [ -d "$artifact_id" ]; then
    warn "A module/project named `yellow $artifact_id` already exists. Override it?"
    warn "Press ENTER to Continue, Ctrl+C to abort."
    read null
    rm -rf $artifact_id
  fi

	mvn archetype:generate -B \
		-DarchetypeGroupId=io.skullabs.kikaha.archetypes \
		-DarchetypeArtifactId=${name}-archetype \
		-DarchetypeVersion=1.0.0 \
		-DgroupId=$group_id \
		-DartifactId=$artifact_id \
		-Dversion=$version
}

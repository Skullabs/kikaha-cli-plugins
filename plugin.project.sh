#!/bin/sh

PROJECTS_DIR=$PLUGIN_DIR/projects/

group_id=kikaha.sample
artifact_id=
version=1.0.0-SNAPSHOT

project_configure(){
  mvn -q -f $PROJECTS_DIR/pom.xml
}

project_run(){
  expected_params 1 $@
  project_$@ || halt
}

project_create(){
  for arg in $@; do
    name=`arg_name $arg`
    if [ ! "$name" = "${arg}" ]; then
      shift 1
      value=`arg_value $arg`
      export $name=$value
    fi
  done

  name=$1
  if [ "$artifact_id" = "" ]; then
    artifact_id=$1
  fi

	mvn archetype:generate -B \
		-DarchetypeGroupId=io.skullabs.kikaha.archetypes \
		-DarchetypeArtifactId=${name}-archetype \
		-DarchetypeVersion=1.0.0 \
		-DgroupId=$group_id \
		-DartifactId=$artifact_id \
		-Dversion=$version
}

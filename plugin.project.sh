#!/bin/sh

# VARIABLES
PROJECTS_DIR=projects

project_configure(){
  mvn -f $1/${PROJECTS_DIR}/pom.xml clean install
}

project_run(){
  expected_params 1 $@
  project_$@ || halt
}

project_create(){
  name=$1
  group_id=${group_id:-kikaha.sample}
  version=${version:-1.0.0-SNAPSHOT}
  artifact_id=${artifact_id:-$name}

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

  cd $artifact_id
  project_use_last
}

project_use_last(){
  latest_version=`curl -s https://raw.githubusercontent.com/Skullabs/kikaha/master/kikaha-project/version`
  project_use $latest_version
}

project_use(){
  expected_params 1 $@
  if [ ! -f "pom.xml" ]; then
    warn "Invalid project. No maven project found."
    info "Ensure that you choose a project folder that have a $(yellow pom.xml) file."
    debug "Current work directory: `pwd`"
    halt
  fi

  info "Setting up project to use Kikaha version $1"
  var_set pom.xml version $1
}

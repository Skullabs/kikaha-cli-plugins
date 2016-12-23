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
  template_name=$1
  name=${name:-$1}
  group_id=${group_id:-$name}
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
		-DarchetypeArtifactId=${template_name}-archetype \
		-DarchetypeVersion=1.0.0 \
		-DgroupId=$group_id \
		-DartifactId=$artifact_id \
		-Dversion=$version
}

project_use_last(){
  latest_version=`curl -s http://download.kikaha.io/stable-version`
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

project_add_dep(){
  SED_RE='\(\([^:]*\):\([^:]*\)\(:\(.*\)\)*\)'
  artifact_id=`echo $1 | sed "s/${SED_RE}/\3/"`
  group_id=`echo $1 | sed "s/${SED_RE}/\2/"`
  version=`echo $1 | sed "s/${SED_RE}/\5/"`

  if [ "$version" = "$1" ]; then
    dep=`cat <<EOF
    <dependency>
      <groupId>$group_id</groupId>
      <artifactId>$artifact_id</artifactId>
    </dependency>
EOF
`
  else
    dep=`cat <<EOF
    <dependency>
      <groupId>$group_id</groupId>
      <artifactId>$artifact_id</artifactId>
      <version>$version</version>
    </dependency>
EOF
`
  fi
  dep=$(echo $dep | sed 's/\//\\\//g')

  info "Adding $artifact_id ($group_id) at version $version as dependency"
  debug "Maven dependency :\n $dep"
  var_add pom.xml dependencies "$dep\n"
}

#!/bin/bash -x

GROUP=$1
SOURCE_GIT="gitlab02.dtdream.com"
DEST_GIT="gitlab05.dtdream.com"
SOURCE_TOKEN="$2"
DEST_TOKEN="$3"

function list_source_projects {
  group_id=`curl -s -k -H "PRIVATE-TOKEN: $SOURCE_TOKEN" https://$SOURCE_GIT/api/v3/groups?search=$GROUP | awk -F [:,] '{print $2}'`

  if test -z $group_id
  then
    echo -e "\e[1;31m!!!GROUP NOT FOUND: $GROUP\e[0m"
    exit 1
  fi

  curl -s -k https://$SOURCE_GIT/api/v3/groups/$group_id?private_token=$SOURCE_TOKEN | python -m json.tool | grep "http_url_to_repo" | awk -F [/.] '{print $7}'
}

function create_dest_project {
  repo=$1
  group_id=`curl -s -k -H "PRIVATE-TOKEN: $DEST_TOKEN" https://$DEST_GIT/api/v3/namespaces?search=$GROUP | awk -F [:,] '{print $2}'`

  if test -z $group_id
  then
    echo -e "\e[1;31m!!!GROUP NOT FOUND IN DEST: $GROUP\e[0m"
    exit 1
  fi

  res=`curl -s -k -H "Content-Type:application/json" https://$DEST_GIT/api/v3/projects?private_token=$DEST_TOKEN -d "{ \"name\": \"$repo\", \"namespace_id\": $group_id}"`
  if (echo $res | grep -q "has already been taken"); then
    echo -e "\e[1;33mWARN:$repo is already exist!\e[0m"
  fi
}

PROJECT_LIST=`list_source_projects`

if [ $? -ne 0 ];then
  echo -e "\e[1;31m${PROJECT_LIST}\e[0m"
  exit 1
fi

for prj in $PROJECT_LIST
do
  echo -e "\e[1;33mCreate project $prj on $DEST_GIT/$GROUP\e[0m"
  create_dest_project $prj
  echo -e "\e[1;33mClone project $prj from $SOURCE_GIT/$GROUP\e[0m"
  git clone --bare git@$SOURCE_GIT:$GROUP/${prj}.git
  cd ${prj}.git
  echo -e "\e[1;33mPush mirror to dest\e[0m"
  git push --mirror git@$DEST_GIT:$GROUP/${prj}.git
  cd ..
  rm -rf ${prj}.git
done
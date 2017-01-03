#!/bin/bash
root="/d/sources/leiming/leiming-cms"
targetMapper="$root/leimingtech-cms/src/main/java/com/leimingtech/cms/mapper/"
targetPo="$root/leimingtech-cms/src/main/java/com/leimingtech/cms/model/"
find $root/leimingtech-cms/src/main/java/com/leimingtech/cms/entity/ -regex ".*\.java"|while read j
do
	fileName=${j##*/}
	name=${fileName%Entity.java}
	name=${name%.java}
	models=("$root/leimingtech-core/src/main/java/com/leimingtech/core/model/Cms${name}Example.java $root/leimingtech-core/src/main/java/com/leimingtech/core/model/Cm${name}Example.java $root/leimingtech-core/src/main/java/com/leimingtech/core/model/Cms${name}.java $root/leimingtech-core/src/main/java/com/leimingtech/core/model/Cm${name}.java")
	mappers=("$root/leimingtech-core/src/main/java/com/leimingtech/core/dao/Cms${name}Mapper.java $root/leimingtech-core/src/main/java/com/leimingtech/core/dao/Cm${name}Mapper.java $root/leimingtech-core/src/main/resources/mapper/Cms${name}Mapper.xml $root/leimingtech-core/src/main/resources/mapper/Cm${name}Mapper.xml")
	let count=0
	for model in $models
	do
		[ -e $model ] && mv $model $targetPo && let count+=1
		#[ -e $model ] && rm $model && let count+=1
	done
	for mapper in $mappers
	do
		[ -e "$mapper" ] && mv $mapper $targetMapper && let count+=1
		#[ -e "$mapper" ] && rm $mapper && let count+=1
	done
	[ $count -ne 3 ] && echo "No mapper or persistent found for $fileName"
done
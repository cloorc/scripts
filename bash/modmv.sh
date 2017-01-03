#!/bin/bash
root="/d/sources/leiming/leiming-cms"
find . -regex ".*\.java"|while read f 
do
	grep "import com\.leimingtech\.cms\.entity\." $f|while read i
	do
		fileName=${i##*.}
		fileName=${fileName%;}
		name=${fileName%Entity;}
		name=${name%;}
		echo $name
		models=("$root/leimingtech-cms/src/main/java/com/leimingtech/cms/model/Cms${name}Example.java $root/leimingtech-cms/src/main/java/com/leimingtech/cms/model/Cm${name}Example.java $root/leimingtech-cms/src/main/java/com/leimingtech/cms/model/Cms${name}.java $root/leimingtech-cms/src/main/java/com/leimingtech/cms/model/Cm${name}.java")
		let count=0
		for model in $models
		do
			[ -e $model ] && {
				c=${model##*/java/}
				c=${c%.java}
				c=${c//\//.}
				sed -i "s/$i/import $c;/g" $f
				sed -i "s/$fileName/${c##*.}/g" $f
			} && let count+=1
		done
		[ $count -ne 1 ] && echo "No mapper or persistent found for $f"
	done
done
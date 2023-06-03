#!/bin/bash

subtree=$1
prevs=0
declare -a position
index=0

function repeat()
{
	local start=1
	local end=${1:-80}
	local str="${2:-=}"
	local range=$(seq $start $end)
	for i in $range ; do printf "${str}"; done
}
 

function dbg()
{
	return
	echo "$@" >&2
}

function explain()
{
	local arr=("$@")
	local t=${subtree}.${arr[@]}
	t=${t// /.}
	#echo "calling explaing on ${t}"
	kubectl explain "$t" | sed -n '/^DESCRIPTION:$/,/^FIELDS:$/{/^FIELDS:$/!p;}' | tr '\n' ' ' | sed 's/DESCRIPTION://'
 
}

fields=0
echo "$subtree"
while read -r	; do
	[ -z "$REPLY" ] && continue
	if [ $fields -eq 0 ] ; then
		[ x"$REPLY" == x'FIELDS:' ] && fields=1 
		continue
	fi
	line=`echo "$REPLY" | sed 's/  /\t/g'`
	leadspaces=`echo "$line" | awk -F '[^\t].*' '{print length($1)}'`
	keyword=`echo "$REPLY" | awk '{print $1}'`
	index=$((leadspaces))

	#if [ $leadspaces -gt $prevs ] ; then
	#	((index++))
	#	#echo "Index is $index"
	#	
	#elif [ $leadspaces -lt $prevs ] ; then
	#
	#	((index += $leadspaces/2))
	#	#((index--))
	#fi
	position[$index]=$keyword
	description=`explain "${position[@]:0:$((index))}"`
	tmp=${position[@]:0:$((index))}
	dbg "---- calling explain on ${tmp// /.}"

	prevs=$leadspaces

	dbg "INDEX: $index, LEADSPACE $leadspaces -$line-, keyword is $keyword, tab is ${position[@]}"

	repeat  $((index)) "\t" 

	echo "${position[$index]} ${description:0:500}"
done



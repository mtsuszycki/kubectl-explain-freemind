#!/bin/bash

subtree=$1
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
	dbg "calling explaing on ${t}"
	kubectl explain "$t" | sed -n '/^DESCRIPTION:$/,/^FIELDS:$/{/^FIELDS:$/!p;}' | tr '\n' ' ' | sed 's/DESCRIPTION://'
 
}

fields=0

description=`explain ""`
echo "$subtree $description"

while read -r	; do
	[ -z "$REPLY" ] && continue

	# skip all lines until "FIELDS:"
	if [ $fields -eq 0 ] ; then
		[ x"$REPLY" == x'FIELDS:' ] && fields=1 
		continue
	fi
	# kubectl explain uses 2 spaces as indent, convert them to 1 tabulator
	line=`echo "$REPLY" | sed 's/  /\t/g'`
	leadspaces=`echo "$line" | awk -F '[^\t].*' '{print length($1)}'`
	keyword=`echo "$REPLY" | awk '{print $1}'`
	index=$((leadspaces))

	position[$index]=$keyword

	# pass whole nesting to the explain so it can call kubectl explain pod.metadata.foo.bar etc.
	description=`explain "${position[@]:0:$((index))}"`
	tmp=${position[@]:0:$((index))}
	dbg "---- calling explain on ${tmp// /.}"

	dbg "INDEX: $index, LEADSPACE $leadspaces -$line-, keyword is $keyword, tab is ${position[@]}"

	# print correct number of tabulators, depending on the position in the tree
	repeat  $((index)) "\t" 

	echo "${position[$index]} ${description}"
done

 

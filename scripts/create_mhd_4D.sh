#!/bin/sh


write_mhd_4D()
{
  cat $orig | sed "s/NDims = .*/NDims = 4/
		  s/TransformMatrix = .*/TransformMatrix = 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1/
		  /Offset/ s/.*/& 0/
		  /CenterOfRotation/ s/.*/& 0/
		  s/AnatomicalOrientation = .*/AnatomicalOrientation = ????/
		  /ElementSpacing/ s/.*/& 1/
		  /DimSize/ s/.*/& $nbph/
		  s/ElementDataFile = .*/ElementDataFile = LIST/" > "$1/$file_name_4D"
  
  for ph in $listph
  do
    ph=`basename $ph`
    echo "$ph" >> "$1/$file_name_4D"
  done
}

#################################################
# create_mhd_4D 	argument : repertoire	#
#################################################
if [ $# -lt 1 ]
then
  echo "Usage: create_mhd_4D.sh DIRECTORY"
  exit 1
fi

nb_phase_file=`find $1 -maxdepth 1 -iname "*[0-9]*.mhd" -o -iname "*[0-9]*\]*.mhd" | wc -l`
if [ $nb_phase_file = 0 ]
then
  echo "Error: no phase found"
  exit 1
fi

########## CT #########

list_pattern=""
list_phase_file=`find $1 -maxdepth 1 -iname "*[0-9]*.mhd"`
for phase_file in $list_phase_file
do
  phase_file_name=`basename $phase_file`
  if [[ ! -z `echo "$phase_file_name" | grep ","` ]]
  then
    prefix=`echo $phase_file_name | sed "s/,_.*/,_/"`
  else
    prefix="NONE"
  fi
  if [[ -z `echo "$list_pattern" | grep "$prefix"` ]]
  then
    list_pattern="$list_pattern $prefix"
  fi
done


for pattern in $list_pattern
do

  if [ "$pattern" = "NONE" ]
  then
    pattern=""
  fi

  nbph=`find $1 -maxdepth 1 -iname "${pattern}*[0-9]*.mhd" | wc -l`
  orig=`find $1 -maxdepth 1 -iname "${pattern}*[0-9]*.mhd" | sort | head -n 1`
  listph=`find $1 -maxdepth 1 -iname "${pattern}*[0-9]*.raw" | sort`

  file_name_4D="${pattern}_4D.mhd"
  echo $file_name_4D

  write_mhd_4D $1

done


############ PET ###########

list_pattern=""
list_phase_file=`find $1 -maxdepth 1 -iname "*[0-9]*\]*.mhd"`
for phase_file in $list_phase_file
do
  phase_file_name=`basename $phase_file`
  if [[ ! -z `echo "$phase_file_name" | grep "[0-9]-.*\]"` ]]
  then
    prefix=`echo $phase_file_name | sed "s/.*[0-9]-/-/;s/\]_.*//"`
  else
    prefix="NONE"
  fi
  if [[ -z `echo "$list_pattern" | grep -- "$prefix"` ]]
  then
    list_pattern="$list_pattern $prefix"
  fi
done

  
for pattern in $list_pattern
do

  if [ "$pattern" = "NONE" ]
  then
    pattern=""
  fi

  nbph=`find $1 -maxdepth 1 -iname "*[0-9]${pattern}\]*.mhd" | wc -l`
  orig=`find $1 -maxdepth 1 -iname "*[0-9]${pattern}\]*.mhd" | sort | head -n 1`
  listph=`find $1 -maxdepth 1 -iname "*[0-9]${pattern}\]*.raw" | sort`
  
  file_name_4D=`basename "$orig" | sed "s/[0-9]${pattern}\]/${pattern}\]/;s/_.mhd/_4D.mhd/"`

  write_mhd_4D $1

done

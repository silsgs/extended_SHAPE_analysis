#! /bin/bash

# usage 
# ./simpre_sampling.sh

factors=($(seq 0.5 0.02 1.51))

# Define vars

## dir paths
dir=${PWD##*/}
dir_coords=$PWD/temp_coords
mkdir -p $dir_coords

## vars
n_coord1=${dir##*-}
n_coord=${n_coord1%_*}
fam=${dir%-*}

s=$(( 5 + ${n_coord} ))

## set enviro
rm -f *b20_sphe_res.txt


# Starts loop

for i in $( seq 0.5 0.02 1.51 )
do
# Read and transform z's from "simpre_$factor.dat" --- Reading sph coords
    x=$( awk '{printf "%12.7f\n", $1}' ${dir_coords}/spherical_${i}.dat )
    y=$( awk '{printf "%12.7f\n", $2}' ${dir_coords}/spherical_${i}.dat )
    z=$( awk '{printf "%12.7f\n", $3}' ${dir_coords}/spherical_${i}.dat )

    qs=$( awk 'NR>=5&&NR<'${s}'{printf "%10.5f\n", $5}' simpre_1.0.dat )
    index=($(seq 1 1 ${n_coord}))
    echo ${index[@]} 


# Construct new "simpre.dat" & "simpre_$i_sph.dat" coords
## initial
    rm -f simpre.dat
    sed -n '1,3p' simpre_1.0.dat >> simpre_${i}_sph.dat
    sed '4q;d' simpre_1.0.dat | sed 's/8/'${n_coord}'/' >> simpre_${i}_sph.dat

# coords
    paste -d" " <(printf '%s\n' "${index[@]}") <(printf '%s' "${x[@]}") <(printf '%s' "${y[@]}") <(printf '%s' "${z[@]}") <(printf '%s' "${qs[@]}")>> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat
    echo "" >> simpre_${i}_sph.dat

# Store simpre_${i}.dat at temp_coords
    cp simpre_${i}_sph.dat simpre.dat
    mv simpre_${i}_sph.dat ${dir_coords}/. 


# Run simpre
    gfortran -llapack simpre1.2.f ; ./a.out

    echo factor "${i}" >> ${fam}-b20_sphe_res.txt
    grep "   2   0 " simpre.out >> ${fam}-b20_sphe_res.txt

done



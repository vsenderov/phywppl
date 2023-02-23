#trees=("CC8" "Charadrii" "Columbidae" "Cuculidae" "Furnaridae" "Lari" "M1" "M4" "M5" "P2" "P7" "P10" "P13P14P16" "P17P18" "P20a" "P20b" "P21" "Phasianidae" "Picidae" "Procellariidae" "Psittacidae1" "Psittacidae2" "S2" "S6" "S7S8" "S9" "S11" "S13" "Scolopaci" "Strigidae" "Thamnophilidae" "TitTyranRest" "Trochilidae")
#rhos=(0.66 0.62 0.43 0.88 0.67 0.84 0.69 0.87 0.86 0.45 0.62 0.63 0.71 0.89 0.89 0.77 0.88 0.73 0.61 0.81 0.65 0.72 0.72 0.91 0.28 0.79 0.73 0.65 0.49 0.77 0.52 0.74 0.69 0.69)
#trees=("Ramphastidae" "S6")
#rhos=(0.65 0.91)
trees=("Lari" "P20a" "Thamnophilidae" "M6")
rhos=(0.84 0.89 0.74 0.77)

iters=1
parts=20000
prefix="posteriors"
interfix="1.5_2.0_1.5_1.0_0.05"

cd ..

# tdbda logz loop
for i in ${!trees[@]}; do
 dir=${prefix}_${trees[$i]}_${rhos[$i]}_${interfix}_tdbda_
 mkdir $dir
 echo "TDBD" $dir
 npm run wppl examples/tdbd-analytical.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts > logz.txt
 npm run wppl examples/tdbd-analytical-dist.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts
 echo "tdbda" > model.txt
 mv logz.txt model.txt tdbd.json $dir/
done

# crbda logz loop
pwd
for i in ${!trees[@]}; do
  dir=${prefix}_${trees[$i]}_${rhos[$i]}_${interfix}_crbda_
  mkdir $dir
  echo "CRBD" $dir
  npm run wppl examples/crbd-analytical.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts > logz.txt
  npm run wppl examples/crbd-analytical-dist.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts
  echo "crbda" > model.txt
  mv logz.txt model.txt crbd.json $dir/
done

for i in ${!trees[@]}; do
  mkdir ${trees[$i]}
done


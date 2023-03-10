trees=("jeremy_crbd" "jeremy_bdd")
rhos=(0.77 0.77)

iters=1
parts=20000
prefix="sims"
interfix="_"

cd ..

# tdbda logz loop
# for i in ${!trees[@]}; do
#  dir=${prefix}_${trees[$i]}_${rhos[$i]}_${interfix}_tdbda_
#  mkdir $dir
#  echo "TDBD" $dir
#  npm run wppl examples/tdbd-analytical.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts > logz.txt
#  npm run wppl examples/tdbd-analytical-dist.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts
#  echo "tdbda" > model.txt
#  mv logz.txt model.txt tdbd.json $dir/
# done

# crbda logz loop (with survivorship)
pwd
for i in ${!trees[@]}; do
  for j in {0..4}; do
    dir=${prefix}_${trees[$i]}_${rhos[$i]}_${interfix}_repl${j}_crbda_
    mkdir $dir
    echo "CRBD" $dir
    npm run wppl examples/crbd-analytical.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts > logz.txt
    npm run wppl examples/crbd-analytical-dist.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts
    echo "crbda" > model.txt
    mv logz.txt model.txt crbd.json $dir/
  done
done

# crbda logz loop (no survivorship with survivorship)
pwd
for i in ${!trees[@]}; do
  for j in {0..4}; do
    dir=${prefix}_${trees[$i]}_${rhos[$i]}_${interfix}_repl${j}_crbda_nosurv_
    mkdir $dir
    echo "CRBD no surv" $dir
    npm run wppl examples/crbd-analytical-nosurv.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts > logz.txt
    npm run wppl examples/crbd-analytical-dist-nosurv.wppl $iters ../data/${trees[$i]}.tre.phyjson ${rhos[$i]} $parts
    echo "crbda_nosurv" > model.txt
    mv logz.txt model.txt crbd.json $dir/
  done
done

for i in ${!trees[@]}; do
  mkdir ${trees[$i]}
done


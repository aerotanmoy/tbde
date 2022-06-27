start=`date +%s`

src_dir=/home/tbde/test/truedata-historical-data/JAN-22
trg_dir=/home/tbde/test/truedata-historical-data/transformed_files-JAN-22
 
src_fl_cnt=$(du $src_dir --inodes | cut -f1)
src_fl_cnt_rt=`expr $src_fl_cnt - 1`

mkdir -p $trg_dir 


cd $src_dir

for i in *FUT.csv; do
awk '
  function basename(file) {
    sub(".*/", "", file)
    sub(".csv", "", file)
    return file
  }
  {print basename(FILENAME) (NF?",":"") $0}' "$i" > "$trg_dir/$i" &
done &


for i in *PE.csv; do
awk '
  function basename(file) {
    sub(".*/", "", file)
    sub(".csv", "", file)
    return file
  }
  {print basename(FILENAME) (NF?",":"") $0}' "$i" > "$trg_dir/$i" &
done &

for i in *CE.csv; do
awk '
  function basename(file) {
    sub(".*/", "", file)
    sub(".csv", "", file)
    return file
  }
  {print basename(FILENAME) (NF?",":"") $0}' "$i" > "$trg_dir/$i" &
done &


trg_fl_cnt=0

while [ $trg_fl_cnt -le $src_fl_cnt_rt ]
do
  trg_fl_cnt=$(du $trg_dir --inodes | cut -f1)
  if [ $(pgrep awk | wc -l) -ge 1 ]
  then
	continue   #Go to next iteration of I in the loop and skip statements3
  fi
done 

cd -

echo "Duration: $((($(date +%s)-$start)/60)) min $((($(date +%s)-$start))) sec"
start=`date +%s`

src_dir=/home/tbde/test/truedata-historical-data/JAN-22
trg_dir=/home/tbde/test/truedata-historical-data/transformed_files-JAN-22
 
src_fl_cnt=$(du $src_dir --inodes | cut -f1)
src_fl_cnt_rt=`expr $src_fl_cnt - 1`

rm -r $trg_dir
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

rm /home/tbde/test/truedata-historical-data/transformed_files-JAN-22_merged/*

#cat /home/tbde/test/truedata-historical-data/transformed_files-JAN-22/*.csv > /home/tbde/test/truedata-historical-data/transformed_files-JAN-22_merged/merged.csv 

for f in /home/tbde/test/truedata-historical-data/transformed_files-JAN-22/*.csv; do cat "${f}" >> /home/tbde/test/truedata-historical-data/transformed_files-JAN-22_merged/merged.csv; done


echo "Duration for  File Manipulation : $((($(date +%s)-$start))) sec"

cd -

cd $trg_dir

start_bulk=`date +%s`


psqlcnt=$(pgrep psql | wc -l)

for i in /home/tbde/test/truedata-historical-data/transformed_files-JAN-22_merged/*.csv; do

sudo -u postgres psql postgres -f /home/tbde/script/copyscript.sql -v v1="$i"

done


echo "Duration for  File Ingestion : $((($(date +%s)-$start_bulk))) sec"

cd -

echo "Overall  Duration : $((($(date +%s)-$start))) sec"

start_transform=`date +%s`

sudo -u postgres psql postgres -f /home/tbde/script/transformscript.sql 

echo "Duration for  File Transformation : $((($(date +%s)-$start_transform))) sec"

echo "Overall  Duration : $((($(date +%s)-$start))) sec"

BEGIN {
  FS=",";
}
{
  if ($4 !~ /#/ && $5 !~ /#/) {
    start_array[NR]=$4;
    end_array[NR]=$5;
  }
}
END {

  printf "start = c("
  for (idx in start_array){
    if (NR == idx){
      printf "%d )\n", start_array[idx];
    } else {
      printf "%d, ", start_array[idx];
    }
  }

  printf "end = c("
  for (idx in end_array){
    if (NR == idx){
      printf "%d )\n", end_array[idx];
    } else {
      printf "%d, ", end_array[idx];
    }
  }

}

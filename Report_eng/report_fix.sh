#!/bin/bash
filter_script="filter_report.awk"
report_file=${1}
csv_file=${2}

if [ -z "${csv_file}"] || [ -z "${report_file}" ]
then
      echo "Pls, pass src and dest files: ./report_fix.sh src.txt dest.csv";
      # exit 0;
else
      #Fix csv file. Changes ", " to ". "
      #Should not do this, but it was easier than reading straight with awk
      sed -e 's/, /\. /g' ${report_file} > ${csv_file};
      #Removing any blank lines from $csv_file. Actlly it DOES need to override the csv_file
      sed -i '/^[[:space:]]*$/d' ${csv_file};

      #Filtering csv and getting start and end times
      #(runs an AWK script)
      awk -f ${filter_script} ${csv_file}
fi

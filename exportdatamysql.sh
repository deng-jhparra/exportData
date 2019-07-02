
#!/bin/bash
# multicsv_export.sh : A utility to export all tables in a given schema to csv files
# Craig Waterman : @ckh2oman : craigwaterman@gmail.com
# Modificado : Jesus Parra. 

# Enter the name of your database here.
echo -n "Nombre de la base de datos a exportar : "
read schema

# Colocar contraseña de root
echo -n "Clave del usuario root : "
read pass

# This is the target for all script output
# IMPORTANT: mysql must have write permissions to this directory.
where="/tmp/mysql_csv_dump"


for table in $(mysql -uroot -p$pass $schema -Be "SHOW tables" | sed 1d); do

  # Clean up, just in-case.
  rm -f $where/$table.csv
  rm -f $where/data.txt

  echo Exporting $table

  # Get our column list; awk off the first column; convert to comma delim; remove the trailing comma;
  mysql $schema -uroot -p$pass -s -e "show columns from $table" | awk '{print $1}' | tr '\n' ';' | awk '{print substr($1, 0, length($1)-1)}' > $where/$table.csv

  # Output CSV content via mysql's "into outfile"
  mysql $schema -uroot -p$pass -e "select * from $table into outfile \"$where/data.txt\" fields terminated by \";\" optionally enclosed by '\"'"

  # Combine our column names and data (mysql won't append to files directly)
  cat $where/data.txt >> $where/$table.csv

  # Remove data.txt for the next iteration
  rm -f $where/data.txt

done
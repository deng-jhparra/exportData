DECLARE @bd VARCHAR(20) = 'BDNBS';
DECLARE @tabla AS nvarchar(50)
DECLARE @sql AS nvarchar(4000)
DECLARE Tabla CURSOR FOR SELECT TABLE_NAME  FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' ORDER BY TABLE_NAME
OPEN Tabla
FETCH NEXT FROM Tabla INTO @tabla
WHILE @@fetch_status = 0
BEGIN
   SET @sql = 'SQLCMD -S localhost -d ' + @bd + ' -E -Q "SELECT * FROM ' + @tabla + '" -o "D:\cvs\' + @bd + '\' + @tabla + '.csv" -W -w 1024 -s"|"'  
   PRINT @sql;
   FETCH NEXT FROM Tabla INTO @tabla
END
CLOSE Tabla
DEALLOCATE Tabla
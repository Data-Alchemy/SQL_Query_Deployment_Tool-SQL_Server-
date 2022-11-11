With Columns_Metadata as 
			(
			Select 
			TABLE_CATALOG														as Table_Catalog	
			,TABLE_SCHEMA														as Table_Schema		 
			,Table_Name															as Table_Name		
			,STUFF(
			(SELECT ',' + COLUMN_NAME
			 FROM [INFORMATION_SCHEMA].[COLUMNS] stf 
			  where stf.TABLE_NAME = tc.TABLE_NAME  
			  FOR XML PATH ('')), 1, 1, '')										as Column_List
			,STUFF(
					(SELECT ',' + DATA_TYPE 
					FROM [INFORMATION_SCHEMA].[COLUMNS] stf  
					where stf.TABLE_NAME = tc.TABLE_NAME 
					FOR XML PATH ('')), 1, 1, '')								as Data_Type
			,'{"type": "TabularTranslator", "mappings":['+STUFF(
					(SELECT '{{"source":{"name":"' + COLUMN_NAME 
						+'"},"sink":{"name":"'+COLUMN_NAME+'"}},' 
					FROM [INFORMATION_SCHEMA].[COLUMNS] stf  
					where stf.TABLE_NAME = tc.TABLE_NAME
					 FOR XML PATH ('')), 1, 1, '')+']}'							as Column_Mapping,
			count(1) as Column_Count
			from [INFORMATION_SCHEMA].[COLUMNS] tc
			group by TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME
			),

			Constraints as 
			 (
			 Select 
			 STUFF(
				(SELECT  ',' +  Constraint_Name 
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS stf 
				where stf.TABLE_NAME = tc.TABLE_NAME 
					and constraint_type = 'PRIMARY KEY' 
				FOR XML PATH ('')), 1, 1, '')									as Primary_Keys
			,STUFF(
				(SELECT  ',' +  Constraint_Name 
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS stf 
				where stf.TABLE_NAME = tc.TABLE_NAME 
					and constraint_type = 'FOREIGN KEY'  
				FOR XML PATH ('')), 1, 1, '')									as Foreign_Keys
				,TABLE_NAME
			   FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
			   group by TABLE_NAME
				),

			Record_Counts as (
			    SELECT
				SCHEMA_NAME(A.schema_id)	AS TABLE_SCHEMA 
				,A.Name						AS TABLE_NAME
				, SUM(B.rows)				AS RecordCount 
				, Max(A.Modify_date)		AS Modified_Date 
				, Max(A.create_date)		AS Created_Date 
				 FROM sys.objects A  
				INNER JOIN sys.partitions B ON A.object_id = B.object_id
				WHERE A.type = 'U' or    A.type = 'V'
				GROUP BY A.schema_id, A.Name 
			)

			Select 
			row_number() over(order by rc.Created_Date asc) as Key_Id

			,c.*
			,rc.RecordCount
			,rc.Created_Date
			,rc.Modified_Date
			,cn.Primary_Keys
			,cn.Foreign_Keys
			,case 
				when COALESCE(s.type_desc,'TABLE') not like '%VIEW%' 
					then 'TABLE' else 'VIEW' 
			end as Object_Type
			
			 from Columns_Metadata c
			left join sys.views s on c.TABLE_NAME = s.name
			Left join Constraints cn on cn.TABLE_NAME = c.TABLE_Name
			left join Record_Counts rc on rc.Table_Name = c.Table_Name
				and rc.Table_Schema = c.Table_Schema
# SQL-Server-Deployment-Tool

## Tool Usage


1. Clone repo 
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Add your sql script to the query.sql file
4. Add file to your git environment (`git add *`) 
4. Commit your changes (`git commit -am 'What i am planning to execute and why'`)
5. Push to the branch (`git push origin feature/fooBar`)
6. Create a new Pull Request


### SQLCMD Overview

The sqlcmd utility lets you enter Transact-SQL statements, system procedures, and script files through a variety of available modes:

At the command prompt.
In Query Editor in SQLCMD mode.
In a Windows script file.
In an operating system (Cmd.exe) job step of a SQL Server Agent job.
The utility uses ODBC to execute Transact-SQL batches.

`sqlcmd` comes with several built-in commands. 
More information can be found about this tool on the following [Microsoft documentation link](https://learn.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver16)

### Basic Syntax 
sqlcmd
```
   -a packet_size
   -A (dedicated administrator connection)
   -b (terminate batch job if there is an error)
   -c batch_terminator
   -C (trust the server certificate)
   -d db_name
   -D
   -e (echo input)
   -E (use trusted connection)
   -f codepage | i:codepage[,o:codepage] | o:codepage[,i:codepage]
   -g (enable column encryption)
   -G (use Azure Active Directory for authentication)
   -h rows_per_header
   -H workstation_name
   -i input_file
   -I (enable quoted identifiers)
   -j (Print raw error messages)
   -k[1 | 2] (remove or replace control characters)  
   -K application_intent  
   -l login_timeout  
   -L[c] (list servers, optional clean output)  
   -m error_level  
   -M multisubnet_failover  
   -N (encrypt connection)  
   -o output_file  
   -p[1] (print statistics, optional colon format)  
   -P password  
   -q "cmdline query"  
   -Q "cmdline query" (and exit)  
   -r[0 | 1] (msgs to stderr)  
   -R (use client regional settings)  
   -s col_separator  
   -S [protocol:]server[instance_name][,port]  
   -t query_timeout  
   -u (unicode output file)  
   -U login_id  
   -v var = "value"
   -V error_severity_level
   -w screen_width
   -W (remove trailing spaces)
   -x (disable variable substitution)
   -X[1] (disable commands, startup script, environment variables, optional exit)
   -y variable_length_type_display_width
   -Y fixed_length_type_display_width
   -z new_password
   -Z new_password (and exit)
   -? (usage)
   ```




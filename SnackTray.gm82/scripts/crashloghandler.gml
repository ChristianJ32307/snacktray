var kek;
directory_create(working_directory+"\"+global.crashdir)
if (global.debug) kek=" - debug" else kek=""
file_rename("game_errors.log",working_directory+"\"+global.crashdir+current_date_filename()+kek+".txt")

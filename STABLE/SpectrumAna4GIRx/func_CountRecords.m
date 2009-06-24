function [ num_records ] = func_CountRecords(record_size, fid)

 ch_length = zeros(3,1);
 fseek(fid,0,1); %% EOF
 file_length_bytes = ftell(fid); %% file length in bytes
 
 num_records = file_length_bytes / record_bytes; %% number of records
 missing_records = record_size*3 - num_records;
 
 fseek(fid,0,-1);
 
 for ii = 1:1:num_records
     fseek(fid, 30, 0); 
     %%% 30 = 26 + 4 : (length of header+length of timestamp)
     
     chid = fread(fid,1,'int16'); %%channel id, (2 bytes)
     
     switch chid
         case {1}
             ch_length(1) = ch_length(1) + 1;
         case {2}
             ch_length(2) = ch_length(2) + 1;
         case {3}
             ch_length(3) = ch_length(3) + 1;
     end%% swtich chid
     
 end%% for num_records
function [hdr,rhdr,dp,du,cp,np,seconds1] = drrad(filename,channel,temp2)

fid=fopen(filename);
hdr=    fread(fid,4,'char');
year=   fread(fid,1,'int');
month=   fread(fid,1,'int');
day=   fread(fid,1,'int')
hour=   fread(fid,1,'int')
minutes=   fread(fid,1,'int')
second=   fread(fid,1,'int');
nsecond=   fread(fid,1,'int');
record_size=   fread(fid,1,'int');
record=    fread(fid,1,'int');
freq=   fread(fid,1,'int');
sfreq=  fread(fid,1,'int');
samples_to_collect=   fread(fid,1,'int');
fclose(fid);
record_bytes=4*(samples_to_collect+13);
%record_size=2;
year
month
day
hour
minutes

hdr=0;
rhdr=0;
dp=0;
np=0;
nu=0;
cp=0;


du=zeros(record_size,samples_to_collect);
I=zeros(record_size,samples_to_collect);
Q=zeros(record_size,samples_to_collect);
hours1=zeros(record_size,1);
minutes1=zeros(record_size,1);
seconds1=zeros(record_size,1);
nseconds1=zeros(record_size,1);

fid=fopen(filename);
im=sqrt(-1);
if channel==1
elseif channel==2
    fseek(fid,record_bytes,0);
elseif channel==3
    fseek(fid,2*record_bytes,0);
end
for i=1:record_size
    i
    hdr1=    fread(fid,4,'char');
    year1=   fread(fid,1,'int');
    month1=   fread(fid,1,'int');
    day1=   fread(fid,1,'int');
    hours1(i)=   fread(fid,1,'int');
    minutes1(i)=   fread(fid,1,'int');
    seconds1(i)=   fread(fid,1,'int');
    nseconds1(i)=   fread(fid,1,'int');
    record_size1=   fread(fid,1,'int');
    record1=    fread(fid,1,'int');
    freq1=   fread(fid,1,'int');
    sfreq1=  fread(fid,1,'int');
    samples_to_collect1=   fread(fid,1,'int');
    for j=1:samples_to_collect
        du(i,j)=fread(fid,1,'int16')+im*fread(fid,1,'int16');
    end
    fseek(fid,2*record_bytes,0);

end
seconds1=60*minutes1+seconds1+1e-9*nseconds1;
fclose(fid);
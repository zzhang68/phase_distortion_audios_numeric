function [file_out] = getFileName(file)
   loc = 0;
   loc2 = 1;
   count =1;
   tmp = 0;
   for i = 1:length(file)-2
       if file(i:i+2) == 'Mix'
           loc = i+2;
           for j = loc:length(file)-1
               if file(j) == '_'
                   loc2(count) = j+1;
                   count = count+1;
               end
           end
       end     
       file_out = file(loc2(1):length(file)-4);     
   end
end

% Function to extract clean file names from testing mixture files
% 0dB_Mix_S_57_03.wav
% 0dB_Mix_h1.wav
% 5dB_Mix_l12s02.wav
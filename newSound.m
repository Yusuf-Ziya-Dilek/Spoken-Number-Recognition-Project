function soundFinal = newSound(soundData,threshold)
result = ones(1,16384).* mean(soundData);
count1 =1;
count2 = 0;
bool = 0;
for i=1:length(soundData)    
    if bool == 0
       if abs(soundData(i) -mean(soundData)) > threshold 
           count2 = count2 + 1;
       end

       if count2 > 10
          bool = 1; 
       end
    end   
    
    if bool == 1
        if count1 < 16385
        result(count1) = soundData(i);
        count1 = count1 +1;
        else
            break;
        end
    end        
end
soundFinal = result;
end
           







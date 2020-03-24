close all
clear all
clc
tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PART 1: MAKING A DATABASE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Downoading following files
%myDir = uigetdir; 
myDir = '\letters';
myFiles = dir(fullfile(myDir,'*.wav')); 
wyniki=zeros(length(myFiles),5);

for cnt = 1:length(myFiles)
  baseFileName = myFiles(cnt).name;
  fullFileName = fullfile(myDir, baseFileName);
  
  %Reading signals
   [x1, Fs] = audioread(fullFileName);
   L = length(x1(:, 1));
   
   %Setting spectrums' moments
   [M0,wyniki(cnt,4),wyniki(cnt,5),M3,M4, Kurtoz, Skos] = obliczoblicz(x1(:, 1),Fs);
   
   %FFT
    Y = fft(x1);
    P2 = abs(Y/L);
    P1 = P2(1:uint16(L/2+1));
    P1(2:end-1) = 2*P1(2:end-1);
    P1 = P1(1:uint16(0.15*length(P1)));
    f = Fs*(0:(L/2))/L;
    f = f(1:uint16(0.15*length(f)));
    
    %Assesing sig. to a group by its name
    name = strsplit(baseFileName, {'_','.'});
    numb = str2num(cell2mat(name(2)));

    %Finding and sorting maxes
    [pks,locs] = findpeaks(P1');
    pks = [pks Fs*locs/L];
    pks(:,2)=uint16(pks(:,2));
    pksy = sortrows(pks,1, 'descend');
  
    %Rejecting pikes lying too close to the maxes
    for ocnt = 1:10
     for icnt=ocnt+1:length(pksy) 
         if abs(pksy(icnt,2)-pksy(ocnt,2))<50
            pksy(icnt, 1) = 0;
         end        
     end
     pksy = sortrows(pksy,1, 'descend');
    end 
    reslt = pksy(1:10,:);
    reslt = sortrows(reslt,2, 'ascend');
    
%Drawing single signals on a plain as a point 
    %%vowel a
if numb > 0 && numb < 4
   if ~isempty(reslt(reslt(:,2) > 600 & reslt(:,2) < 1050,2))
       wyniki(cnt, 1) = wyb_max(reslt, 600,1050);
   end
   if ~isempty(reslt(reslt(:,2) > 1000 & reslt(:,2) < 1700,2))
        wyniki(cnt, 2) = wyb_max(reslt, 1000,1700);
   end
   
   if wyniki(cnt, 2) ~= 0 && wyniki(cnt, 1) ~= 0   
        figure(1)
        scatter(wyniki(cnt, 1),wyniki(cnt, 2),'o', 'c') 
        hold on
   end
   wyniki(cnt, 3) = 1; 
    figure(2)
    scatter(wyniki(cnt, 4),wyniki(cnt, 5),'o', 'c') 
    hold on
end 
%%vowel u
if numb > 3 && numb < 7
    if ~isempty(reslt(reslt(:,2) > 200 & reslt(:,2) < 400,2))
         wyniki(cnt, 1) = wyb_max(reslt, 200,400);
   end
   if ~isempty(reslt(reslt(:,2) > 450 & reslt(:,2) < 850,2))
        wyniki(cnt, 2) = wyb_max(reslt, 450, 850);
   end
   
   if wyniki(cnt, 2) ~= 0 && wyniki(cnt, 1) ~= 0
       figure(1)
       scatter(wyniki(cnt, 1),wyniki(cnt, 2),'x', 'r')
       hold on
   end
   wyniki(cnt, 3) = 2;
       figure(2)
       scatter(wyniki(cnt, 4),wyniki(cnt, 5),'x', 'r')
       hold on
end
%%vowel e
if numb > 6 && numb < 10
    if ~isempty(reslt(reslt(:,2) > 500 & reslt(:,2) < 650,2))
       wyniki(cnt, 1) = wyb_max(reslt, 500,650);
   end
   if ~isempty(reslt(reslt(:,2) > 1300 & reslt(:,2) < 2300,2))
        wyniki(cnt, 2) = wyb_max(reslt, 1300,2300);
   end
   
   if wyniki(cnt, 2) ~= 0 && wyniki(cnt, 1) ~= 0
      figure(1)
      scatter(wyniki(cnt, 1),wyniki(cnt, 2),'d', 'g') 
      hold on
   end
   wyniki(cnt, 3) = 3;
      figure(2)
      scatter(wyniki(cnt, 4),wyniki(cnt, 5),'d', 'g') 
      hold on
end
%%vowel i
if numb > 9 && numb < 13
    if ~isempty(reslt(reslt(:,2) > 150 & reslt(:,2) < 350,2))
       wyniki(cnt, 1) = wyb_max(reslt, 150,350);
   end
   if ~isempty(reslt(reslt(:,2) > 1900 & reslt(:,2) < 3000,2))
        wyniki(cnt, 2) = wyb_max(reslt, 1900,3000);
   end
   
   if wyniki(cnt, 2) ~= 0 && wyniki(cnt, 1) ~= 0
       figure(1)
       scatter(wyniki(cnt, 1),wyniki(cnt, 2),'h', 'm') 
       hold on
   end
   wyniki(cnt, 3) = 4;
    figure(2)
    scatter(wyniki(cnt, 4),wyniki(cnt, 5),'h', 'm') 
    hold on
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PART 2: RECOGNIZING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Downoading following files 
myDir = '\samples';
myFiles = dir(fullfile(myDir,'*.wav')); 
probki=zeros(length(myFiles),5);

for cnt = 1:length(myFiles)
  baseFileName = myFiles(cnt).name;
  fullFileName = fullfile(myDir, baseFileName);
  
  %Reading signals
   [x1, Fs] = audioread(fullFileName);
   L = length(x1(:, 1));
   
   [M0,probki(cnt,4),probki(cnt,5),M3,M4, Kurtoz, Skos] = obliczoblicz(x1(:, 1),Fs);

   %FFT
    Y = fft(x1);
    P2 = abs(Y/L);
    P1 = P2(1:uint16(L/2+1));
    P1(2:end-1) = 2*P1(2:end-1);
    P1 = P1(1:uint16(0.15*length(P1)));
    f = Fs*(0:(L/2))/L;
    f = f(1:uint16(0.15*length(f)));
    
    %Finding and sorting maxes
    [pks,locs] = findpeaks(P1');
    pks = [pks Fs*locs/L];
    pks(:,2)=uint16(pks(:,2));
    pksy = sortrows(pks,1, 'descend');
  
    %Rejecting pikes lying too close to the maxes
    for ocnt = 1:10
     for icnt=ocnt+1:length(pksy) 
         if abs(pksy(icnt,2)-pksy(ocnt,2))<50
            pksy(icnt, 1) = 0;
         end
        
     end
     pksy = sortrows(pksy,1, 'descend');
    end 
    reslt = pksy(1:10,:);
    F0 = reslt(1,2);
    reslt = sortrows(reslt,2, 'ascend');
    
    probki(cnt, 1) = wyb_max(reslt, F0,1000);
    probki(cnt, 2) = wyb_max(reslt,  probki(cnt, 1),2500);
    
    figure(1)
    scatter(probki(cnt, 1),probki(cnt, 2),'x', 'b') 
    hold on
   
    figure(2)
    scatter(probki(cnt, 4),probki(cnt, 5),'x', 'b') 
    hold on
end

figure(1)
title('Wykres formantow F1 i F2');xlabel('F1');ylabel('F2');
hold off
figure(2)
title('Wykres momentow widma M1 i M2');xlabel('M1');ylabel('M2');
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PART 3: NORMALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Matrix of normalized features of model group
%Col 1 - feat. F1, 2 feat - F2, 3 - class, 4 - feat. M1, 5 - feat. M2
nwyniki= zeros(length(wyniki),5);
%Normalization
nwyniki(:,1) = (wyniki(:,1)-min(wyniki(:,1)))/(max(wyniki(:,1))-min(wyniki(:,1)));
nwyniki(:,2) = (wyniki(:,2)-min(wyniki(:,2)))/(max(wyniki(:,2))-min(wyniki(:,2)));
nwyniki(:,3) = wyniki(:,3);
nwyniki(:,4) = (wyniki(:,4)-min(wyniki(:,4)))/(max(wyniki(:,4))-min(wyniki(:,4)));
nwyniki(:,5) = (wyniki(:,5)-min(wyniki(:,5)))/(max(wyniki(:,5))-min(wyniki(:,5)));

%Drawing on plains normalized feat. F1 i F2 and separately feat. M1 i M2
for cnt = 1:length(nwyniki)
    if nwyniki(cnt,3) == 1
        figure(3)
        scatter(nwyniki(cnt, 1),nwyniki(cnt, 2),'o', 'c') 
        hold on
        figure(4)
        scatter(nwyniki(cnt, 4),nwyniki(cnt, 5),'o', 'c') 
        hold on
    end
    if nwyniki(cnt,3) == 2
        figure(3)
        scatter(nwyniki(cnt, 1),nwyniki(cnt, 2),'x', 'r')
        hold on
        figure(4)
        scatter(nwyniki(cnt, 4),nwyniki(cnt, 5),'x', 'r')
        hold on
    end
    if nwyniki(cnt,3) == 3
        figure(3)
        scatter(nwyniki(cnt, 1),nwyniki(cnt, 2),'d', 'g') 
        hold on
        figure(4)
        scatter(nwyniki(cnt, 4),nwyniki(cnt, 5),'d', 'g') 
        hold on
    end
    if nwyniki(cnt,3) == 4
        figure(3)
        scatter(nwyniki(cnt, 1),nwyniki(cnt, 2),'h', 'm')
        hold on
        figure(4)
        scatter(nwyniki(cnt, 4),nwyniki(cnt, 5),'h', 'm')
        hold on
    end
end

%Matrix of normalized features of identified group
nprobki = zeros(length(probki),5);
nprobki(:,1) = (probki(:,1)-min(wyniki(:,1)))/(max(wyniki(:,1))-min(wyniki(:,1)));
nprobki(:,2) = (probki(:,2)-min(wyniki(:,2)))/(max(wyniki(:,2))-min(wyniki(:,2)));
nprobki(:,4) = (probki(:,4)-min(wyniki(:,4)))/(max(wyniki(:,4))-min(wyniki(:,4)));
nprobki(:,5) = (probki(:,5)-min(wyniki(:,5)))/(max(wyniki(:,5))-min(wyniki(:,5)));
%Drawing in to plains with nomalized model, feats. of identified group
for cnt = 1:length(nprobki)    
    figure(3)
    scatter(nprobki(cnt, 1),nprobki(cnt, 2),'x', 'b') 
    hold on
    figure(4)
    scatter(nprobki(cnt, 4),nprobki(cnt, 5),'x', 'b') 
    hold on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PRAT 4: RECOGNIZING 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Matrice of classes spectral centroids
SC = zeros(4,5);
z = zeros(1,4);
%Counting classes spectral centroid
for cnt = 1:length(nwyniki)
  for cnt2 = 1:4
    if nwyniki(cnt, 3) == cnt2 && nwyniki(cnt, 2) ~= 0 && nwyniki(cnt, 1) ~= 0 
   SC(cnt2,1) =  SC(cnt2,1) + nwyniki(cnt, 1);
   SC(cnt2,2) =  SC(cnt2,2) + nwyniki(cnt, 2);
   SC(cnt2,4) =  SC(cnt2,4) + nwyniki(cnt, 4);
   SC(cnt2,5) =  SC(cnt2,5) + nwyniki(cnt, 5);
   z(cnt2) = z(cnt2)+1;
    end
  end
end
SC(1,:)=SC(1,:)/z(1);
SC(2,:)=SC(2,:)/z(2);
SC(3,:)=SC(3,:)/z(3);
SC(4,:)=SC(4,:)/z(4);

%Drawing in to plains with nomalized model, feats. spectral centroids of every class
for cnt = 1:4
    figure(3)
    scatter(SC(cnt, 1),SC(cnt, 2),'s', 'k') 
    hold on
    figure(4)
    scatter(SC(cnt, 4),SC(cnt, 5),'s', 'k') 
    hold on
end
figure(3)
title('Wykres znormalizowanych formantow F1 i F2');xlabel('F1');ylabel('F2');
hold off
figure(4)
title('Wykres znormalizowanych momentow widma M1 i M2');xlabel('M1');ylabel('M2');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PART 5: COMPUTING METRICES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ME = zeros(length(nprobki),4);
for cnt = 1:length(nprobki)
    %NY metrics for 4 feats.
    for cnt2 = 1:4
     ME(cnt, cnt2) = sqrt(sqrt((SC(cnt2,1)-nprobki(cnt,1))^4+(SC(cnt2,2)-nprobki(cnt,2))^4+(SC(cnt2,4)-nprobki(cnt,4))^4+(SC(cnt2,5)-nprobki(cnt,5))^4));
    end
    
    %Assesing class of object
    [w, id] = min(ME(cnt,:));
    if id == 1
         fprintf('Probka nr %d to litera a.\n\n', cnt);
    end
    if id == 2
         fprintf('Probka nr %d to litera u.\n\n', cnt);
    end
    if id == 3
         fprintf('Probka nr %d to litera e.\n\n', cnt);
    end
    if id == 4
         fprintf('Probka nr %d to litera i.\n\n', cnt);
    end
end

toc

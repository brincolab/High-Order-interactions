%{ 
Code description: 
Example to use high_order() function to compute S-Information, O-Information, and characterize the High-order interactions among 3 variables governed by Redundancy or Synergy.
We compute the measures for 8 subjects, but we do not attach the data

Input: - 'data': Matrix with dimensionality (T, N), where N=20 is the number of brain regions or modules, and T=159 is the number of samples.
       - 'n': n=3 is the number of interactions among triplets. 

Output: - 'Red': Matrix with dimension (8,20), with the redundancy values per subject and per module
        - 'Syn': Matrix with dimension (8,20), with the synergy values per subject and per module
        - 'Oinfo': O-Information for all the triplets.
        - 'Sinfo': S-Information for all the triplets

@author: Marilyn Gatica, marilyn.gatica@postgrado.uv.cl
%}
Npatients=8;%number of subjects
Modules=20;%number of modules or brain regions. In out case we use the BHA parcelation with 20 modules, https://github.com/compneurobilbao/bha.git
Red=zeros(Npatients,Modules);%matrix to save the redundant values, per patient and per module
Syn=zeros(Npatients,Modules);%matrix to save the synergy values, per patient and per module
%% input data Path
inPath='C:\Users\maril\Desktop\InteractionInformation\TS20_original\';%Path files
%% Per subject: Estimate Oinfo, Sinfo for each triplet and Redundancy and Synergy per module.
n=3;
tic;
outPath=sprintf('High-OrderN%i',n);%output data name
mkdir(sprintf('./%s',outPath))%create the folder
for patient=1:Npatients
        dataPatient=load(sprintf('%sts_20_young_%.3d.txt',inPath,patient)); %Load the data per subject. For example ts_20_young_001.txt,...,ts_20_young_026.txt
%     dataPatient=dataPatient(:,1:159); %We recommend truncating all the data to the same number of samples. In this example 159.
    [Oinfo,Sinfo,Red(patient,:),Syn(patient,:)]=high_order(dataPatient,n);
%     save(sprintf('%s/Oinfop%.3d.mat',outPath,patient),'Oinfo','Sinfo')%Per subject, save the Oinfo and Sinfo for all the n-plets
end
%% save the redundancy and synergy values
%     save(sprintf('%s/Red.mat',outPath),'Red')
%     save(sprintf('%s/Syn.mat',outPath),'Syn')
%% plot mean values of Redundancy and Synergy values per modules 

fg1=figure; 
set(fg1,'position',[0,0,1000,600])
subplot(211);hold on
x=1:Modules;
plot(x,mean(Red))
grid on
xticks(x)
title('Redundancy')
xlabel('Modules')
ylabel('R (nats)')
set(gca,'FontSize',15)
xlim([1 Modules])

subplot(212);hold on
plot(x,mean(Syn))
grid on
xticks(x)
title('Synergy')
xlabel('Modules')
ylabel('S (nats)')
set(gca,'FontSize',15)
xlim([1 Modules])
%     saveas(fg1,sprintf('%s/RedSyn%i.png',outPath,n))
%     close;
toc;
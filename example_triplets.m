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
Npatients=161;%number of subjects
Modules=20;%number of modules or brain regions. In out case we use the BHA parcelation with 20 modules, https://github.com/compneurobilbao/bha.git
Red=zeros(Npatients,Modules);%matrix to save the redundant values, per patient and per module
Syn=zeros(Npatients,Modules);%matrix to save the synergy values, per patient and per module
%% input data Path
inPath='.\dataset\timeseries\';%Path files
%% Per subject: Estimate Oinfo, Sinfo for each triplet and Redundancy and Synergy per module.
n=3;
tic;
outPath=sprintf('High-OrderN%i',n);%output data name
mkdir(sprintf('./%s',outPath))%create the folder
for patient=1:Npatients
    disp(patient)
    dataPatient=load(sprintf('%sts_m20_p%.3d.txt',inPath,patient)); %Load the data per subject. 
    dataPatient=dataPatient(:,1:159); %We recommend truncating all the data to the same number of samples. In this example 159.
    [Oinfo,Sinfo,Red(patient,:),Syn(patient,:)]=high_order(dataPatient,n);
%     save(sprintf('%s/Oinfop%.3d.mat',outPath,patient),'Oinfo','Sinfo')%Per subject, save the Oinfo and Sinfo for all the n-plets
end
toc;
%% save the redundancy and synergy values
%     save(sprintf('%s/Red.mat',outPath),'Red')
%     save(sprintf('%s/Syn.mat',outPath),'Syn')
%% 
load('.\dataset\ages_up.mat');%ages vector
I1=find(ages_up<=20);%I1: 10<=patient<20
I2=find(ages_up>20&ages_up<=40);%I2: 20<=patient<40
I3=find(ages_up>40&ages_up<=60);%I3: 40<=patient<60
I4=find(ages_up>60);%I4: 60<=patient<81
G={[I1,I2,I3],I4};
%% plot mean values of Redundancy and Synergy values per modules 
cmap=[[0 0.5 0.9];[0.9290 0.6940 0.1250]];

fg1=figure; 
set(fg1,'position',[0,0,1000,600])
subplot(211);hold on
x=1:Modules;
for i=1:size(G,2)
    plot(x,mean(Red(G{i},:)),'color',cmap(i,:),'LineWidth',2)
end
grid on
xticks(x)
title('Redundancy')
xlabel('Modules')
ylabel('R (nats)')
set(gca,'FontSize',15)
xlim([1 Modules])
legend('(I1,I2,I3)','I4','Location','best')

subplot(212);hold on
for i=1:size(G,2)
    plot(x,mean(Syn(G{i},:)),'color',cmap(i,:),'LineWidth',2)
end
grid on
xticks(x)
title('Synergy')
xlabel('Modules')
ylabel('S (nats)')
set(gca,'FontSize',15)
xlim([1 Modules])
%     saveas(fg1,sprintf('%s/RedSyn%i.png',outPath,n))
%     close;

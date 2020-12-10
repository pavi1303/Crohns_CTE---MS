%CV testing
%objective: Using the training and testing splits generated in DisStudyFat
%I will run CV with the testing data being taken from the a different recon
%or dosage.

clear;
addpath(genpath('O:\Resampled_data\Features'))
addpath(genpath('P:\Resampled_results\Reproducibility\ICC'))
addpath(genpath('P:\CT_Rectal'))
addpath(genpath('P:\Resampled_results_2\Feature_subsets'))
% dontuse=[71];
% Holdout=[];
% D1 = load('CT_TI_resampled3D_entire_vol_grp1_3foldCV_IS_pruning_combined6_mrmr_QDA.mat')
% idx = D1.idx;
fselmeth='mrmr';
%pruning=1;
num_top_feats=6;
cd('P:\Resampled_results_2\No_pruning\Grp2\mrmr\QDA')

% load('Rep_3D_resampled_stable_ICC_h.mat');
% idx1 = find(ICC_final_layer(3,:)>0.85);
% idx2 = find(ICC_final_layer(5,:)>0.85);
% idx3 = find(ICC_final_layer(6,:)>0.85);
% 
% idx = intersect(idx1,idx2);
% idx_h = intersect(idx,idx3);
% clear idx1* idx2 idx*3 idx
% 
% load('Rep_3D_resampled_stable_ICC_d.mat');
% idx1 = find(ICC_final_layer(3,:)>0.85);
% idx2 = find(ICC_final_layer(5,:)>0.85);
% idx3 = find(ICC_final_layer(6,:)>0.85);
% 
% idx = intersect(idx1,idx2);
% idx_d = intersect(idx,idx3);
% 
% idx = intersect(idx_h,idx_d);

load('CT_TI_featstack_resampled3D_IS_ICCboth_grp2.mat');

% graycolumnindices = [1:21 464:484 927:947 1390:1410];
feanames = statnames;
% feanames(:,1:21)=[];
feanames=feanames.';
feanames=feanames(:).';
% feanames = feanames(1,idx);
%  for i=1:length(top_fea)
%     % mrmr_idx(i)=find(strcmp(feanames,top_fea(i)))';
%      mrmr_idx(i) = find(strcmp(feanames,top_fea(i)));
%      mrmr_idx=mrmr_idx';
%  end
% featstack_TI_full(isnan(featstack_TI_full))=0;
%   featstack_TI_half(isnan(featstack_TI_half))=0;
% % %featstack_TI_safire3(isnan(featstack_TI_safire3))=0;
%  featstack_TI_safire4(isnan(featstack_TI_safire4))=0;


 featstack_TI_full(isnan(featstack_TI_full))=0;
 featstack_TI_half(isnan(featstack_TI_half))=0;
%featstack_TI_safire3(isnan(featstack_TI_safire3))=0;
 featstack_TI_safire4(isnan(featstack_TI_safire4))=0;


featstack_full_t=featstack_TI_full;
featstack_half_t=featstack_TI_half;
featstack_safire4_t=featstack_TI_safire4;
% featstack_full_t(:,graycolumnindices)= [];
%  featstack_full_t = featstack_full_t(:,idx);
%  featstack_half_t = featstack_half_t(:,idx);
%  featstack_safire4_t = featstack_safire4_t(:,idx);
 labels_t=labels;

load('CT_TI_featstack_resampled3D_IS_ICCboth_grp1.mat');
%labels=labels-1;
% num_top_feats=5;

try
  featstack_full=featstack_TI_full;
%   featstack_half=featstack_TI_half;
%   featstack_safire3=featstack_TI_safire3;
%   featstack_safire4=featstack_TI_safire4;

  featstack_full(isnan(featstack_TI_full))=0;
%  featstack_half(isnan(featstack_TI_half))=0;
% featstack_safire3(isnan(featstack_TI_safire3))=0;
%  featstack_safire4(isnan(featstack_TI_safire4))=0;
catch
  featstack_TI_full(isnan(featstack_TI_full))=0;
%  featstack_TI_half(isnan(featstack_TI_half))=0;
% featstack_TI_safire3(isnan(featstack_TI_safire3))=0;
%  featstack_TI_safire4(isnan(featstack_TI_safire4))=0;
end

featstack_full(isnan(featstack_full))=0;
%featstack_half(isnan(featstack_half))=0;
% %featstack_safire3(isnan(featstack_safire3))=0;
%   featstack_safire4(isnan(featstack_safire4))=0;

load('CTsubsets_lmn3.mat');

% list_dat=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90]';
% newlist=setdiff(list_dat,dontuse);

% featstack_TI_safire4=featstack_TI_safire4(newlist,:);
% featstack_TI_half = featstack_TI_half(newlist,:);
% featstack_TI_full=featstack_TI_full(newlist,:);
%  featstack_full(:,graycolumnindices)=[];
%  featstack_full = featstack_full(:,idx);
labels=labels;
% %newlist=setdiff(newlist,Holdout);
HO_AUC=[];
fea_cell={};

 %fea_sw=[452,262,439,877,231,885];
fea_sw=[168,500,206,156,504,501,867,51,50,503];

for gset=1:1
    clear alpha* beta*
    switch gset
        case 1
            
%             featstack_full=[featstack_full(1:70,:);zeros(1,784);featstack_full(71:89,:)];
%             featstack_half=[featstack_half(1:70,:);zeros(1,784);featstack_half(71:89,:)];
%             featstack_safire4=[featstack_safire4(1:70,:);zeros(1,784);featstack_safire4(71:89,:)];
%             
            labels=[labels(1:70),1,labels(72:end)];
            
%             
%             trainingdata=featstack_full_t;
%             testingdata1=featstack_half(newlist,:);
%             testingdata2=featstack_safire4(newlist,:);
%             testingdata3=featstack_full(newlist,:);
            
                        trainingdata=featstack_full;
                        testingdata2=featstack_half_t;
                        testingdata1=featstack_full_t;
                        testingdata3=featstack_safire4_t;
                        
%                         trainingdata=featstack_safire4(newlist,:);
%                         testingdata2=featstack_half_t;
%                         testingdata1=featstack_safire4_t;
%                         testingdata3=featstack_full_t;
%                         labels=labels(:,newlist);
            
            
        case 2
            
            
            featstack_half=[featstack_half(1:70,:);zeros(1,784);featstack_half(71:89,:)];
            featstack_safire4=[featstack_safire4(1:70,:);zeros(1,784);featstack_safire4(71:89,:)];
            featstack_safire3=[featstack_safire3(1:70,:);zeros(1,784);featstack_safire3(71:89,:)];
            
            labels=[labels(1:70),1,labels(71:end)];
            
%             trainingdata=featstack_half_t;
%             testingdata1=featstack_full(newlist,:);
%             testingdata2=featstack_safire4(newlist,:);
%             testingdata3=featstack_half(newlist,:);
            
                        trainingdata=featstack_half(newlist,:);
                        testingdata1=featstack_full_t;
                        testingdata2=featstack_safire4_t;
                        testingdata3=featstack_half_t;
            
    end
    HO_AUC1=[];
    HO_AUC2=[];
    HO_AUC3=[];
    fea_store=cell(1,6);
    for iter=1:1
%          trainingsplit{1}=[1:74];
%          testingsplit{1}=[1:89];
                trainingsplit{1}=[1:90];
                testingsplit{1}=[1:74];
        %         trainingsplit=subsets(iter).training;
        %         testingsplit=subsets(iter).testing;
        for fset=1:1
           % fea=[];
           % fea=fea_sw
            training_set=trainingdata(trainingsplit{fset},:);
            testing_set1=testingdata1(testingsplit{fset},:);
              testing_set2=testingdata2(testingsplit{fset},:);
              testing_set3=testingdata3(testingsplit{fset},:);
% %             
            training_labels=labels(trainingsplit{fset});
            testing_labels=labels_t(testingsplit{fset});
            options = {'threshmeth','euclidean'};
%             
%             % training_labels=labels(trainingsplit{fset});
%             % testing_labels=labels_t(testingsplit{fset});
%             
%             if pruning==0
%                 set_candiF=(1:length(training_set));
%             else
%                 set_candiF=pick_best_uncorrelated_features(training_set,training_labels);
%             end
%             
%             
%             if strcmp(fselmeth,'mrmr')
%                 
%                 [IDX, ~] = rankfeatures(training_set(:,set_candiF)',training_labels,'criterion','wilcoxon','CCWeighting', 1);
%                 if length(find(IDX==1))>1 && size(data_set,2)>20 %occurs if CCWeighting is too high and not many features to choose from or if too few (<20) features in data_set
%                     warning('Too many correlated features found. Only %i features chosen. Reduce CCWeighting in call to rankfeatures() to correct.',length(IDX)-length(find(IDX==1)));
%                     fea = set_candiF(IDX(1:length(IDX)-length(find(IDX==1))));
%                 else
%                     fea = set_candiF(IDX(1:num_top_feats));
%                 end
%                 
%             else
%                 
%                 [IDX, ~] = rankfeatures(training_set(:,set_candiF)',training_labels,'criterion','wilcoxon','CCWeighting', 1);
%                 if length(find(IDX==1))>1 && size(data_set,2)>20 %occurs if CCWeighting is too high and not many features to choose from or if too few (<20) features in data_set
%                     warning('Too many correlated features found. Only %i features chosen. Reduce CCWeighting in call to rankfeatures() to correct.',length(IDX)-length(find(IDX==1)));
%                     fea = set_candiF(IDX(1:length(IDX)-length(find(IDX==1))));
%                 else
%                     fea = set_candiF(IDX(1:num_top_feats));
%                 end
%             end
%             
            
%             %
%             [temp_stats1,~] = Classify_wrapper('QDA', training_set(:,fea) , testing_set1(:,fea), training_labels(:), testing_labels(:), options);
%             [temp_stats2,~] = Classify_wrapper('QDA', training_set(:,fea) , testing_set2(:,fea), training_labels(:), testing_labels(:), options);
%             [temp_stats3,~] = Classify_wrapper('QDA', training_set(:,fea) , testing_set3(:,fea), training_labels(:), testing_labels(:), options);
%             
%             
%             foldpredictions1{fset} =  temp_stats1.prediction;
%             foldpredictions2{fset} =  temp_stats2.prediction;
%             foldpredictions3{fset} =  temp_stats3.prediction;
 %            foldlabels{fset} = testing_labels;
% 
%             HO_AUC1(iter,fset)=temp_stats1.AUC  ;
%             HO_AUC2(iter,fset)=temp_stats2.AUC  ;
%             HO_AUC3(iter,fset)=temp_stats2.AUC  ;
%             fea_store{iter,fset}=fea;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%simplewhiten%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
             fea=[];
              fea=fea_sw;
              iter
              fset
             [training_set_swno,mean_val,mad_val]=simplewhitennooutlier(training_set);
              training_set=simplewhiten(training_set,mean_val,mad_val);
          %   [testing_set1_swno,mean_val1,mad_val1]=simplewhitennooutlier(testing_set1);
              testing_set1=simplewhiten(testing_set1,mean_val,mad_val);
         %  [testing_set2_swno,mean_val2,mad_val2]=simplewhitennooutlier(testing_set2);
                testing_set2=simplewhiten(testing_set2,mean_val,mad_val);
%       %        [testing_set3_swno,mean_val3,mad_val3]=simplewhitennooutlier(testing_set3);
               testing_set3=simplewhiten(testing_set3,mean_val,mad_val);
%             [training_set,mean_val,mad_val]=simplewhiten(training_set);
%             testing_set1=simplewhiten(testing_set1);
%             testing_set2=simplewhiten(testing_set2);
%             testing_set3=simplewhiten(testing_set3);
            
%             if pruning==0
%                 set_candiF=(1:length(training_set));
%             else
%                 set_candiF=pick_best_uncorrelated_features(training_set,training_labels);
%             end
%             
%             
%             if strcmp(fselmeth,'mrmr')
%                 
%                 training_set_d = discretize(training_set(:,set_candiF), [-inf -1 1 inf]);
%                 fea = mrmr_mid_d(training_set_d,training_labels,num_top_feats); % MRMR
%                 fea = fea';
%                 fea=set_candiF(fea);
%                 
%             else
%                 
%                 [IDX, ~] = rankfeatures(training_set(:,set_candiF)',training_labels,'criterion','wilcoxon','CCWeighting', 1);
%                 if length(find(IDX==1))>1 && size(data_set,2)>20 %occurs if CCWeighting is too high and not many features to choose from or if too few (<20) features in data_set
%                     warning('Too many correlated features found. Only %i features chosen. Reduce CCWeighting in call to rankfeatures() to correct.',length(IDX)-length(find(IDX==1)));
%                     fea = set_candiF(IDX(1:length(IDX)-length(find(IDX==1))));
%                 else
%                     fea = set_candiF(IDX(1:num_top_feats));
%                 end
%             end
%             
            [temp_stats1_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set1(:,fea), training_labels(:), testing_labels(:), options);
            [temp_stats2_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set2(:,fea), training_labels(:), testing_labels(:), options);
            [temp_stats3_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set3(:,fea), training_labels(:), testing_labels(:), options);
%             
            foldpredictions1_sw{fset} =  temp_stats1_sw.prediction;
            foldpredictions2_sw{fset} =  temp_stats2_sw.prediction;
            foldpredictions3_sw{fset} =  temp_stats3_sw.prediction;
            
            HO_AUC1(iter,fset)=temp_stats1_sw.AUC  ;
            HO_AUC2(iter,fset)=temp_stats2_sw.AUC  ;
            HO_AUC3(iter,fset)=temp_stats2_sw.AUC  ;
  
            fea_store{iter,fset}=fea;
            clear training_set* testing_set1* 
        end
        %         [FPR,TPR,~,AUC1(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions1, 1,'XVals', [0:0.02:1]);
        %         [FPR,TPR,T,AUC2(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions2, 1,'XVals', [0:0.02:1]);
        %         [FPR,TPR,~,AUC3(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions3, 1,'XVals', [0:0.02:1]);
        %
               % [FPR,TPR,~,AUC1_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions1_sw, 1,'XVals', [0:0.02:1]);
               %[FPR,TPR,T,AUC2_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions2_sw, 1,'XVals', [0:0.02:1]);
             %   [FPR,TPR,T,AUC3_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions3_sw, 1,'XVals', [0:0.02:1]);
        
    end
    
%     featlist=fea_store(:,1:3);
%     featlist=cell2mat(featlist);
%     alpha(:,1)=unique(featlist);
%     alpha(:,2)=count(featlist);
%     alpha=sortrows(alpha,2,'descend');
%     alpha(:,2)=alpha(:,2)/600;
%     
    featlist=fea_store(:,1);
    featlist=cell2mat(featlist);
    beta(:,1)=unique(featlist);
    beta(:,2)=count(featlist);
    beta=sortrows(beta,2,'descend');
    beta(:,2)=beta(:,2)/600;
    
    
     HO_AUC(gset,1)=mean(HO_AUC1);
     HO_AUC(gset,2)=mean(HO_AUC2);
     HO_AUC(gset,3)=mean(HO_AUC3);
%    HO_AUC_m = max(HO_AUC1);
%    HO_AUC_m1=max(HO_AUC2);
%    HO_AUC{gset,1}=mean(AUC1_sw);
%    HO_AUC{gset,2}=mean(AUC2_sw);
%    HO_AUC{gset,3}=mean(AUC3_sw);
     %
    %fea_cell{gset,1}=alpha;
    fea_cell{gset,2}=beta;
    clear AUC* beta
end
%save(['CT_TI_resampled3D_entire_vol_grp2_no_pruning_',num2str(num_top_feats),'_',fselmeth,'_','QDA.mat'],'fea_cell','HO_AUC1','HO_AUC2','HO_AUC3','HO_AUC','temp_stats1_sw','temp_stats2_sw','temp_stats3_sw');
%save(['CT_standardized_ROI_TI_unsup_combat_grp2_CV_',num2str(num_top_feats),'_',fselmeth,'_','QDA.mat'],'fea_cell','HO_AUC1','HO_AUC2','HO_AUC3','HO_AUC','temp_stats1_sw','temp_stats2_sw','temp_stats3_sw');
%save(['CT_largest_TI_combat_modified_my_approach_grp2_CV_',num2str(num_top_feats),'_',fselmeth,'_','Randomforest.mat'],'fea_cell','HO_AUC1','HO_AUC2','HO_AUC3','HO_AUC','temp_stats1_sw','temp_stats2_sw','temp_stats3_sw');
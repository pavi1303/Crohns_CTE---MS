%CV testing
%objective: Using the training and testing splits generated in DisStudyFat
%I will run CV with the testing data being taken from the a different recon
%or dosage.

addpath(genpath('P:\Resampled_results'))
addpath(genpath('O:\Resampled_data\Features'))
addpath(genpath('P:\CT_Rectal'))
addpath(genpath('P:\Resampled_results\Reproducibility\IS\Rep_IS'))
% addpath(genpath('P:\Resampled_results\Reproducibility\ICC\ICC_based_pruning'))
cd('P:\Resampled_results_2\Pruning\IS+ICC_d_rd\Grp1\mrmr\Randomforest');
%--------------------------IS based pruning-------------------------------%
%----------------Find stable features in the healthy comparison-----------%
graycolumnindices = [1:21 464:484 927:947 1390:1410];
load('Rep_3D_resampled_IS_healthy.mat');
IS_h = Score_pw_sw;
IS_h(graycolumnindices) = [];
IS_h(1769:1770)=[];
idx_h = find(IS_h==0);
%---------------Find stable features in the diseased comparison-----------%
load('Rep_3D_resampled_IS_diseased.mat');
IS_d = Score_pw_sw;
IS_d(graycolumnindices) = [];
IS_d(1769:1770)=[];
idx_d = find(IS_d==0);
%-------Find the stable features common between healthy & diseased--------%
idx = intersect(idx_h,idx_d);
% D1=load('Rep_3D_resampled_IS_combined.mat');
% IS= D1.Score_pw_sw;
% IS(graycolumnindices) = [];
% IS(1769:1770)=[];
% idx = find(IS==0);
% dontuse=[71];
% Holdout=[];
%------------------------------ICC based pruning--------------------------%
% load('Rep_3D_resampled_ICC_h.mat');
% idx1 = find(ICC_final_layer(3,:)>0.85);
% % idx2 = find(ICC_final_layer(5,:)>0.85);
% idx3 = find(ICC_final_layer(6,:)>0.85);
% 
% % idx = intersect(idx1,idx2);
% idx_h = intersect(idx1,idx3);
% clear idx1* idx3*
% 
% load('Rep_3D_resampled_ICC_d.mat');
% idx1 = find(ICC_final_layer(3,:)>0.85);
% % idx2 = find(ICC_final_layer(5,:)>0.85);
% idx3 = find(ICC_final_layer(6,:)>0.85);
% 
% % idx = intersect(idx1,idx2);
% idx_d = intersect(idx1,idx3);
% 
% idx = intersect(idx_h,idx_d);

load('CT_TI_featstack_resampled3D_IS_ICCboth_grp1.mat');
% labels=labels-1;
fselmeth='mrmr';
pruning=0;
num_top_feats=9;

try
  featstack_full=featstack_TI_full;
  featstack_half=featstack_TI_half;
% %featstack_safire3=featstack_TI_safire3;
  featstack_safire4=featstack_TI_safire4;

  featstack_full(isnan(featstack_TI_full))=0;
  featstack_half(isnan(featstack_TI_half))=0;
% featstack_safire3(isnan(featstack_TI_safire3))=0;
  featstack_safire4(isnan(featstack_TI_safire4))=0;
catch
  featstack_TI_full(isnan(featstack_TI_full))=0;
  featstack_TI_half(isnan(featstack_TI_half))=0;
% featstack_TI_safire3(isnan(featstack_TI_safire3))=0;
  featstack_TI_safire4(isnan(featstack_TI_safire4))=0;
end

 featstack_full(isnan(featstack_full))=0;
 featstack_half(isnan(featstack_half))=0;
% featstack_safire3(isnan(featstack_safire3))=0;
featstack_safire4(isnan(featstack_safire4))=0;

% % graycolumnindices = [1:21 464:484 927:947 1390:1410];
% featstack_full(:,graycolumnindices)=[];
% featstack_TI_full(:,graycolumnindices)=[];
% featstack_full = featstack_full(:,idx);
%  featstack_half(:,graycolumnindices)=[];
% % featstack_safire3(:,graycolumnindices)=[];
% featstack_safire4(:,graycolumnindices)=[];

% featstack_full = featstack_full(:,idx);
% featstack_half = featstack_half(:,idx);
% featstack_safire4 = featstack_safire4(:,idx);

feanames = statnames;
% feanames(:,1:21)=[];
feanames=feanames.';
feanames=feanames(:).';
% feanames=feanames(1,idx);

load('CTsubsets_lmn3.mat')%replace this with the needed subset

 list_dat=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90]';
% % 
%  newlist=setdiff(list_dat,dontuse);
% % newlist=setdiff(newlist,Holdout);
HO_AUC={};
% con_matrix={};
fea_cell={};
for gset=1:1
    clear alpha* beta*
    switch gset
        case 1
            
%             featstack_full=[featstack_full(1:70,:);zeros(1,784);featstack_full(71:89,:)];
%             featstack_half=[featstack_half(1:70,:);zeros(1,784);featstack_half(71:89,:)];
%             featstack_safire4=[featstack_safire4(1:70,:);zeros(1,784);featstack_safire4(71:89,:)];
            
             labels=[labels(1:70),1,labels(72:end)];
%             labels = labels;
            
             trainingdata=featstack_full;
             testingdata1=featstack_full;
             testingdata2=featstack_half;
             testingdata3=featstack_safire4;
%            
%              trainingdata=featstack_full(newlist,:);
%              testingdata1=featstack_full(newlist,:);
% %              testingdata2=featstack_half;
% %              testingdata3=featstack_full;
        
        
        case 2
            
           
      %      featstack_half=[featstack_half(1:70,:);zeros(1,784);featstack_half(71:89,:)];
     %       featstack_safire4=[featstack_safire4(1:70,:);zeros(1,784);featstack_safire4(71:89,:)];
      %      featstack_safire3=[featstack_safire3(1:70,:);zeros(1,784);featstack_safire3(71:89,:)];
            
     %     labels=[labels(1:70),1,labels(71:end)];
            
            trainingdata=featstack_half;
         %   testingdata1=featstack_safire3;
            testingdata2=featstack_safire4;
         %   testingdata3=featstack_half(newlist,:);

    end
    HO_AUC1=[];
    HO_AUC2=[];
    HO_AUC3=[];
    fea_store={};
    for iter=1:100
         trainingsplit=subsets(iter).training;
         testingsplit=subsets(iter).testing;
        for fset=1:3
            fea=[];
            training_set=trainingdata(trainingsplit{fset},:);
            testing_set1=testingdata1(testingsplit{fset},:);
            testing_set2=testingdata2(testingsplit{fset},:);
            testing_set3=testingdata3(testingsplit{fset},:);
            
            training_labels=labels(trainingsplit{fset});
            testing_labels=labels(testingsplit{fset});
             
%             if pruning==0
%                 set_candiF=(1:length(training_set));
%             else
%                set_candiF=pick_best_uncorrelated_features(training_set,training_labels);
%             end
%              
%              
%             if strcmp(fselmeth,'mrmr')
%                  
%                 training_set_d = discretize(training_set(:,set_candiF), [-inf -1 1 inf]);
%                 fea = mrmr_mid_d(training_set_d,training_labels,num_top_feats); % MRMR
%                 fea = fea';
%                 fea=set_candiF(fea);
% %                 
%             else
%                 
%                [IDX, ~] = rankfeatures(training_set(:,set_candiF)',training_labels,'criterion','wilcoxon','CCWeighting', 1);
%                 if length(find(IDX==1))>1 && size(data_set,2)>20 %occurs if CCWeighting is too high and not many features to choose from or if too few (<20) features in data_set
%                    warning('Too many correlated features found. Only %i features chosen. Reduce CCWeighting in call to rankfeatures() to correct.',length(IDX)-length(find(IDX==1)));
%                     fea = set_candiF(IDX(1:length(IDX)-length(find(IDX==1))));
%                 else
%                     fea = set_candiF(IDX(1:num_top_feats));
%                 end
%             end
%              
             options = {'threshmeth','euclidean'};
             
%             [temp_stats1,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set1(:,fea), training_labels(:), testing_labels(:), options);
%             [temp_stats2,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set2(:,fea), training_labels(:), testing_labels(:), options);
%             [temp_stats3,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set3(:,fea), training_labels(:), testing_labels(:), options);
             
             
%             foldpredictions1{fset} =  temp_stats1.prediction;
%             foldpredictions2{fset} =  temp_stats2.prediction;
%             foldpredictions3{fset} =  temp_stats3.prediction;
             foldlabels{fset} = testing_labels;
             
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %%%%%%%%%%%%%simplewhiten%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             
%             HO_AUC1(iter,fset)=temp_stats1.AUC  ;
%             HO_AUC2(iter,fset)=temp_stats2.AUC  ;
%             HO_AUC3(iter,fset)=temp_stats2.AUC  ;
%             fea_store{iter,fset}=fea;
%            
               [training_set_swno,mean_val,mad_val]=simplewhitennooutlier(training_set);
               training_set=simplewhiten(training_set,mean_val,mad_val);
%              [testing_set1_swno,mean_val1,mad_val1]=simplewhitennooutlier(testing_set1);
%              testing_set1=simplewhiten(testing_set1,mean_val,mad_val);
%  %           [testing_set2_swno,mean_val2,mad_val2]=simplewhitennooutlier(testing_set2);
%              testing_set2=simplewhiten(testing_set2,mean_val2,mad_val2);
               testing_set1=simplewhiten(testing_set1,mean_val,mad_val);
               testing_set2=simplewhiten(testing_set2,mean_val,mad_val);
               testing_set3=simplewhiten(testing_set3,mean_val,mad_val);
            
            % testing_set1=simplewhiten(testing_set1);
%             testing_set2=simplewhiten(testing_set2);
     %       testing_set3=simplewhiten(testing_set3);
            
            if pruning==0
               set_candiF=(1:length(training_set));
            else
                set_candiF=pick_best_uncorrelated_features(training_set,training_labels);
            end
            
            
            if strcmp(fselmeth,'mrmr')
                
                training_set_d = discretize(training_set(:,set_candiF), [-inf -1 1 inf]);
                fea = mrmr_mid_d(training_set_d,training_labels,num_top_feats); % MRMR
                fea = fea';
                fea=set_candiF(fea);
                
            else
                
               [IDX, ~] = rankfeatures(training_set(:,set_candiF)',training_labels,'criterion','wilcoxon','CCWeighting', 1);
                if length(find(IDX==1))>1 && size(data_set,2)>20 %occurs if CCWeighting is too high and not many features to choose from or if too few (<20) features in data_set
                    warning('Too many correlated features found. Only %i features chosen. Reduce CCWeighting in call to rankfeatures() to correct.',length(IDX)-length(find(IDX==1)));
                    fea = set_candiF(IDX(1:length(IDX)-length(find(IDX==1))));
                else
                    fea = set_candiF(IDX(1:num_top_feats));
                end
            end
            
            [temp_stats1_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set1(:,fea), training_labels(:), testing_labels(:), options);
            [temp_stats2_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set2(:,fea), training_labels(:), testing_labels(:), options);
            [temp_stats3_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set3(:,fea), training_labels(:), testing_labels(:), options);
            
            stats1(iter,fset)=temp_stats1_sw;
            stats2(iter,fset)=temp_stats2_sw;
            stats3(iter,fset)=temp_stats1_sw;
            
            foldpredictions1_sw{fset} =  temp_stats1_sw.prediction;
            foldpredictions2_sw{fset} =  temp_stats2_sw.prediction;
            foldpredictions3_sw{fset} =  temp_stats3_sw.prediction;  
            
            HO_AUC1(iter,fset)=temp_stats1_sw.AUC;
            HO_AUC2(iter,fset)=temp_stats2_sw.AUC;
            HO_AUC3(iter,fset)=temp_stats3_sw.AUC;
            
            fea_store{iter,fset}=fea;
            
            clear training_set* testing_set*
%             Error_rate1_fold(iter,fset)=1-(temp_stats1_sw.acc);
%             Error_rate2_fold(iter,fset)=1-(temp_stats2_sw.acc);
% 
%             true_positive1(iter,fset)=temp_stats1_sw.tp;
%             true_negative1(iter,fset)=temp_stats1_sw.tn;
%             false_positive1(iter,fset)=temp_stats1_sw.fp;
%             false_negative1(iter,fset)=temp_stats1_sw.fn;
%             
%             true_positive2(iter,fset)=temp_stats2_sw.tp;
%             true_negative2(iter,fset)=temp_stats2_sw.tn;
%             false_positive2(iter,fset)=temp_stats2_sw.fp;
%             false_negative2(iter,fset)=temp_stats2_sw.fn;
        end
%        [FPR,TPR,~,AUC1(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions1, 1,'XVals', [0:0.02:1]);
%        [FPR,TPR,T,AUC2(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions2, 1,'XVals', [0:0.02:1]);
%        [FPR,TPR,~,AUC3(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions3, 1,'XVals', [0:0.02:1]);
        
        [FPR,TPR,~,AUC1_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions1_sw, 1,'XVals', [0:0.02:1]);
        [FPR,TPR,T,AUC2_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions2_sw, 1,'XVals', [0:0.02:1]);
        [FPR,TPR,T,AUC3_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions3_sw, 1,'XVals', [0:0.02:1]);
        
    end
    
%     featlist=fea_store(:,1:3);
%     featlist=cell2mat(featlist);
%     alpha(:,1)=unique(featlist);
%     alpha(:,2)=count(featlist);
%     alpha=sortrows(alpha,2,'descend');
%     alpha(:,2)=alpha(:,2)/600;
    
    featlist=fea_store(:,1:3);
    featlist=cell2mat(featlist);
    beta(:,1)=unique(featlist);
    beta(:,2)=count(featlist);
    beta=sortrows(beta,2,'descend');
    beta(:,2)=beta(:,2)/300;
%    HO_AUC{gset,1}=mean(AUC1);
%    HO_AUC{gset,2}=mean(AUC2);
%    HO_AUC{gset,3}=mean(AUC3);
    HO_AUC{gset,1}=mean(mean(AUC1_sw));
    HO_AUC{gset,2}=mean(mean(AUC2_sw));
    HO_AUC{gset,3}=mean(mean(AUC3_sw));
    HO_AUC{gset,4}=mean(std(AUC1_sw));
    HO_AUC{gset,5}=mean(std(AUC2_sw));
    HO_AUC{gset,6}=mean(std(AUC3_sw));
    
%   fea_cell{gset,1}=alpha
    fea_cell{gset,2}=beta;
    clear AUC* temp* beta
%     Errorrate(gset,1)=mean(Error_rate1_fold(:,1));
%     Errorrate(gset,2)=mean(Error_rate1_fold(:,2));
%     Errorrate(gset,3)=mean(Error_rate1_fold(:,3));
%     Errorrate(2,1)=mean(Error_rate2_fold(:,1));
%     Errorrate(2,2)=mean(Error_rate2_fold(:,2));
%     Errorrate(2,3)=mean(Error_rate2_fold(:,3));
%     
%     con_matrix{gset,1}=true_positive1;
%     con_matrix{gset,2}=true_negative1;
%     con_matrix{gset,3}=false_positive1;
%     con_matrix{gset,4}=false_negative1;
%     
%     con_matrix{2,1}=true_positive2;
%     con_matrix{2,2}=true_negative2;
%     con_matrix{2,3}=false_positive2;
%     con_matrix{2,4}=false_negative2;

    temp1=fea_cell{1,2};
    top_fea=feanames(temp1(1:num_top_feats,1));
    top_fea=top_fea';
end
save(['CT_TI_resampled3D_entire_vol_grp1_IS+ICC_d_rd_pruning_',num2str(num_top_feats),'_',fselmeth,'_','Randomforest.mat'],'fea_cell','HO_AUC','top_fea','HO_AUC1','HO_AUC2','HO_AUC3','stats1','stats2','stats3');
%save(['CT_largestTI_modified_combat_my_approach_grp1_CV_',num2str(num_top_feats),'_',fselmeth,'_','QDA.mat'],'fea_cell','HO_AUC','top_fea');
%save(['CT_min_slices_flipped_grp1_CV_',num2str(num_top_feats),'_',fselmeth,'_','QDA.mat'],'fea_cell','HO_AUC','top_fea','HO_AUC1','HO_AUC2','HO_AUC3','stats1','stats2','stats3');
%save(['CT_standardized_ROI_TI_grp1_CV_',num2str(num_top_feats),'_',fselmeth,'_','QDA.mat'],'fea_cell','HO_AUC','top_fea','HO_AUC1','HO_AUC2','HO_AUC3','stats1','stats2','stats3');
%save(['CT_largestTI_modified_combat_nomod_grp1_CV_',num2str(num_top_feats),'_',fselmeth,'_','Randomforest.mat'],'fea_cell','HO_AUC','top_fea','HO_AUC1','HO_AUC2');
% save(['CT_erroranalysis_largestTI_grp1_CV_',num2str(num_top_feats),'_',fselmeth,'_','Randomforest_independentwhiten.mat'],'con_matrix','Error_rate1_fold','Error_rate2_fold','Errorrate','stats1','stats2');
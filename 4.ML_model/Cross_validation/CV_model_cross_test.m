
clear
addpath(genpath('W:\CT_Rectal'))
addpath(genpath('W:\Final_resampled_results\Featstack_subsets'))
addpath(genpath('W:\My_code'))

dontuse = 71;
fselmeth='wilcoxon';
pruning=1;
topfea_range= (6:10);
pruning_stage = ["NO", "ICC", "IS", "IS_ICC"];
tra_dose = ["HALF","SAF4"];

for tfset = 1:length(topfea_range)
    num_top_feats = topfea_range(1,tfset);
    for pset = 1:length(pruning_stage)
        pruning_level = pruning_stage(1,pset);
        switch pruning_level
            case 'NO'
                load('CT_TI_featstack_3Dresampled_nopruning_grp2.mat');
                cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\1.No_pruning');
            case 'ICC'
                load('CT_TI_featstack_3Dresampled_ICCpruning_grp2.mat');
                cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\2.ICC_pruning');
            case 'IS'
                load('CT_TI_featstack_3Dresampled_ISpruning_grp2.mat');
                cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\3.IS_pruning');
            case 'IS_ICC'
                load('CT_TI_featstack_3Dresampled_IS_ICCpruning_grp2.mat');
                cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\IS_ICC_pruning');
        end
        
        featstack_TI_full(isnan(featstack_TI_full))=0;
        featstack_TI_half(isnan(featstack_TI_half))=0;
        featstack_TI_safire4(isnan(featstack_TI_safire4))=0;
        
        featstack_full_t=featstack_TI_full;
        featstack_half_t=featstack_TI_half;
        featstack_safire4_t=featstack_TI_safire4;
        labels_t=labels;
        
        clear featstack_TI* labels
        
        switch pruning_level
            case 'NO'
                load('CT_TI_featstack_3Dresampled_nopruning_grp1.mat');
                top_fea = [408,283,252,800,794,71,798,1438,328,805];%nopruning_wilcoxon
                cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\1.No_pruning');
            case 'ICC'
                load('CT_TI_featstack_3Dresampled_ICCpruning_grp1.mat');
                top_fea = [204,175,283,223,242,976,561,563,986,59];%ICC_wilcoxon
                cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\2.ICC_pruning');
            case 'IS'
                load('CT_TI_featstack_3Dresampled_ISpruning_grp1.mat');
                top_fea = [635,634,214,1166,66,67,60,255,640,201];%IS_wilcoxon
                cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\3.IS_pruning');
            case 'IS_ICC'
                load('CT_TI_featstack_3Dresampled_IS_ICCpruning_grp1.mat');
                top_fea = [800,145,179,164,48,49,462,810,789,151];%IS_ICC_wilcoxon
                cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\IS_ICC_pruning');
        end
        try
            featstack_full=featstack_TI_full;
            featstack_half=featstack_TI_half;
            featstack_safire4=featstack_TI_safire4;
            
            featstack_full(isnan(featstack_TI_full))=0;
            featstack_half(isnan(featstack_TI_half))=0;
            featstack_safire4(isnan(featstack_TI_safire4))=0;
        catch
            featstack_TI_full(isnan(featstack_TI_full))=0;
            featstack_TI_half(isnan(featstack_TI_half))=0;
            featstack_TI_safire4(isnan(featstack_TI_safire4))=0;
        end
        
        featstack_full(isnan(featstack_full))=0;
        featstack_half(isnan(featstack_half))=0;
        featstack_safire4(isnan(featstack_safire4))=0;
        
        pat_id = (1:90)';
        newlist=setdiff(pat_id,dontuse);
        featstack_full = featstack_full(newlist,:);
        labels = labels(:,newlist);
        
        clear featstack_TI*
        
        for dset = 1:2
            dose = tra_dose(1,dset);
            switch dose
                case 'HALF'
                    trainingdata=featstack_half(newlist,:);
                case 'SAF4'
                    trainingdata=featstack_safire4(newlist,:);
            end
            testingdata1=featstack_full_t;
            testingdata2=featstack_half_t;
            testingdata3=featstack_safire4_t;
            
            HO_AUC1=[];
            HO_AUC2=[];
            HO_AUC3=[];
            
            for iter=1:1
                trainingsplit{1}=[1:89];
                trainingsplit = repmat(trainingsplit,1,3);
                testingsplit{1}=[1:74];
                testingsplit = repmat(testingsplit,1,3);
                for fset=1:3
                    training_set=trainingdata(trainingsplit{fset},:);
                    testing_set1=testingdata1(testingsplit{fset},:);
                    testing_set2=testingdata2(testingsplit{fset},:);
                    testing_set3=testingdata3(testingsplit{fset},:);
                    
                    training_labels=labels(trainingsplit{fset});
                    testing_labels=labels_t(testingsplit{fset});
                    options = {'threshmeth','euclidean'};
                    fea=[];
                    fea=top_fea(1,1:num_top_feats);
                    iter
                    fset
                    [~,mean_val,mad_val]=sw_outlier_compensation(training_set);
                    [~,mean_val2,mad_val2]=simplewhiten(training_set,mean_val,mad_val);
                    testing_set1=simplewhiten(testing_set1,mean_val2,mad_val2);
                    testing_set2=simplewhiten(testing_set2,mean_val2,mad_val2);
                    testing_set3=simplewhiten(testing_set3,mean_val2,mad_val2);
                    
                    [temp_stats1_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set1(:,fea), training_labels(:), testing_labels(:), options);
                    [temp_stats2_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set2(:,fea), training_labels(:), testing_labels(:), options);
                    [temp_stats3_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set3(:,fea), training_labels(:), testing_labels(:), options);
                    
                    stats1(iter,fset)=temp_stats1_sw;
                    stats2(iter,fset)=temp_stats2_sw;
                    stats3(iter,fset)=temp_stats1_sw;
                    
                    foldpredictions1_sw{fset} =  temp_stats1_sw.prediction;
                    foldpredictions2_sw{fset} =  temp_stats2_sw.prediction;
                    foldpredictions3_sw{fset} =  temp_stats3_sw.prediction;
                    
                    HO_AUC1(iter,fset)=temp_stats1_sw.AUC  ;
                    HO_AUC2(iter,fset)=temp_stats2_sw.AUC  ;
                    HO_AUC3(iter,fset)=temp_stats2_sw.AUC  ;
                    
                    fea_store{iter,fset}=fea;
                    clear training_set* testing_set1*
                end
            end
            HO_AUC(1,1)=mean(mean(HO_AUC1));
            HO_AUC(1,2)=mean(mean(HO_AUC2));
            HO_AUC(1,3)=mean(mean(HO_AUC3));
            
            save(['CT_TI_3Dresampled_val_grp2_',num2str(num_top_feats),'_',convertStringsToChars(pruning_level),...
                '_',convertStringsToChars(dose),'_Randomforest.mat'],'fea_store','HO_AUC','HO_AUC1','HO_AUC2','HO_AUC3','stats1','stats2','stats3');
        end
    end
    clearvars -except dontuse fselmeth pruning topfea_range pruning_stage tra_dose
end
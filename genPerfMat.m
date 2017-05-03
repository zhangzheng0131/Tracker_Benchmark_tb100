function genPerfMat(seqs, trackers, evalType, nameTrkAll, perfMatPath)

pathAnno = './anno_TB100/';
numTrk = length(trackers);

thresholdSetOverlap = 0:0.05:1;
thresholdSetError = 0:50;

switch evalType
    case 'SRE'
        rpAll=['.\results\results_SRE\'];
    case {'TRE'}
        rpAll=['.\results\results_TRE\'];
    case {'OPE'}
        rpAll=['.\results\results_OPE\results_OPE_OTB100\'];
end

for idxSeq=1:length(seqs)
    %idxSeq=91;
    s = seqs{idxSeq};
    seqzz{idxSeq}=s.name;
    s.len = s.endFrame - s.startFrame + 1;
    s.s_frames = cell(s.len,1);
    nz	= strcat('%0',num2str(s.nz),'d'); %number of zeros in the name of image
    for i=1:s.len
        image_no = s.startFrame + (i-1);
        id = sprintf(nz,image_no);
        s.s_frames{i} = strcat(s.path,id,'.',s.ext);
    end
    
    rect_anno = dlmread([pathAnno s.name '.txt']);
    numSeg = 20;
    [subSeqs, subAnno]=splitSeqTRE(s,numSeg,rect_anno);
    
    nameAll=[];
    for idxTrk=1:numTrk
        
        t = trackers{idxTrk};
        %         load([rpAll s.name '_' t.name '.mat'], 'results','coverage','errCenter');
        if idxTrk~=13
            load([rpAll s.name '_' t.name '.mat'])
        else
            %res.type = res.transformType;
            res.res =  load([rpAll s.name '_' t.name '.mat']);
            res.res = res.res.result;
        end
        trkzz{idxTrk}=t.name;
        disp([s.name ' ' t.name]);
        
        aveCoverageAll=[];
        aveErrCenterAll=[];
        errCvgAccAvgAll = 0;
        errCntAccAvgAll = 0;
        errCoverageAll = 0;
        errCenterAll = 0;
        
        lenALL = 0;
        
        switch evalType
            case 'SRE'
                idxNum = length(results);
                anno=subAnno{1};
            case 'TRE'
                idxNum = length(results);
            case 'OPE'
                idxNum = 1;
                anno=subAnno{1};
        end
        
        successNumOverlap = zeros(idxNum,length(thresholdSetOverlap));
        successNumErr = zeros(idxNum,length(thresholdSetError));
        
        for idx = 1:idxNum
            if idxTrk~=13
                res = results{idx};
            else
                res.res = res.res;
                res.type = results{idx}.type;
                res.fps = results{idx}.fps;
                res.len = results{idx}.len;
                res.annoBegin = results{idx}.annoBegin;
                res.startFrame = results{idx}.startFrame;
            end
            
            if strcmp(evalType, 'TRE')
                anno=subAnno{idx};
            end
            
            len = size(anno,1);
            
            if isempty(res)
                break;
            elseif isempty(res.res)
                break;
            end
            
            if ~isfield(res,'type')&&isfield(res,'transformType')
                res.type = res.transformType;
                res.res = res.res';
            end
            
            [aveCoverage, aveErrCenter, errCoverage, errCenter] = calcSeqErrRobust(res, anno);
            resultszz(idxSeq,idxTrk)=aveCoverage;
            for tIdx=1:length(thresholdSetOverlap)
                successNumOverlap(idx,tIdx) = sum(errCoverage >thresholdSetOverlap(tIdx));
            end
            
            for tIdx=1:length(thresholdSetError)
                successNumErr(idx,tIdx) = sum(errCenter <= thresholdSetError(tIdx));
            end
            
            lenALL = lenALL + len;
            
        end
        
        
        if strcmp(evalType, 'OPE')
            aveSuccessRatePlot(idxTrk, idxSeq,:) = successNumOverlap/(lenALL+eps);
            aveSuccessRatePlotErr(idxTrk, idxSeq,:) = successNumErr/(lenALL+eps);
        else
            aveSuccessRatePlot(idxTrk, idxSeq,:) = sum(successNumOverlap)/(lenALL+eps);
            aveSuccessRatePlotErr(idxTrk, idxSeq,:) = sum(successNumErr)/(lenALL+eps);
        end
        
    end
end
%
%写入到excel数据
[status, message] = xlswrite('F:\Workplace\matlab\tracker_benchmark_v1.1\tracker_benchmark_v1.1\results\result.xlsx', resultszz, 'Sheet1', 'B2:P101');
%行名称与列名称
%textdate=textdate(2,2:5)
[status, message] = xlswrite('F:\Workplace\matlab\tracker_benchmark_v1.1\tracker_benchmark_v1.1\results\result.xlsx', trkzz, 'Sheet1', 'B1:P1');

for i=1:length(seqzz)
    locationzz=['A' num2str(i+1)]; 
    [status, message] = xlswrite('F:\Workplace\matlab\tracker_benchmark_v1.1\tracker_benchmark_v1.1\results\result.xlsx', seqzz(i), 'Sheet1', locationzz);
end
dataName1=[perfMatPath 'aveSuccessRatePlot_' num2str(numTrk) 'alg_overlap_' evalType '.mat'];
save(dataName1,'aveSuccessRatePlot','nameTrkAll');

dataName2=[perfMatPath 'aveSuccessRatePlot_' num2str(numTrk) 'alg_error_' evalType '.mat'];
aveSuccessRatePlot = aveSuccessRatePlotErr;
save(dataName2,'aveSuccessRatePlot','nameTrkAll');

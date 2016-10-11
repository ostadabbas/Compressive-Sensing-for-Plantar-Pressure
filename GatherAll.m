% Gathering all the data
function  [data tm] = GatherAll()
    cfg = expConfig1();
    
    outfile = makeProcFile('GatheredData', '.mat');
    if(~shouldProcess(outfile))
        data = load(outfile, 'data');
        data = data.data;
        tm = getFileTime(outfile);
        return;
    end


    %=== Come up with all Data ===
    data = {};
    for subIdx = 1:numel(cfg.subjects)
        expname = cfg.subjects(subIdx).src;
        
        for lrIdx = 1:2
            lr = cfg.lr{lrIdx};
            
            [inData tmIn1] = procStepAlign1(expname, lr);
            params = {expname, lr};
                %--- Get Training Point Data ---
            pdata = getPointData1(inData([inData.train]));
            testPdata = getPointData1(inData(~[inData.train]));
            ntrain = sum([inData.train]);
            ntest = sum(~[inData.train]);
            data{subIdx,lrIdx}.datatrain = cat(2,pdata{:});
            data{subIdx,lrIdx}.datatest = cat(2,testPdata{:});
            data{subIdx,lrIdx}.params=params;
                    
        end % lr
    end % sub
    
    %=== Output file ===    
    save(outfile, 'data');
    tm = getFileTime(outfile);
    
end
    
    
    
    % compute the individual points
function pdata = getPointData1(data)%, sensorLocs)
    pdata = {};
    
%     if(nargin < 2)
%         mask = squeeze(mean(cat(3,data.rmax),3));
%         sensorLocs = find(mask>0);
%     end
    
    for step_idx=1:numel(data)
        pdata = horzcat(pdata, getOnePointData1(data(step_idx)));%, sensorLocs));
    end

end

function pdata = getOnePointData1(stepd)%, sensorLocs)

    pdata = {};
    fdataAll = stepd.rfdata;
    
        
    %=== Loop through all frames ===
    for frame=1:stepd.frames
        fdata = squeeze(fdataAll(:,:,frame));
        %pd = [];
 
        % get values
        %idx = sensorLocs;
        Vs = fdata(:);
        %[Xs Ys] = ind2sub(size(fdata),idx);

        %--- save the values ---
        pdata{frame} = [Vs];

    end
    
end
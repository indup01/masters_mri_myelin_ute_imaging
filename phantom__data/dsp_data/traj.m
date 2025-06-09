function result = traj(GRAD,stridx,endidx,TR,readout_pts)
%   This function removes the spoiler gradient in every readout
%   INPUTS:
%       GRAD         - array with gradient waveform after removal of
%                      spoilergradient [units of mT/m]
%       stridx       - variables indicate the index after RF excitation
%       endidx       - variables indicate the end index for time
%                      integration
%       TR           - Repetition Time[units of ms]
%       readout_pts  - variables indicate no. of samples in one readout

%   OUTPUTS: 
%       result       - array of the nominal gradient waveform without spoiler
%                      gradient [units of mT/m]

    %no. of samples in one readout, 5us sampling period
    TR_in_pts = TR * 200;
    result = [];
    gamma_HzpmT = 42.577478518e3; % For sodium: 11.26e3;
    ADCdwelltime = 5E-6;
    idx = stridx; 

    %no. of samples between RF excitation and end of trajectory (excluding
    %rewinders)
    sample = endidx - idx; 

    while idx + sample <= numel(GRAD)
        GRAD_segment = GRAD(idx:idx+sample);
        traj = 2 * pi * gamma_HzpmT *  ADCdwelltime * cumsum(GRAD_segment);
        result = [result; traj(numel(GRAD_segment)-readout_pts+1:end)];  % Ensure segment is a column vector
        idx = idx+TR_in_pts;
    end
end
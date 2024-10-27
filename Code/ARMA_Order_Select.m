function [AR_Order,MA_Order] = ARMA_Order_Select(data,max_ar,max_ma,di)
% Violently determine the order by criteria such as AIC and BIC, with differentiation term
% Input:
% data - Object data
% max_ar - Maximum order for AR model search
% max_ma - Maximum order for MA model search
% di - Differentiation order
% Output:
% AR_Orderr - Output order of the AR model
% MA_Orderr - Output order of the MA model

T = length(data);

for ar = 0:max_ar
    for ma = 0:max_ma
        if ar==0&&ma==0
            infoC_Sum = NaN;
            continue
        end
        try
            Mdl = arima(ar, di, ma);
            [~, ~, LogL] = estimate(Mdl, data, 'Display', 'off');
            [aic,bic] = aicbic(LogL,(ar+ma+2),T); % In addition to AR and MA, there are also constants and variances, hence +2.
            infoC_Sum(ar+1,ma+1) = bic+aic;  % Select the sum of BIC and AIC as the standard
        catch ME % Catch error information
            msgtext = ME.message;
            if (strcmp(ME.identifier,'econ:arima:estimate:InvalidVarianceModel'))
                 infoC_Sum(ar+1,ma+1) = NaN; % Cannot estimate parameters, directly set to NaN.
                %msgtext = [msgtext,'  ','Cannot estimate ARMA parameters due to small data length and high model orders. Reduce max_ar and max_ma values']
            else
                %msgbox(msgtext, 'error') % Turn off popup error notifications.
                infoC_Sum(ar+1,ma+1) = NaN; % Cannot estimate parameters, directly set to NaN.
            end
        end
    end
end
[x, y]=find(infoC_Sum==min(min(infoC_Sum)));
AR_Order = x -1;
MA_Order = y -1;
end
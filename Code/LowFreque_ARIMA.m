clc,clear,close all

name='Tailembend';%'LOCK9'; 'Mannum'; 'Morgan'; 'MurrayBridge'; 'Tailembend'
switch name
    case 'LOCK9'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Lock_9\Lock_9.csv');
    case 'Mannum'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Mannum\Mannum.csv');
    case 'Morgan'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Morgan\Morgan.csv');
    case 'MurrayBridge'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\MurrayBridge\Murray_Bridge.csv');
    case 'Tailembend'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Tailembend\Tailembend.csv');
end
 
% Wavelet Decomposition and Plotting
figure
plot(A(1:1248,7))
[C,L]=wavedec(A(1:1248,7),3,'sym10');
Sa3=wrcoef('a',C,L,'sym10',3); 
Sd3=wrcoef('d',C,L,'sym10',3); 
Sd2=wrcoef('d',C,L,'sym10',2); 
Sd1=wrcoef('d',C,L,'sym10',1); 

 %% %ori
s(:,1)=A(1:1248,7);
y=s;
len = length(y);

% ACF and PACF Plot Examination
% Original data
y_adf = adftest(y)
y_kpss = kpsstest(y)

% Differencing the original data
dy = diff( y );
dy_adf = adftest(dy)
dy_kpss = kpsstest(dy)

% Applying a second-order difference to the original data
ddy=diff(dy);
ddy_adf = adftest(ddy)
ddy_kpss = kpsstest(ddy)
aimy = y;

% Forcefully determining the order through criteria such as AIC and BIC
max_ar = 5;
max_ma = 5;
[AR_Order,MA_Order] = ARMA_Order_Select(aimy,max_ar,max_ma,1)

% 4.ARIMA Model Construction and Residual Testing
Mdl = arima(AR_Order, 1, MA_Order);
EstMdl = estimate(Mdl,aimy);
[res,~,~] = infer(EstMdl,aimy);   % res is the residual

stdr = res/sqrt(EstMdl.Variance);

figure('Name','Residual Testing')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)

% Durbin-Watson
% White Noise Test
diffRes0 = diff(res);  
SSE0 = res'*res;
DW0 = (diffRes0'*diffRes0)/SSE0 % Durbin-Watson statistic
Predict_dY=zeros(1248,1);

% 5.Single-step Predicion
numSteps = 1; 
for i = 6 :length(aimy) 
    Predict_dY(i+1) = forecast(EstMdl,numSteps,'Y0',aimy(1:i));  
end
Predict_y=Predict_dY;
Predict_y=Predict_y(1:end-1); 
figure
plot(Predict_y(1248-104+1:end),'-bv')
hold on
plot(A(1248-104+1:end,7),'-ro')
title('Prediction Results of Original Data')
legend('Predicted Value','True value')
xlabel('Years')
set(gca,'xtick',[1:52:1248])
set(gca,'xticklabel',[1994:1:2017])

Loss_ori=A(1:1248,7)-Predict_y;
Predict_ori=Predict_y;
figure
plot(Loss_ori)

 %% %a3
s(:,1)=Sa3(:,1);
y=s;
len = length(y);

% ACF and PACF Plot Examination
% Original data
y_adf = adftest(y)
y_kpss = kpsstest(y)

% Differencing the original data
dy = diff( y );
dy_adf = adftest(dy)
dy_kpss = kpsstest(dy)

% Applying a second-order difference to the original data
ddy=diff(dy);
ddy_adf = adftest(ddy)
ddy_kpss = kpsstest(ddy)
aimy = y;

% Forcefully determining the order through criteria such as AIC and BIC
max_ar = 5;
max_ma = 5;
[AR_Order,MA_Order] = ARMA_Order_Select(aimy,max_ar,max_ma,1)

% 4.ARIMA Model Construction and Residual Testing
Mdl = arima(AR_Order, 1, MA_Order);
EstMdl = estimate(Mdl,aimy);
[res,~,~] = infer(EstMdl,aimy);   % res is the residual

stdr = res/sqrt(EstMdl.Variance);

figure('Name','Residual Testing')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)

% Durbin-Watson
% White Noise Test
diffRes0 = diff(res);  
SSE0 = res'*res;
DW0 = (diffRes0'*diffRes0)/SSE0 % Durbin-Watson statistic
Predict_dY=zeros(1248,1);

% 5.Single-step Predicion
numSteps = 1; 
for i = 6 :length(aimy) 
    Predict_dY(i+1) = forecast(EstMdl,numSteps,'Y0',aimy(1:i));  
end
Predict_y=Predict_dY;
Predict_y=Predict_y(1:end-1); 
figure
plot(Predict_y(1248-104+1:end),'-bv')
hold on
plot(Sa3(1248-104+1:end),'-ro')
title('Prediction Results of a3')
legend('Predicted Value','True value')
xlabel('Years')
set(gca,'xtick',[1:52:1248])
set(gca,'xticklabel',[1994:1:2017])

Loss_a3=Sa3(1:1248)-Predict_y;
Predict_a3=Predict_y;
figure
plot(Loss_a3)

 %% %d3
s(:,1)=Sd3(:,1);
y=s;
len = length(y);

% ACF and PACF Plot Examination
% Original data
y_adf = adftest(y)
y_kpss = kpsstest(y)

% Differencing the original data
dy = diff( y );
dy_adf = adftest(dy)
dy_kpss = kpsstest(dy)

% Applying a second-order difference to the original data
ddy=diff(dy);
ddy_adf = adftest(ddy)
ddy_kpss = kpsstest(ddy)
aimy = y;

% Forcefully determining the order through criteria such as AIC and BIC
max_ar = 5;
max_ma = 5;
[AR_Order,MA_Order] = ARMA_Order_Select(aimy,max_ar,max_ma,1)

% 4.ARIMA Model Construction and Residual Testing
Mdl = arima(AR_Order, 1, MA_Order);
EstMdl = estimate(Mdl,aimy);
[res,~,~] = infer(EstMdl,aimy);   % res is the residual

stdr = res/sqrt(EstMdl.Variance);

figure('Name','Residual Testing')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)

% Durbin-Watson
% White Noise Test
diffRes0 = diff(res);  
SSE0 = res'*res;
DW0 = (diffRes0'*diffRes0)/SSE0 % Durbin-Watson statistic
Predict_dY=zeros(1248,1);

% 5.Single-step Predicion
numSteps = 1; 
for i = 6:length(aimy) 
    Predict_dY(i+1) = forecast(EstMdl,numSteps,'Y0',aimy(1:i));  
end
Predict_y = Predict_dY; 
Predict_y=Predict_y(1:end-1); 
figure
plot(Predict_y(1248-104+1:end),'-bv')
hold on
plot(Sd3(1248-104+1:end),'-ro')
title('Prediction Results of d3')
legend('Predicted Value','True value')
xlabel('Years')
set(gca,'xtick',[1:52:1248])
set(gca,'xticklabel',[1994:1:2017])

Loss_d3=Sd3(1:1248)-Predict_y;
Predict_d3=Predict_y;
figure
plot(Loss_d3)

 %% %d2
s(:,1)=Sd2(:,1);
y=s;
len = length(y);

% ACF and PACF Plot Examination
% Original data
y_adf = adftest(y)
y_kpss = kpsstest(y)

% Differencing the original data
dy = diff( y );
dy_adf = adftest(dy)
dy_kpss = kpsstest(dy)

% Applying a second-order difference to the original data
ddy=diff(dy);
ddy_adf = adftest(ddy)
ddy_kpss = kpsstest(ddy)
aimy = y;

% Forcefully determining the order through criteria such as AIC and BIC
max_ar = 5;
max_ma = 5;
[AR_Order,MA_Order] = ARMA_Order_Select(aimy,max_ar,max_ma,1)

% 4.ARIMA Model Construction and Residual Testing
Mdl = arima(AR_Order, 1, MA_Order);
EstMdl = estimate(Mdl,aimy);
[res,~,~] = infer(EstMdl,aimy);   % res is the residual

stdr = res/sqrt(EstMdl.Variance);

figure('Name','Residual Testing')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)

% Durbin-Watson
% White Noise Test
diffRes0 = diff(res);  
SSE0 = res'*res;
DW0 = (diffRes0'*diffRes0)/SSE0 % Durbin-Watson statistic
Predict_dY=zeros(1248,1);

% 5.Single-step Predicion
numSteps = 1; 
for i = 6:length(aimy) 
    Predict_dY(i+1) = forecast(EstMdl,numSteps,'Y0',aimy(1:i));  
end
Predict_y = Predict_dY; 
Predict_y=Predict_y(1:end-1); 
figure
plot(Predict_y(1248-104+1:end),'-bv')
hold on
plot(Sd2(1248-104+1:end),'-ro')
title('Prediction Results of d2')
legend('Predicted Value','True value')
xlabel('Years')
set(gca,'xtick',[1:52:1248])
set(gca,'xticklabel',[1994:1:2017])

Loss_d2=Sd2(1:1248)-Predict_y;
Predict_d2=Predict_y;
figure
plot(Loss_d2)

 %% %d1
s(:,1)=Sd1(:,1);
y=s;
len = length(y);

% ACF and PACF Plot Examination
% Original data
y_adf = adftest(y)
y_kpss = kpsstest(y)

% Differencing the original data
dy = diff( y );
dy_adf = adftest(dy)
dy_kpss = kpsstest(dy)

% Applying a second-order difference to the original data
ddy=diff(dy);
ddy_adf = adftest(ddy)
ddy_kpss = kpsstest(ddy)
aimy = y;

% Forcefully determining the order through criteria such as AIC and BIC
max_ar = 5;
max_ma = 5;
[AR_Order,MA_Order] = ARMA_Order_Select(aimy,max_ar,max_ma,1)

% 4.ARIMA Model Construction and Residual Testing
Mdl = arima(AR_Order, 1, MA_Order);
EstMdl = estimate(Mdl,aimy);
[res,~,~] = infer(EstMdl,aimy);   % res is the residual

stdr = res/sqrt(EstMdl.Variance);

figure('Name','Residual Testing')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)

% Durbin-Watson
% White Noise Test
diffRes0 = diff(res);  
SSE0 = res'*res;
DW0 = (diffRes0'*diffRes0)/SSE0 % Durbin-Watson statistic
Predict_dY=zeros(1248,1);

% 5.Single-step Predicion
numSteps = 1; 
for i = 6:length(aimy) 
    Predict_dY(i+1) = forecast(EstMdl,numSteps,'Y0',aimy(1:i));  
end
Predict_y = Predict_dY; 
Predict_y=Predict_y(1:end-1); 
figure
plot(Predict_y(1248-104+1:end),'-bv')
hold on
plot(Sd1(1248-104+1:end),'-ro')
title('Prediction Results of d1')
legend('Predicted Value','True value')
xlabel('Years')
set(gca,'xtick',[1:52:1248])
set(gca,'xticklabel',[1994:1:2017])

Loss_d1=Sd1(1:1248)-Predict_y;
Predict_d1=Predict_y;
figure
plot(Loss_d1)

%% % Display of Prediction Results
Predict=Predict_a3+Predict_d3+Predict_d2+Predict_d1;
Observed=Sd1+Sd2+Sd3+Sa3;
figure
plot(Predict(1254-104+1:end),'-bv')
hold on
plot(Observed(1254-104+1:end),'-ro')
title('Prediction Results of Decomposed Data')
legend('Predicted Value','True value')
xlabel('Years')
set(gca,'xtick',[1:52:1248])
set(gca,'xticklabel',[1994:1:2017])
%% %Save
Date=[1:1248]';
switch name %'LOCK9'; 'Mannum'; 'Morgan'; 'MurrayBridge'; 'Tailembend'
    case 'LOCK9'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1,Loss_ori,Loss_a3,Loss_d3,Loss_d2,Loss_d1];
        filename = 'ARIMA_LOCK9.csv'; % file path
        csvwrite(filename, data,1); 
    case 'Mannum'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1,Loss_ori,Loss_a3,Loss_d3,Loss_d2,Loss_d1];
        filename = 'ARIMA_Mannum.csv';
        csvwrite(filename, data,1); 
    case 'Morgan'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1,Loss_ori,Loss_a3,Loss_d3,Loss_d2,Loss_d1];
        filename = 'ARIMA_Morgan.csv'; 
        csvwrite(filename, data,1); 
    case 'MurrayBridge'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1,Loss_ori,Loss_a3,Loss_d3,Loss_d2,Loss_d1];
        filename = 'ARIMA_MurrayBridge.csv';
        csvwrite(filename, data,1); 
    case 'Tailembend'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1,Loss_ori,Loss_a3,Loss_d3,Loss_d2,Loss_d1];
        filename = 'ARIMA_Tailembend.csv'; 
        csvwrite(filename, data,1);
end

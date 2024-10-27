clear all; close all; clc

name='Tailembend';%'LOCK9'; 'Mannum'; 'Morgan'; 'MurrayBridge'; 'Tailembend'
switch name
    case 'LOCK9'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Lock_9\Lock_9.csv');
        AR=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_LOCK9.csv');
    case 'Mannum'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Mannum\Mannum.csv');
        AR=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Mannum.csv');
    case 'Morgan'
        A=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\Morgan.csv');
        AR=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Morgan.csv');
    case 'MurrayBridge'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\MurrayBridge\Murray_Bridge.csv');
        AR=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_MurrayBridge.csv');
    case 'Tailembend'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Tailembend\Tailembend.csv');
        AR=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Tailembend.csv');
end
%Assign Concentration Residuals
ori_Cyano=AR(:,7);
s3_Cyano=AR(:,11); 
s4_Cyano=AR(:,10);
s5_Cyano=AR(:,9); 
s6_Cyano=AR(:,8); 
%Decompossing Discharge
[c,l]=wavedec(A(1:1248,2),3,'sym10');
ori_Discharge=A(1:1248,2);
s3_Discharge=wrcoef('d',c,l,'sym10',1); %Reconstruct detail coefficients to match the decomposed data length with the original data
s4_Discharge=wrcoef('d',c,l,'sym10',2);
s5_Discharge=wrcoef('d',c,l,'sym10',3);%Reconstruct high-frequency components
s6_Discharge=wrcoef('a',c,l,'sym10',3);%Reconstruct low-frequency components
%Decompossing Velocity
[c,l]=wavedec(A(1:1248,3),3,'sym10');
ori_Velocity=A(1:1248,3);
s3_Velocity=wrcoef('d',c,l,'sym10',1);
s4_Velocity=wrcoef('d',c,l,'sym10',2);
s5_Velocity=wrcoef('d',c,l,'sym10',3);
s6_Velocity=wrcoef('a',c,l,'sym10',3); 
%Decompossing Temperature
[c,l]=wavedec(A(1:1248,4),3,'sym10');
ori_Temperature=A(1:1248,4);
s3_Temperature=wrcoef('d',c,l,'sym10',1); 
s4_Temperature=wrcoef('d',c,l,'sym10',2);
s5_Temperature=wrcoef('d',c,l,'sym10',3); 
s6_Temperature=wrcoef('a',c,l,'sym10',3); 
%Decompossing Salinity
[c,l]=wavedec(A(1:1248,5),3,'sym10');
ori_Salinity=A(1:1248,5);
s3_Salinity=wrcoef('d',c,l,'sym10',1); 
s4_Salinity=wrcoef('d',c,l,'sym10',2);
s5_Salinity=wrcoef('d',c,l,'sym10',3); 
s6_Salinity=wrcoef('a',c,l,'sym10',3); 

%% %Original Data
S=[ori_Discharge,ori_Velocity,ori_Temperature,ori_Salinity,ori_Cyano]; 
[d,ps] = mapminmax(S');
data=d';
STEP=4;
test_len = 104;
data_len = length(data)-STEP;
train_len= data_len-test_len;
for i=1:train_len
    x = data(i:i+STEP-1,:);
    y = data(i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_train(:,i) = x;
    y_train(i) = y;
end
for i=1:test_len
    x = data(train_len+i:train_len+i+STEP-1,:);
    y = data(train_len+i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_test(:,i)=x;
    y_test(i)=y;
end

numFeatures =  size(x_train, 1);
numHiddenUnits1 = 80;
Learning_Rate=0.0075;
numResponses = 1;

layers = [sequenceInputLayer(numFeatures,"Name","sequence")
    lstmLayer(numHiddenUnits1,"Name","lstm")
    tanhLayer("Name","tanh_1")
    fullyConnectedLayer(1,"Name","fc")
    regressionLayer("Name","regressionoutput")];

miniBatchSize =32;
MaxEpochs=500;

options = trainingOptions('adam', ...
    'ExecutionEnvironment', 'cpu', ...
    'MaxEpochs', MaxEpochs, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', Learning_Rate, ...
    'Verbose', false, ...
    'Shuffle','never', ...
    'Plots', 'training-progress');

net = trainNetwork(x_train,y_train,layers,options);

y_train_pre = predict(net, x_train,'MiniBatchSize', miniBatchSize);
ytrain_pre=mapminmax('reverse',y_train_pre,ps);
ytrain_pre=ytrain_pre(end,:);
ytrain=mapminmax('reverse',y_train,ps);
ytrain=ytrain(end,:);
ytrain_pre_ori_residual=y_train_pre;

err_train=[];
err_train = ytrain_pre - ytrain;
figure(1)
subplot(2,1,1);
plot(ytrain_pre,'-bv');
hold on
plot(ytrain,'-ro');
title('(c) Prediction of original data')
legend('Predicted','Observed')
xlabel('Year')
subplot(2,1,2);
plot(err_train);
title('(c) Prediction error of high-frequency 3rd decomposition')
xlabel('Year')
rmse_train = rms(err_train)

y_test_pre = predict(net, x_test);
ytest_pre=mapminmax('reverse',y_test_pre,ps);
ytest_pre=ytest_pre(end,:);
ytest=mapminmax('reverse',y_test,ps);
ytest=ytest(end,:);
err_test = ytest_pre - ytest;
rmse_test = rms(err_test)
ytest_pre_ori_residual=ytest_pre;

figure
plot(ytest_pre,'-bv');
hold on
plot(ytest,'-ro');
title('Prediction of original data')
legend('Predicted','Observed')
xlabel('Year')
set(gca,'xtick',[1:52:104])
set(gca,'xticklabel',[2016:1:2018])


%% %G1
S=[s3_Discharge,s3_Velocity,s3_Temperature,s3_Salinity,s3_Cyano];
[d,ps] = mapminmax(S');
data=d';
test_len = 104;
data_len = length(data)-STEP;
train_len= data_len-test_len;
for i=1:train_len
    x = data(i:i+STEP-1,:);
    y = data(i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_train(:,i) = x;
    y_train(i) = y;
end
for i=1:test_len
    x = data(train_len+i:train_len+i+STEP-1,:);
    y = data(train_len+i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_test(:,i)=x;
    y_test(i)=y;
end


numFeatures =  size(x_train, 1);
numResponses = 1;

layers = [sequenceInputLayer(numFeatures,"Name","sequence")
    lstmLayer(numHiddenUnits1,"Name","bilstm")
    tanhLayer("Name","tanh_1")
    fullyConnectedLayer(1,"Name","fc")
    regressionLayer("Name","regressionoutput")];

options = trainingOptions('adam', ...
    'ExecutionEnvironment', 'cpu', ...
    'MaxEpochs', MaxEpochs, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', Learning_Rate, ...
    'Verbose', false, ...
    'Shuffle','never', ...
    'Plots', 'training-progress');

net = trainNetwork(x_train,y_train,layers,options);

y_train_pre = predict(net, x_train,'MiniBatchSize', miniBatchSize);
ytrain_pre=mapminmax('reverse',y_train_pre,ps);
ytrain_pre=ytrain_pre(end,:);
ytrain=mapminmax('reverse',y_train,ps);
ytrain=ytrain(end,:);
ytrain_pre_d1_residual=y_train_pre;

err_train = ytrain_pre - ytrain;
figure(1)
subplot(2,1,1);
plot(ytrain_pre,'-bv');
hold on
plot(ytrain,'-ro');
title('(c) Prediction of original data')
legend('Predicted','Observed')
xlabel('Year')
subplot(2,1,2);
plot(err_train);
title('(c) Prediction error of high-frequency 3rd decomposition')
xlabel('Year')

rmse_train = rms(err_train)

y_test_pre = predict(net, x_test);
ytest_pre=mapminmax('reverse',y_test_pre,ps);
ytest_pre=ytest_pre(end,:);
ytest=mapminmax('reverse',y_test,ps);
ytest=ytest(end,:);
err_test = ytest_pre - ytest;
rmse_test = rms(err_test)
ytest_pre_d1_residual=ytest_pre;

figure
plot(ytest_pre,'-bv');
hold on
plot(ytest,'-ro');
title('Prediction of d1 data')
legend('Predicted','Observed')
xlabel('Year')
set(gca,'xtick',[1:52:104])
set(gca,'xticklabel',[2016:1:2018])

%% %G2
S=[s4_Discharge,s4_Velocity,s4_Temperature,s4_Salinity,s4_Cyano];
[d,ps] = mapminmax(S');
data=d';
test_len = 104;
data_len = length(data)-STEP;
train_len= data_len-test_len;
for i=1:train_len
    x = data(i:i+STEP-1,:);
    y = data(i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_train(:,i) = x;
    y_train(i) = y;
end
for i=1:test_len
    x = data(train_len+i:train_len+i+STEP-1,:);
    y = data(train_len+i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_test(:,i)=x;
    y_test(i)=y;
end

numFeatures =  size(x_train, 1);
numResponses = 1;

layers = [sequenceInputLayer(numFeatures,"Name","sequence")
    lstmLayer(numHiddenUnits1,"Name","bilstm")
    tanhLayer("Name","tanh_1")
    fullyConnectedLayer(1,"Name","fc")
    regressionLayer("Name","regressionoutput")];

options = trainingOptions('adam', ...
    'ExecutionEnvironment', 'cpu', ...
    'MaxEpochs', MaxEpochs, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', Learning_Rate, ...
    'Verbose', false, ...
    'Shuffle','never', ...
    'Plots', 'training-progress');

net = trainNetwork(x_train,y_train,layers,options);

y_train_pre = predict(net, x_train,'MiniBatchSize', miniBatchSize);
ytrain_pre=mapminmax('reverse',y_train_pre,ps);
ytrain_pre=ytrain_pre(end,:);
ytrain=mapminmax('reverse',y_train,ps);
ytrain=ytrain(end,:);
ytrain_pre_d2_residual=y_train_pre;

err_train = ytrain_pre - ytrain;
figure(1)
subplot(2,1,1);
plot(ytrain_pre,'-bv');
hold on
plot(ytrain,'-ro');
title('(c) Prediction of original data')
legend('Predicted','Observed')
xlabel('Year')
subplot(2,1,2);
plot(err_train);
title('(c) Prediction error of high-frequency 3rd decomposition')
xlabel('Year')

rmse_train = rms(err_train)

y_test_pre = predict(net, x_test);
ytest_pre=mapminmax('reverse',y_test_pre,ps);
ytest_pre=ytest_pre(end,:);
ytest=mapminmax('reverse',y_test,ps);
ytest=ytest(end,:);
err_test = ytest_pre - ytest;
rmse_test = rms(err_test)
ytest_pre_d2_residual=ytest_pre;

figure
plot(ytest_pre,'-bv');
hold on
plot(ytest,'-ro');
title('Prediction of d2')
legend('Predicted','Observed')
xlabel('Year')
set(gca,'xtick',[1:52:104])
set(gca,'xticklabel',[2016:1:2018])

%% %G3
S=[s5_Discharge,s5_Velocity,s5_Temperature,s5_Salinity,s5_Cyano];
[d,ps] = mapminmax(S');
data=d';
test_len = 104;
data_len = length(data)-STEP;
train_len= data_len-test_len;
for i=1:train_len
    x = data(i:i+STEP-1,:);
    y = data(i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_train(:,i) = x;
    y_train(i) = y;
end
for i=1:test_len
    x = data(train_len+i:train_len+i+STEP-1,:);
    y = data(train_len+i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_test(:,i)=x;
    y_test(i)=y;
end

numFeatures =  size(x_train, 1);
numResponses = 1;

layers = [sequenceInputLayer(numFeatures,"Name","sequence")
    lstmLayer(numHiddenUnits1,"Name","bilstm")
    tanhLayer("Name","tanh_1")
    fullyConnectedLayer(1,"Name","fc")
    regressionLayer("Name","regressionoutput")];

options = trainingOptions('adam', ...
    'ExecutionEnvironment', 'cpu', ...
    'MaxEpochs', MaxEpochs, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', Learning_Rate, ...
    'Verbose', false, ...
    'Shuffle','never', ...
    'Plots', 'training-progress');

net = trainNetwork(x_train,y_train,layers,options);

y_train_pre = predict(net, x_train,'MiniBatchSize', miniBatchSize);
ytrain_pre=mapminmax('reverse',y_train_pre,ps);
ytrain_pre=ytrain_pre(end,:);
ytrain=mapminmax('reverse',y_train,ps);
ytrain=ytrain(end,:);
ytrain_pre_d3_residual=y_train_pre;

err_train = ytrain_pre - ytrain;
figure(1)
subplot(2,1,1);
plot(ytrain_pre,'-bv');
hold on
plot(ytrain,'-ro');
title('(c) Prediction of original data')
legend('Predicted','Observed')
xlabel('Year')
subplot(2,1,2);
plot(err_train);
title('(c) Prediction error of high-frequency 3rd decomposition')
xlabel('Year')

rmse_train = rms(err_train)

y_test_pre = predict(net, x_test);
ytest_pre=mapminmax('reverse',y_test_pre,ps);
ytest_pre=ytest_pre(end,:);
ytest=mapminmax('reverse',y_test,ps);
ytest=ytest(end,:);
err_test = ytest_pre - ytest;
rmse_test = rms(err_test)
ytest_pre_d3_residual=ytest_pre;

figure
plot(ytest_pre,'-bv');
hold on
plot(ytest,'-ro');
title('Prediction of d3')
legend('Predicted','Observed')
xlabel('Year')
set(gca,'xtick',[1:52:104])
set(gca,'xticklabel',[2016:1:2018])

%% %D3
S=[s6_Discharge,s6_Velocity,s6_Temperature,s6_Salinity,s6_Cyano];
[d,ps] = mapminmax(S');
data=d';
test_len = 104;
data_len = length(data)-STEP;
train_len= data_len-test_len;
for i=1:train_len
    x = data(i:i+STEP-1,:);
    y = data(i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_train(:,i) = x;
    y_train(i) = y;
end
for i=1:test_len
    x = data(train_len+i:train_len+i+STEP-1,:);
    y = data(train_len+i+STEP,end);
    x = reshape(x,[size(x,2)*STEP,1]);
    x_test(:,i)=x;
    y_test(i)=y;
end

numResponses = 1;

layers = [sequenceInputLayer(numFeatures,"Name","sequence")
    lstmLayer(numHiddenUnits1,"Name","bilstm")
    tanhLayer("Name","tanh_1")
    fullyConnectedLayer(1,"Name","fc")
    regressionLayer("Name","regressionoutput")];

options = trainingOptions('adam', ...
    'ExecutionEnvironment', 'cpu', ...
    'MaxEpochs', MaxEpochs, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', Learning_Rate, ...
    'Verbose', false, ...
    'Shuffle','never', ...
    'Plots', 'training-progress');

net = trainNetwork(x_train,y_train,layers,options);

y_train_pre = predict(net, x_train,'MiniBatchSize', miniBatchSize);
ytrain_pre=mapminmax('reverse',y_train_pre,ps);
ytrain_pre=ytrain_pre(end,:);
ytrain=mapminmax('reverse',y_train,ps);
ytrain=ytrain(end,:);
ytrain_pre_a3_residual=y_train_pre;

err_train = ytrain_pre - ytrain;
figure(1)
subplot(2,1,1);
plot(ytrain_pre,'-bv');
hold on
plot(ytrain,'-ro');
title('(c) Prediction of original data')
legend('Predicted','Observed')
xlabel('Year')
subplot(2,1,2);
plot(err_train);
title('(c) Prediction error of high-frequency 3rd decomposition')
xlabel('Year')

rmse_train = rms(err_train)

y_test_pre = predict(net, x_test);
ytest_pre=mapminmax('reverse',y_test_pre,ps);
ytest_pre=ytest_pre(end,:);
ytest=mapminmax('reverse',y_test,ps);
ytest=ytest(end,:);
err_test = ytest_pre - ytest;
rmse_test = rms(err_test)
ytest_pre_a3_residual=ytest_pre;

figure
plot(ytest_pre,'-bv');
hold on
plot(ytest,'-ro');
title('Prediction of a3')
legend('Predicted','Observed')
xlabel('Year')
set(gca,'xtick',[1:52:104])
set(gca,'xticklabel',[2016:1:2018])

%% %Summarize and evaluate prediction results
test=ytest_pre_d1_residual+ytest_pre_d2_residual+ytest_pre_d3_residual+ytest_pre_a3_residual;
AA=A(1248-104+1:1248,7);
test(test<0)=0;
Error=AA-test';
RMSE=sqrt([sum((Error).^2)]/104)
NSE=1-[sum((Error).^2)]./[sum((AA-mean(AA)).^2)]
COR=corr(AA,test')

%2016
figure
plot(AA(1:52),'-ro','LineWidth',1); 
hold on
plot(test(1:52),'-.mo','LineWidth',1); 
hold on
title('(a) 2016','FontName','Times new roman');
legend('Observed','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/milliliter)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');

%2017
figure
plot(AA(53:104),'-ro','LineWidth',1); 
hold on
plot(test(53:104),'-.mo','LineWidth',1); 
hold on
title('(b) 2017','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cells/milliliter)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350]); 

figure
plot(AA,'-ro','LineWidth',1);
hold on
plot(test,'-.mo','LineWidth',1); 
hold on
title('(a) 2016&2017','FontName','Times new roman');
legend('Observed','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/milliliter)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52*2])
set(gca,'xlim',[1,52.1*2])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec','Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northeast');

%% %Save
Date=[5:1248]';
Predict_ori=[ytrain_pre_ori_residual,ytest_pre_ori_residual]';
Predict_a3=[ytrain_pre_a3_residual,ytest_pre_a3_residual]';
Predict_d3=[ytrain_pre_d3_residual,ytest_pre_d3_residual]';
Predict_d2=[ytrain_pre_d2_residual,ytest_pre_d2_residual]';
Predict_d1=[ytrain_pre_d1_residual,ytest_pre_d1_residual]';
switch name %'LOCK9'; 'Mannum'; 'Morgan'; 'MurrayBridge'; 'Tailembend'
    case 'LOCK9'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1];
        filename = 'ResidualLSTM_LOCK9.csv'; % File Path
        csvwrite(filename, data,1); 
    case 'Mannum'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1];
        filename = 'ResidualLSTM_Mannum.csv'; 
        csvwrite(filename, data,1); 
    case 'Morgan'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1];
        filename = 'ResidualLSTM_Morgan.csv'; 
        csvwrite(filename, data,1); 
    case 'MurrayBridge'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1];
        filename = 'ResidualLSTM_MurrayBridge.csv'; 
        csvwrite(filename, data,1); 
    case 'Tailembend'
        data=[Date,Predict_ori,Predict_a3,Predict_d3,Predict_d2,Predict_d1];
        filename = 'ResidualLSTM_Tailembend.csv'; 
        csvwrite(filename, data,1); 
end


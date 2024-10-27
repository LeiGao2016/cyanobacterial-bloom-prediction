clc
clear
close all

name='LOCK9';%'LOCK9'; 'Mannum'; 'Morgan'; 'MurrayBridge'; 'Tailembend'
switch name
    case 'LOCK9'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Lock_9\Lock_9.csv');
        A=A(1145:1248,7); %Predict for two years 52*2
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Lock9.csv');%LowFrqPre-ARIMA
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Lock9.csv');%LowFrqPre-LSTM
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Lock9.csv');%HighFreqPre
        E=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\PSOANN_Lock9.csv');%Comp
    case 'Mannum'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Mannum\Mannum.csv');
        A=A(1145:1248,7); 
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Mannum.csv');
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Mannum.csv');
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Mannum.csv');
        E=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\PSOANN_Mannum.csv');
    case 'Morgan'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Morgan\Morgan.csv');
        A=A(1145:1248,7); 
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Morgan.csv');
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Morgan.csv');
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Morgan.csv');
        E=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\PSOANN_Morgan.csv');
    case 'MurrayBridge'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\MurrayBridge\Murray_Bridge.csv');
        A=A(1145:1248,7); 
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_MurrayBridge.csv');
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_MurrayBridge.csv');
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_MurrayBridge.csv');
        E=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\PSOANN_MurrayBridge.csv');
    case 'Tailembend'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Tailembend\Tailembend.csv');
        A=A(1145:1248,7); 
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Tailembend.csv');
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Tailembend.csv');
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Tailembend.csv');
        E=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\PSOANN_Tailembend.csv');
end

Predictori_DoubleLSTM=D(:,2);
Predicta3_DoubleLSTM=D(:,3);
Predictd3_DoubleLSTM=D(:,4);
Predictd2_DoubleLSTM=D(:,5);
Predictd1_DoubleLSTM=D(:,6);

Predictori_ARIMA=B(5:end,2);
Predicta3_ARIMA=B(5:end,3);
Predictd3_ARIMA=B(5:end,4);
Predictd2_ARIMA=B(5:end,5);
Predictd1_ARIMA=B(5:end,6);

Predictori_ResidualLSTM=C(:,2);
Predicta3_ResidualLSTM=C(:,3);
Predictd3_ResidualLSTM=C(:,4);
Predictd2_ResidualLSTM=C(:,5);
Predictd1_ResidualLSTM=C(:,6);

PSO_ANN=E(:,2);

xx1=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM; %DWT+HighFreqPre+LowFreqPre
xx6=xx1(5:end)+PSO_ANN; %DWT+HighFreqPre+LowFreqPre+Comp, proposed model
xx1(xx1<0)=1; %Amplitude limiting
xx1_test=xx1(end-104+1:end);
xx6(xx6<0)=1; 
xx6_Lock9=xx6;
xx6_test=xx6(end-104+1:end);
xx2=Predictori_DoubleLSTM; %HighFreqPre(No DWT)
xx2(xx2<0)=1; 
xx2_test=xx2(end-104+1:end);
xx3=Predictori_ARIMA+Predictori_ResidualLSTM; %LowFreqPre(No DWT)
xx3(xx3<0)=1; 
xx3_test=xx3(end-104+1:end);
xx4=Predicta3_DoubleLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM;%DWT+HighFreqPre
xx4(xx4<0)=1; 
xx4_test=xx4(end-104+1:end);
xx5=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_ARIMA+Predictd3_ResidualLSTM+Predictd2_ARIMA+Predictd2_ResidualLSTM+Predictd1_ARIMA+Predictd1_ResidualLSTM;%DWT+LowFreqPre
xx5(xx5<0)=1; 
xx5_test=xx5(end-104+1:end);

'HighFreqPre(No DWT)'
test=xx2_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'LowFreqPre(No DWT)'
test=xx3_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFreqPre'
test=xx4_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+LowFreqPre'
test=xx5_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFre+LowFreq'
test=xx1_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'Proposed model'
test=xx6_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

%2016
figure
plot(A(1:52),'-ro','LineWidth',1); %observed
hold on
plot(xx2_test(1:52),'-.+'); 
hold on
plot(xx3_test(1:52),'--x'); 
hold on
plot(xx4_test(1:52),'--x'); 
hold on
plot(xx5_test(1:52),'-.v'); 
hold on
plot(xx1_test(1:52),'-.bv'); 
hold on
plot(xx6_test(1:52),'-mo','LineWidth',0.8); 
hold on
title('(a) 2016','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');

%2017
figure
plot(A(53:104),'-ro','LineWidth',1); 
hold on
plot(xx2_test(53:104),'-.+');
hold on
plot(xx3_test(53:104),'--x'); 
hold on
plot(xx4_test(53:104),'--x'); 
hold on
plot(xx5_test(53:104),'-.v'); 
hold on
plot(xx1_test(53:104),'-.bv'); 
hold on
plot(xx6_test(53:104),'-mo','LineWidth',0.8); 
hold on
title('(b) 2017','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cells/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350]); 

figure
plot(A,'-ro','LineWidth',1); %observed
hold on
plot(xx2_test,'-.x'); 
hold on
plot(xx3_test,'--x'); 
hold on
plot(xx4_test,'-.*'); 
hold on
plot(xx5_test,'--*'); 
hold on
plot(xx1_test,'-.bv'); 
hold on
plot(xx6_test,'-mo','LineWidth',0.8); 
hold on
title('(a) 2016&2017','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52*2])
set(gca,'xlim',[1,52.1*2])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec','Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');

%%  %Mannum
A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Mannum\Mannum.csv');
A=A(1145:1248,7); 
B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Mannum.csv');
C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Mannum.csv');
D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Mannum.csv');
E=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\PSOANN_Mannum.csv');

Predictori_DoubleLSTM=D(:,2);
Predicta3_DoubleLSTM=D(:,3);
Predictd3_DoubleLSTM=D(:,4);
Predictd2_DoubleLSTM=D(:,5);
Predictd1_DoubleLSTM=D(:,6);

Predictori_ARIMA=B(5:end,2);
Predicta3_ARIMA=B(5:end,3);
Predictd3_ARIMA=B(5:end,4);
Predictd2_ARIMA=B(5:end,5);
Predictd1_ARIMA=B(5:end,6);

Predictori_ResidualLSTM=C(:,2);
Predicta3_ResidualLSTM=C(:,3);
Predictd3_ResidualLSTM=C(:,4);
Predictd2_ResidualLSTM=C(:,5);
Predictd1_ResidualLSTM=C(:,6);

PSO_ANN=E(:,2);

xx1=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM; %DWT+HighFreqPre+LowFreqPre
xx6=xx1(5:end)+PSO_ANN; %DWT+HighFreqPre+LowFreqPre+Comp, proposed model
xx1(xx1<0)=1; %Amplitude limiting
xx1_test=xx1(end-104+1:end);
xx6(xx6<0)=1; 
xx6_Lock9=xx6;
xx6_test=xx6(end-104+1:end);
xx2=Predictori_DoubleLSTM; %HighFreqPre(No DWT)
xx2(xx2<0)=1; 
xx2_test=xx2(end-104+1:end);
xx3=Predictori_ARIMA+Predictori_ResidualLSTM; %LowFreqPre(No DWT)
xx3(xx3<0)=1; 
xx3_test=xx3(end-104+1:end);
xx4=Predicta3_DoubleLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM;%DWT+HighFreqPre
xx4(xx4<0)=1; 
xx4_test=xx4(end-104+1:end);
xx5=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_ARIMA+Predictd3_ResidualLSTM+Predictd2_ARIMA+Predictd2_ResidualLSTM+Predictd1_ARIMA+Predictd1_ResidualLSTM;%DWT+LowFreqPre
xx5(xx5<0)=1; 
xx5_test=xx5(end-104+1:end);

'HighFreqPre(No DWT)'
test=xx2_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'LowFreqPre(No DWT)'
test=xx3_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFreqPre'
test=xx4_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+LowFreqPre'
test=xx5_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFre+LowFreq'
test=xx1_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'Proposed model'
test=xx6_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

%2016
figure
plot(A(1:52),'-ro','LineWidth',1); %observed
hold on
plot(xx2_test(1:52),'-.+');
hold on
plot(xx3_test(1:52),'--x');
hold on
plot(xx4_test(1:52),'--x'); 
hold on
plot(xx5_test(1:52),'-.v'); 
hold on
plot(xx1_test(1:52),'-.bv'); 
hold on
plot(xx6_test(1:52),'-mo','LineWidth',0.8); 
hold on
title('(a) 2016','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');

%2017
figure
plot(A(53:104),'-ro','LineWidth',1); %observed
hold on
plot(xx2_test(53:104),'-.+');
hold on
plot(xx3_test(53:104),'--x');
hold on
plot(xx4_test(53:104),'--x');
hold on
plot(xx5_test(53:104),'-.v');
hold on
plot(xx1_test(53:104),'-.bv');
hold on
plot(xx6_test(53:104),'-mo','LineWidth',0.8);
hold on
title('(b) 2017','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cells/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350]); 

figure
plot(A,'-ro','LineWidth',1); 
hold on
plot(xx2_test,'-.x'); 
hold on
plot(xx3_test,'--x');
hold on
plot(xx4_test,'-.*');
hold on
plot(xx5_test,'--*');
hold on
plot(xx1_test,'-.bv');
hold on
plot(xx6_test,'-mo','LineWidth',0.8);
hold on
title('(a) 2016&2017','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52*2])
set(gca,'xlim',[1,52.1*2])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec','Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');
%%  %Morgan
A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Morgan\Morgan.csv');
A=A(1145:1248,7);
B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Morgan.csv');
C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Morgan.csv');
D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Morgan.csv');
E=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\PSOANN_Morgan.csv');

Predictori_DoubleLSTM=D(:,2);
Predicta3_DoubleLSTM=D(:,3);
Predictd3_DoubleLSTM=D(:,4);
Predictd2_DoubleLSTM=D(:,5);
Predictd1_DoubleLSTM=D(:,6);

Predictori_ARIMA=B(5:end,2);
Predicta3_ARIMA=B(5:end,3);
Predictd3_ARIMA=B(5:end,4);
Predictd2_ARIMA=B(5:end,5);
Predictd1_ARIMA=B(5:end,6);

Predictori_ResidualLSTM=C(:,2);
Predicta3_ResidualLSTM=C(:,3);
Predictd3_ResidualLSTM=C(:,4);
Predictd2_ResidualLSTM=C(:,5);
Predictd1_ResidualLSTM=C(:,6);

PSO_ANN=E(:,2);

xx1=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM; %DWT+HighFreqPre+LowFreqPre
xx6=xx1(5:end)+PSO_ANN; %DWT+HighFreqPre+LowFreqPre+Comp, proposed model
xx1(xx1<0)=1; %Amplitude limiting
xx1_test=xx1(end-104+1:end);
xx6(xx6<0)=1; 
xx6_Lock9=xx6;
xx6_test=xx6(end-104+1:end);
xx2=Predictori_DoubleLSTM; %HighFreqPre(No DWT)
xx2(xx2<0)=1; 
xx2_test=xx2(end-104+1:end);
xx3=Predictori_ARIMA+Predictori_ResidualLSTM; %LowFreqPre(No DWT)
xx3(xx3<0)=1; 
xx3_test=xx3(end-104+1:end);
xx4=Predicta3_DoubleLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM;%DWT+HighFreqPre
xx4(xx4<0)=1; 
xx4_test=xx4(end-104+1:end);
xx5=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_ARIMA+Predictd3_ResidualLSTM+Predictd2_ARIMA+Predictd2_ResidualLSTM+Predictd1_ARIMA+Predictd1_ResidualLSTM;%DWT+LowFreqPre
xx5(xx5<0)=1; 
xx5_test=xx5(end-104+1:end);

'HighFreqPre(No DWT)'
test=xx2_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'LowFreqPre(No DWT)'
test=xx3_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFreqPre'
test=xx4_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+LowFreqPre'
test=xx5_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFre+LowFreq'
test=xx1_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'Proposed model'
test=xx6_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

%2016
figure
plot(A(1:52),'-ro','LineWidth',1); 
hold on
plot(xx2_test(1:52),'-.+'); 
hold on
plot(xx3_test(1:52),'--x'); 
hold on
plot(xx4_test(1:52),'--x'); 
hold on
plot(xx5_test(1:52),'-.v'); 
hold on
plot(xx1_test(1:52),'-.bv'); 
hold on
plot(xx6_test(1:52),'-mo','LineWidth',0.8); 
hold on
title('(a) 2016','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');

%2017
figure
plot(A(53:104),'-ro','LineWidth',1); 
hold on
plot(xx2_test(53:104),'-.+'); 
hold on
plot(xx3_test(53:104),'--x'); 
hold on
plot(xx4_test(53:104),'--x'); 
hold on
plot(xx5_test(53:104),'-.v'); 
hold on
plot(xx1_test(53:104),'-.bv'); 
hold on
plot(xx6_test(53:104),'-mo','LineWidth',0.8); 
hold on
title('(b) 2017','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cells/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350]); 

figure
plot(A,'-ro','LineWidth',1);
hold on
plot(xx2_test,'-.x'); 
hold on
plot(xx3_test,'--x'); 
hold on
plot(xx4_test,'-.*'); 
hold on
plot(xx5_test,'--*'); 
hold on
plot(xx1_test,'-.bv'); 
hold on
plot(xx6_test,'-mo','LineWidth',0.8); 
hold on
title('(a) 2016&2017','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52*2])
set(gca,'xlim',[1,52.1*2])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec','Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');

%% %MurrayBridge
A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\MurrayBridge\Murray_Bridge.csv');
A=A(1145:1248,7); 
B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_MurrayBridge.csv');
C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_MurrayBridge.csv');
D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_MurrayBridge.csv');
E=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\PSOANN_MurrayBridge.csv');

Predictori_DoubleLSTM=D(:,2);
Predicta3_DoubleLSTM=D(:,3);
Predictd3_DoubleLSTM=D(:,4);
Predictd2_DoubleLSTM=D(:,5);
Predictd1_DoubleLSTM=D(:,6);

Predictori_ARIMA=B(5:end,2);
Predicta3_ARIMA=B(5:end,3);
Predictd3_ARIMA=B(5:end,4);
Predictd2_ARIMA=B(5:end,5);
Predictd1_ARIMA=B(5:end,6);

Predictori_ResidualLSTM=C(:,2);
Predicta3_ResidualLSTM=C(:,3);
Predictd3_ResidualLSTM=C(:,4);
Predictd2_ResidualLSTM=C(:,5);
Predictd1_ResidualLSTM=C(:,6);

PSO_ANN=E(:,2);

xx1=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM; %DWT+HighFreqPre+LowFreqPre
xx6=xx1(5:end)+PSO_ANN; %DWT+HighFreqPre+LowFreqPre+Comp, proposed model
xx1(xx1<0)=1; %Amplitude limiting
xx1_test=xx1(end-104+1:end);
xx6(xx6<0)=1; 
xx6_Lock9=xx6;
xx6_test=xx6(end-104+1:end);
xx2=Predictori_DoubleLSTM; %HighFreqPre(No DWT)
xx2(xx2<0)=1; 
xx2_test=xx2(end-104+1:end);
xx3=Predictori_ARIMA+Predictori_ResidualLSTM; %LowFreqPre(No DWT)
xx3(xx3<0)=1; 
xx3_test=xx3(end-104+1:end);
xx4=Predicta3_DoubleLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM;%DWT+HighFreqPre
xx4(xx4<0)=1; 
xx4_test=xx4(end-104+1:end);
xx5=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_ARIMA+Predictd3_ResidualLSTM+Predictd2_ARIMA+Predictd2_ResidualLSTM+Predictd1_ARIMA+Predictd1_ResidualLSTM;%DWT+LowFreqPre
xx5(xx5<0)=1; 
xx5_test=xx5(end-104+1:end);

'HighFreqPre(No DWT)'
test=xx2_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'LowFreqPre(No DWT)'
test=xx3_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFreqPre'
test=xx4_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+LowFreqPre'
test=xx5_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFre+LowFreq'
test=xx1_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'Proposed model'
test=xx6_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

%2016
figure
plot(A(1:52),'-ro','LineWidth',1);
hold on
plot(xx2_test(1:52),'-.+'); 
hold on
plot(xx3_test(1:52),'--x'); 
hold on
plot(xx4_test(1:52),'--x'); 
hold on
plot(xx5_test(1:52),'-.v'); 
hold on
plot(xx1_test(1:52),'-.bv');
hold on
plot(xx6_test(1:52),'-mo','LineWidth',0.8); 
hold on
title('(a) 2016','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');

%2017
figure
plot(A(53:104),'-ro','LineWidth',1); 
hold on
plot(xx2_test(53:104),'-.+'); 
hold on
plot(xx3_test(53:104),'--x'); 
hold on
plot(xx4_test(53:104),'--x');
hold on
plot(xx5_test(53:104),'-.v');
hold on
plot(xx1_test(53:104),'-.bv');
hold on
plot(xx6_test(53:104),'-mo','LineWidth',0.8);
hold on
title('(b) 2017','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cells/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350]); 

figure
plot(A,'-ro','LineWidth',1); 
hold on
plot(xx2_test,'-.x');
hold on
plot(xx3_test,'--x');
hold on
plot(xx4_test,'-.*');
hold on
plot(xx5_test,'--*');
hold on
plot(xx1_test,'-.bv');
hold on
plot(xx6_test,'-mo','LineWidth',0.8);
hold on
title('(a) 2016&2017','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52*2])
set(gca,'xlim',[1,52.1*2])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec','Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');

%%  %%TailemBend
A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Tailembend\Tailembend.csv');
A=A(1145:1248,7); 
B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Tailembend.csv');
C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Tailembend.csv');
D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Tailembend.csv');
E=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\PSOANN_Tailembend.csv');

Predictori_DoubleLSTM=D(:,2);
Predicta3_DoubleLSTM=D(:,3);
Predictd3_DoubleLSTM=D(:,4);
Predictd2_DoubleLSTM=D(:,5);
Predictd1_DoubleLSTM=D(:,6);

Predictori_ARIMA=B(5:end,2);
Predicta3_ARIMA=B(5:end,3);
Predictd3_ARIMA=B(5:end,4);
Predictd2_ARIMA=B(5:end,5);
Predictd1_ARIMA=B(5:end,6);

Predictori_ResidualLSTM=C(:,2);
Predicta3_ResidualLSTM=C(:,3);
Predictd3_ResidualLSTM=C(:,4);
Predictd2_ResidualLSTM=C(:,5);
Predictd1_ResidualLSTM=C(:,6);

PSO_ANN=E(:,2);

xx1=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM; %DWT+HighFreqPre+LowFreqPre
xx6=xx1(5:end)+PSO_ANN; %DWT+HighFreqPre+LowFreqPre+Comp, proposed model
xx1(xx1<0)=1; %Amplitude limiting
xx1_test=xx1(end-104+1:end);
xx6(xx6<0)=1; 
xx6_Lock9=xx6;
xx6_test=xx6(end-104+1:end);
xx2=Predictori_DoubleLSTM; %HighFreqPre(No DWT)
xx2(xx2<0)=1; 
xx2_test=xx2(end-104+1:end);
xx3=Predictori_ARIMA+Predictori_ResidualLSTM; %LowFreqPre(No DWT)
xx3(xx3<0)=1; 
xx3_test=xx3(end-104+1:end);
xx4=Predicta3_DoubleLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM;%DWT+HighFreqPre
xx4(xx4<0)=1; 
xx4_test=xx4(end-104+1:end);
xx5=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_ARIMA+Predictd3_ResidualLSTM+Predictd2_ARIMA+Predictd2_ResidualLSTM+Predictd1_ARIMA+Predictd1_ResidualLSTM;%DWT+LowFreqPre
xx5(xx5<0)=1; 
xx5_test=xx5(end-104+1:end);

'HighFreqPre(No DWT)'
test=xx2_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'LowFreqPre(No DWT)'
test=xx3_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFreqPre'
test=xx4_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+LowFreqPre'
test=xx5_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'DWT+HighFre+LowFreq'
test=xx1_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

'Proposed model'
test=xx6_test;
Error=A-test;
MSE=[sum((Error).^2)]/104
MRE=[sum(abs((Error)./A))]/104
NSE=1-[sum((Error).^2)]./[sum((A-mean(A)).^2)]
COR=corr(A,test)
RMSE=sqrt(MSE)

%2016
figure
plot(A(1:52),'-ro','LineWidth',1); 
hold on
plot(xx2_test(1:52),'-.+'); 
hold on
plot(xx3_test(1:52),'--x');
hold on
plot(xx4_test(1:52),'--x');
hold on
plot(xx5_test(1:52),'-.v');
hold on
plot(xx1_test(1:52),'-.bv');
hold on
plot(xx6_test(1:52),'-mo','LineWidth',0.8);
hold on
title('(a) 2016','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');

%2017
figure
plot(A(53:104),'-ro','LineWidth',1); 
hold on
plot(xx2_test(53:104),'-.+'); 
hold on
plot(xx3_test(53:104),'--x');
hold on
plot(xx4_test(53:104),'--x');
hold on
plot(xx5_test(53:104),'-.v');
hold on
plot(xx1_test(53:104),'-.bv');
hold on
plot(xx6_test(53:104),'-mo','LineWidth',0.8);
hold on
title('(b) 2017','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cells/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52])
set(gca,'xlim',[1,52.1])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350]); 

figure
plot(A,'-ro','LineWidth',1);
hold on
plot(xx2_test,'-.x');
hold on
plot(xx3_test,'--x');
hold on
plot(xx4_test,'-.*');
hold on
plot(xx5_test,'--*');
hold on
plot(xx1_test,'-.bv');
hold on
plot(xx6_test,'-mo','LineWidth',0.8);
hold on
title('(a) 2016&2017','FontName','Times new roman');
legend('Observed','HighFreqPre (Original data)','LowFreqPre (Original data)','DWT+HighFreqPre','DWT+LowFreqPre','DWT+HighFreqPre+LowFreqPre','DWT+HighFreqPre+LowFreqPre+Comp','FontName','Times new roman');
ylabel('Cyanobacteria cell concentration (cell/ml)','FontName','Times new roman')
xlabel('Time (month)','FontName','Times new roman')
set(gca,'xtick',[1:4.3:52*2])
set(gca,'xlim',[1,52.1*2])
set(gca,'xticklabel',{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec','Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
set(gcf, 'Position', [100 100 1150 350])
set(legend,'Location','northwest');
%% %Comparison between proposed model and RF model
load LOCK9_RF LOCK9_RF
LOCK9_RF(LOCK9_RF<0)=0; 
load Mannum_RF Mannum_RF
Mannum_RF(Mannum_RF<0)=0; 
load Morgan_RF Morgan_RF
Morgan_RF(Morgan_RF<0)=0; 
load MurrayBridge_RF MurrayBridge_RF
MurrayBridge_RF(MurrayBridge_RF<0)=0; 
load Tailembend_RF Tailembend_RF
Tailembend_RF(Tailembend_RF<0)=0; 
idx=104;

%LOCK9
A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Lock_9\Lock_9.csv');
figure
plot(A(1248-idx+1:1248,7),'-o','LineWidth',1); %observed
hold on
plot(LOCK9_RF(1248-idx+1-4:1248-4),'-.+','LineWidth',1); %Random Forest
hold on
plot(xx6_Lock9(1248-idx+1-4-4:1248-4-4),'-v','LineWidth',1); %Proposed model
hold on
str=['Cyanobacteria cell concentration' sprintf('\n') '(cells/ml)'];
title('LOCK 9','FontName','Times new roman','FontSize',12);
ylabel(str,'FontName','Times new roman','FontSize',12)
xlabel('Time (month)','FontName','Times new roman','FontSize',12)
legend('Observed','Random Forest','Our Proposed Model','FontName','Times new roman','FontSize',10);
set(gca,'xtick',[1:52:idx])
set(gca,'xlim',[1,idx])
set(gca,'xticklabel',{'2012', '2013', '2014', '2015', '2016', '2017', '2018'})
set(gcf, 'Position', [100 100 1150 250]); 
set(legend,'Location','northwest');

%Mannum
A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Mannum\Mannum.csv');
figure
plot(A(1248-idx+1:1248,7),'-o','LineWidth',1); 
hold on
plot(Mannum_RF(1248-idx+1-4:1248-4),'-.+','LineWidth',1); 
hold on
plot(xx6_Mannum(1248-idx+1-4-4:1248-4-4),'-v','LineWidth',1); 
hold on
str=['Cyanobacteria cell concentration' sprintf('\n') '(cells/ml)'];
title('Mannum','FontName','Times new roman','FontSize',12);
ylabel(str,'FontName','Times new roman','FontSize',12)
xlabel('Time (month)','FontName','Times new roman','FontSize',12)
set(gca,'xtick',[1:52:idx])
set(gca,'xlim',[1,idx])
set(gca,'xticklabel',{'2012', '2013', '2014', '2015', '2016', '2017', '2018'})
set(gcf, 'Position', [100 100 1150 250]); 

%Morgan
A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Morgan\Morgan.csv');
figure
plot(A(1248-idx+1:1248,7),'-o','LineWidth',1); 
hold on
plot(Morgan_RF(1248-idx+1-4:1248-4),'-.+','LineWidth',1); 
hold on
plot(xx6_Morgan(1248-idx+1-4-4:1248-4-4),'-v','LineWidth',1); 
hold on
str=['Cyanobacteria cell concentration' sprintf('\n') '(cells/ml)'];
title('Morgan','FontName','Times new roman','FontSize',12);
ylabel(str,'FontName','Times new roman','FontSize',12)
xlabel('Time (month)','FontName','Times new roman','FontSize',12)
set(gca,'xtick',[1:52:idx])
set(gca,'xlim',[1,idx])
set(gca,'xticklabel',{'2012', '2013', '2014', '2015', '2016', '2017', '2018'})
set(gcf, 'Position', [100 100 1150 250]); 

%Murray Bridge
A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\MurrayBridge\Murray_Bridge.csv');
figure
plot(A(1248-idx+1:1248,7),'-o','LineWidth',1); 
hold on
plot(MurrayBridge_RF(1248-idx+1-4:1248-4),'-.+','LineWidth',1); 
hold on
plot(xx6_MurrayBridge(1248-idx+1-4-4:1248-4-4),'-v','LineWidth',1); 
hold on
str=['Cyanobacteria cell concentration' sprintf('\n') '(cells/ml)'];
title('Murray Bridge','FontName','Times new roman','FontSize',12);
ylabel(str,'FontName','Times new roman','FontSize',12)
xlabel('Time (month)','FontName','Times new roman','FontSize',12)
set(gca,'xtick',[1:52:idx])
set(gca,'xlim',[1,idx])
set(gca,'xticklabel',{'2012', '2013', '2014', '2015', '2016', '2017', '2018'})
set(gcf, 'Position', [100 100 1150 250]); 

%Tailem Bend
A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Tailembend\Tailembend.csv');
figure
plot(A(1248-idx+1:1248,7),'-o','LineWidth',1);
hold on
plot(Tailembend_RF(1248-idx+1-4:1248-4),'-+','LineWidth',1);
hold on
plot(xx6_TailemBend(1248-idx+1-4-4:1248-4-4),'-v','LineWidth',1);
hold on
str=['Cyanobacteria cell concentration' sprintf('\n') '(cells/ml)'];
title('Tailem Bend','FontName','Times new roman','FontSize',12);
ylabel(str,'FontName','Times new roman','FontSize',12)
xlabel('Time (year)','FontName','Times new roman','FontSize',12)
set(gca,'xtick',[1:52:idx])
set(gca,'xlim',[1,idx])
set(gca,'xticklabel',{'2012', '2013', '2014', '2015', '2016', '2017', '2018'})
set(gcf, 'Position', [100 100 1150 250]); 
clc                         
clear 
close all

name='Tailembend';%'LOCK9'; 'Mannum'; 'Morgan'; 'MurrayBridge'; 'Tailembend'
switch name
    case 'LOCK9'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Lock_9\Lock_9.csv');
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Lock9.csv');%LowFreqPre-ARIMA
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Lock9.csv');%LowFreqPre-LSTM
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Lock9.csv');%HighFreqPre
    case 'Mannum'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Mannum\Mannum.csv');
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Mannum.csv');%LowFreqPre-ARIMA
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Mannum.csv');%LowFreqPre-LSTM
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Mannum.csv');%HighFreqPre
    case 'Morgan'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Morgan\Morgan.csv');
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Morgan.csv');%LowFreqPre-ARIMA
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Morgan.csv');%LowFreqPre-LSTM
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Morgan.csv');%HighFreqPre
    case 'MurrayBridge'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\MurrayBridge\Murray_Bridge.csv');
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_MurrayBridge.csv');%LowFreqPre-ARIMA
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_MurrayBridge.csv');%LowFreqPre-LSTM
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_MurrayBridge.csv');%HighFreqPre
    case 'Tailembend'
        A=xlsread('C:\Users\Lenovo\Desktop\pythonfiles\DPSSA-Cyano\Tailembend\Tailembend.csv');
        B=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ARIMA_Tailembend.csv');%LowFreqPre-ARIMA
        C=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\ResidualLSTM_Tailembend.csv');%LowFreqPre-LSTM
        D=xlsread('C:\Users\Lenovo\Desktop\LSTM_with_Environmental_Variables\DoubleLSTM_Tailembend.csv');%HighFreqPre
end

BP=A(5:1248,7);
Predicta3_ARIMA=B(5:end,3);
Predicta3_ResidualLSTM=C(:,3);
Predictd3_DoubleLSTM=D(:,4);
Predictd2_DoubleLSTM=D(:,5);
Predictd1_DoubleLSTM=D(:,6);
xx1=Predicta3_ARIMA+Predicta3_ResidualLSTM+Predictd3_DoubleLSTM+Predictd2_DoubleLSTM+Predictd1_DoubleLSTM;

BP=BP-xx1;           
figure
plot(BP);

tic  %start timing  
HiddenNum=32; InDim=4; OutDim=1; STEP=4; 
test_len = 104; SamNum=length(BP)-104-STEP; 
data_len = length(BP)-STEP;
train_len= data_len-test_len;

for i=1:train_len
    x = BP(i:i+STEP-1);
    y = BP(i+STEP);
    x_train(:,i) = x;
    y_train(i) = y;
end
for i=1:test_len
    x = BP(train_len+i:train_len+i+STEP-1);
    y = BP(train_len+i+STEP);
    x_test(:,i)=x;
    y_test(i)=y;
end
a=x_train;              
d=y_train;     

%Take logarithm to stabilize the data for easier prediction
bias_log=50000;
figure
plot(log(BP+bias_log));
SamIn=log(a+bias_log) ;
SamOut=log(d+bias_log);
SamIn=SamIn';
SamOut=SamOut';

%%
%the begin of PSO
E0=0.00000001;
Max_num=3000;                        %Number of iterations
particlesize=100;                    %Numerical particles
c1=2;                                %Weight parameters C1, C2
c2=2;
w=1;
vc=2;
vmax=2;
dims=InDim*HiddenNum+HiddenNum+HiddenNum*OutDim+OutDim;
x=rand(particlesize,dims);
v=rand(particlesize,dims);
f=zeros(particlesize,1);                            %Construct the error matrix
 %% %Initialize the loss function
 for jjj=1:particlesize
     trans_x=x(jjj,:);
     W1=zeros(InDim,HiddenNum);                                                          %Set the weight matrix and bias
     B1=zeros(HiddenNum,1);
     W2=zeros(HiddenNum,OutDim);
     B2=zeros(OutDim,1);

     for ii=1:InDim
         W1(ii,:)=trans_x(1,1+HiddenNum*(ii-1):HiddenNum*ii);
     end
     B1=trans_x(1,HiddenNum*InDim+1:HiddenNum*(InDim+1))';
     W2=trans_x(1,HiddenNum*(InDim+1)+1:HiddenNum*(InDim+2))';
     B2=trans_x(1,HiddenNum*(InDim+2)+1);

     Hiddenout=logsig(SamIn*W1+repmat(B1',SamNum,1));
     Networkout=Hiddenout*W2+repmat(B2',SamNum,1);
     Error=Networkout-SamOut;
     SSE=sumsqr(Error)

     f(jjj)=SSE;
 end
 
personalbest_x=x;
personalbest_f=f;
[groupbest_f,i]=min(personalbest_f);
groupbest_x=x(i,:);

for j_Num=1:Max_num                                                               %begin of PSO
    vc=(Max_num-j_Num)/Max_num;
    v=w*v+c1*rand*(personalbest_x-x)+c2*rand*(repmat(groupbest_x,particlesize,1)-x);

    for kk=1:particlesize
        for  kk0=1:dims
            if v(kk,kk0)>vmax
                v(kk,kk0)=vmax;
            else if v(kk,kk0)<-vmax
                    v(kk,kk0)=-vmax;
            end
            end
        end
    end
    x=x+vc*v;
    %%
    for jjj=1:particlesize
        trans_x=x(jjj,:);
        W1=zeros(InDim,HiddenNum);
        B1=zeros(HiddenNum,1);
        W2=zeros(HiddenNum,OutDim);
        B2=zeros(OutDim,1);
        
        for ii=1:InDim
            W1(ii,:)=trans_x(1,1+HiddenNum*(ii-1):HiddenNum*ii);                              
        end
        B1=trans_x(1,HiddenNum*InDim+1:HiddenNum*(InDim+1))';                     %Set the weight coefficients and bias
        W2=trans_x(1,HiddenNum*(InDim+1)+1:HiddenNum*(InDim+2))';
        B2=trans_x(1,HiddenNum*(InDim+2)+1);

        Hiddenout=logsig(SamIn*W1+repmat(B1',SamNum,1));
        Networkout=Hiddenout*W2+repmat(B2',SamNum,1);
        Error=Networkout-SamOut;
        SSE=sumsqr(Error)
        % Output the prediction error for each particle in generation j_Num
        f(jjj)=SSE;

    end
    %%
    for kk=1:particlesize
        if f(kk)<personalbest_f(kk)
            personalbest_f(kk)=f(kk);
            personalbest_x(kk)=x(kk);
        end
    end
    [groupbest_f0,i]=min(personalbest_f);
    if  groupbest_f0<groupbest_f
        groupbest_x=x(i,:);
        groupbest_f=groupbest_f0;
    end
    %Output once per generation increase
    ddd(j_Num)=groupbest_f
end
str=num2str(groupbest_f);
trans_x=groupbest_x;
for ii=1:InDim
    W1(ii,:)=trans_x(1,1+HiddenNum*(ii-1):HiddenNum*ii);
end
B1=trans_x(1,HiddenNum*InDim+1:HiddenNum*(InDim+1))';
W2=trans_x(1,HiddenNum*(InDim+1)+1:HiddenNum*(InDim+2))';
B2=trans_x(1,HiddenNum*(InDim+2)+1);
%the end of PSO

%Output of the Network in Training Set
Hiddenout=logsig(SamIn*W1+repmat(B1',SamNum,1));
Networkout=Hiddenout*W2+repmat(B2',SamNum,1);
aa=exp(Networkout)-bias_log;                                              
newk=aa;                                    
figure 
plot(d,'r-o');
hold on
plot(newk,'b-+') ;

%Test
TestNum=104 ;
cx=x_test;
cf=y_test;

TestIn=log(cx+bias_log) ;
TestOut=log(cf+bias_log);
TestIn=TestIn';
TestOut=TestOut';

Hiddenout=logsig(TestIn*W1+repmat(B1',TestNum,1));
Networkout=Hiddenout*W2+repmat(B2',TestNum,1);
%end of Network

bb=exp(Networkout)-bias_log;          
error=bb-cf';
err=error.*error;
RMSE=sqrt(sum(err,1)./TestNum)  

figure 
plot(cf,'r-o');
hold on
plot(bb,'b--+');

Date=[9:1248]';
predict_data=[newk;bb];
data=[Date,predict_data];

switch name %'LOCK9'; 'Mannum'; 'Morgan'; 'MurrayBridge'; 'Tailembend'
    case 'LOCK9'
        filename = 'PSOANN_LOCK9.csv'; % File Path
    case 'Mannum'
        filename = 'PSOANN_Mannum.csv'; 
    case 'Morgan'
        filename = 'PSOANN_Morgan.csv'; 
    case 'MurrayBridge'
        filename = 'PSOANN_MurrayBridge.csv'; 
    case 'Tailembend'
        filename = 'PSOANN_Tailembend.csv'; 
end
csvwrite(filename, data,1); % Write to CSV file

toc
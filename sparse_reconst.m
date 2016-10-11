
function rcol_img=sparse_reconst(col_img,col_mask,imdim,newdim,sensorloc,orgdim,sx,sy,mode,sol,L)

%col_img   coulmn-stacked images n*N
%col_mask  mask of possible nonzero entries n*1
%imdim     image dimension [dx dy]
%newdim    image standard dimension [dx dy] for DCT/DWT
%sensorloc    sensor locations in original image
%orgdim     original image dimension
%sx   row index of image in original space [xmin;xmax]
%sy   column index of image in original space [ymin;ymax]
%mode  1 for DCT, 2 for DWT, 3 for mixed
%sol   sparse solution, 1 for OMP and 2 for LASSO
%L    model order for OMP

mask=reshape(col_mask,imdim);

dimdif=round((newdim-imdim)/2);

newmask=zeros(newdim);
newmask(dimdif(1)+1:dimdif(1)+imdim(1),dimdif(2)+1:dimdif(2)+imdim(2))=mask;

indxm=find(newmask==1);

org_img=zeros(orgdim);
org_img(sensorloc(:))=1;
norg_img=org_img(sx(1):sx(2),sy(1):sy(2));



%for testing
% newmask=zeros(newdim);
% newmask(dimdif(1)+1:dimdif(1)+imdim(1),dimdif(2)+1:dimdif(2)+imdim(2))=1;
% col_imgt=zeros(newdim(1)*newdim(2),size(col_img,2));
% col_imgt(newmask==1,:)=col_img;
%***************

%norg_img(mask==0)=1; %for testing
Y=col_img(norg_img==1,:);

%sensmask=ones(newdim); %for testing
sensmask=zeros(newdim);
sensmask(dimdif(1)+1:dimdif(1)+imdim(1),dimdif(2)+1:dimdif(2)+imdim(2))=norg_img;

indxs=find(sensmask==1);

%Y=col_imgt(indxs,:); %for testing

%DCT dictionary
DCTx=dct(eye(newdim(1)));
DCTy=dct(eye(newdim(2)));
DCTdic=kron(DCTx,DCTy)';

iDCTdic=DCTdic(indxm,:);
sDCTdic=DCTdic(indxs,:);


%DWT dictionary

Iden=eye(newdim(1));
DWTx=zeros(newdim(1),newdim(1));

for i=1:newdim(1)
    DWTx(:,i)=wavedec(Iden(:,i),nextpow2(newdim(1)),'haar');
end

Iden=eye(newdim(2));
DWTy=zeros(newdim(2),newdim(2));

for i=1:newdim(2)
    DWTy(:,i)=wavedec(Iden(:,i),nextpow2(newdim(2)),'haar');
end
   
DWTdic=kron(DWTx,DWTy)';

iDWTdic=DWTdic(indxm,:);
sDWTdic=DWTdic(indxs,:);

%mode selection
if mode==1
    D=sDCTdic;
    iD=iDCTdic;
elseif mode==2
    D=sDWTdic;
    iD=iDWTdic;
else
    D=[sDCTdic sDWTdic];
    iD=[iDCTdic iDWTdic];
end
    
if sol==1
%OMP
X=OMP(D,Y,L);
rY=iD*X;

rcol_img=zeros(size(col_img));
rcol_img(col_mask==1,:)=rY;

elseif sol==2

%LASSO
%MATLAB LASSO FUNCTION

for i=1:size(Y,2)
    X(:,i)=fminunc(@(X) myobj(D,Y(:,i),X,1),randn(size(D,2),1));

end

rY=iD*X;

rcol_img=zeros(size(col_img));
rcol_img(col_mask==1,:)=rY;

end

function [out] = myobj(D,Y,X,lambda)
    resid = Y - D*X;
    out = 0.5*norm(resid)^2 + lambda*sum(abs(X));
end


end

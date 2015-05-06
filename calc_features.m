function [hw_ratio, zhixin] = calc_features(video)
if ischar(video)
     % Load the video from an avi file.
     avi = aviread(video);
     pixels = double(cat(4,avi(1:1:end).cdata))/255;
     clear avi
 else
     % Compile the pixel data into a single array
     pixels = double(cat(4,video{1:1:end}))/255;%%%%%%%%%%%%%%%%
     clear video
 end
 
% Convert to RGB to GRAY SCALE image.
 nFrames = size(pixels,4);
 for f = 1:nFrames
     pixel(:,:,f) = (rgb2gray(pixels(:,:,:,f)));  %�ҶȻ�
     %pixel(:,:,f)=imnoise(pixel(:,:,f),'salt & pepper',0.25);
     %pixel(:,:,f)=medfilt2(pixel(:,:,f),[7,7],'symmetric');
     %pixel(:,:,f)=adpmedian(pixel(:,:,f),7);
 end
 
rows=size(pixel,1);%144����
cols=size(pixel,2); %180����
 BG=pixel(:,:,1);%����
  X=1:40;%����ƽ��ʱ��Ҫ��֡��
  for u=1:rows
      for v=1:cols
          for t=1:40
              X(t)=pixel(u,v,t);                       
          end
          BG(u,v)=median(X); %����ÿ�е��м�ֵ������ż�������򷵻��м�����ֵ��ƽ��ֵ 
          %Y=sort(X);
          %BG(u,v)=mean(Y(10:30));
      end
  end        %�˶γ����ǵõ��ɾ��ı���ͼƬ��ʹ�õ���ͳ��ƽ������
 
 %BBG=imread('11.jpg');
 %BG=double(rgb2gray(BBG))/255;
f1 = figure(1);
set(f1, 'Position', [200 100 400 400]);
imshow(BG);%��ʾ����ͼƬ
 
nrames=f;
f2 = figure(2);
 set(f2, 'Position', [200 800 400 400]);
 
 %f3 = figure(3);
 %set(f3, 'Position', [600 100 400 400]);
 
 
 for l = 2:nrames
 d(:,:,l)=(abs(pixel(:,:,l)-BG));%����������
 k=d(:,:,l);
 bw(:,:,l) = im2bw(k, .2);%ת���ɶ�ֵͼ��
 bw1(:,:,l)=bwlabel(bw(:,:,l));%��Ƕ�ֵͼ�����ͨ����
 se=strel('disk',1);%����ָ����̬ѧ�ṹ��������̬ѧ����
 bw2(:,:,l)=imopen(bw1(:,:,l),se);%������
 bw3(:,:,l)=imclose(bw2(:,:,l),se);%�����㣬�����ֵͼ��
 %figure(3);
 imshow(bw3(:,:,l));%��ʾ��ֵ��ͼƬ
 figure(2);
 %imshow(pixels(:,:,:,l));%��ʾԭ��Ƶ
 hold on%���ֵ�ǰͼ�ν���
 
cou=1;%��ʾ��һ��������������������
 for h=1:rows%��ֵ
     for w=1:cols%��ֵ
         if(bw3(h,w,l)>0.5)%����ֵ����0.5
             toplen = h;%���Ϸ�
             if (cou == 1)
                 tpln=toplen;
             end
             cou=cou+1;
             break
         end
     end
 end%����
 
%  disp(toplen); 
 
coun=1;%��ʾ��һ������������������ֵ
 for w=1:cols%��ֵ
     for h=1:rows%��ֵ
         if(bw3(h,w,l)>0.5)
             leftsi = w;%���
             if (coun == 1)
                 lftln=leftsi;
                 coun=coun+1;
             end
             break
         end
     end
 end%����
 
%  disp(leftsi);
%  disp(lftln); 
 
%for h=1:rows
     %for w=1:cols
         %if(bw3(h,w,l)<0.5)
            %BG(h,w)=0.8*BG(h,w)+0.2*pixel(h,w,l);
         %end
     %end
 %end
 widh=leftsi-lftln;%�궨����
 heig=toplen-tpln;%�궨��ֵ
 
widt=widh/2;%ȷ���궨���ĵĺ����꣬�궨����λ�ڱ궨���ο�����λ��
 heit=heig/2;%ȷ���궨���ĵ�������
 
with=lftln+widt;%�궨���λ�á�����
heth=tpln+heit;%�궨���λ�á��߶�

 rectangle('Position',[lftln tpln widh heig],'EdgeColor','r');%������widh,�߶���heig,�߿���ɫ�Ǻ�ɫ��
 x(l-1)=heig/widh;%�õ�������
 plot(with,heth, 'r+');%��ʾ�궨��
 [zhixin(1, l-1), zhixin(2, l-1)] = get_zhixin(bw3(:,:,l));
 drawnow;
 hold off

 end;
 close(f1);
 close(f2);
 %close(f3);
 hw_ratio = x;
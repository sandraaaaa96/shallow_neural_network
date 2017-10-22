function write_to_file(image_data,sample_no) 
    image_template=zeros(48);
    for k=1:48
        for j=1:48
            image_template(k,j)=image_data(1,j+(k-1)*48);
        end
    end
    image_array=mat2gray(image_template);
    samplenominus1=sample_no-1;
    formatspec='figure%d.png';
    picname=sprintf(formatspec,samplenominus1);
    imwrite(image_array,picname);
end
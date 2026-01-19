function [J] = stegancoder_Rand(img,msg,enc_key,randSeed)



msgtype = ischar(msg);  % If message is text this will be true; 
                        %   false otherwise

if msgtype == 1     % Message = TEXT
    msg_temp = double(msg);     % Converts from ASCII to Integer Values.
    msg_dim = num2str(length(msg_temp));
    msg_length = length(msg_dim);
    z = 0;
    if msg_length < 7
        padtext = 7 - msg_length;
        for z = 1:padtext
            msg_dim = horzcat('0',msg_dim);
        end
        msg_head = horzcat('t',msg_dim);
        % Applying Header To Beginning of Message to be Encoded.
        msg_temp_head = horzcat(msg_head,msg_temp);
    end
    
else
    % Message = IMAGE
    msg = im2uint8(msg);        % Convert to Integer Value Representation.
    
    msg_temp = rgb2gray(msg);   % Converts Hidden Message to Grayscale. 
                                %   Reduces Amount of Data to Hide.
                                                               
    % Determine Message Image's Size for Encoding in Header                            
    [hideM1,hideN1] = size(msg_temp);
    hideM = num2str(hideM1);
    hideN = num2str(hideN1);
    dimM = length(hideM);
    dimN = length(hideN);
    padM = 0; padN = 0;
    z = 0;
    
    if dimM < 4
        padM = 4 - dimM;
        for z = 1:padM
            % Zero Padding Dimension if less than 4 Sig Figs.
            hideM = horzcat('0',hideM);
        end
    end
    z = 0;
    
    if dimN < 4
        padN = 4 - dimN;
        for z = 1:padN
            % Zero Padding Dimension if less than 4 Sig Figs.
            hideN = horzcat('0',hideN);
        end
    end
    msg_head = horzcat(hideM,hideN);
    msg_temp_head = msg_head;
    
    y = 0;  k = hideM1;
    for y = 1:k
        % Applying Header To Beginning of Message to be Encoded.
        msg_temp_head = horzcat(msg_temp_head,msg_temp(y,:));
    end
    
end

msg_enc = bitxor(uint8(msg_temp_head),uint8(enc_key));

msg_enc_set = dec2bin(msg_enc, 8);

%% Step 4: Preparing Hiding Canvas and Initializing Random Number Set
% "Canvas" Image
img_prep = im2uint8(img);

% Random Permutation Set
rng(randSeed); % Initialize Random Number Generator to a "Common" State. We 
               %   need this value shared for the Decoding Steps.
[canM,canN,chan]=size(img);
canvas_Dim = canM * canN;
% Ensuring Dimension is Divisible by 3; RESHAPE Function will fail
% otherwise.
canTest = rem(canvas_Dim,3);
if canTest ~= 0
    canvas_Dim = canvas_Dim - canTest;
end

randSet = randperm(canvas_Dim);     % Random Pixel Set.
randGroup = reshape(randSet,[],3);  % Final Pixel Groupings (3 pixels/grp).    



run_time = length(msg_enc_set);

for z = 1:run_time;
    temp_code = msg_enc_set(z,:);
    temp_loc = randGroup(z,:);
    
    % Encoding First 3 Bits Using RGB
    % -------------------------------
    % Isolate Pixel Location 1
    [row1,col1] = ind2sub([canM,canN],temp_loc(1));
    
    % Bit 1: Red
    if str2double(temp_code(1)) == 0
        img_prep(row1,col1,1) = bitand(img_prep(row1,col1,1),uint8(254));
    else
        img_prep(row1,col1,1) = bitor(img_prep(row1,col1,1),uint8(1));
    end
    
    % Bit 2: Green
    if str2double(temp_code(2)) == 0
        img_prep(row1,col1,2) = bitand(img_prep(row1,col1,2),uint8(254));
    else
        img_prep(row1,col1,2) = bitor(img_prep(row1,col1,2),uint8(1));
    end
    
    % Bit 3: Blue
    if str2double(temp_code(3)) == 0
        img_prep(row1,col1,3) = bitand(img_prep(row1,col1,3),uint8(254));
    else
        img_prep(row1,col1,3) = bitor(img_prep(row1,col1,3),uint8(1));
    end
    
    % Encoding Second 3 Bits Using BGR
    % -------------------------------
    % Isolate Pixel Location 2
    [row2,col2] = ind2sub([canM,canN],temp_loc(2));
    
    % Bit 4: Blue
    if str2double(temp_code(4)) == 0
        img_prep(row2,col2,3) = bitand(img_prep(row2,col2,3),uint8(254));
    else
        img_prep(row2,col2,3) = bitor(img_prep(row2,col2,3),uint8(1));
    end
    
    % Bit 5: Green
    if str2double(temp_code(5)) == 0
        img_prep(row2,col2,2) = bitand(img_prep(row2,col2,2),uint8(254));
    else
        img_prep(row2,col2,2) = bitor(img_prep(row2,col2,2),uint8(1));
    end
    
    % Bit 6: Red
    if str2double(temp_code(6)) == 0
        img_prep(row2,col2,1) = bitand(img_prep(row2,col2,1),uint8(254));
    else
        img_prep(row2,col2,1) = bitor(img_prep(row2,col2,1),uint8(1));
    end
    
    % Encoding Final 2 Bits Using RG_
    % -------------------------------
    % Isolate Pixel Location 3
    [row3,col3] = ind2sub([canM,canN],temp_loc(3));
    
    % Bit 7: Red
    if str2double(temp_code(7)) == 0
        img_prep(row3,col3,1) = bitand(img_prep(row3,col3,1),uint8(254));
    else
        img_prep(row3,col3,1) = bitor(img_prep(row3,col3,1),uint8(1));
    end
    
    % Bit 8: Green
    if str2double(temp_code(8)) == 0
        img_prep(row3,col3,2) = bitand(img_prep(row3,col3,2),uint8(254));
    else
        img_prep(row3,col3,2) = bitor(img_prep(row3,col3,2),uint8(1));
    end
        
end

%% Step 6: Final Output
J = img_prep;       % Final Encoding Output
% J = msg_enc_set;  % ENCRYPTION STEP TEST OUTPUT
end
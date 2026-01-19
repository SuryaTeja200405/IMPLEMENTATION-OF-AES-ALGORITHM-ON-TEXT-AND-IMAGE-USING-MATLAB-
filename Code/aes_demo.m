
% Initialization
[s_box, inv_s_box, w, poly_mat, inv_poly_mat] = aes_init;

% Define an arbitrary series of 16 plaintext bytes 
% in hexadecimal (string) representation
% The following two specific plaintexts are used as examples 
% in the AES-Specification (draft)
plaintext_hex = {'00' '11' '22' '33' '44' '55' '66' '77' ...
                 '88' '99' 'aa' 'bb' 'cc' 'dd' 'ee' 'ff'};
%plaintext_hex = {'32' '43' 'f6' 'a8' '88' '5a' '30' '8d' ...
%                 '31' '31' '98' 'a2' 'e0' '37' '07' '34'};

% Convert plaintext from hexadecimal (string) to decimal representation
plaintext = hex2dec (plaintext_hex);

% This is the real McCoy.
% Convert the plaintext to ciphertext,
% using the expanded key, the S-box, and the polynomial transformation matrix
ciphertext = cipher (plaintext, w, s_box, poly_mat, 1);

% Convert the ciphertext back to plaintext
% using the expanded key, the inverse S-box, 
% and the inverse polynomial transformation matrix
re_plaintext = inv_cipher (ciphertext, w, inv_s_box, inv_poly_mat, 1);
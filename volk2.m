function [activity] = volk2(chatFile, user)
% PS Chat Room Activity Analyzer
%   This function takes a PS chat log as input and shows chat room activity
%   at different times of the day. This function can also analyze a
%   specific user's activity if a username is specified.

fid = fopen(['logs/' chatFile]);
lineData = zeros(1,25);
if exist('user', 'var')
    user = lower(regexprep(user, '[^a-zA-Z0-9]', ''));
    while feof(fid) == 0
        line = fgetl(fid);
        if length(line) >= 14
            if strcmp(line(10:12), '|c|') && ~strcmp(line(14), '|')
                verticalBars = strfind(line, '|');
                fullUsername = line((verticalBars(2) + 2):(verticalBars(3) - 1));
                alphanumericUsername = regexprep(fullUsername, '[^a-zA-Z0-9]', '');
                if strcmpi(alphanumericUsername, user)
                    hour = str2double(line(1:2));
                    lineData(floor(hour)+1) = lineData(floor(hour)+1) + 1;
                    lineData(25) = lineData(25) + 1;
                end
            end
        end
    end
    fclose(fid);
    fprintf('Activity for user: %s has been analyzed.\n', user);
else
    while feof(fid) == 0
        line = fgetl(fid);
        if length(line) >= 14
            if strcmp(line(10:12), '|c|') && ~strcmp(line(14), '|')
                hour = str2double(line(1:2));
                lineData(floor(hour)+1) = lineData(floor(hour)+1) + 1;
                lineData(25) = lineData(25) + 1;
            end
        end
    end
    fclose(fid);
    fprintf('Activity for all users has been analyzed.\n');
end
header = {'12 AM' '1 AM' '2 AM' '3 AM' '4 AM' '5 AM' '6 AM' '7 AM'...
    '8 AM' '9 AM' '10 AM' '11 AM' '12 PM' '1 PM' '2 PM' '3 PM' '4 PM'...
    '5 PM' '6 PM' '7 PM' '8 PM' '9 PM' '10 PM' '11 PM' 'Total'};
lines = num2cell(lineData);
percent = {};
i = 1;
while i <= 25
    percent(i) = {[num2str(100*lineData(i)/lineData(25)) '%']};
    i = i + 1;
end
activity = [header; lines; percent];

end

function cont = checkContinue()
    cont = true;
    orig_state = warning;   
    warning('off', 'backtrace');
    warning('This will erase all test data and replace with new results.');
    warning(orig_state);
    m = input('Continue? ','s');
    if ~strcmpi(m, 'yes')
        disp('That''s what I thought.');
        cont = false;
    end
end

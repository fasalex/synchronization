function [retval] = fact(n)
  if (n > 0)
     retval = n.*fact(n-1);
  else
     retval = 1;
  endif
endfunction 

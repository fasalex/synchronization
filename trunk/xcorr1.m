function c = xcorr1(a,b,biasflag)
  if (nargin < 1 || nargin > 3)
    usage ("c = xcorr1(A [, B] [, 'scale'])");
  endif
  if (nargin == 1)
    b = a; 
    biasflag = 'none'; 
  elseif (nargin == 2)
    if (isstr (b)) 
      biasflag = b; 
      b = a;
    else 
      biasflag = 'none';
    endif
  endif

  ## compute correlation
  [ma,na] = size(a);
  [mb,nb] = size(b);
  c = conv2 (a, conj (b (mb:-1:1, nb:-1:1)));

  ## bias routines by Dave Cogdell (cogdelld@asme.org)
  ## optimized by Paul Kienzle (pkienzle@kienzle.powernet.co.uk)
  if strcmp(lower(biasflag), 'biased'),
    c = c / ( min ([ma, mb]) * min ([na, nb]) );
  elseif strcmp(lower(biasflag), 'unbiased'), 
    eleo = empty_list_elements_ok;
    unwind_protect
      lo = min ([na,nb]); hi = max ([na, nb]);
      row = [ 1:(lo-1), lo*ones(1,hi-lo+1), (lo-1):-1:1 ];
      lo = min ([ma,mb]); hi = max ([ma, mb]);
      col = [ 1:(lo-1), lo*ones(1,hi-lo+1), (lo-1):-1:1 ]';
      empty_list_elements_ok = 1;
    unwind_protect_cleanup
      empty_list_elements_ok = eleo;
    end_unwind_protect
    bias = col*row;
    c = c./bias;
  elseif strcmp(lower(biasflag),'coeff'),
    c = c/max(c(:))';
  endif
  x = length(c);
  m = median(c);
  temp = (x + 1)/2;
  x = c(temp:x);
  c = x ;
endfunction



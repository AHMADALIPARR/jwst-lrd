% SPDX-License-Identifier: AGPL-3.0-only
% cc_models.m -- list of the 10 continuum models (PREREG section 2).  field hi = column of W.rm for 'rm'.
function M = cc_models()
  M = {struct('name','RM6','type','rm','hi',1,'H',6), struct('name','RM12','type','rm','hi',2,'H',12), struct('name','RM20','type','rm','hi',3,'H',20), ...
       struct('name','P0','type','poly','p',0), struct('name','P1','type','poly','p',1), struct('name','P2','type','poly','p',2), struct('name','P3','type','poly','p',3), ...
       struct('name','PL','type','pl'), struct('name','PLLIN','type','pllin'), struct('name','SPL','type','spl')};
end

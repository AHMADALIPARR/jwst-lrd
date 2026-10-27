% SPDX-License-Identifier: AGPL-3.0-only
% Reads key=value lines ('#' comments). Numeric values via str2double; 'unknown' -> NaN.
function s = read_inputs(path)
  fid = fopen(path, 'r');
  if fid < 0, error('cannot open %s', path); end
  s = struct();
  while true
    line = fgetl(fid);
    if ~ischar(line), break; end
    line = strtrim(line);
    if isempty(line) || line(1) == '#', continue; end
    p = strfind(line, '=');
    if isempty(p), continue; end
    key = strtrim(line(1:p(1)-1)); val = strtrim(line(p(1)+1:end));
    num = str2double(val);
    if strcmp(val, 'unknown') || isempty(val), s.(key) = NaN;
    elseif ~isnan(num), s.(key) = num;
    else s.(key) = val; end
  end
  fclose(fid);
end

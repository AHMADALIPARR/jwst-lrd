% SPDX-License-Identifier: AGPL-3.0-only
% cc_parse.m -- parse 'KEY value' / key=value records of the given prefix from job output files into a struct array.
function S = cc_parse(files, prefix)
  S = struct([]); n = 0;
  for f = 1:numel(files)
    fid = fopen(files{f}, 'r'); if fid < 0, continue; end
    while true
      ln = fgetl(fid); if ~ischar(ln), break; end
      if strncmp(ln, [prefix ' '], numel(prefix) + 1)
        t = regexp(ln, '(\w+)=(\S+)', 'tokens'); r = struct();
        for q = 1:numel(t)
          v = str2double(t{q}{2}); if isnan(v) && ~strcmpi(t{q}{2}, 'nan'), r.(t{q}{1}) = t{q}{2}; else, r.(t{q}{1}) = v; end
        end
        n++; S(n).r = r;
      end
    end
    fclose(fid);
  end
end

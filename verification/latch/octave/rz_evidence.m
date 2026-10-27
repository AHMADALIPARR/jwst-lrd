% SPDX-License-Identifier: AGPL-3.0-only
% Producer of measurement-evidence events (NDJSON) for the verification latch.
% usage: rz_evidence(inputs_file, git_revision, seq_base, out_file)
% Emits two events on subject verify.evidence.measurement:
%   redshift.z_residual (r_z)      and      redshift.sigma_residual (r_sigma)
% Engine label is always printed/recorded: "Octave <ver>, NOT MATLAB" when under Octave.
function rz_evidence(inputs_file, revision, seq_base, out_file)
  if exist('OCTAVE_VERSION', 'builtin')
    engine = ['Octave ' OCTAVE_VERSION ', NOT MATLAB'];
  else
    engine = ['MATLAB ' version()];
  end
  in = read_inputs(inputs_file);
  z = rz_core(in.z_measured, in.z_measured_sigma, in.z_published, in.z_published_sigma, in.k_sigma);
  sg = sigma_core(in.sigma_computed, in.sigma_reference, in.sigma_abs_tol);

  ez = mk_event('redshift.z_residual', revision, in.inputs_id, seq_base, z.status, z, engine, ...
    ['k=' num2str(in.k_sigma) ' x measured sigma (published sigma unknown unless given); ' ...
     'k=3 is a convention (about 0.27% two-sided Gaussian false-flag rate); the verdict ' ...
     'is the same for any k below ratio_measured_only']);
  es = mk_event('redshift.sigma_residual', revision, in.inputs_id, seq_base + 1, sg.status, sg, engine, ...
    'abs(r_sigma) <= sigma_abs_tol; tolerance must be supplied, none is assumed');

  fid = fopen(out_file, 'w');
  fprintf(fid, '# SPDX-License-Identifier: AGPL-3.0-only\n');
  fprintf(fid, '%s\n%s\n', jsonencode(ez), jsonencode(es));
  fclose(fid);
  fprintf('engine: %s\n', engine);
  print_summary('r_z', z);
  print_summary('r_sigma', sg);
  fprintf('wrote %s (2 events)\n', out_file);
end

function e = mk_event(check, revision, inputs_id, seq, status, meas, engine, tol_basis)
  e = struct('id', sprintf('octave-%s-%s-%s', check, revision(1:min(12, end)), inputs_id), ...
             'source', 'octave', 'subject', 'verify.evidence.measurement', ...
             'check', check, 'revision', revision, 'kind', 'evidence', ...
             'status', status, 'critical', true, 'seq', seq, ...
             'engine', engine, 'tolerance_basis', tol_basis, 'measurement', meas);
end

function print_summary(name, m)
  fprintf('%s status=%s disposition=%s\n', name, m.status, m.disposition);
  f = fieldnames(m);
  for i = 1:numel(f)
    v = m.(f{i});
    if isnumeric(v), fprintf('  %-28s %.17g\n', f{i}, v); end
  end
end

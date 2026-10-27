<!-- SPDX-License-Identifier: AGPL-3.0-only -->
# Schwarzschild redshift, Kruskal–Szekeres extension, Einstein–Rosen bridge, and symmetries

> **Scope label.** This file is a **mathematical derivation of a model — not empirical evidence about QSO1 and not an explanation of the z = 7.04221 vs 7.0451 discrepancy.** Nothing here is a measurement. Every number that looks astrophysical is computed from *stated assumed inputs* and is labelled as such.

Math notation: display equations use `$$ … $$`; inline math uses `\( … \)` (as requested). If a viewer does not render `\( … \)`, a mechanical replacement by `$ … $` is equivalent.

Conventions. Signature \((-,+,+,+)\). Units are kept explicit; where \(G=c=1\) is used it is said. \(r_s = 2GM/c^2\). \(f(r)=1-r_s/r\). Independent checks referenced as **[chk NN]** are in `checks/` and are run by `./run.sh` (Section 6).

---

## 1. Gravitational redshift from the Schwarzschild metric

### 1.1 Exact result for static emitter and static observer

The Schwarzschild metric (vacuum, spherically symmetric, \(M\) fixed) is

$$
ds^2 = -f(r)\,c^2dt^2 + \frac{dr^2}{f(r)} + r^2\left(d\theta^2+\sin^2\theta\,d\varphi^2\right),\qquad f(r)=1-\frac{r_s}{r}.
$$

The vector field \(\xi=\partial_t\) is Killing (the metric components do not depend on \(t\); verified in §3 and **[chk 04f]**). For a photon with 4-momentum \(p^\mu\) the quantity \(E=-p_\mu\xi^\mu\) is conserved along the geodesic, because \(\frac{d}{d\lambda}(p_\mu\xi^\mu)=p^\nu p^\mu\nabla_\nu\xi_\mu=0\) (Killing equation + geodesic equation).

A *static* observer has 4-velocity \(u^\mu = \xi^\mu/\sqrt{-\xi\cdot\xi}\), with \(-\xi\cdot\xi = c^2 f(r)\). The frequency it measures is \(\nu \propto -p_\mu u^\mu = E/\sqrt{f(r)}\) (up to a constant factor common to emitter and observer). Since \(E\) is the same at emission and reception,

$$
\frac{\nu_{\rm obs}}{\nu_{\rm em}}=\sqrt{\frac{f(r_e)}{f(r_o)}}
\quad\Longrightarrow\quad
1+z_{\rm grav}\;\equiv\;\frac{\nu_{\rm em}}{\nu_{\rm obs}}=\sqrt{\frac{1-\dfrac{2GM}{c^2 r_o}}{1-\dfrac{2GM}{c^2 r_e}}}\;,\qquad r_e,r_o>r_s .
$$

Assumptions: both ends static (zero 4-velocity spatial part in these coordinates), Schwarzschild exterior, no other redshift/blueshift sources, frequency = photon energy in each local static frame. For a distant observer \(r_o\to\infty\): \(1+z_{\rm grav}=(1-r_s/r_e)^{-1/2}\).

### 1.2 Limits

*Weak field* (\(r_s\ll r_e,r_o\)). Expanding to first order in \(r_s\),

$$
z_{\rm grav}\simeq \frac{r_s}{2}\left(\frac1{r_e}-\frac1{r_o}\right)=\frac{GM}{c^2}\left(\frac1{r_e}-\frac1{r_o}\right)=\frac{\Phi(r_o)-\Phi(r_e)}{c^2}=\frac{\Delta\Phi}{c^2},\qquad \Phi=-\frac{GM}{r}.
$$

For \(r_o\to\infty\), \(z_{\rm grav}=\tfrac{r_s}{2r_e}+\tfrac{3}{8}\left(\tfrac{r_s}{r_e}\right)^2+\tfrac{5}{16}\left(\tfrac{r_s}{r_e}\right)^3+\dots\) **[chk 06]** (series verified symbolically, items 1–2).

*Horizon limit.* \(r_e\to r_s^+\): \(f(r_e)\to0^+\), so \(1+z_{\rm grav}\to\infty\) **[chk 06 item 3]**. This divergence is a property of *static* emitters near the horizon (no static observers exist at or inside \(r_s\)); it is a coordinate-/observer-dependent statement about the family of static emitters, not a curvature singularity (curvature is finite there, §2.3).

### 1.3 Relation to cosmological redshift; composition

Gravitational redshift (a static-frame frequency ratio in a *fixed* background metric) is physically distinct from cosmological redshift (a ratio of scale factors, \(1+z_{\rm cosmo}=a(t_o)/a(t_e)\), arising from expansion). They are different effects with different mathematics; the observed redshift is not "either/or".

*Composition (assumption stated).* If the emitter sits in a local, quasi-static Schwarzschild environment whose asymptotic frame (\(r_o\to\infty\) for that local patch) is comoving with the Hubble flow at the emitter's cosmic epoch, and the local region is small compared with cosmological scales so that the two redshifts apply to *successive* stages of the same photon's journey, then frequency ratios multiply:

$$
1+z_{\rm obs}=(1+z_{\rm cosmo})\,(1+z_{\rm grav}) .
$$

Consequences: \(z_{\rm obs}\neq z_{\rm cosmo}+z_{\rm grav}\) in general; \(z_{\rm grav}=\dfrac{1+z_{\rm obs}}{1+z_{\rm cosmo}}-1=\dfrac{z_{\rm obs}-z_{\rm cosmo}}{1+z_{\rm cosmo}}\) **[chk 06 item 4]**. The assumption is the *separation of scales*; peculiar velocities, Doppler shifts of the emitter (including orbital motion, transverse Doppler), and line-formation effects are additional factors and are *not* included.

### 1.4 Size of \(z_{\rm grav}\) for a BLR at \(10^3\)–\(10^5\,r_s\)  (assumed inputs, not measurements)

Inputs (assumptions): \(M=10^7\) and \(10^8\,M_\odot\); emitter radius \(\rho\equiv r_e/r_s=10^3,10^4,10^5\); observer at infinity; static emitter; Schwarzschild. \(GM_\odot=1.32712440018\times10^{20}\,\mathrm{m^3\,s^{-2}}\), \(c=299\,792\,458\,\mathrm{m\,s^{-1}}\).

Because \(1+z_{\rm grav}=(1-1/\rho)^{-1/2}\), **\(z_{\rm grav}\) depends only on \(\rho\), not on \(M\)**:

| \(\rho=r_e/r_s\) | \(z_{\rm grav}\) exact | \(1/(2\rho)\) | \(c\,z_{\rm grav}\) |
|---|---|---|---|
| \(10^3\) | \(5.0037531\times10^{-4}\) | \(5.0\times10^{-4}\) | 150.009 km/s |
| \(10^4\) | \(5.0003750\times10^{-5}\) | \(5.0\times10^{-5}\) | 14.9907 km/s |
| \(10^5\) | \(5.0000375\times10^{-6}\) | \(5.0\times10^{-6}\) | 1.49897 km/s |

Arithmetic: \(\rho=10^3\): \(1-10^{-3}=0.999\), \(0.999^{-1/2}=1.000500375\), so \(z=5.00375\times10^{-4}\); \(c z=299792.458\times5.00375\times10^{-4}=150.009\) km/s. Others analogous. (bc 20-digit values: **[chk arith]**; cross-checked in Fortran and awk.)

\(M\) enters only the *physical* radius: \(r_s=2GM/c^2=2953.250\,\mathrm{m}\,(M/M_\odot)\), giving \(r_s=2.9533\times10^{7}\) km (light-crossing 98.51 s) for \(10^7M_\odot\) and \(2.9533\times10^{8}\) km (985.1 s, 1.974 AU) for \(10^8M_\odot\). Hence \(r=10^3\,r_s\) is 1.140 light-days (\(10^7M_\odot\)) or 11.40 light-days (\(10^8M_\odot\)); \(10^5\,r_s\) is 114.0 or 1140 light-days. These are scalings of assumed inputs only.

*Contrast: a circular-orbit emitter* (not static) at \(\rho\gg1\) has \(1+z=(1-\tfrac{3}{2\rho})^{-1/2}\), \(z\simeq\tfrac{3}{4\rho}\) (gravitational + transverse Doppler) **[chk 06 item 7]** — 1.5× the static value. Real BLR gas is not static; the static formula is the stated model, not a claim.

### 1.5 A conditional characteristic radius (explicitly **not** an upper limit and **not** a measured radius)

Take, purely as an arithmetic exercise, the two quoted redshift values \(z_{\rm ref}=7.04221\) and \(z_{\rm alt}=7.0451\). Treating the whole difference as a gravitational factor on top of the first,

$$
z_{\rm grav}^{\rm (cond)}=\frac{1+7.0451}{1+7.04221}-1=3.5935\times10^{-4},\qquad
c\,z_{\rm grav}^{\rm (cond)}=107.73\ \mathrm{km\,s^{-1}}\approx108\ \mathrm{km\,s^{-1}},\qquad v/c\approx3.6\times10^{-4}.
$$

Weak-field inversion \(z\simeq r_s/(2r)\) gives \(r\simeq 1/(2z)\,r_s = 1391\,r_s\); the exact inversion \(r_e/r_s=[1-(1+z)^{-2}]^{-1}\) gives 1392.1 \(r_s\) (the weak-field value is accurate to 0.05 %) **[chk f90-02, bc, awk]**. Hence "\(\approx1{,}390\,r_s\)".

**How to read this number.** It is a *conditional characteristic radius*: the radius at which a static emitter in a Schwarzschild field would have to sit **if** the entire velocity-equivalent discrepancy were gravitational. It is **not an upper limit** and **not a measured emission radius**. The conditions:

1. the *whole* velocity-equivalent discrepancy (\(\approx108\) km/s) is assigned to gravitational redshift;
2. the source is Schwarzschild (non-rotating, uncharged, vacuum exterior);
3. the emitter is static;
4. other line-formation effects (kinematics, radiative transfer, outflows/inflows, blending, instrumental/wavelength-calibration terms) are ignored.

If only a *part* of the gap is gravitational, the implied radius is **larger** (smaller \(z\) ⇒ larger \(\rho\)). If some other effect *opposes* the gravitational shift, the gravitational part would need to be larger and the implied radius could be **smaller**. So the number is neither a bound from above nor from below.

Further, as supplied to this task the 7.04221 and 7.0451 values are two fits of the *same lines*, and the fit systematics (about \(4\times10^{-3}\) spread across continuum choices) are **unresolved**; that spread is larger than the gap \(\Delta z=2.9\times10^{-3}\) itself. The quoted values and the \(4\times10^{-3}\) figure are taken as given by the task statement and were not independently verified here. Nothing in this section tests, supports, or excludes a gravitational origin of the discrepancy; any such link would be a separate hypothesis requiring its own test.

---

## 2. Kruskal–Szekeres coordinates and the Einstein–Rosen bridge

Set \(r_s=2GM/c^2\) and use length units with \(c=1\) so \(t\) has units of length (restore with \(t\to ct\)).

### 2.1 Derivation from Schwarzschild coordinates

*Tortoise coordinate.* \(dr_*=dr/f\), giving \(r_*=r+r_s\ln\left|\dfrac{r}{r_s}-1\right|\). With \(u=t-r_*\), \(v=t+r_*\) the radial part of the metric is conformally flat:

$$
ds^2=-f\,du\,dv+r^2d\Omega^2 .
$$

*Rescaling to remove the zero of \(f\).* Define (this is the **convention used throughout**; regions are labelled by the signs \(s_U,s_V\))

$$
U=s_U\,e^{-u/(2r_s)},\qquad V=s_V\,e^{v/(2r_s)}.
$$

Then \(UV=s_Us_V\,e^{r_*/r_s}\). For \(r>r_s\): \(e^{r_*/r_s}=(r/r_s-1)e^{r/r_s}\); for \(r<r_s\) (use \(r_*=r+r_s\ln(1-r/r_s)\)): \(e^{r_*/r_s}=(1-r/r_s)e^{r/r_s}\). Choosing \(s_Us_V=-1\) outside and \(+1\) inside gives, in every region,

$$
\boxed{\,UV=\left(1-\frac{r}{r_s}\right)e^{r/r_s}\,}\qquad\qquad \frac{V}{U}=-e^{t/r_s}\ (\text{exterior}).
$$

Since \(dU=-\dfrac{U}{2r_s}du\), \(dV=\dfrac{V}{2r_s}dv\): \(du\,dv=-\dfrac{4r_s^2}{UV}\,dU\,dV\). With \(f=(r-r_s)/r\) and \(UV=-\dfrac{r-r_s}{r_s}e^{r/r_s}\),

$$
\frac{f}{UV}=-\frac{r_s}{r}e^{-r/r_s}
\quad\Longrightarrow\quad
\boxed{\,ds^2=-\frac{4r_s^3}{r}\,e^{-r/r_s}\,dU\,dV+r^2\left(d\theta^2+\sin^2\theta\,d\varphi^2\right)\,}
$$

Define \(T=(U+V)/2\), \(X=(V-U)/2\) (so \(U=T-X\), \(V=T+X\), \(dU\,dV=dT^2-dX^2\)):

$$
ds^2=\frac{4r_s^3}{r}e^{-r/r_s}\left(-dT^2+dX^2\right)+r^2d\Omega^2,\qquad T^2-X^2=\left(1-\frac r{r_s}\right)e^{r/r_s}.
$$

In region I: \(t=r_s\ln(-V/U)\) and \(T/X=\tanh\left(t/2r_s\right)\); and \(X^2-T^2=(r/r_s-1)e^{r/r_s}\). (Other texts use \(U=(T-X)\) with different scalings, e.g. \(r_s\)-dimensionful \(T,X\), or factors of \(1/2\) in the exponent; the relation \(UV=(1-r/r_s)e^{r/r_s}\) is convention-independent only up to those rescalings. Above is the convention used by all checks.) 

Verified: pullback of the Kruskal 2-metric to \((t,r)\) equals Schwarzschild in all four regions (16 components, symbolic) **[chk 02a]**; \(UV\) relation, \(T^2-X^2=UV\), Jacobian \(\partial(U,V)/\partial(t,r)=\dfrac{r\,e^{r/r_s}}{2r_s^3}\) nonzero **[chk 02b]**; \(\partial_tU=-U/2r_s\), etc. **[chk 02c]**; numeric finite-difference pullback at 80 points **[chk oct-08]**.

### 2.2 Regularity at \(r=r_s\) and extension

The map \(r\mapsto F(r)=(1-r/r_s)e^{r/r_s}\) has \(F'(r)=-\dfrac{r}{r_s^2}e^{r/r_s}\neq0\) for all \(r>0\) **[chk 02d]**. By the implicit-function theorem \(r=r(U,V)\) is a real-analytic function of the product \(w=UV\) on \(w<1\) (explicitly \(r/r_s=1+W_0(-w/e)\) with \(W_0\) the principal Lambert-\(W\) branch; \(w=1\) is \(r=0\)). Its derivatives are
\(r_U=V/F'=-r_s^2Ve^{-r/r_s}/r\), \(r_V=-r_s^2Ue^{-r/r_s}/r\), which are smooth through \(U=0\) or \(V=0\). The metric coefficient \(A=\tfrac{4r_s^3}{r}e^{-r/r_s}\) is finite and nonzero at \(r=r_s\) (\(A=4r_s^2/e\)) **[chk 02e]**, and \(\det g=-\tfrac{A^2}{4}r^4\sin^2\theta\ne0\) there **[chk 03c]**. So the Kruskal metric is a smooth Lorentzian metric across \(r=r_s\) (the "singularity" at \(r_s\) of Schwarzschild coordinates is a coordinate artefact): the metric extends analytically to \(UV<1\).

*Curvature.* \(R_{\mu\nu}=0\) in Kruskal coordinates (symbolic, 16 components, using only the implicit derivatives above, never dividing by \(r-r_s\)) **[chk 03d]**, \(R=0\) **[chk 03e]**, and the Kretschmann scalar \(R_{\alpha\beta\gamma\delta}R^{\alpha\beta\gamma\delta}=12r_s^2/r^6=48G^2M^2/(c^4r^6)\) is finite at \(r_s\) and diverges only as \(r\to0\) **[chk 01c, 03f]**. A negative control (a wrong conformal factor \(e^{-2r/r_s}\)) is detected as non-Ricci-flat **[chk 03g, oct-04]**.

### 2.3 The four regions

With \(U=T-X,V=T+X\):

| Region | Sign of \((U,V)\) | Description | \(r\) vs \(r_s\) |
|---|---|---|---|
| I | \(U<0,V>0\) (\(X>|T|\)) | our exterior | \(r>r_s\) |
| II | \(U>0,V>0\) (\(T>|X|\)) | black-hole interior (future) | \(r<r_s\) |
| III | \(U>0,V<0\) (\(X<-|T|\)) | second, causally disconnected exterior | \(r>r_s\) |
| IV | \(U<0,V<0\) (\(T<-|X|\)) | white-hole interior (past) | \(r<r_s\) |

\(UV<0\) in I, III; \(UV>0\) in II, IV **[chk oct-02]**. The future horizon is \(U=0,V>0\) (boundary I/II) and \(V=0\) (III/II); the past horizon is \(V=0,U<0\) (I/IV) etc. The singularities are at \(UV=1\), i.e. \(T^2-X^2=1\), \(r=0\), in II (\(T=+\sqrt{1+X^2}\)) and IV (\(T=-\sqrt{1+X^2}\)). Null rays are \(U=\) const, \(V=\) const (45° lines). The causal structure (Penrose diagram) follows.

### 2.4 The Einstein–Rosen bridge (\(T=0\) slice)

On \(T=0\): \(U=-X\), \(V=X\), \(UV=-X^2\), so \(X^2=(r/r_s-1)e^{r/r_s}\) with \(r\ge r_s\), and \(X\in(-\infty,\infty)\) covers region I (\(X>0\)), region III (\(X<0\)), and the bifurcation 2-sphere \(X=0\), \(r=r_s\). The induced metric is

$$
dl^2=\frac{4r_s^3}{r}e^{-r/r_s}\,dX^2+r^2d\Omega^2 .
$$

* \(dr/dX=-2X/F'(r)=2X r_s^2e^{-r/r_s}/r\), vanishing **only** at \(X=0\); \(d^2r/dX^2|_{X=0}=2r_s/e>0\). Hence \(r(X)\) has its unique minimum \(r=r_s\) at \(X=0\) **[chk 05, f90-03/04, oct-09]**.
* Radial proper length: \(A(dX/dr)^2=1/f\), i.e. \(dl=dr/\sqrt{1-r_s/r}\) on each side, giving \(l(r)=\sqrt{r(r-r_s)}+r_s\ln\left(\sqrt{r/r_s}+\sqrt{r/r_s-1}\right)\to 2\sqrt{r_s(r-r_s)}\) as \(r\to r_s\) (so \(r-r_s\simeq l^2/4r_s\)) **[chk 05, f90-05]**.
* The areal radius of the sphere at \(X\) is \(r(X)\); the area \(4\pi r^2\) is minimal at the **throat**, with

$$
A_{\min}=4\pi r_s^2=\frac{16\pi G^2M^2}{c^4}.
$$

The slice is two asymptotically flat ends joined at a throat: the Einstein–Rosen "bridge" (originally constructed by Einstein and Rosen, 1935, using a coordinate \(u^2=r-2m\) to avoid the singularity; the Kruskal form is due to Kruskal and Szekeres, 1960). The map \(X\mapsto-X\) (\(U\leftrightarrow V\)) is a \(\mathbb Z_2\) isometry exchanging the two exteriors (§3.3).

**Non-traversability.** *Claim:* in the eternal vacuum Schwarzschild–Kruskal solution no causal curve joins region I to region III (in either direction). *Proof:* a future-directed causal curve has \(dT\ge|dX|\), i.e. \(dU=dT-dX\ge0\) and \(dV=dT+dX\ge0\) at every point, so both \(U\) and \(V\) are non-decreasing along it. Region I has \(V>0\), region III has \(V<0\): going I\(\to\)III needs \(V\) to decrease. III\(\to\)I needs \(U\) to go from \(>0\) to \(<0\), a decrease. Both are impossible. \(\square\) Causal curves from I can only reach II (and I itself). This is the content of the Fuller–Wheeler (1962) result: the throat pinches off (the \(T=\) const slices through \(X=0\) reach \(r=0\) at \(T=\pm1\)) before any signal can cross, so the bridge is **non-traversable**. A Monte-Carlo run (200 000 random causal curves of 40 steps: 0 crossings; a spacelike-step control: crossings occur) is **only an illustration** of the proof, not independent evidence **[chk f90-06/07]**.

**Physical status.** The extended solution is an *eternal* idealisation. A black hole formed by gravitational collapse has no region III or IV (the collapsing matter replaces them); the Einstein–Rosen bridge has **no observational counterpart**, and nothing in this derivation implies an observable signature. Any proposed link between the bridge, or any part of this geometry, and QSO1 would be a **separate hypothesis requiring its own test**.

---

## 3. Symmetries and Killing vectors

### 3.1 Killing equation

\(\xi\) is a Killing vector iff \(\mathcal L_\xi g_{\mu\nu}=\xi^\rho\partial_\rho g_{\mu\nu}+g_{\rho\nu}\partial_\mu\xi^\rho+g_{\mu\rho}\partial_\nu\xi^\rho=\nabla_\mu\xi_\nu+\nabla_\nu\xi_\mu=0\). Both forms were verified symbolically and independently for each field below.

### 3.2 Continuous isometries

In Kruskal \((U,V,\theta,\varphi)\):

$$
\xi_t\equiv\partial_t=\frac1{2r_s}\left(V\partial_V-U\partial_U\right)=\frac1{2r_s}\left(X\partial_T+T\partial_X\right),
$$

$$
L_z=\partial_\varphi,\quad L_x=-\sin\varphi\,\partial_\theta-\cot\theta\cos\varphi\,\partial_\varphi,\quad L_y=\cos\varphi\,\partial_\theta-\cot\theta\sin\varphi\,\partial_\varphi .
$$

* \(\partial_t\) is time translation in the exteriors and a *boost* in the \((T,X)\) plane: \(U\to e^{-a/2r_s}U\), \(V\to e^{a/2r_s}V\). Its squared norm \(g(\xi_t,\xi_t)=-(1-r_s/r)\): timelike in I and III, null on \(U=0\) or \(V=0\) (the Killing horizons, where it vanishes only at the bifurcation sphere \(U=V=0\)), spacelike in II and IV **[chk 04c]**. It is smooth through the horizon, which shows that the "time-independent" Schwarzschild symmetry is a smooth symmetry of the extension.
* \(L_x,L_y,L_z\) generate SO(3).
* With these field signs the brackets are \([\xi_t,L_i]=0\) and \([L_x,L_y]=-L_z\) (cyclic) — the \(\mathbb R\times\mathfrak{so}(3)\) algebra (sign fixed by the choice of field signs) **[chk 04d]**.
* **Killing equation verified** for all four fields by both the Lie-derivative and covariant forms (16/16 components each, symbolic) **[chk 04a/04b]**, also for \(\partial_t,\partial_\varphi\) in the Schwarzschild chart **[chk 04f/g]**, and numerically by finite differences at 120 sample points per field **[chk oct-05]**. Non-Killing controls (\(\partial_U\), the dilation \(U\partial_U+V\partial_V\), \(\partial_\theta\)) are correctly rejected **[chk 04e, oct-06]**.

*Why the invariance of the boost is immediate:* both \(A\) and \(r\) depend on \((U,V)\) only through \(UV\), and \(dU\,dV\) and \(UV\) are invariant under \((U,V)\to(\lambda U,V/\lambda)\). By Birkhoff's theorem and the form of the metric the continuous isometry group of the maximal extension is generated by these four vectors (I do not re-prove Birkhoff here; the four-dimensional count is the standard statement, not an output of the checks).

### 3.3 Discrete isometries

Because the metric depends on \((U,V)\) only through \(UV\) and \(dU\,dV\), these maps are isometries (pullback verified for an arbitrary function \(a(UV)\)) **[chk 04h]**:

| Map | In \((T,X)\) | Effect on regions |
|---|---|---|
| \((U,V)\mapsto(V,U)\) | \(X\to-X\) | **\(\mathbb Z_2\) exchange of the two exteriors**, I\(\leftrightarrow\)III; II, IV map to themselves |
| \((U,V)\mapsto(-V,-U)\) | \(T\to-T\) | time reversal: I\(\to\)I, III\(\to\)III, II\(\leftrightarrow\)IV |
| \((U,V)\mapsto(-U,-V)\) | \((T,X)\to(-T,-X)\) | I\(\leftrightarrow\)III, II\(\leftrightarrow\)IV (their composition) |
| \((U,V)\mapsto(\lambda U,V/\lambda)\), \(\lambda>0\) | boost | flow of \(\xi_t\) |

Under \(X\to-X\), \(\xi_t\mapsto-\xi_t\): the "Schwarzschild time" Killing vector is future-directed in I and past-directed in III. The full isometry group is generated by the boost, SO(3), and these discrete maps; the discrete part is \(\mathbb Z_2\times\mathbb Z_2\).

---

## 4. Summary of what is and is not claimed

* Derived: Schwarzschild redshift formula, its limits and composition rule; Kruskal–Szekeres chart and regularity at \(r_s\); four regions; ER slice with throat area \(4\pi r_s^2\); non-traversability in the eternal vacuum solution; Killing vectors and discrete symmetries. All are standard textbook results re-derived and machine-checked as described in §6.
* Not claimed: any empirical statement about QSO1 or any quasar; any explanation of the 7.04221 vs 7.0451 gap; that real BLR gas is static; that an Einstein–Rosen bridge exists in any astrophysical object (it has no observational counterpart); that the ≈1,390 \(r_s\) number is an upper limit or a measured radius (§1.5); any formal Lean/Agda/Coq proof.

---

## 5. References (standard)

Schwarzschild (1916); Einstein & Rosen, Phys. Rev. 48, 73 (1935); Kruskal, Phys. Rev. 119, 1743 (1960); Szekeres, Publ. Math. Debrecen 7, 285 (1960); Fuller & Wheeler, Phys. Rev. 128, 919 (1962); Misner–Thorne–Wheeler, *Gravitation* (1973), §§25, 31; Wald, *General Relativity* (1984), §6.4. (Cited from memory of the standard literature; not re-fetched in this task.)

---

## 6. Independent checks

Run `./run.sh` (writes `results.txt`). Tools: **Maxima 5.47.0** (symbolic; was *not* on PATH — installed in user space from Debian trixie `.deb` files with `dpkg -x`, no root; see `bootstrap_maxima.sh`), **GNU Octave 9.4.0** (numeric; not MATLAB), **GNU Fortran 14.2 (`-std=f2018`)**, **bc**, **mawk**. **Not used / unavailable:** SymPy and all Python (forbidden; not used); Lean and Agda (binaries present, but no formal development attempted; none claimed); Coq (not found); Octave `symbolic` package (no Octave packages installed); `gawk`, `sage`, `pari/gp` (not installed).

### 6.1 Results of the final full run (`./run.sh`, exit status 0, Monday 2026-10-26, America/Los_Angeles)

`SUMMARY: 55 PASS lines, 0 FAIL lines; individual checks passed: 9475 of 9475.` (full lines in `results.txt`; each PASS line carries its own `n/n` count.)

| Tool | PASS lines | Individual checks | Content |
|---|---|---|---|
| Maxima (symbolic) | 35 | 276 | Ricci-flatness (Schwarzschild + Kruskal chart), pullback, Jacobian, regularity, Kretschmann, Killing eqs (Lie + covariant), commutators, discrete maps, ER identities, redshift algebra, negative controls |
| Octave (numeric, fixed seed, 120 points) | 12 | 1167 | Newton inversion, FD Ricci, FD Killing, pullback, ER throat, controls |
| Fortran 2018 | 7 | 8019 | redshift table, composition and conditional radius, ER grid (8001 points), area, proper length, MC illustration |
| awk vs bc | 1 | 13 | double-precision arithmetic vs 20-digit bc references |

(Per-tool breakdown computed from `results.txt` with awk: 35+12+7+1 = 55 PASS lines; 276+1167+8019+13 = 9475.)

### 6.2 Caveats on the checks (honest notes)

* **Octave tolerance changed once.** The first Ricci finite-difference run passed 119/120 with a fixed absolute tolerance \(2\times10^{-6}\) (worst point 2.35e-6, near small \(r\), where curvature itself scales like \(r^{-3}\)). I replaced it with a curvature-scaled tolerance \(10^{-6}\max(1,r^{-3})\) (worst ratio 0.37) giving 120/120. This is a tolerance choice made after seeing a result, not a different calculation; the symbolic check [chk 03d] independently proves the same statement exactly.
* **Maxima commutator signs.** My first expectation was \([L_x,L_y]=+L_z\); the symbolic result for these specific field signs is \(-L_z\) (cyclic). I corrected the expectation; the check is on the computed algebra, which closes as \(\mathbb R\times\mathfrak{so}(3)\).
* **Awk references:** an initial hand-typed reference table had a typo (12/13); the references are now generated by bc.
* **Monte Carlo (f90-06/07)** illustrates, and does not prove, non-traversability; the proof is §2.4. The "I→II" count is trivial.
* **Finite differences** only sample points; they do not prove identities (the symbolic checks do).
* **Symbolic checks are only as good as Maxima's simplifier**: each has a negative control that must fail, so a vacuously-true check would be detected.
* **Not formally verified.** Lean 4 (`~/.elan`) and Agda binaries exist on this box, but **no Lean/Agda/Coq development was attempted**, so no formal proof is claimed. Python exists on the box but was deliberately not used (task forbids Python/SymPy).
* Birkhoff's theorem, the Fuller–Wheeler theorem and the textbook references are cited, not re-proved or re-fetched (non-traversability itself is proven in §2.4 from the Kruskal causal structure).
* Redshift tables use assumed inputs only; no data file was read.
